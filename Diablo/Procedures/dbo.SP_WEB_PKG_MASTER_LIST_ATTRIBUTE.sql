USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2011-03-16 박형만 PROVIDER 조건 PKG_MASTER_AFFILIATE 와 조인
 2011-04-14	박형만	임시 씽크엔젤PROVIDER=16 나오도록 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[SP_WEB_PKG_MASTER_LIST_ATTRIBUTE]
	@REGION_CODE VARCHAR(100),
	@NATION_CODE VARCHAR(1000),
	@CITY_CODE  VARCHAR(1000),
	@GROUP_CODE  VARCHAR(500),
	@ATT_CODE  VARCHAR(100),

	@START_DATE  DATETIME,
	@END_DATE  DATETIME,
	@DAY   VARCHAR(1000),
	@PRICE   varchar(1000),
	@SEARCH_TEXT VARCHAR(100),
	@PROVIDER  INT
AS
BEGIN  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @KEYWORD NVARCHAR(4000);
	DECLARE @PUSAN_TEAM_CODE VARCHAR(30)
	DECLARE @TMP VARCHAR(2000);

	SET @PUSAN_TEAM_CODE = '''514'', ''515'', ''516''';

	-- WHERE 조건 만들기  
	SET @WHERE = 'WHERE A.SHOW_YN = ''Y'''  

		-- 검색조건 추가
	IF @START_DATE IS NOT NULL
	BEGIN
		SET @WHERE = 'WHERE A.LAST_DATE > @START_DATE AND A.NEXT_DATE < @END_DATE'
	END
	
	IF ISNULL(@DAY, '') <> ''
	BEGIN  
	
		SET @TMP = ''
		SELECT
		@TMP = @TMP + CASE WHEN ISNULL(@TMP, '') = '' THEN '' ELSE ' OR ' END + REPLACE(
			REPLACE('
		(
		A.TOUR_DAY >= @LOW_DAY AND A.TOUR_DAY <= @HIGH_DAY
		)
		', '@LOW_DAY', '''' + MIN_DAY + '''')
		, '@HIGH_DAY', '''' + MAX_DAY + '''')
		FROM (
			SELECT 
				SUBSTRING(DATA, 1, CHARINDEX('|', DATA) - 1) AS MIN_DAY,
				SUBSTRING(DATA, CHARINDEX('|', DATA) + 1, LEN(DATA) - CHARINDEX('|', DATA)) AS MAX_DAY
			 FROM [DBO].[FN_SPLIT] (@DAY, ',') 
		) A 
		PRINT @TMP
	
		SET @WHERE = @WHERE + ' AND (' + @TMP + ') '
		
	END
			

	IF ISNULL(@PRICE, '') <> ''
	BEGIN  
	
		SET @TMP = ''
		SELECT
		@TMP = @TMP + CASE WHEN ISNULL(@TMP, '') = '' THEN '' ELSE ' OR ' END + REPLACE(
			REPLACE('
		(
		LOW_PRICE <= @LOW_PRICE AND HIGH_PRICE >= @LOW_PRICE
		OR
		LOW_PRICE <= @HIGH_PRICE AND HIGH_PRICE >= @HIGH_PRICE
		OR
		LOW_PRICE <= @LOW_PRICE AND HIGH_PRICE >= @HIGH_PRICE
		)
		', '@LOW_PRICE', '''' + MIN_PRICE + '''')
		, '@HIGH_PRICE', '''' + MAX_PRICE + '''')
		FROM (
			SELECT 
				SUBSTRING(DATA, 1, CHARINDEX('|', DATA) - 1) AS MIN_PRICE,
				SUBSTRING(DATA, CHARINDEX('|', DATA) + 1, LEN(DATA) - CHARINDEX('|', DATA)) AS MAX_PRICE
			 FROM [DBO].[FN_SPLIT] (@PRICE, ',') 
		) A 
		PRINT @TMP
	
		SET @WHERE = @WHERE + ' AND (' + @TMP + ') '
		
	END
	
	
	IF ISNULL(@SEARCH_TEXT, '') <> ''  
	BEGIN
		SELECT @KEYWORD = '(' + STUFF((SELECT (' AND (A.MASTER_NAME LIKE ''%' + DATA + '%'')') AS [text()] FROM [DBO].[FN_SPLIT] (@SEARCH_TEXT, ' ') WHERE DATA <> '' FOR XML PATH('')), 1, 5, '') + ')'
		SELECT @KEYWORD = @KEYWORD + ' OR (' + STUFF((SELECT (' AND (A.KEYWORD LIKE ''%' + DATA + '%'')') AS [text()] FROM [DBO].[FN_SPLIT] (@SEARCH_TEXT, ' ') WHERE DATA <> '' FOR XML PATH('')), 1, 5, '') + ')'
		SELECT @KEYWORD = @KEYWORD + ' OR (' + STUFF((SELECT (' OR (A.MASTER_CODE = ''' + DATA + ''')') AS [text()] FROM [DBO].[FN_SPLIT] (@SEARCH_TEXT, ' ') WHERE DATA <> '' FOR XML PATH('')), 1, 4, '') + ')'
		SELECT @KEYWORD = ' AND (' + @KEYWORD + ')'

		SET @WHERE = @WHERE + @KEYWORD
	END
		-- 검색조건 추가  

		-- 지역코드  
	IF ISNULL(@REGION_CODE, '') <> ''  
	BEGIN  
		SELECT @REGION_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@REGION_CODE, ',') FOR XML PATH('')), 1, 1, '')  

		SET @WHERE = @WHERE + ' AND B.CITY_CODE IN (
			SELECT C.CITY_CODE FROM PUB_REGION A WITH(NOLOCK)
			INNER JOIN PUB_NATION B WITH(NOLOCK) ON A.REGION_CODE = B.REGION_CODE
			INNER JOIN PUB_CITY C WITH(NOLOCK) ON B.NATION_CODE = C.NATION_CODE
			WHERE [SIGN] IN (' + @REGION_CODE + ')
		)'
	END  
		-- 국가코드  
	IF ISNULL(@NATION_CODE, '') <> ''  or ISNULL(@CITY_CODE, '') <> ''  
	BEGIN
			
		SET @WHERE = @WHERE + ' AND ( ('	
		
		IF ISNULL(@NATION_CODE, '') <> ''  
		BEGIN  
			SELECT @NATION_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@NATION_CODE, ',') FOR XML PATH('')), 1, 1, '')  
			SET @WHERE = @WHERE + ' B.MAINCITY_YN = ''Y'' AND B.CITY_CODE IN (
				SELECT CITY_CODE FROM PUB_CITY WHERE NATION_CODE IN (' + @NATION_CODE + ')) )'
		END  
		
		IF (ISNULL(@NATION_CODE, '') <> '' AND  ISNULL(@CITY_CODE, '') <> '' )
			SET @WHERE = @WHERE + ' OR ('
		
			-- 도시코드  
		IF ISNULL(@CITY_CODE, '') <> ''  
		BEGIN  
			SELECT @CITY_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@CITY_CODE, ',') FOR XML PATH('')), 1, 1, '')
			SET @WHERE = @WHERE + '  B.MAINCITY_YN = ''Y'' AND B.CITY_CODE IN (
				SELECT CITY_CODE FROM PUB_CITY WHERE CITY_CODE IN (' + @CITY_CODE + ')) )'
		END  
		
		SET @WHERE = @WHERE + ' ) '
		
		
	END
		-- 그룹코드  
	IF ISNULL(@GROUP_CODE, '') <> ''  AND @GROUP_CODE <> '@SEARCH@'
	BEGIN  
		SELECT @GROUP_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@GROUP_CODE, ',') FOR XML PATH('')), 1, 1, '')  
		SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_GROUP  WITH(NOLOCK) WHERE GROUP_CODE IN (' + @GROUP_CODE + '))'  
	END
	ELSE
	BEGIN
		-- 그룹코드가 아닐 시 부산 담당 상품 제외
		SET @WHERE = @WHERE + ' AND A.NEW_CODE NOT IN (SELECT EMP_CODE FROM EMP_MASTER WHERE TEAM_CODE IN (' + @PUSAN_TEAM_CODE + '))'
	END
		-- 속성코드  
	IF ISNULL(@ATT_CODE, '') <> ''  
	BEGIN  
		SELECT @ATT_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@ATT_CODE, ',') FOR XML PATH('')), 1, 1, '')     
		SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_ATTRIBUTE  WITH(NOLOCK) WHERE ATT_CODE IN (' + @ATT_CODE + '))'  
	END    

	SET @SQLSTRING = N'  
		WITH LIST AS  
		(  
			SELECT C.ATT_CODE
			FROM PKG_MASTER A WITH(NOLOCK)
			LEFT JOIN PKG_MASTER_SCH_CITY B ON A.MASTER_CODE = B.MASTER_CODE
			INNER JOIN PKG_ATTRIBUTE C ON A.MASTER_CODE = C.MASTER_CODE
			'

	IF (@PROVIDER NOT IN(0,5,16))
		--SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_PROVIDER Z WITH(NOLOCK) ON Z.PROVIDER = ' + CAST(@PROVIDER AS VARCHAR) + ' AND A.MASTER_CODE = Z.CODE
		SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = ' + CAST(@PROVIDER AS VARCHAR) + ' AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''
			'
			
	SET @SQLSTRING = @SQLSTRING + @WHERE + '
			GROUP BY C.ATT_CODE
		)  
		SELECT  A.ATT_CODE, B.PUB_VALUE AS [ATT_NAME]
		FROM LIST A
		INNER JOIN COD_PUBLIC B ON PUB_TYPE = ''PKG.ATTRIBUTE'' AND A.ATT_CODE = B.PUB_CODE'
	 
	SET @PARMDEFINITION = N'@START_DATE DATETIME, @END_DATE DATETIME, @DAY VARCHAR(1000), @PRICE VARCHAR(1000), @SEARCH_TEXT VARCHAR(100)';  

--	PRINT @SQLSTRING
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @START_DATE, @END_DATE, @DAY, @PRICE, @SEARCH_TEXT;  

END





GO
