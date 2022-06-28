USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_EMPLOYEE_EMAIL_SELECT
■ DESCRIPTION				: BTMS 거래처 직원 EMAIL 상세정보 검색
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@EMAIL_SEQ				: 메일순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_COM_EMPLOYEE_EMAIL_SELECT 92756, 1

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-22		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_EMPLOYEE_EMAIL_SELECT]
	@AGT_CODE	VARCHAR(10),
	@EMAIL_SEQ	INT
AS 
BEGIN

	SELECT A.AGT_CODE, A.EMAIL_SEQ, A.MAIL_TYPE, A.RCV_EMAIL, A.EMP_SEQ, A.BODY, A.RCV_STATE, A.RCV_DATE, A.CFM_DATE
	FROM COM_RECEIVE_EMAIL A
	WHERE A.AGT_CODE = @AGT_CODE AND A.EMAIL_SEQ = @EMAIL_SEQ

END 





GO
