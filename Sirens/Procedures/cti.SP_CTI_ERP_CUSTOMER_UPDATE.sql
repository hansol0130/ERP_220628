USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ERP_CUSTOMER_UPDATE
■ DESCRIPTION				: ERP 고객정보 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_ERP_CUSTOMER_UPDATE 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-25		박형만			최초생성
   2014-10-27		박형만			정회원(CUS_MEMBER)은 여행자(CUS_CUSTOMER)  수정안되도록 요청사항  처리
   2014-11-13		곽병삼			고객특징(ETC) 내용 추가.
   2015-09-04		정지용			휴면계정으로 인해 회원테이블 업데이트 분기
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ERP_CUSTOMER_UPDATE]
--DECLARE
	@CUS_NO	INT,
	@CUS_ID	VARCHAR(20),
	@CUS_NAME	VARCHAR(20),
	@BIRTH_DATE	VARCHAR(20),
	@GENDER		VARCHAR(1),
	@EMAIL		VARCHAR(40),
	@NOR_TEL1	VARCHAR(6),
	@NOR_TEL2	VARCHAR(4),
	@NOR_TEL3	VARCHAR(4),
	@HOM_TEL1	VARCHAR(6),
	@HOM_TEL2	VARCHAR(4),
	@HOM_TEL3	VARCHAR(4),
	@COM_TEL1	VARCHAR(6),
	@COM_TEL2	VARCHAR(4),
	@COM_TEL3	VARCHAR(4),
	@EMP_CODE	VARCHAR(7),
	@ETC		NVARCHAR(MAX)

--SET @CUS_NAME = '테스트'
--SET @CUS_ID = ''
--SET @BIRTH_DATE = '2014-10-23'
--SET @GENDER = 'M'
--SET @EMAIL = 'sam9339@naver.com'
--SET @NOR_TEL1 = '010'
--SET @NOR_TEL2 = '5566'
--SET @NOR_TEL3 = '4455'
--SET @EMP_CODE = '2012019'
AS
BEGIN

	--여행자정보수정
	UPDATE Diablo.DBO.CUS_CUSTOMER_DAMO 
	SET CUS_NAME = @CUS_NAME 
		,BIRTH_DATE = @BIRTH_DATE	 
		,GENDER	 = @GENDER		 
		,EMAIL = @EMAIL		 
		,NOR_TEL1 = @NOR_TEL1	 
		,NOR_TEL2 = @NOR_TEL2	 
		,NOR_TEL3 = @NOR_TEL3	 
		,HOM_TEL1 = @HOM_TEL1	 
		,HOM_TEL2 = @HOM_TEL2	 
		,HOM_TEL3 = @HOM_TEL3	 
		,COM_TEL1 = @COM_TEL1	 
		,COM_TEL2 = @COM_TEL2	 
		,COM_TEL3 = @COM_TEL3	 
		,ETC = @ETC
	WHERE  CUS_NO = @CUS_NO 

	--정회원정보중 이름,생년월일,성별을 수정할수 없음
	IF( ISNULL(@CUS_ID,'') <> '')
	BEGIN
		IF EXISTS(SELECT 1 FROM Diablo.dbo.CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @CUS_NO AND CUS_ID IS NULL)
		BEGIN
			--정회원정보 수정
			UPDATE Diablo.DBO.CUS_MEMBER_SLEEP
			SET EMAIL = @EMAIL		 
				,NOR_TEL1 = @NOR_TEL1	 
				,NOR_TEL2 = @NOR_TEL2	 
				,NOR_TEL3 = @NOR_TEL3	 
				,HOM_TEL1 = @HOM_TEL1	 
				,HOM_TEL2 = @HOM_TEL2	 
				,HOM_TEL3 = @HOM_TEL3	 
				,COM_TEL1 = @COM_TEL1	 
				,COM_TEL2 = @COM_TEL2	 
				,COM_TEL3 = @COM_TEL3	 
				,ETC = @ETC
			WHERE  CUS_NO = @CUS_NO 
		END
		ELSE
		BEGIN
			--정회원정보 수정
			UPDATE Diablo.DBO.CUS_MEMBER
			SET EMAIL = @EMAIL		 
				,NOR_TEL1 = @NOR_TEL1	 
				,NOR_TEL2 = @NOR_TEL2	 
				,NOR_TEL3 = @NOR_TEL3	 
				,HOM_TEL1 = @HOM_TEL1	 
				,HOM_TEL2 = @HOM_TEL2	 
				,HOM_TEL3 = @HOM_TEL3	 
				,COM_TEL1 = @COM_TEL1	 
				,COM_TEL2 = @COM_TEL2	 
				,COM_TEL3 = @COM_TEL3	 
				,ETC = @ETC
			WHERE  CUS_NO = @CUS_NO 
		END
	END 

	SELECT @CUS_NO as CUS_NO
END
GO
