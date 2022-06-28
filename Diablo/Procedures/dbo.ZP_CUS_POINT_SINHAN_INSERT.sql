USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_Name					: ZP_CUS_POINT_SINHAN_INSERT
■ Description				: 신한은행이벤트 포인트 적립
■ Input Parameter			: 
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

-- 적립
	EXEC ZP_CUS_POINT_SINHAN_INSERT @SHINHAN_CODE, @CUS_NO, @REMARK
	
■ Memo						: 
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
   Date				Author			Description           
------------------------------------------------------------------------------------------------------------------
   2021-03-31		김영민			신한은행이벤트포인트적립			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_CUS_POINT_SINHAN_INSERT]
	@SHINHAN_CODE				CHAR(10),
	@CUS_NO						INT
AS

    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @TOTAL_POINT INT

	IF EXISTS (SELECT * FROM VIEW_MEMBER WHERE CUS_NO = @CUS_NO)
	BEGIN
	   ---SHBANK_CODE 사용자 / 코드확인
		IF EXISTS (SELECT * FROM onetime.SHBANK_CODE WHERE CUS_NO = @CUS_NO  AND CODE = @SHINHAN_CODE )
			BEGIN 
				SELECT 'EXIST' --이미적립한회원
			END 
			ELSE 
			BEGIN
			 ---SHBANK_CODE 코드번호확인
				IF EXISTS (SELECT * FROM onetime.SHBANK_CODE  WHERE CODE = @SHINHAN_CODE AND CUS_NO IS NULL)
				BEGIN
					SET @TOTAL_POINT = ISNULL(
						(	SELECT TOP 1 TOTAL_PRICE
							FROM CUS_POINT AS CP WITH(NOLOCK)
							WHERE CP.CUS_NO = @CUS_NO ORDER BY POINT_NO DESC ) , 0 ) + '10000' 

					-- 유효기간 현재 3년 으로 .ACC_USE_TYPE- 이벤트적립(5)/ 관리자New_code /36개월/신한이벤트적립/ POINT_PRICE 10000 / TOTAL_PRICE total_point + 10000원
					UPDATE  onetime.SHBANK_CODE
					SET
					CUS_NO = @CUS_NO,
					NEW_DATE = GETDATE()
					WHERE  CODE =@SHINHAN_CODE
			
					INSERT INTO CUS_POINT ( CUS_NO,POINT_TYPE,ACC_USE_TYPE,START_DATE,END_DATE,
						POINT_PRICE,RES_CODE,TITLE,TOTAL_PRICE,REMARK,NEW_CODE,NEW_DATE,MASTER_SEQ,BOARD_SEQ ) 
					VALUES ( @CUS_NO,1,5,GETDATE(),DATEADD(MM,36,GETDATE()),
						10000,NULL,'신한은행 Someday 외환적금 가입 이벤트',@TOTAL_POINT,NULL,'9999999',GETDATE(),NULL,NULL ) 	
					
				SELECT 'SUCC'--성공
					
				END
				ELSE
			
				SELECT 'FAIL'--코드번호 틀림
				
			END
	END
	ELSE
		SELECT 'NOMEM' --회원이 아님



		
	
	


GO
