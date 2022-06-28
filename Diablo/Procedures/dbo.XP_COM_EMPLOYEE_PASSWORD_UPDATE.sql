USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_EMPLOYEE_PASSWORD_UPDATE
■ DESCRIPTION				: BTMS 거래처 직원 비밀번호 초기화
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@EMP_SEQ				: 직원코드
	@PASSWORD				: 변경 패스워드
	@NEW_SEQ				: 변경 직원코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-01		김성호			비밀번호 초기화
   2016-08-01		이유라			ERP수정시 VGT담당자정보 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_EMPLOYEE_PASSWORD_UPDATE]
	@AGT_CODE		VARCHAR(10),
	@EMP_SEQ		INT,
	@PASSWORD		VARCHAR(100),
	@NEW_SEQ		INT,
	@VGL_CODE		VARCHAR(8)
AS 
BEGIN

	--UPDATE COM_EMPLOYEE SET PASS_WORD = @PASSWORD, FAIL_COUNT = 0, EDT_DATE = GETDATE(), EDT_SEQ = @NEW_SEQ WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ = @EMP_SEQ;
	UPDATE COM_EMPLOYEE 
	SET PASS_WORD = @PASSWORD
		, FAIL_COUNT = 0
		, EDT_DATE = CASE WHEN @VGL_CODE IS NOT NULL THEN EDT_DATE ELSE GETDATE() END
		, EDT_SEQ = CASE WHEN @VGL_CODE IS NOT NULL THEN EDT_SEQ ELSE @NEW_SEQ END
		, VGL_CODE = CASE WHEN @VGL_CODE IS NOT NULL THEN  @VGL_CODE ELSE VGL_CODE END
		, VGL_DATE = CASE WHEN @VGL_CODE IS NOT NULL THEN GETDATE() ELSE VGL_DATE END
	WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ = @EMP_SEQ;

END
GO
