USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_TEAM_SUB_LIST_SELECT
■ DESCRIPTION				: BTMS 하위부서 리스트 검색
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@TEAM_SEQ				: 부서코드
■ EXEC						: 

	EXEC DBO.XP_COM_TEAM_SUB_LIST_SELECT '92756', 2

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-17		JUSTGO백경훈		최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_TEAM_SUB_LIST_SELECT]
	@AGT_CODE		VARCHAR(10),
	@TEAM_SEQ		INT
AS 

WITH LIST AS
(
	SELECT A.AGT_CODE, A.TEAM_SEQ, A.TEAM_NAME, A.PARENT_TEAM_SEQ, A.COM_NUMBER, A.ORDER_NUM, A.USE_YN
	FROM COM_TEAM A WITH(NOLOCK)
	WHERE A.AGT_CODE = @AGT_CODE AND A.TEAM_SEQ = @TEAM_SEQ
	UNION ALL
	SELECT A.AGT_CODE, A.TEAM_SEQ, A.TEAM_NAME, A.PARENT_TEAM_SEQ, A.COM_NUMBER, A.ORDER_NUM, A.USE_YN
	FROM COM_TEAM A WITH(NOLOCK)
	INNER JOIN LIST B ON A.AGT_CODE = B.AGT_CODE AND A.PARENT_TEAM_SEQ = B.TEAM_SEQ
)
SELECT A.*
FROM LIST A
GO
