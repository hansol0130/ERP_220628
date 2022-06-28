USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_EMP_CODE_STRING_SELECT
■ DESCRIPTION				: 대외업무 사내메일 사내주소록을 위한 부장직급이하 직원 리스트
■ INPUT PARAMETER			: 
	@EMP_STRING				: '이규식[시스템개발],권병철[WEB],김성호[시스템개발],오선경 [WEB],'
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_EMP_CODE_STRING_SELECT '이규식[시스템개발],권병철[WEB],김성호[시스템개발],오선경 [WEB],'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-06-19		김성호			직원명으로 직원코드 리턴
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_EMP_CODE_STRING_SELECT]
(
	@EMP_STRING	NVARCHAR(4000)
)
AS  
BEGIN

	WITH LIST AS
	(
		SELECT
			SUBSTRING(DATA, 0, CHARINDEX('[', DATA, 1)) AS [EMP_NAME]
			, REPLACE(REPLACE(SUBSTRING(DATA, CHARINDEX('[', DATA, 1), 100), '[', ''), ']', '') AS [TEAM_NAME]
		FROM DBO.FN_SPLIT(@EMP_STRING, ',') WHERE DATA <> ''
	)
	SELECT B.EMP_CODE + ',' AS [text()]
	FROM LIST A
	INNER JOIN EMP_MASTER B WITH(NOLOCK) ON A.EMP_NAME = B.KOR_NAME
	INNER JOIN EMP_TEAM C WITH(NOLOCK) ON B.TEAM_CODE = C.TEAM_CODE AND A.TEAM_NAME = C.TEAM_NAME
	WHERE B.WORK_TYPE = 1 AND C.USE_YN = 'Y'
	FOR XML PATH('')

END



GO
