USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_PKG_MASTER_SELECT_CODES_GMARKET
- 기 능 : G마켓-참좋은여행상품 마스터 코드 검색 (G마켓호출 웹서비스용)
====================================================================================
	참고내용
====================================================================================
- (G마켓호출 웹서비스용)
- 예제
 EXEC SP_PKG_MASTER_SELECT_CODES_GMARKET '' ,'','2011-06-01','2011-06-30','5|5','ICN',''
====================================================================================
	변경내역
====================================================================================
- 2011-05-12 박형만 신규 작성 
- 2011-05-23 박형만 KEYWORD 추가 
- 2011-05-27 박형만 TOUR_DAY 를 DETAIL 에서 검색.
- 2012-06-14 FULL TEXT INDEX 반영
- 2016-02-12 사용안함
===================================================================================*/
CREATE PROCEDURE [dbo].[_SP_PKG_MASTER_SELECT_CODES_GMARKET]
	@ATT_CODE VARCHAR(100),
	@CITY_CODE VARCHAR(100),
	@START_DATE DATETIME ,
	@END_DATE DATETIME ,
	@DAY VARCHAR(100),
	@DEP_AIR_PORT VARCHAR(100),
	@SEARCH_TEXT VARCHAR(100)
AS  
BEGIN   
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--DECLARE @ATT_CODE VARCHAR(100),
--	@CITY_CODE VARCHAR(100),
--	@START_DATE DATETIME ,
--	@END_DATE DATETIME ,
--	@DAY VARCHAR(100),
--	@DEP_AIR_PORT VARCHAR(100),@SEARCH_TEXT VARCHAR(100)
--SELECT @ATT_CODE ='P' , @CITY_CODE ='PKT,KLO',
--@START_DATE = '2011-05-15' , @END_DATE = '2011-05-31' , 
--@DAY = '' , @DEP_AIR_PORT = 'ICN'

	DECLARE @PROVIDER INT 
	SET @PROVIDER = 14 -- G마켓  PROVIDER 
	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @INNERTABLE NVARCHAR(4000);
	DECLARE @KEYWORD NVARCHAR(1000);--, @SORT_STRING VARCHAR(100), @DESC VARCHAR(10)
	DECLARE @TMP NVARCHAR(2000);
	
	-- 부산, 광주, 대전, 법인, LCC 팀 제거
	--DECLARE @PUSAN_TEAM_CODE VARCHAR(100) -- 변수 크기 주의
	--SET @PUSAN_TEAM_CODE = '''514'', ''515'', ''516'', ''524'', ''531''';
	
	-- WHERE 조건 만들기
	SET @WHERE = 'WHERE A.SHOW_YN = ''Y'''
	SET @INNERTABLE = N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK)
		ON Z.PROVIDER = ' + CAST(@PROVIDER AS VARCHAR) + ' AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''
		'

	-- 출발일조건 추가(필수값임)
	IF @START_DATE IS NOT NULL AND @END_DATE IS NOT NULL
	BEGIN
		SET @INNERTABLE = 'INNER JOIN (
					SELECT MASTER_CODE FROM PKG_DETAIL WHERE DEP_DATE >= @START_DATE AND DEP_DATE <= @END_DATE
					--#검색조건
				) Y ON A.MASTER_CODE = Y.MASTER_CODE
				'
		SET @TMP = ''
		--SET @WHERE = @WHERE + ' AND A.LAST_DATE >= @START_DATE AND A.NEXT_DATE < @END_DATE + 1 '

		--여행일자 검색조건 추가  2011.05.27 
		IF ISNULL(@DAY, '') <> ''
		BEGIN
			SELECT @TMP = @TMP + 
				CASE
					WHEN MIN_DAY = MAX_DAY THEN ' OR TOUR_DAY = ' + MIN_DAY
					ELSE ' OR (TOUR_DAY >= ' + MIN_DAY + ' AND TOUR_DAY <= ' + MAX_DAY + ')'
				END
			FROM (
				SELECT 
					SUBSTRING(DATA, 1, CHARINDEX('|', DATA) - 1) AS MIN_DAY,
					SUBSTRING(DATA, CHARINDEX('|', DATA) + 1, LEN(DATA) - CHARINDEX('|', DATA)) AS MAX_DAY
				 FROM [DBO].[FN_SPLIT] (@DAY, ',') 
			) A 
			--PRINT @TMP
			SET @TMP = ' AND (' + SUBSTRING(@TMP, 5, 2000) + ') '
		END
		
		SET @INNERTABLE = REPLACE(@INNERTABLE, '--#검색조건', @TMP)
	END
	ELSE
	BEGIN
		SET @WHERE = @WHERE + ' AND A.LAST_DATE >= GETDATE() '
	END

	--검색어 검색 
	IF ISNULL(@SEARCH_TEXT, '') <> ''
	BEGIN
		SELECT @TMP = STUFF((SELECT (' AND "' + DATA + '"') AS [text()] FROM [DBO].[FN_SPLIT] (@SEARCH_TEXT, ' ') WHERE DATA <> '' FOR XML PATH('')), 1, 5, '')
		
		SELECT @KEYWORD = ' AND (CONTAINS(A.MASTER_NAME, ''' + @TMP + ''') OR CONTAINS(A.KEYWORD, ''' + @TMP + ''') OR CONTAINS(A.MASTER_CODE, ''' + REPLACE(@TMP,'" AND "','" OR "') + '''))'
		
		SET @WHERE = @WHERE + @KEYWORD
	END
	
	-- 출발지 검색
	IF ISNULL(@DEP_AIR_PORT, '') <> ''
	BEGIN
		SET @INNERTABLE = @INNERTABLE + N'
		INNER JOIN PKG_MASTER_SCH_CITY B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE AND B.DAY_SEQ = 1 AND B.CITY_CODE = @DEP_AIR_PORT
		';
	END
	
	-- 도시코드 검색
	IF ISNULL(@CITY_CODE, '') <> ''
	BEGIN
		SET @INNERTABLE = @INNERTABLE + N'
		INNER JOIN PKG_MASTER_SCH_CITY C WITH(NOLOCK) ON A.MASTER_CODE = C.MASTER_CODE
		INNER JOIN GMARKET_CITY_MAP D WITH(NOLOCK) ON C.CITY_CODE = D.G_CITY_CODE
		';
		
		SELECT @TMP = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@CITY_CODE, ',') FOR XML PATH('')), 1, 1, '')
		
		SET @WHERE = @WHERE + ' AND D.G_CITY_CODE IN (' + @TMP + ')'
	END
	
	-- 속성코드  
	IF ISNULL(@ATT_CODE, '') <> ''  
	BEGIN
		SET @INNERTABLE = @INNERTABLE + N'
		INNER JOIN PKG_ATTRIBUTE E WITH(NOLOCK) ON A.MASTER_CODE = E.MASTER_CODE
		';
		
		SELECT @TMP = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@ATT_CODE, ',') FOR XML PATH('')), 1, 1, '')     
		SET @WHERE = @WHERE + ' AND E.ATT_CODE IN (' + @TMP + ')'
	END
	
	-- ,문자열로 합친다
	SET @SQLSTRING = N'
	SELECT UPPER(
		STUFF((
			SELECT  '','' + ISNULL(A.MASTER_CODE,'''') AS [text()]
			FROM PKG_MASTER A WITH(NOLOCK)
			' + @INNERTABLE
			
		SET @SQLSTRING = @SQLSTRING + @WHERE + '
			GROUP BY A.MASTER_CODE 
			FOR XML PATH('''') 
		), 1, 1, '''') ) AS [GD_NO],
	CONVERT(VARCHAR(19),GETDATE(),121) AS [SC_DT]
	'
	SET @PARMDEFINITION = N'@START_DATE DATETIME, @END_DATE DATETIME,@DEP_AIR_PORT VARCHAR(10)';  

	--PRINT @SQLSTRING
	
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @START_DATE, @END_DATE,@DEP_AIR_PORT
	
END
GO
