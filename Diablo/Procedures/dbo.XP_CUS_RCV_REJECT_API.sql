USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_CUS_RCV_REJECT_API
■ DESCRIPTION				: SMS수신거부 API
■ INPUT PARAMETER			: @PHONE_NUM VARCHAR(100), @REJECT_DATE VARCHAR(100)
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_CUS_RCV_REJECT_API @PHONE_NUM = '', @REJECT_DATE = '2019-01-01 00:00:00: 000'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-03-14	    이명훈	        생성
   2019-05-08	    이명훈	        전화번호 처리 로직 추가 (비회원)
================================================================================================================*/ 
CREATE PROC [dbo].[XP_CUS_RCV_REJECT_API]
@PHONE_NUM VARCHAR(100),
@REJECT_DATE VARCHAR(100)
AS
BEGIN
	DECLARE @INDEX INT,
			@CUS_NO INT,
			@CUS_NAME VARCHAR(100),   
			@EMAIL VARCHAR(100),
			@NOR_TEL1 VARCHAR(100),
			@NOR_TEL2 VARCHAR(100),
			@NOR_TEL3 VARCHAR(100),
			@SELECT_NOR_TEL1 VARCHAR(4),
			@SELECT_NOR_TEL2 VARCHAR(4),
			@SELECT_NOR_TEL3 VARCHAR(4),
			@TRANS_REJECT_DATE DATETIME


    IF(@REJECT_DATE = '')
	BEGIN
		SET @REJECT_DATE = GETDATE();
	END

	SET @INDEX = 0; --INDEX초기화
	SET @TRANS_REJECT_DATE = CONVERT(DATETIME, @REJECT_DATE)

	--전화번호 처리 로직 중간자리 3글자
	IF(LEN(@PHONE_NUM) = 10)
	BEGIN
		SET @SELECT_NOR_TEL1 = SUBSTRING(@PHONE_NUM,1,3)
		SET @SELECT_NOR_TEL2 = SUBSTRING(@PHONE_NUM,4,3)
		SET @SELECT_NOR_TEL3 = SUBSTRING(@PHONE_NUM,7,4)
	END
	--중간자리 4글자
	ELSE IF(LEN(@PHONE_NUM) = 11)
	BEGIN
		SET @SELECT_NOR_TEL1 = SUBSTRING(@PHONE_NUM,1,3)
		SET @SELECT_NOR_TEL2 = SUBSTRING(@PHONE_NUM,4,4)
		SET @SELECT_NOR_TEL3 = SUBSTRING(@PHONE_NUM,8,4)
	END


	INSERT INTO CUS_REJECT ([CID 번호],거부신청번호,거부일자,거부타입)
	VALUES(@SELECT_NOR_TEL1 + '-' + @SELECT_NOR_TEL2 + '-' + @SELECT_NOR_TEL3, @SELECT_NOR_TEL1 + '-' + @SELECT_NOR_TEL2 + '-' + @SELECT_NOR_TEL3,@TRANS_REJECT_DATE,'1')
	

	DECLARE CUR CURSOR FOR   --CUR라는 이름의 커서 선언
	
	SELECT TOP 100 CUS_NAME,		
				   EMAIL,		
				   NOR_TEL1,
				   NOR_TEL2,
				   NOR_TEL3,
				   CUS_NO
	FROM CUS_CUSTOMER_damo WITH(NOLOCK)
	WHERE NOR_TEL1 + NOR_TEL2 + NOR_TEL3 = @PHONE_NUM 
	
	OPEN CUR      --커서 오픈
	FETCH NEXT FROM CUR INTO @CUS_NAME, @EMAIL, @NOR_TEL1, @NOR_TEL2, @NOR_TEL3, @CUS_NO
	--커서를이용해 한ROW씩 읽음 
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @INDEX = @INDEX + 1; --INDEX증가
			
			--SELECT 한 데이터의 행집합을 가지고 수행할 작업
			EXEC SP_CUS_RCV_AGREE_INSERT 
				@CUS_NAME = @CUS_NAME, 
				@EMAIL = @EMAIL, 
				@NOR_TEL1 = @NOR_TEL1, 
				@NOR_TEL2 = @NOR_TEL2,  
				@NOR_TEL3 = @NOR_TEL3,  
				@RCV_EMAIL_YN = '',   -- N:수신거부  , Y:수신동의 , 빈값:갱신안함 
				@RCV_SMS_YN = 'N',    --  N:수신거부  , Y:수신동의 , 빈값:갱신안함 
				@AGREE_DATE = @TRANS_REJECT_DATE,  -- 동의 , 거부 날짜 
				@INFLOW_TYPE =  '90', -- 080 수신거부 
				@CUS_NO = @CUS_NO,                    
				@EMP_CODE = '9999999' 

			FETCH NEXT FROM CUR INTO @CUS_NAME, @EMAIL, @NOR_TEL1, @NOR_TEL2, @NOR_TEL3, @CUS_NO
		END
	--커서 닫고 초기화
	CLOSE CUR
	DEALLOCATE CUR
END
GO
