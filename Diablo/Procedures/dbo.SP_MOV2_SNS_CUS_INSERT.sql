USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_SNS_CUS_INSERT
■ DESCRIPTION				: 입력_SNS 가입정보입력
■ INPUT PARAMETER			: @CUS_NO, @SNS_COMPANY, @SNS_ID, @SNS_EMAIL, @SNS_NAME
■ EXEC						: 
    -- SP_MOV2_SNS_CUS_INSERT '8505125', '1','232328505125','a@a.gmail.com', '김호석'   --일반 회원등록번호 ,SNS 회사 ,SNS 발행 아이디, 이메일, 이름
	EXEC SP_MOV2_SNS_CUS_INSERT '7225080', '3','10417444','uniajung@naver.com', '..러브유'
	SELECT * FROM CUS_SNS_INFO
■ MEMO						: SNS 회원가입시 일반 회원가입 키값으로  SNS 회원입력.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26	  아이비솔루션				최초생성
   2017-10-23		정지용					수정
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_SNS_CUS_INSERT]

	-- Add the parameters for the stored procedure here
	@CUS_NO					INT,
	@SNS_COMPANY			INT,
	@SNS_ID				VARCHAR(20),
	@SNS_EMAIL			VARCHAR(200),
	@SNS_NAME			VARCHAR(20)

AS
BEGIN 
	SET NOCOUNT ON;
	IF EXISTS ( SELECT 1 FROM CUS_SNS_INFO WITH(NOLOCK) WHERE SNS_ID = @SNS_ID AND SNS_COMPANY = @SNS_COMPANY AND DISCNT_DATE IS NULL )
	BEGIN 
		SELECT 'SNS_EXISTS';
		RETURN;
	END
	ELSE
	BEGIN
		IF EXISTS ( SELECT 1 FROM CUS_SNS_INFO WITH(NOLOCK) WHERE SNS_COMPANY = @SNS_COMPANY AND SNS_ID = @SNS_ID AND DISCNT_DATE IS NOT NULL)
		BEGIN
			UPDATE CUS_SNS_INFO SET 
				CUS_NO = @CUS_NO,
				SNS_COMPANY = @SNS_COMPANY,
				SNS_ID = @SNS_ID,
				SNS_EMAIL = @SNS_EMAIL,
				DISCNT_DATE = null,
				NEW_DATE = GETDATE()
			WHERE SNS_COMPANY = @SNS_COMPANY AND SNS_ID = @SNS_ID;
		END
		ELSE
		BEGIN
			INSERT INTO CUS_SNS_INFO (CUS_NO, SNS_COMPANY,SNS_ID,SNS_EMAIL,SNS_NAME, NEW_DATE)
			VALUES(@CUS_NO, @SNS_COMPANY, @SNS_ID, @SNS_EMAIL, @SNS_NAME, GETDATE());
		END
		SELECT '';
	END
/*
IF EXISTS(SELECT * FROM CUS_SNS_INFO WHERE CUS_NO=@CUS_NO)
BEGIN
	SET NOCOUNT ON;
	UPDATE CUS_SNS_INFO SET SNS_COMPANY=@SNS_COMPANY,SNS_ID=@SNS_ID,SNS_EMAIL=@SNS_EMAIL,DISCNT_DATE=null,NEW_DATE=GETDATE()
		OUTPUT INSERTED.*
	WHERE CUS_NO=@CUS_NO
END
ELSE
BEGIN
	SET NOCOUNT ON;
	INSERT INTO CUS_SNS_INFO (CUS_NO, SNS_COMPANY,SNS_ID,SNS_EMAIL,SNS_NAME, NEW_DATE)
		 OUTPUT INSERTED.*
	VALUES(@CUS_NO, @SNS_COMPANY, @SNS_ID, @SNS_EMAIL, @SNS_NAME, GETDATE())
END
*/
END



GO
