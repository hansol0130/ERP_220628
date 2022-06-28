USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ Server					: 222.122.198.100
■ Database					: DIABLO
■ USP_Name					: SP_WEB_PKG_MASTER_LIST
■ Description				: 여행 상품을 검색한다.
■ Input Parameter			:                  
		@FLAG				:
		@SORT_CODE			:
		@PAGE_SIZE			:
		@PAGE_INDEX			:
		@REGION_CODE		:
		@NATION_CODE		:
		@CITY_CODE			:
		@GROUP_CODE			:
		@ATT_CODE			:
		@START_DATE			:
		@END_DATE			:
		@DAY				:
		@PRICE				:
		@SEARCH_TEXT		:
		@PROVIDER			: 
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_WEB_PKG_MASTER_LIST  
■ Author					:  
■ Date						: 
■ Memo						: 
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
   Date				Author			Description           
------------------------------------------------------------------------------------------------------------------
									최초생성
   2010-09-08       임형민			검색조건 수정
   2010-11-29       이규식			메인화면 리뉴얼로 인한 상품검색 조건 변경
   2011-01-12       박형만			가격조건수정  LOW_PRICE 가 0 일때 수정
   2011-03-10       박형만			PROVIDER 조건 PKG_MASTER_AFFILIATE 와 조인
   2011-04-14		박형만			임시 씽크엔젤PROVIDER=16 나오도록 
   
   2011-05-19		박형만			출발일 검색 추가
   2011-05-27		박형만			출발일기간, 여행일자 검색 조건 PKG_DETAIL 으로검색
   2011-07-20		박형만			지점구분 BRANCH_CODE 추가 
   2011-07-26		박형만			지역코드 SIGN_CODE 추가
   2012-02-07		박형만			브랜드타입 BRAND_TYPE 추가
   2012-02-20		김성호			여행일자, 가격조건 수정
   2012-04-30		박형만			브랜드타입 BRAND_TYPE 검색조건 추가
   2013-01-07		박형만			무궁화 관광은(PROVIDER=18) 모든상품 출력
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[SP_WEB_PKG_MASTER_LIST]
(
	@FLAG   CHAR(1),
	@SORT_CODE  INT,
	@PAGE_SIZE  INT,
	@PAGE_INDEX  INT,
	@REGION_CODE VARCHAR(1000),
	@NATION_CODE VARCHAR(1000),
	@CITY_CODE  VARCHAR(1000),
	@GROUP_CODE  VARCHAR(500),
	@ATT_CODE  VARCHAR(100),
	@START_DATE  DATETIME,
	@END_DATE  DATETIME,
	@DAY   VARCHAR(1000),
	@PRICE   VARCHAR(1000),
	@SEARCH_TEXT VARCHAR(100),
	@PROVIDER  INT,
	
	@DEP_DATE VARCHAR(10), --출발일(선택)
	@BRAND_TYPE INT -- 브랜드타입 99:브랜드있는전체
)

AS  
	BEGIN  
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);
		DECLARE @INNERTABLE NVARCHAR(4000), @LEFTTABLE NVARCHAR(100);
		DECLARE @KEYWORD NVARCHAR(4000), @SORT_STRING VARCHAR(100), @DESC VARCHAR(10), @FROM INT, @TO INT;
		DECLARE @TMP VARCHAR(2000);
		
		DECLARE @SEARCH_DEP_DATE DATETIME 
		
		-- 부산, 광주, 대전, 법인, LCC 팀 제거
		DECLARE @PUSAN_TEAM_CODE VARCHAR(100) -- 변수 크기 주의
		SET @PUSAN_TEAM_CODE = '''514'', ''515'', ''516'', ''524'', ''531''';
		
		--SET @PUSAN_TEAM_CODE = '';
		SET @FROM = @PAGE_INDEX * @PAGE_SIZE + 1;  
		SET @TO = @PAGE_INDEX * @PAGE_SIZE + @PAGE_SIZE;  

		-- WHERE 조건 만들기
		SET @WHERE = 'WHERE A.SHOW_YN = ''Y'''
		SET @INNERTABLE = ''
		SET @LEFTTABLE = ''

		--검색조건 추가
		--출발일범위검색. 정상적인 검색은 날짜 조건이 필수임.
		IF @START_DATE IS NOT NULL AND @END_DATE IS NOT NULL
		BEGIN
			SET @INNERTABLE = 'INNER JOIN (
						SELECT MASTER_CODE FROM PKG_DETAIL WHERE DEP_DATE >= @START_DATE AND DEP_DATE <= @END_DATE
						--#검색조건
					) Y ON A.MASTER_CODE = Y.MASTER_CODE
					'
			SET @TMP = ''
			--SET @WHERE = @WHERE + ' AND A.LAST_DATE >= @START_DATE AND A.NEXT_DATE < @END_DATE + 1 '
			
			-- PKG_DETAIL 의 EXISTS 조건 
			DECLARE @DETAIL_WHERE VARCHAR(2000)
			SET @DETAIL_WHERE = '' 
			
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
			
			--해당 출발일검색 2011.05.19 추가 (서브메인 달력검색) 
			IF ISNULL(@DEP_DATE,'') <> ''
			BEGIN
				IF LEN(@DEP_DATE) > 8 
				BEGIN 
					SET @SEARCH_DEP_DATE  = CONVERT(DATETIME,@DEP_DATE)
					--SET @WHERE = @WHERE + 'AND EXISTS(SELECT 1 FROM PKG_DETAIL WHERE MASTER_CODE = A.MASTER_CODE AND DEP_DATE = @SEARCH_DEP_DATE)'
					SET @TMP = @TMP +  ' AND DEP_DATE = @SEARCH_DEP_DATE'
				END 
			END
			
			SET @INNERTABLE = REPLACE(@INNERTABLE, '--#검색조건', @TMP)

			---- 출발일기간 검색  + @DETAIL_WHERE 조건 추가 
			--SET @WHERE = @WHERE + ' AND EXISTS(SELECT 1 FROM PKG_DETAIL  WITH(NOLOCK) WHERE MASTER_CODE = A.MASTER_CODE AND DEP_DATE >= @START_DATE AND DEP_DATE <= @END_DATE  
			--	' + @DETAIL_WHERE + ' 
			--) '
		END
		ELSE
		BEGIN
			SET @WHERE = @WHERE + ' AND A.LAST_DATE >= GETDATE() '
		END
		
		IF ISNULL(@PRICE, '') <> ''
		BEGIN
			SET @TMP = ''
			SELECT @TMP = @TMP + ' OR (LOW_PRICE >= ' + MIN_PRICE + ' AND LOW_PRICE <= ' + MAX_PRICE + ')'
			FROM (
				SELECT 
					SUBSTRING(DATA, 1, CHARINDEX('|', DATA) - 1) AS MIN_PRICE,
					SUBSTRING(DATA, CHARINDEX('|', DATA) + 1, LEN(DATA) - CHARINDEX('|', DATA)) AS MAX_PRICE
				 FROM [DBO].[FN_SPLIT] (@PRICE, ',') 
			) A 
			--PRINT @TMP
		
			SET @WHERE = @WHERE + ' AND (
						' + SUBSTRING(@TMP, 5, 2000) + '
					) '
			
		END
		
		
		IF ISNULL(@SEARCH_TEXT, '') <> ''  
		BEGIN
			--SELECT @KEYWORD = '(' + STUFF((SELECT (' AND (A.MASTER_NAME LIKE ''%' + DATA + '%'')') AS [text()] FROM [DBO].[FN_SPLIT] (@SEARCH_TEXT, ' ') WHERE DATA <> '' FOR XML PATH('')), 1, 5, '') + ')'
			--SELECT @KEYWORD = @KEYWORD + ' OR (' + STUFF((SELECT (' AND (A.KEYWORD LIKE ''%' + DATA + '%'')') AS [text()] FROM [DBO].[FN_SPLIT] (@SEARCH_TEXT, ' ') WHERE DATA <> '' FOR XML PATH('')), 1, 5, '') + ')'
			--SELECT @KEYWORD = @KEYWORD + ' OR (' + STUFF((SELECT (' OR (A.MASTER_CODE = ''' + DATA + ''')') AS [text()] FROM [DBO].[FN_SPLIT] (@SEARCH_TEXT, ' ') WHERE DATA <> '' FOR XML PATH('')), 1, 4, '') + ')'
			--SELECT @KEYWORD = ' AND (' + @KEYWORD + ')'
			
			SELECT @TMP = STUFF((SELECT (' AND "' + DATA + '"') AS [text()] FROM [DBO].[FN_SPLIT] (@SEARCH_TEXT, ' ') WHERE DATA <> '' FOR XML PATH('')), 1, 5, '')
			SELECT @KEYWORD = ' AND (CONTAINS(A.MASTER_NAME, ''' + @TMP + ''') OR CONTAINS(A.KEYWORD, ''' + @TMP + ''') OR CONTAINS(A.MASTER_CODE, ''' + REPLACE(@TMP,'" AND "','" OR "') + '''))'

			SET @WHERE = @WHERE + @KEYWORD
		END
			-- 검색조건 추가  

			-- 지역코드  
		IF ISNULL(@REGION_CODE, '') <> ''  
		BEGIN  
			SELECT @REGION_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@REGION_CODE, ',') FOR XML PATH('')), 1, 1, '')  

			SET @WHERE = @WHERE + ' AND A.SIGN_CODE IN (' + @REGION_CODE + ')'

			--SET @WHERE = @WHERE + ' AND B.CITY_CODE IN (
			--	SELECT C.CITY_CODE FROM PUB_REGION A WITH(NOLOCK)
			--	INNER JOIN PUB_NATION B WITH(NOLOCK) ON A.REGION_CODE = B.REGION_CODE
			--	INNER JOIN PUB_CITY C WITH(NOLOCK) ON B.NATION_CODE = C.NATION_CODE
			--	WHERE [SIGN] IN (' + @REGION_CODE + ')
			--)'  
		END  
		
		-- @GROUP_CODE <> '@SEARCH@' 일 경우 검색으로 인식
		-- 아닐 경우 일반 리스트로 인식
		
		IF ISNULL(@GROUP_CODE, '') = '@SEARCH@'
		BEGIN		
			-- 국가코드와 도시코드는 OR 결합을 시킨다. 
			-- 국가코드와 도시코드가 하나라도 들어와 있는지를 체크
			IF (ISNULL(@NATION_CODE, '') <> '') OR (ISNULL(@CITY_CODE, '') <> ''  )
			BEGIN
					-- 국가코드  
				IF ISNULL(@NATION_CODE, '') <> ''  
				BEGIN
					SET @LEFTTABLE = 'LEFT JOIN PKG_MASTER_SCH_CITY B  WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
						';
						
					SELECT @NATION_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@NATION_CODE, ',') FOR XML PATH('')), 1, 1, '')  
				END  
				
					-- 도시코드  
				IF ISNULL(@CITY_CODE, '') <> ''  
				BEGIN
					SET @LEFTTABLE = 'LEFT JOIN PKG_MASTER_SCH_CITY B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
						';
						
					SELECT @CITY_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@CITY_CODE, ',') FOR XML PATH('')), 1, 1, '')  
				END  
				
				SET @WHERE = @WHERE + ' AND ( '
				
				IF (ISNULL(@NATION_CODE, '') <> '' )
					SET @WHERE = @WHERE + ' B.MAINCITY_YN = ''Y'' AND B.CITY_CODE IN (
						SELECT CITY_CODE FROM PUB_CITY WHERE NATION_CODE IN (' + @NATION_CODE + '))'
				
				IF (ISNULL(@NATION_CODE, '') <> '' AND  ISNULL(@CITY_CODE, '') <> '' )
					SET @WHERE = @WHERE + ' OR '
				
				
				IF ISNULL(@CITY_CODE, '') <> '' 
					SET @WHERE = @WHERE + ' B.MAINCITY_YN = ''Y'' AND B.CITY_CODE IN (
						SELECT CITY_CODE FROM PUB_CITY WHERE CITY_CODE IN (' + @CITY_CODE + '))'
				
				SET @WHERE = @WHERE + ' ) '
				
			END
		END
		ELSE
		BEGIN
				-- 국가코드  
			IF ISNULL(@NATION_CODE, '') <> ''  
			BEGIN
				SET @LEFTTABLE = 'LEFT JOIN PKG_MASTER_SCH_CITY B  WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
					';
					
				SELECT @NATION_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@NATION_CODE, ',') FOR XML PATH('')), 1, 1, '')  
				SET @WHERE = @WHERE + ' AND B.MAINCITY_YN = ''Y'' AND B.CITY_CODE IN (
					SELECT CITY_CODE FROM PUB_CITY WHERE NATION_CODE IN (' + @NATION_CODE + '))'
			END  
				-- 도시코드  
			IF ISNULL(@CITY_CODE, '') <> ''  
			BEGIN
				SET @LEFTTABLE = 'LEFT JOIN PKG_MASTER_SCH_CITY B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
					';
					
				SELECT @CITY_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@CITY_CODE, ',') FOR XML PATH('')), 1, 1, '')  
				SET @WHERE = @WHERE + ' AND B.MAINCITY_YN = ''Y'' AND B.CITY_CODE IN (
					SELECT CITY_CODE FROM PUB_CITY WHERE CITY_CODE IN (' + @CITY_CODE + '))'
			END  
		END
		
			-- 그룹코드  
		IF ISNULL(@GROUP_CODE, '') <> ''  AND ISNULL(@GROUP_CODE, '') <> '@SEARCH@'
		BEGIN  
			SELECT @GROUP_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@GROUP_CODE, ',') FOR XML PATH('')), 1, 1, '')  
			SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_GROUP  WITH(NOLOCK) WHERE GROUP_CODE IN (' + @GROUP_CODE + '))'  
		END
		ELSE
		BEGIN
			-- 검색일때는 제외
			IF ISNULL(@SEARCH_TEXT, '') = '' AND ISNULL(@GROUP_CODE, '') <> '@SEARCH@'
			BEGIN
				-- 그룹코드가 아닐 시 부산 담당 상품 제외
				SET @WHERE = @WHERE + ' AND A.NEW_CODE NOT IN (SELECT EMP_CODE FROM EMP_MASTER  WITH(NOLOCK) WHERE TEAM_CODE IN (' + @PUSAN_TEAM_CODE + '))'
			END
		END
		
			-- 속성코드  
		IF ISNULL(@ATT_CODE, '') <> ''  
		BEGIN  
			SELECT @ATT_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@ATT_CODE, ',') FOR XML PATH('')), 1, 1, '')     
			SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_ATTRIBUTE  WITH(NOLOCK) WHERE ATT_CODE IN (' + @ATT_CODE + '))'  
		END    
		
		-- 브랜드타입 - 2012-04-30 추가
		IF @BRAND_TYPE > 0 
		BEGIN
			IF @BRAND_TYPE = 99 
			BEGIN
				SET @WHERE = @WHERE + ' AND A.BRAND_TYPE IN(1,2,3,4) '
			END 
			ELSE 
			BEGIN
				SET @WHERE = @WHERE + ' AND A.BRAND_TYPE = ' +  CONVERT(VARCHAR,@BRAND_TYPE) +' '
			END 
		END

		-- SORT 조건 만들기  
		SELECT @SORT_STRING = (  
			CASE @SORT_CODE  
				WHEN 1 THEN 'A.REGION_ORDER'
				WHEN 2 THEN 'A.THEME_ORDER'
				WHEN 3 THEN 'A.GROUP_ORDER'
				WHEN 4 THEN 'A.LOW_PRICE'
				WHEN 5 THEN 'A.HIGH_PRICE'
				WHEN 6 THEN 'A.MASTER_NAME'
			END
		)
		
		SELECT @DESC = (
			CASE @SORT_CODE
				WHEN 5 THEN ' DESC'
				ELSE ''
			END
		)

		IF @FLAG = 'C'  
		BEGIN  
			SET @SQLSTRING = N'
				SELECT COUNT(*)
				FROM (
					SELECT A.MASTER_CODE
					FROM PKG_MASTER A WITH(NOLOCK)
					' + @LEFTTABLE + @INNERTABLE
					
			IF (@PROVIDER NOT IN(0,5,16,18)) --
				--SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_PROVIDER Z WITH(NOLOCK) ON Z.PROVIDER = ' + CAST(@PROVIDER AS VARCHAR) + ' AND A.MASTER_CODE = Z.CODE
				SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = ' + CAST(@PROVIDER AS VARCHAR) + ' AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''
					'
					
			SET @SQLSTRING = @SQLSTRING + @WHERE + '
					GROUP BY A.MASTER_CODE
				) A'
				
		END  
		ELSE IF @FLAG = 'L'  
		BEGIN  
			SET @SQLSTRING = N'
				WITH LIST AS
				(
					SELECT ROW_NUMBER() OVER (ORDER BY ' + @SORT_STRING + ') AS [ROWNUMBER], A.MASTER_CODE, ' + @SORT_STRING + '
					FROM PKG_MASTER A WITH(NOLOCK)
					' + @LEFTTABLE + @INNERTABLE
						
			IF (@PROVIDER NOT IN(0,5,16,18))
				--SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_PROVIDER Z WITH(NOLOCK) ON Z.PROVIDER = ' + CAST(@PROVIDER AS VARCHAR) + ' AND A.MASTER_CODE = Z.CODE
				SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = ' + CAST(@PROVIDER AS VARCHAR) + ' AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''
					'
						
			SET @SQLSTRING = @SQLSTRING + @WHERE + '
					GROUP BY A.MASTER_CODE, ' + @SORT_STRING + '
				)
				SELECT
					B.MASTER_CODE, B.MASTER_NAME, B.PKG_COMMENT, B.PKG_SUMMARY, B.LOW_PRICE, B.HIGH_PRICE, B.EVENT_NAME, B.NEXT_DATE   
					, B.EVENT_PRO_CODE, B.EVENT_DEP_DATE  
					, (SELECT SUM(GRADE) / COUNT(GRADE) FROM PRO_COMMENT WHERE MASTER_CODE = A.MASTER_CODE) AS [GRADE]  
					, (SELECT COUNT(*) FROM HBS_DETAIL WHERE MASTER_SEQ = ''1'' AND MASTER_CODE = A.MASTER_CODE) AS [TRAVEL]  
					, C.*, D.TWO_COUNT, D.THREE_COUNT, D.FOUR_COUNT, D.FIVE_COUNT,  
					D.TWO_PERCENT, D.THREE_PERCENT, D.FOUR_PERCENT, D.FIVE_PERCENT  
					, DBO.FN_GET_TOUR_NIGHY_DAY_TEXT(B.MASTER_CODE,0) AS TOUR_NIGHT_DAY
					, B.ATT_CODE , B.BRANCH_CODE  , B.SIGN_CODE  , B.BRAND_TYPE 
				FROM LIST A  
				INNER JOIN PKG_MASTER B  WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE  
				LEFT OUTER JOIN INF_FILE_MASTER C  WITH(NOLOCK) ON B.MAIN_FILE_CODE = C.FILE_CODE  
				LEFT OUTER JOIN STS_PKG_RES_COUNT D  WITH(NOLOCK) ON A.MASTER_CODE = D.MASTER_CODE  
				WHERE A.ROWNUMBER BETWEEN @FROM AND @TO  
			ORDER BY ' + @SORT_STRING + @DESC
		END  

		
		
		SET @PARMDEFINITION = N'@FROM INT, @TO INT, @START_DATE DATETIME, @END_DATE DATETIME, @SEARCH_DEP_DATE DATETIME';  

		--PRINT @SQLSTRING
		
		EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @FROM, @TO, @START_DATE, @END_DATE, @SEARCH_DEP_DATE;  

	END






GO
