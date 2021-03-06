USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_CTI_TEAM_SUMMARY_LIST_SELECT
■ DESCRIPTION				: CTI 팀별 통계
■ INPUT PARAMETER			: 
	@START_DATE				: 기준일
	@END_DATE				: 종료일
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_CTI_TEAM_SUMMARY_LIST_SELECT '2015-12-01', '2016-01-01'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-12-21		김성호			최초생성
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_CTI_TEAM_SUMMARY_LIST_SELECT]
(
	@START_DATE	DATE,
	@END_DATE	DATE
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH EMP_LIST AS 
	(
		---- 대상 직원 선별
		SELECT A.EMP_CODE, A.JOIN_DATE, A.OUT_DATE, A.TEAM_CODE
		FROM DIABLO.DBO.EMP_MASTER_damo A WITH(NOLOCK)
		INNER JOIN Diablo.DBO.EMP_TEAM B WITH(NOLOCK) ON A.TEAM_CODE = B.TEAM_CODE
		WHERE A.EMP_CODE < '3000000' AND A.WORK_TYPE = '1' AND A.CTI_USE_YN = 'Y' AND A.DUTY_TYPE = 1 AND A.TEAM_CODE NOT IN (540, 558, 556, 560, 557, 529, 538, 518)
			AND A.JOIN_DATE < @END_DATE AND (A.OUT_DATE IS NULL OR A.OUT_DATE > @START_DATE)
	)
	, EMP_WORK_DATE_LIST AS
	(
		-- 대상 직원 별 근무일 조회
		SELECT CONVERT(VARCHAR(8), A.DATE, 112) AS [YMD_DATE], B.EMP_CODE, B.TEAM_CODE
		FROM DIABLO.DBO.PUB_TMP_DATE A WITH(NOLOCK)
		INNER JOIN EMP_LIST B ON A.DATE >= B.JOIN_DATE
		LEFT JOIN (
			SELECT AA.EDI_CODE, AA.NEW_CODE, BB.DATE, BB.WEEK_DAY
			FROM DIABLO.DBO.EDI_MASTER_damo AA WITH(NOLOCK)
			LEFT JOIN DIABLO.DBO.PUB_TMP_DATE BB WITH(NOLOCK) ON BB.DATE >= AA.JOIN_DATE AND BB.DATE <=  AA.OUT_DATE
			WHERE AA.EDI_STATUS = 3 AND AA.VIEW_YN = 'Y' AND AA.DOC_TYPE IN (1,2)
				AND (AA.JOIN_DATE >= @START_DATE AND AA.JOIN_DATE < @END_DATE OR AA.OUT_DATE >= @START_DATE AND AA.OUT_DATE < @END_DATE)
		) C ON B.EMP_CODE = C.NEW_CODE AND A.DATE = C.DATE
		WHERE A.DATE >= @START_DATE AND A.DATE < @END_DATE AND A.WEEK_DAY IN (2, 3, 4, 5, 6)
			AND A.DATE NOT IN (SELECT HOLIDAY FROM PUB_HOLIDAY WITH(NOLOCK) WHERE HOLIDAY >= @START_DATE AND HOLIDAY < @END_DATE)
			AND C.DATE IS NULL -- 휴가 제외
	)
	, TEAM_EMP_LIST AS
	(
		-- 팀 인원 조회
		SELECT A.TEAM_CODE, COUNT(*) AS [EMP_COUNT]
		FROM EMP_LIST A
		GROUP BY A.TEAM_CODE
	)
	, TEAM_MONTH_WORK_LIST AS
	(
		-- 팀 전체 근무일
		SELECT A.TEAM_CODE, COUNT(*) AS [WORK_COUNT]
		FROM EMP_WORK_DATE_LIST A
		GROUP BY A.TEAM_CODE
	)
	, TEAM_CALL_TIME_LIST AS
	(
		-- 팀 전체 통화시간
		SELECT A.TEAM_CODE
			, (SUM(B.IN_CALL_TIME) + SUM(B.OUT_CALL_TIME)) AS [CALL_TIME]
			, SUM(B.RESERVE_COUNT) AS [RES_COUNT]
		FROM EMP_WORK_DATE_LIST A
		INNER JOIN Sirens.cti.CTI_STAT_WORKTIME B WITH(NOLOCK) ON B.S_DATE = A.YMD_DATE --AND B.TEAM_CODE = A.TEAM_CODE
			AND B.EMP_CODE = A.EMP_CODE
		GROUP BY A.TEAM_CODE
	)
	, TEAM_COMMENT_LIST AS
	(
	
		SELECT A.TEAM_CODE, COUNT(*) AS [TOTAL_CALL_COUNT]
			, ISNULL(SUM(CASE WHEN B.CONSULT_CONTENT LIKE '상담내용없음' AND B.DURATION_TIME > 20 THEN 1 END), 0) AS [NO_COMMENT]
		FROM EMP_LIST A
		INNER JOIN Sirens.cti.CTI_CONSULT B WITH(NOLOCK) ON A.EMP_CODE = B.EMP_CODE AND B.CONSULT_DATE >= @START_DATE AND B.CONSULT_DATE < @END_DATE
		--INNER JOIN TEAM_MONTH_WORK_LIST C ON A.TEAM_CODE = C.TEAM_CODE
		GROUP BY A.TEAM_CODE
	)
	, TEAM_COMMENT_RATE_LIST AS 
	(
		SELECT A.TEAM_CODE
			--, ROUND(((A.TOTAL_CALL_COUNT * 1.0) / A.TOTAL_WORK_COUNT), 1) AS [DAY_AVG_CALL_COUNT]
			, ROUND(100 - (A.NO_COMMENT * 100.0 / A.TOTAL_CALL_COUNT), 1) AS [AVG_COMMENT_RATE]
		FROM TEAM_COMMENT_LIST A
	)
	, TEAM_CALL_TIME_DAY_LIST AS
	(
		SELECT A.TEAM_CODE, A.RES_COUNT, A.CALL_TIME AS [TOTAL_CALL_TIME], (A.CALL_TIME / (CASE WHEN B.WORK_COUNT > 0 THEN B.WORK_COUNT ELSE 1 END)) AS [DAY_CALL_TIME]
		FROM TEAM_CALL_TIME_LIST A
		INNER JOIN TEAM_MONTH_WORK_LIST B ON A.TEAM_CODE = B.TEAM_CODE
	)
	SELECT
		-- 팀명, 사번, 성명, 근무일 수, 상담건수, 일평균상담건수, 총통화시간, 일평균통화시간, 평균작성율, 예약 건수
		A.TEAM_CODE AS [팀코드]
		, G.TEAM_NAME AS [팀명]
		, F.EMP_COUNT AS [팀원수]
		, A.WORK_COUNT AS [총근무일수]
		, (A.WORK_COUNT / F.EMP_COUNT) AS [인당근무일수]
		, C.TOTAL_CALL_COUNT AS [총통화수]
		, (C.TOTAL_CALL_COUNT / F.EMP_COUNT) AS [인당통화수]
		, Sirens.cti.FN_GET_TIME_STRING(E.TOTAL_CALL_TIME) AS [총통화시간]
		, Sirens.cti.FN_GET_TIME_STRING(E.TOTAL_CALL_TIME / C.TOTAL_CALL_COUNT) AS [콜평균통화시간]
		, Sirens.cti.FN_GET_TIME_STRING(E.DAY_CALL_TIME) AS [일평균통화시간]
		, (C.TOTAL_CALL_COUNT / A.WORK_COUNT) AS [일평균통화수]
		, D.AVG_COMMENT_RATE AS [평균작성율]
		, B.RES_COUNT AS [총예약건수]
		, (B.RES_COUNT / F.EMP_COUNT) AS [인당예약건수]
	FROM TEAM_MONTH_WORK_LIST A
	INNER JOIN TEAM_CALL_TIME_LIST B ON A.TEAM_CODE = B.TEAM_CODE
	INNER JOIN TEAM_COMMENT_LIST C ON A.TEAM_CODE = C.TEAM_CODE
	INNER JOIN TEAM_COMMENT_RATE_LIST D ON A.TEAM_CODE = D.TEAM_CODE
	INNER JOIN TEAM_CALL_TIME_DAY_LIST E ON A.TEAM_CODE = E.TEAM_CODE
	INNER JOIN TEAM_EMP_LIST F ON A.TEAM_CODE = F.TEAM_CODE
	INNER JOIN Diablo.DBO.EMP_TEAM G WITH(NOLOCK) ON A.TEAM_CODE = G.TEAM_CODE
	ORDER BY G.TEAM_NAME;

END

GO
