USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_EVENT_VIEW_COUNT_LIST_SELECT
■ DESCRIPTION				: 주별 이벤트,기획전 읽음 수 검색
■ INPUT PARAMETER			: 

	@START_DATE				: 조회 시작일
	@END_DATE				: 조회 종료일
	@EVENT_YN				: Y: 이벤트, N: 기획전
	@REGION_CODE			: 지역코드
	@ATT_CODE				: 속성코드
	@TOP_VIEW				: 최대검색수
	@EVENT_NAME				: 이벤트명
	@ORDER_TYPE				: 1: 조회수, 2: 등록역순, 3: 수정일역순

■ EXEC						: 

	EXEC XP_PUB_EVENT_VIEW_COUNT_LIST_SELECT '2018-03-01', '2018-04-30', 'N', '', '', 100, '파도', 2

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-03-27		김성호					최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_PUB_EVENT_VIEW_COUNT_LIST_SELECT]
	@START_DATE		DATE,
	@END_DATE		DATE,
	@EVENT_YN		VARCHAR(1),
	@REGION_CODE	VARCHAR(1),
	@ATT_CODE		VARCHAR(1),
	@TOP_VIEW		INT,
	@EVENT_NAME		VARCHAR(100),
	@ORDER_TYPE		INT = 1
AS
BEGIN

	DECLARE @SQLSTRING NVARCHAR(MAX) = '', @PARMDEFINITION NVARCHAR(1000) = '';
	DECLARE @WHERE NVARCHAR(1000) = '', @TOP_STRING NVARCHAR(100) = '', @SORT_STRING NVARCHAR(50), @DATE_STRING NVARCHAR(4000) = '';

	-- 마지막 날짜가 오늘을 넘지 않도록
	--IF @START_DATE < '2018-03-01'
	--	SET @START_DATE = '2018-03-01';
	IF @END_DATE > GETDATE()
		SET @END_DATE = GETDATE();

	IF @TOP_VIEW > 0
	BEGIN
		SET @TOP_STRING = ' TOP (@TOP_VIEW) ';
	END

	-- 최소생성 제외
	SET @WHERE = ' AND B.READ_DATE > ''2018-03-18''';

	IF LEN(@EVENT_YN) = 1
	BEGIN
		SET @WHERE = @WHERE + N' AND C.EVT_YN = @EVENT_YN'
	END

	IF LEN(@REGION_CODE) = 1
	BEGIN
		SET @WHERE = @WHERE + N' AND CHARINDEX(@REGION_CODE, ISNULL(C.SIGN_CODE, @REGION_CODE)) > 0'
	END

	IF LEN(@ATT_CODE) = 1
	BEGIN
		SET @WHERE = @WHERE + N' AND CHARINDEX(@ATT_CODE, ISNULL(C.ATT_CODE, @ATT_CODE)) > 0'--(C.ATT_CODE = @ATT_CODE OR C.ATT_CODE IS NULL)'
	END

	IF LEN(@EVENT_NAME) > 1
	BEGIN
		SET @WHERE = @WHERE + N' AND C.EVT_NAME LIKE ''%'' + @EVENT_NAME + ''%'''
	END

	IF LEN(@WHERE) > 0
	BEGIN
		SET @WHERE = 'WHERE ' + SUBSTRING(@WHERE, 5, 1000)
	END

	SELECT @SORT_STRING = (
		CASE @ORDER_TYPE
			WHEN 2 THEN 'B.NEW_DATE DESC'
			WHEN 3 THEN 'ISNULL(B.EDT_DATE, B.NEW_DATE) DESC'
			ELSE 'A.[합계] DESC'
		END
	)

	-- PIVOT 문자열
	SELECT @DATE_STRING = SUBSTRING(CONVERT(NVARCHAR(4000), (
		SELECT (',' + A.FLAG) AS [text()]
		FROM (
			SELECT '[' + CONVERT(VARCHAR(4), YEAR(A.DATE)) + '년' + RIGHT(('0' + CONVERT(VARCHAR(2), MONTH(A.DATE))), 2) + '월'
				+ CONVERT(VARCHAR(1), ROW_NUMBER() OVER (PARTITION BY YEAR(A.DATE), MONTH(A.DATE) ORDER BY A.DATE)) + '주]' AS [FLAG]
			FROM [DBO].[PUB_TMP_DATE] A WITH(NOLOCK)
			WHERE A.DATE >= @START_DATE AND A.DATE < @END_DATE AND WEEK_DAY = 1
		) A
		FOR XML PATH('')
	)) + ',[합계]', 2, 4000)
	

	SET @SQLSTRING = N'
WITH EVT_LIST AS (
	SELECT *
	FROM (
		SELECT B.EVT_SEQ, ISNULL((A.YEAR + ''년'' + A.MONTH + ''월'' + A.WEEK_NUM + ''주''), ''합계'') AS [DATE_INFO], SUM(B.WEEK_COUNT) AS [WEEK_COUNT]
		FROM (
			SELECT A.DATE, A.WEEK_DAY, CONVERT(VARCHAR(4), YEAR(A.DATE)) AS [YEAR], RIGHT((''0'' + CONVERT(VARCHAR(2), MONTH(A.DATE))), 2) AS [MONTH]
				, CONVERT(VARCHAR(1), ROW_NUMBER() OVER (PARTITION BY YEAR(A.DATE), MONTH(A.DATE) ORDER BY A.DATE)) AS [WEEK_NUM]
			FROM [DBO].[PUB_TMP_DATE] A WITH(NOLOCK)
			WHERE A.DATE >= @START_DATE AND A.DATE < @END_DATE AND WEEK_DAY = 1
		) A
		INNER JOIN VGLOG.DBO.PUB_EVENT_READ_COUNT B WITH(NOLOCK) ON A.DATE = B.READ_DATE
		INNER JOIN DIABLO.DBO.PUB_EVENT C WITH(NOLOCK) ON B.EVT_SEQ = C.EVT_SEQ
		' + @WHERE + N'
		GROUP BY GROUPING SETS (((A.YEAR + ''년'' + A.MONTH + ''월'' + A.WEEK_NUM + ''주''), B.EVT_SEQ, WEEK_COUNT)
			, (B.EVT_SEQ))
	) A
	PIVOT (
		SUM(A.WEEK_COUNT) FOR A.DATE_INFO IN (' + @DATE_STRING + N')
	) AS [PVT]
)
SELECT ' + @TOP_STRING + N' A.EVT_SEQ AS [번호], B.EVT_NAME AS [기획전명], CONVERT(VARCHAR(10), B.NEW_DATE, 120) + ISNULL((''<br />('' + CONVERT(VARCHAR(10), B.EDT_DATE, 120) + '')''), '''') AS [등록(수정)일]
	, ' + @DATE_STRING + N'
FROM EVT_LIST A
INNER JOIN Diablo.DBO.PUB_EVENT B WITH(NOLOCK) ON A.EVT_SEQ = B.EVT_SEQ
ORDER BY ' + @SORT_STRING + ';'

	--PRINT @SQLSTRING;

	SET @PARMDEFINITION = N'
		@START_DATE DATE, 
		@END_DATE DATE,
		@EVENT_YN VARCHAR(1),
		@REGION_CODE VARCHAR(1),
		@ATT_CODE VARCHAR(1),
		@TOP_VIEW INT,
		@EVENT_NAME VARCHAR(100)';

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@START_DATE, 
		@END_DATE,
		@EVENT_YN,
		@REGION_CODE,
		@ATT_CODE,
		@TOP_VIEW,
		@EVENT_NAME;

END

GO
