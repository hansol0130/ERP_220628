USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_PKG_SEARCH_CATEGORY_LIST_SELECT
■ DESCRIPTION				: 통합검색 리스트 카테고리 검색
■ INPUT PARAMETER			: 
	@KEY		VARCHAR(400): 검색 키
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	DECLARE @KEY		VARCHAR(400)
	SELECT @KEY=N'Provider=0&BrandType=&RegionCode=&CityCode=&NationCode=&AttCode=&MainAttCode=&GroupCode=&MinPrice=&MaxPrice=&DepDate=&Day=&Keyword='
	exec XP_WEB_PKG_SEARCH_CATEGORY_LIST_SELECT @key

■ MEMO						: 수정 시 XP_WEB_PKG_MASTER_LIST_SELECT 프로시저와 검색 조건 동기화 해야함
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-07-09		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_WEB_PKG_SEARCH_CATEGORY_LIST_SELECT]
(
	@KEY		VARCHAR(400)
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @INNER_TABLE NVARCHAR(1000), @WHERE NVARCHAR(4000)
	DECLARE @PUSAN_TEAM_CODE VARCHAR(100), @TEMP NVARCHAR(1000)
	
	DECLARE @PROVIDER VARCHAR(3), @BRAND_TYPE VARCHAR(1), @REGION_CODE VARCHAR(50), @CITY_CODE VARCHAR(500), @NATION_CODE VARCHAR(50), @ATT_CODE VARCHAR(50), @GROUP_CODE VARCHAR(300)
	DECLARE @MIN_PRICE VARCHAR(10), @MAX_PRICE VARCHAR(10), @DEP_DATE VARCHAR(10), @DAY VARCHAR(5), @BRANCH_CODE VARCHAR(1), @KEYWORD NVARCHAR(1000), @MAIN_ATT_CODE VARCHAR(10)

	-- 검색 제외팀
	--SET @PUSAN_TEAM_CODE = '''514'', ''515'', ''516'', ''524'', ''531''';

	SELECT
		@PROVIDER = DBO.FN_PARAM(@KEY, 'Provider'),
		@BRAND_TYPE = DBO.FN_PARAM(@KEY, 'BrandType'),
		@REGION_CODE = DBO.FN_PARAM(@KEY, 'RegionCode'),
		@CITY_CODE = DBO.FN_PARAM(@KEY, 'CityCode'),
		@NATION_CODE = DBO.FN_PARAM(@KEY, 'NationCode'),
		@ATT_CODE = DBO.FN_PARAM(@KEY, 'AttCode'),
		@MAIN_ATT_CODE = DBO.FN_PARAM(@KEY, 'MainAttCode'),
		@GROUP_CODE = DBO.FN_PARAM(@KEY, 'GroupCode'),
		@MIN_PRICE = DBO.FN_PARAM(@KEY, 'MinPrice'),
		@MAX_PRICE = DBO.FN_PARAM(@KEY, 'MaxPrice'),
		@DEP_DATE = DBO.FN_PARAM(@KEY, 'DepDate'),
		@DAY = DBO.FN_PARAM(@KEY, 'Day'),
		@BRANCH_CODE = DBO.FN_PARAM(@KEY, 'BranchCode'),
		@KEYWORD = DBO.FN_PARAM(@KEY, 'Keyword'),
		@WHERE = 'WHERE A.SHOW_YN = ''Y'''

	-- 속성코드가 'BU' 부산일때는 지점코드를 정의한다
	IF @MAIN_ATT_CODE = 'BU'
	BEGIN
		SELECT @MAIN_ATT_CODE = NULL, @BRANCH_CODE = 1
	END
	ELSE IF ISNULL(@MAIN_ATT_CODE, '') <> ''
	BEGIN
		SELECT @BRANCH_CODE = 0
	END

	-- 그룹코드 사용시 다른 조건 무시
	IF ISNULL(@GROUP_CODE, '') <> ''
	BEGIN
		SELECT @GROUP_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@GROUP_CODE, ',') FOR XML PATH('')), 1, 1, '')
		SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_GROUP WITH(NOLOCK) WHERE GROUP_CODE IN (' + @GROUP_CODE + '))'
	END
	ELSE
	BEGIN
		IF ISNULL(@REGION_CODE, '') <> ''
		BEGIN
			SELECT @REGION_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@REGION_CODE, ',') FOR XML PATH('')), 1, 1, '')
			SET @WHERE = @WHERE + ' AND A.SIGN_CODE IN (' + @REGION_CODE + ')'
		END

		IF ISNULL(@ATT_CODE, '') <> ''
		BEGIN
			SELECT @ATT_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@ATT_CODE, ',') FOR XML PATH('')), 1, 1, '')

			SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_ATTRIBUTE AA WITH(NOLOCK) WHERE A.MASTER_CODE = AA.MASTER_CODE AND AA.ATT_CODE IN (' + @ATT_CODE + '))'    
		END

		-- 대표속성 검색
		IF ISNULL(@MAIN_ATT_CODE, '') <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND A.ATT_CODE = @MAIN_ATT_CODE'
		END

		-- 그룹코드가 아닐 시 부산 담당 상품 제외
		--SET @WHERE = @WHERE + ' AND A.NEW_CODE NOT IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE IN (' + @PUSAN_TEAM_CODE + '))'
	END

	IF (ISNULL(@CITY_CODE, '') <> '' OR ISNULL(@NATION_CODE, '') <> '')
	BEGIN
		SET @TEMP = ''

		IF ISNULL(@CITY_CODE, '') <> ''
		BEGIN
			SELECT @CITY_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@CITY_CODE, ',') FOR XML PATH('')), 1, 1, '')

			SET @TEMP = (' OR AA.CITY_CODE IN (' + @CITY_CODE + ')')
			--SET @TEMP = (' OR B.CITY_CODE IN (' + @CITY_CODE + ')')
		END

		IF ISNULL(@NATION_CODE, '') <> ''
		BEGIN
			SELECT @NATION_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@NATION_CODE, ',') FOR XML PATH('')), 1, 1, '')

			SET @TEMP = @TEMP + ' OR AA.CITY_CODE IN (SELECT CITY_CODE FROM PUB_CITY AAA WITH(NOLOCK) WHERE AAA.NATION_CODE IN (' + @NATION_CODE + '))'
			--SET @TEMP = @TEMP + ' OR B.CITY_CODE IN (SELECT CITY_CODE FROM PUB_CITY AA WHERE AA.NATION_CODE IN (' + @NATION_CODE + '))'
		END

		SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_MASTER_SCH_CITY AA WITH(NOLOCK) WHERE A.MASTER_CODE = AA.MASTER_CODE AND AA.MAINCITY_YN = ''Y'' AND (' + SUBSTRING(@TEMP, 4, LEN(@TEMP)) + '))'
		--SET @WHERE = @WHERE + ' AND (' + SUBSTRING(@TEMP, 4, LEN(@TEMP)) + ')'
	END

	IF ISNULL(@MIN_PRICE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.HIGH_PRICE >= CONVERT(INT, @MIN_PRICE)'
	END

	IF ISNULL(@MAX_PRICE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.LOW_PRICE <= CONVERT(INT, @MAX_PRICE)'
	END

	IF (ISNULL(@DEP_DATE, '') <> '') OR (ISNULL(@DAY, '') <> '')
	BEGIN
		SET @TEMP = ''

		IF (ISNULL(@DEP_DATE, '') <> '')
			SET @TEMP = ' AND AA.DEP_DATE = CONVERT(DATETIME, @DEP_DATE)'
		IF (ISNULL(@DAY, '') <> '')
		BEGIN
			IF @DAY = '10'
				SET @TEMP = @TEMP + ' AND AA.TOUR_DAY >= @DAY'
			ELSE
				SET @TEMP = @TEMP + ' AND AA.TOUR_DAY = @DAY'
		END

		SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_DETAIL AA WITH(NOLOCK) WHERE A.MASTER_CODE = AA.MASTER_CODE ' + @TEMP + ')'
	END
	ELSE
	BEGIN
		SET @WHERE = @WHERE + ' AND A.LAST_DATE >= GETDATE() '
	END

	IF ISNULL(@BRANCH_CODE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.BRANCH_CODE = CONVERT(INT, @BRANCH_CODE)'
	END

	IF ISNULL(@KEYWORD, '') <> ''
	BEGIN
		SELECT @TEMP = STUFF((SELECT (' AND "' + DATA + '"') AS [text()] FROM [DBO].[FN_SPLIT](@KEYWORD, ' ') WHERE DATA <> '' FOR XML PATH('')), 1, 5, '')
		SELECT @KEYWORD = ' AND (CONTAINS(A.MASTER_NAME, ''' + @TEMP + ''') OR CONTAINS(A.KEYWORD, ''' + @TEMP + ''') OR CONTAINS(A.PKG_COMMENT, ''' + @TEMP + ''') OR CONTAINS(A.MASTER_CODE, ''' + REPLACE(@TEMP,'" AND "','" OR "') + ''') OR A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = ''' + @KEYWORD + '''))'
--		SELECT @TEMP = STUFF((SELECT (' AND "' + DATA + '"') AS [text()] FROM [DBO].[FN_SPLIT](@KEYWORD, ' ') WHERE DATA <> '' FOR XML PATH('')), 1, 5, '')
--		SELECT @KEYWORD = ' AND (CONTAINS(A.MASTER_NAME, ''' + @TEMP + ''') OR CONTAINS(A.KEYWORD, ''' + @TEMP + ''') OR CONTAINS(A.MASTER_CODE, ''' + REPLACE(@TEMP,'" AND "','" OR "') + '''))'

		SET @WHERE = @WHERE + @KEYWORD
	END

	IF ISNULL(@BRAND_TYPE, '') <> ''
	BEGIN
		IF @BRAND_TYPE = '9'
		BEGIN
			SET @WHERE = @WHERE + ' AND A.BRAND_TYPE IN(''1'', ''2'', ''3'', ''4'') '
		END 
		ELSE 
		BEGIN
			SET @WHERE = @WHERE + ' AND A.BRAND_TYPE = @BRAND_TYPE'
		END 
	END
	
	
	SET @SQLSTRING = N'
	WITH LIST AS
	(
		SELECT A.FLAG, (
			CASE
				-- 패키지
				WHEN A.FLAG = ''P'' AND A.SIGN_CODE = ''E'' THEN 1
				WHEN A.FLAG = ''P'' AND A.SIGN_CODE = ''A'' THEN 2
				WHEN A.FLAG = ''P'' AND A.SIGN_CODE = ''C'' THEN 3
				WHEN A.FLAG = ''P'' AND A.SIGN_CODE = ''J'' THEN 4
				WHEN A.FLAG = ''P'' AND A.SIGN_CODE = ''P'' THEN 5
				WHEN A.FLAG = ''P'' AND A.SIGN_CODE = ''I'' THEN 6
				WHEN A.FLAG = ''P'' AND A.SIGN_CODE IN (''U'',''R'',''S'') THEN 7
				WHEN A.FLAG = ''P'' AND A.SIGN_CODE IN (''M'',''F'',''O'') THEN 8
				WHEN A.FLAG = ''P'' AND A.SIGN_CODE = ''K'' THEN 9
				-- 자유여행
				WHEN A.FLAG = ''F'' AND A.SIGN_CODE = ''E'' THEN 1
				WHEN A.FLAG = ''F'' AND A.SIGN_CODE IN (''J'',''C'',''K'') THEN 2
				WHEN A.FLAG = ''F'' AND A.SIGN_CODE = ''A'' THEN 3
				WHEN A.FLAG = ''F'' AND A.SIGN_CODE = ''P'' THEN 4
				WHEN A.FLAG = ''F'' AND A.SIGN_CODE IN (''I'',''U'',''R'',''S'') THEN 5
				-- 부산출발
				WHEN A.FLAG = ''BU'' AND A.SIGN_CODE IN (''E'',''O'',''F'') THEN 1
				WHEN A.FLAG = ''BU'' AND A.SIGN_CODE = ''A'' THEN 2
				WHEN A.FLAG = ''BU'' AND A.SIGN_CODE = ''J'' THEN 3
				WHEN A.FLAG = ''BU'' AND A.SIGN_CODE = ''C'' THEN 4
				WHEN A.FLAG = ''BU'' AND A.SIGN_CODE IN (''P'',''I'') THEN 5
				WHEN A.FLAG = ''BU'' AND A.SIGN_CODE IN (''U'',''R'',''S'') THEN 6
				WHEN A.FLAG = ''BU'' AND A.SIGN_CODE = ''K'' THEN 7
				-- 허니문
				WHEN A.FLAG = ''W'' AND A.SIGN_CODE = ''E'' THEN 1
				WHEN A.FLAG = ''W'' AND A.SIGN_CODE = ''A'' THEN 2
				WHEN A.FLAG = ''W'' AND A.SIGN_CODE = ''C'' THEN 3
				WHEN A.FLAG = ''W'' AND A.SIGN_CODE = ''J'' THEN 4
				WHEN A.FLAG = ''W'' AND A.SIGN_CODE = ''P'' THEN 5
				WHEN A.FLAG = ''W'' AND A.SIGN_CODE = ''I'' THEN 6
				WHEN A.FLAG = ''W'' AND A.SIGN_CODE IN (''U'',''R'',''S'') THEN 7
				WHEN A.FLAG = ''W'' AND A.SIGN_CODE IN (''M'',''F'',''O'') THEN 8
				-- 골프
				WHEN A.FLAG = ''G'' AND A.SIGN_CODE = ''A'' THEN 1
				WHEN A.FLAG = ''G'' AND A.SIGN_CODE = ''C'' THEN 2
				WHEN A.FLAG = ''G'' AND A.SIGN_CODE = ''J'' THEN 3
				WHEN A.FLAG = ''G'' AND A.SIGN_CODE = ''K'' THEN 4
				WHEN A.FLAG = ''G'' AND A.SIGN_CODE = ''I'' THEN 5
			END
		) AS [FLAG2], A.SIGN_CODE, A.MASTER_COUNT
		FROM (
			SELECT (
					CASE
						WHEN A.ATT_CODE = ''P'' AND A.BRANCH_CODE = 0 THEN ''P''
						WHEN A.ATT_CODE = ''F'' AND A.BRANCH_CODE = 0 THEN ''F''
						WHEN A.BRANCH_CODE = 1 THEN ''BU''
						WHEN A.ATT_CODE = ''W'' AND A.BRANCH_CODE = 0 THEN ''W''
						WHEN A.ATT_CODE = ''G'' AND A.BRANCH_CODE = 0 THEN ''G''
					END
				) AS [FLAG], A.SIGN_CODE, COUNT(*) AS [MASTER_COUNT]
			FROM PKG_MASTER A WITH(NOLOCK) 
			'
			IF @PROVIDER NOT IN('0','5','16','18')
				SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = CONVERT(INT, @PROVIDER) AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''
			'
			SET @SQLSTRING = @SQLSTRING + @WHERE + N'
			GROUP BY (
					CASE
						WHEN A.ATT_CODE = ''P'' AND A.BRANCH_CODE = 0 THEN ''P''
						WHEN A.ATT_CODE = ''F'' AND A.BRANCH_CODE = 0 THEN ''F''
						WHEN A.BRANCH_CODE = 1 THEN ''BU''
						WHEN A.ATT_CODE = ''W'' AND A.BRANCH_CODE = 0 THEN ''W''
						WHEN A.ATT_CODE = ''G'' AND A.BRANCH_CODE = 0 THEN ''G''
					END
				), A.SIGN_CODE
		) A
		WHERE A.FLAG IS NOT NULL
	)
	SELECT A.FLAG, A.FLAG2, SUM(A.MASTER_COUNT) AS [COUNT], B.Data AS [MENU_NAME]
		, STUFF((SELECT '','' + AA.SIGN_CODE AS [text()] FROM LIST AA WHERE AA.FLAG = A.FLAG AND AA.FLAG2 = A.FLAG2 FOR XML PATH('''')), 1, 1, '''') AS [SIGN_CODE]
	FROM LIST A
	INNER JOIN (
		SELECT ''P'' AS [FALG], * FROM DBO.FN_SPLIT(''유럽,동남아,중국,일본,호주/뉴질랜드/피지,사이판/괌,미주/캐나다/중남미,인도/중동/아프리카,국내'', '','')
		UNION
		SELECT ''F'' AS [FALG], * FROM DBO.FN_SPLIT(''유럽,일본/중국/국내,동남아,호주/뉴질랜드,미주/괌/사이판'', '','')
		UNION
		SELECT ''BU'' AS [FALG], * FROM DBO.FN_SPLIT(''유럽/인도/아프리카,동남아,일본,중국,대양주/괌/사이판,하와이/미주/캐나다/중남미,제주도/울릉도'', '','')
		UNION
		SELECT ''W'' AS [FALG], * FROM DBO.FN_SPLIT(''유럽,동남아,중국,일본,호주/뉴질랜드/피지,사이판/괌,미주/캐나다/중남미,인도/중동/아프리카'', '','')
		UNION
		SELECT ''G'' AS [FALG], * FROM DBO.FN_SPLIT(''동남아,중국,일본,국내,괌/사이판'', '','')
	) B ON A.FLAG = B.FALG AND A.FLAG2 = B.ID
	WHERE A.FLAG2 IS NOT NULL
	GROUP BY A.FLAG, A.FLAG2, B.Data
	ORDER BY A.FLAG, A.FLAG2';
	

	SET @PARMDEFINITION = N'
		@PROVIDER VARCHAR(3),
		@BRAND_TYPE VARCHAR(1),
		@MIN_PRICE VARCHAR(10),
		@MAX_PRICE VARCHAR(10),
		@DEP_DATE VARCHAR(10),
		@DAY VARCHAR(5),
		@BRANCH_CODE VARCHAR(1),
		@KEYWORD NVARCHAR(1000),
		@MAIN_ATT_CODE VARCHAR(10)';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PROVIDER,
		@BRAND_TYPE,
		@MIN_PRICE,
		@MAX_PRICE,
		@DEP_DATE,
		@DAY,
		@BRANCH_CODE,
		@KEYWORD,
		@MAIN_ATT_CODE;

END

GO
