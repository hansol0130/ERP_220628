USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_EMPLOYEE_ID_LIST_SELECT
■ DESCRIPTION				: BTMS 직원 아이디 리스트
■ INPUT PARAMETER			: NONE
■ OUTPUT PARAMETER			: 
■ EXEC						: EXEC DBO.XP_COM_EMPLOYEE_ID_LIST_SELECT '92756'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-18		강태영			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_EMPLOYEE_ID_LIST_SELECT]

@AGT_CODE VARCHAR(10)
AS 
BEGIN

	SELECT
		AGT_CODE,
		EMP_SEQ,
		EMP_ID,
		KOR_NAME
	FROM COM_EMPLOYEE
	WHERE AGT_CODE = @AGT_CODE

END 

GO
