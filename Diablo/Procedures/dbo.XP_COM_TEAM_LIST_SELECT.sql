USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_TEAM_LIST_SELECT
■ DESCRIPTION				: BTMS 조직 리스트 검색
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_COM_TEAM_LIST_SELECT 93084

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-23		김성호			최초생성
   2016-01-26		김성호			parent_agt_code null 검색되게 처리
   2016-02-02		김성호			레벨별 정리를 위해 정렬값 생성및 정렬 조건 변경
   2016-03-16		김성호			트리뷰 디자인 정리를 위한 마지막 노드 유무 추가
   2016-05-11		이유라			부서별 직원수 컬럼 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_TEAM_LIST_SELECT]
	@AGT_CODE		VARCHAR(10)
AS 
BEGIN

	-- 수정자정보
	--WITH LIST AS
	--(
	--	SELECT TOP 1 AGT_CODE, ISNULL(EDT_SEQ, NEW_SEQ) AS [NEW_SEQ], ISNULL(EDT_DATE, NEW_DATE) AS [NEW_DATE]
	--	FROM COM_TEAM WITH(NOLOCK)
	--	WHERE AGT_CODE = @AGT_CODE
	--	ORDER BY ISNULL(EDT_DATE, NEW_DATE) DESC
	--)
	--SELECT A.EMP_SEQ, A.KOR_NAME, B.TEAM_NAME, C.POS_NAME, Z.NEW_DATE
	--FROM LIST Z
	--INNER JOIN COM_EMPLOYEE A WITH(NOLOCK) ON Z.AGT_CODE = A.AGT_CODE AND Z.NEW_SEQ = A.EMP_SEQ
	--INNER JOIN COM_TEAM B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.TEAM_SEQ = B.TEAM_SEQ
	--INNER JOIN COM_POSITION C WITH(NOLOCK) ON A.AGT_CODE = C.AGT_CODE AND A.POS_SEQ = C.POS_SEQ;

	--WITH LIST1 AS
	--(
	--	SELECT A.AGT_CODE, A.TEAM_SEQ, A.TEAM_NAME, A.PARENT_TEAM_SEQ, A.COM_NUMBER, A.ORDER_NUM, A.USE_YN, 0 AS [LEVEL]
	--		, CONVERT(VARCHAR(100), RIGHT(('00000' + CONVERT(VARCHAR(10), A.ORDER_NUM)), 5)) AS [ORDER_STRING]
	--	FROM COM_TEAM A WITH(NOLOCK)
	--	WHERE A.AGT_CODE = @AGT_CODE AND (A.PARENT_TEAM_SEQ IS NULL OR A.PARENT_TEAM_SEQ = 0)
	--	UNION ALL
	--	SELECT A.AGT_CODE, A.TEAM_SEQ, A.TEAM_NAME, A.PARENT_TEAM_SEQ, A.COM_NUMBER, A.ORDER_NUM, A.USE_YN, (B.LEVEL + 1)
	--		, CONVERT(VARCHAR(100), B.ORDER_STRING + RIGHT(('00000' + CONVERT(VARCHAR(10), A.ORDER_NUM)), 5))
	--	FROM COM_TEAM A WITH(NOLOCK)
	--	INNER JOIN LIST1 B ON A.PARENT_TEAM_SEQ = B.TEAM_SEQ
	--	WHERE A.AGT_CODE = @AGT_CODE
	--)
	--, LIST2 AS (
	--	SELECT A.AGT_CODE, A.TEAM_SEQ, (CASE WHEN MAX(B.TEAM_SEQ) IS NULL THEN 'Y' ELSE 'N' END) AS [END_YN]
	--	FROM LIST1 A
	--	LEFT JOIN LIST1 B ON A.AGT_CODE = B.AGT_CODE AND A.TEAM_SEQ = B.PARENT_TEAM_SEQ
	--	GROUP BY A.AGT_CODE, A.TEAM_SEQ
	--)
	--SELECT A.*, B.END_YN
	--FROM LIST1 A
	--LEFT JOIN LIST2 B ON A.AGT_CODE = B.AGT_CODE AND A.TEAM_SEQ = B.TEAM_SEQ
	--ORDER BY A.ORDER_STRING

	WITH LIST1 AS
	(
		SELECT A.AGT_CODE, A.TEAM_SEQ, A.TEAM_NAME, A.PARENT_TEAM_SEQ, A.COM_NUMBER, A.ORDER_NUM, A.USE_YN, 0 AS [LEVEL]
			, CONVERT(VARCHAR(100), RIGHT(('000' + CONVERT(VARCHAR(10), A.ORDER_NUM)), 3) + RIGHT(('000' + CONVERT(VARCHAR(10), A.TEAM_SEQ)), 3)) AS [ORDER_STRING]
		FROM COM_TEAM A WITH(NOLOCK)
		WHERE A.AGT_CODE = @AGT_CODE AND (A.PARENT_TEAM_SEQ IS NULL OR A.PARENT_TEAM_SEQ = 0)
		UNION ALL
		SELECT A.AGT_CODE, A.TEAM_SEQ, A.TEAM_NAME, A.PARENT_TEAM_SEQ, A.COM_NUMBER, A.ORDER_NUM, A.USE_YN, (B.LEVEL + 1)
			, CONVERT(VARCHAR(100), B.ORDER_STRING + RIGHT(('000' + CONVERT(VARCHAR(10), A.ORDER_NUM)), 3) + RIGHT(('000' + CONVERT(VARCHAR(10), A.TEAM_SEQ)), 3))
		FROM COM_TEAM A WITH(NOLOCK)
		INNER JOIN LIST1 B ON A.PARENT_TEAM_SEQ = B.TEAM_SEQ
		WHERE A.AGT_CODE = @AGT_CODE
	)
	, LIST2 AS (
		SELECT A.AGT_CODE, A.TEAM_SEQ, (CASE WHEN MAX(B.TEAM_SEQ) IS NULL THEN 'Y' ELSE 'N' END) AS [END_YN]
		FROM LIST1 A
		LEFT JOIN LIST1 B ON A.AGT_CODE = B.AGT_CODE AND A.TEAM_SEQ = B.PARENT_TEAM_SEQ
		GROUP BY A.AGT_CODE, A.TEAM_SEQ
	)
	SELECT A.*, B.END_YN, ISNULL((SELECT COUNT(*) FROM COM_EMPLOYEE C WHERE A.AGT_CODE = C.AGT_CODE AND A.TEAM_SEQ = C.TEAM_SEQ),0) AS EMP_COUNT
	FROM LIST1 A
	LEFT JOIN LIST2 B ON A.AGT_CODE = B.AGT_CODE AND A.TEAM_SEQ = B.TEAM_SEQ
	ORDER BY A.ORDER_STRING

END 

GO
