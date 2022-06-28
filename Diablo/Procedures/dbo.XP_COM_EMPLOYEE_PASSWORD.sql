USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_EMPLOYEE_PASSWORD
■ DESCRIPTION				: BTMS 거래처 직원 비밀번호
■ INPUT PARAMETER			: EMP_SEQ, AGT_CODE
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
	EXEC XP_COM_EMPLOYEE_PASSWORD '92756'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE					AUTHOR				DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-27		저스트고강태영			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_EMPLOYEE_PASSWORD]
	@AGT_CODE VARCHAR(5),
	@EMP_SEQ INT
AS 
BEGIN

SELECT
	EMP_SEQ,
	KOR_NAME,
	PASS_WORD
FROM COM_EMPLOYEE
WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ = @EMP_SEQ

END

GO
