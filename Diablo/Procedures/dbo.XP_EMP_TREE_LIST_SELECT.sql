USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_EMP_TREE_LIST_SELECT
■ DESCRIPTION				: 대외업무 사내메일 사내주소록을 위한 부장직급이하 직원 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_EMP_TREE_LIST_SELECT '2008011'
	exec XP_EMP_TREE_LIST_SELECT 'A130001'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-02-28		김성호			최초생성
   2014-01-14		김성호			팀장 지정 안된 팀 누락으로 인한 수정
   2014-10-28		김성호			직원수 GROUP_TYPE < 9 추가
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_EMP_TREE_LIST_SELECT]
(
	@EMP_CODE	CHAR(7)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(200);

	IF DBO.XN_COM_GET_VGL_YN(@EMP_CODE) = 'Y'
	BEGIN
		SET @WHERE = ''
	END
	ELSE IF DBO.XN_COM_GET_VGL_YN(@EMP_CODE) = 'N'
	BEGIN
		SELECT @WHERE = ' AND A.TEAM_CODE IN (SELECT AA.TEAM_CODE FROM EMP_MASTER AA WITH(NOLOCK) WHERE AA.WORK_TYPE = ''1'' GROUP BY AA.TEAM_CODE HAVING MAX(AA.POS_TYPE) < 7)'
	END

	SET @SQLSTRING = N'
	WITH LIST AS
	(
		SELECT NULL AS [PARENT_CODE], TEAM_NAME AS [EMP_NAME], CONVERT(VARCHAR(7), A.TEAM_CODE) AS [CODE]
			, (SELECT COUNT(*) FROM EMP_MASTER AA WHERE AA.TEAM_CODE = A.TEAM_CODE AND AA.WORK_TYPE = ''1'' AND AA.GROUP_TYPE < 9' + @WHERE + ') AS [EMPLOYEE_COUNT]
			, ''T'' AS [FLAG], '''' AS [INFO], ORDER_SEQ AS [SORT]
		FROM EMP_TEAM A
		WHERE USE_YN = ''Y'' AND VIEW_YN = ''Y''' + @WHERE + '
	)
	SELECT *
	FROM LIST
	UNION ALL
	SELECT A.TEAM_CODE AS [PARENT_CODE], A.KOR_NAME AS [EMP_NAME], CONVERT(VARCHAR(7), A.EMP_CODE) AS [CODE]
		, 0 AS [EMPLOYEE_COUNT], ''E'' AS [FLAG], B.TEAM_NAME AS [INFO], ''999'' AS [SORT]
	FROM EMP_MASTER A
	INNER JOIN EMP_TEAM B ON A.TEAM_CODE = B.TEAM_CODE
	WHERE WORK_TYPE = ''1'' AND A.TEAM_CODE IN (SELECT CODE FROM LIST) AND A.GROUP_TYPE < 9' + @WHERE + '
	ORDER BY SORT, EMP_NAME'

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING;

END



GO
