USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [XP_COM_EMPLOYEE_PASS_LATEST_SELECT
■ DESCRIPTION				: BTMS  직원 여권 가장최근 1건 가져오기 
■ INPUT PARAMETER			: 
	 
■ OUTPUT PARAMETER			: 
 
■ EXEC						: 
 
	EXEC DBO.XP_COM_EMPLOYEE_PASS_LATEST_SELECT  
	 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
  
   2016-04-28		박형만		최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_EMPLOYEE_PASS_LATEST_SELECT]
	@AGT_CODE	VARCHAR(10),
	@EMP_SEQ	INT
AS 
BEGIN

	-- 여권정보
	SELECT A.AGT_CODE, A.EMP_SEQ, A.PASS_SEQ, A.NATION_CODE, B.KOR_NAME AS [NATION_NAME], A.PASS_BIRTHDATE, A.PASS_NUM, A.PASS_ISSUE, A.PASS_EXPIRE, A.NEW_DATE, A.NEW_SEQ
	FROM COM_EMP_PASSPORT A WITH(NOLOCK)
	INNER JOIN PUB_NATION B WITH(NOLOCK) ON A.NATION_CODE = B.NATION_CODE
	WHERE A.AGT_CODE = @AGT_CODE AND A.EMP_SEQ = @EMP_SEQ AND USE_YN = 'Y'
	ORDER BY A.PASS_SEQ DESC 

END 
GO
