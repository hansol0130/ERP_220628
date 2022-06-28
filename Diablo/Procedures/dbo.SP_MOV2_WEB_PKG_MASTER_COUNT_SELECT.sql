USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================        
■ USP_NAME     : SP_MOV2_WEB_PKG_MASTER_COUNT_SELECT         
■ DESCRIPTION    : 함수_행사_상품리스트_검색수        
■ INPUT PARAMETER   :         
	@KEY  VARCHAR(400): 검색 키        
■ OUTPUT PARAMETER   :         
	@TOTAL_COUNT INT OUTPUT : 총 메일 수               
■ EXEC      :         
        
	DECLARE @TOTAL_COUNT INT,         
	@KEY  VARCHAR(400)        
	SELECT @KEY=N'Provider=0&BrandType=&RegionCode=&CityCode=&NationCode=&AttCode=&GroupCode=&MinPrice=&MaxPrice=&DepDate=&Day=&BranchCode=1&Keyword='        
	exec SP_MOV2_WEB_PKG_MASTER_COUNT_SELECT @total_count output, @key        
        
■ MEMO      : 마스터 리스트 검색 수        
------------------------------------------------------------------------------------------------------------------        
■ CHANGE HISTORY                           
------------------------------------------------------------------------------------------------------------------        
   DATE    AUTHOR   DESCRIPTION                   
------------------------------------------------------------------------------------------------------------------        
   2017-08-26  ibsolution  XP_WEB_PKG_MASTER_LIST_SELECT 에서 전체 갯수만 구함        
   2017-11-28  정지용   실시간 항공 마스터 조회되는 경우 때문에 ATT_CODE가 조건에 없을 경우 ATT_CODE R:실시간항공 제외하도록..        
   2019-05-13  이명훈   REGION_CODE = 'U'(미주일 때) R, S 남미 중미 추가        
   2019-12-17  임검제   2019 리뉴얼 추가    
       CFM_YN(출발확정여부,Y/N)     
       BRANCHCODES 출발지역    
       type 상품속성    
       airlineType 선호항공사    
       hotelGrade 호텔등급    
       researchKeyword 재검색키워드    
    PRICE 금액   
    
================================================================================================================*/         
CREATE PROCEDURE [dbo].[SP_MOV2_WEB_PKG_MASTER_COUNT_SELECT] 
	(@TOTAL_COUNT INT OUTPUT ,@KEY VARCHAR(400))
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
	
	DECLARE @SQLSTRING          NVARCHAR(MAX)
	       ,@PARMDEFINITION     NVARCHAR(1000);        
	DECLARE @INNER_TABLE     NVARCHAR(1000)
	       ,@WHERE           NVARCHAR(4000)
	       ,@SORT_STRING     VARCHAR(50);        
	DECLARE @PUSAN_TEAM_CODE VARCHAR(100)
	       ,@TEMP NVARCHAR(1000)        
	
	DECLARE @PROVIDER VARCHAR(3)
	       ,@BRAND_TYPE VARCHAR(1)
	       ,@REGION_CODE VARCHAR(50)
	       ,@CITY_CODE VARCHAR(50)
	       ,@NATION_CODE VARCHAR(50)
	       ,@ATT_CODE VARCHAR(50)
	       ,@GROUP_CODE VARCHAR(300)
	
	DECLARE @MIN_PRICE VARCHAR(10)
	       ,@MAX_PRICE VARCHAR(10)
	       ,@DEP_DATE VARCHAR(10)
	       ,@DAY VARCHAR(5)
	       ,@BRANCH_CODE VARCHAR(1)
	       ,@KEYWORD NVARCHAR(1000)
	       ,@MAIN_ATT_CODE VARCHAR(10)
	
	DECLARE @CFM_YN               CHAR(1)
	       ,@BRANCH_CODES         VARCHAR(9)
	       ,@TYPE                 VARCHAR(5)
	       ,@AIRLINE_TYPE         VARCHAR(7)
	       ,@HOTEL_GRADE          VARCHAR(5)
	       ,@RESEARCH_KEYWORD     NVARCHAR(1000)
	       ,@PRICE                VARCHAR(10) 
	
	
	-- 검색 제외팀
	--SET @PUSAN_TEAM_CODE = '''514'', ''515'', ''516'', ''524'', ''531''';        
	
	SELECT @PROVIDER = DBO.FN_PARAM(@KEY ,'Provider')
	      ,@BRAND_TYPE = DBO.FN_PARAM(@KEY ,'BrandType')
	      ,@REGION_CODE = DBO.FN_PARAM(@KEY ,'RegionCode')
	      ,@CITY_CODE = DBO.FN_PARAM(@KEY ,'CityCode')
	      ,@NATION_CODE = DBO.FN_PARAM(@KEY ,'NationCode')
	      ,@MAIN_ATT_CODE = DBO.FN_PARAM(@KEY ,'MainAttCode')
	      ,@ATT_CODE = DBO.FN_PARAM(@KEY ,'AttCode')
	      ,@GROUP_CODE = DBO.FN_PARAM(@KEY ,'GroupCode')
	      ,@MIN_PRICE = DBO.FN_PARAM(@KEY ,'MinPrice')
	      ,@MAX_PRICE = DBO.FN_PARAM(@KEY ,'MaxPrice')
	      ,@DEP_DATE = DBO.FN_PARAM(@KEY ,'DepDate')
	      ,@DAY = DBO.FN_PARAM(@KEY ,'Day')
	      ,@BRANCH_CODE = DBO.FN_PARAM(@KEY ,'BranchCode')
	      ,@KEYWORD = DBO.FN_PARAM(@KEY ,'Keyword')
	      ,-- 2019 리뉴얼 추가 시작      
	       @CFM_YN = DBO.FN_PARAM(@KEY ,'CfmYN')	-- 출발일 확정 여부
	      ,@BRANCH_CODES = DBO.FN_PARAM(@KEY ,'BranchCodes')	-- 출발지
	      ,@TYPE = DBO.FN_PARAM(@KEY ,'Type')	-- 속성(패키지,라르고,자유여행)
	      ,@AIRLINE_TYPE = DBO.FN_PARAM(@KEY ,'AirlineType')	-- 선호항공사
	      ,@HOTEL_GRADE = DBO.FN_PARAM(@KEY ,'HotelGrade')	-- 호텔등급
	      ,@RESEARCH_KEYWORD = DBO.FN_PARAM(@KEY ,'ResearchKeyword')	-- 재검색 키워드
	      ,@PRICE = DBO.FN_PARAM(@KEY ,'PRICE')	-- 금액
	      ,-- 2019 리뉴얼 추가 끝      
	       
	       @WHERE = 'WHERE SHOW_YN = ''Y''' 
	
	-- 속성코드가 'BU' 부산일때는 지점코드를 정의한다        
	IF @MAIN_ATT_CODE = 'BU'
	BEGIN
	    SELECT @MAIN_ATT_CODE = NULL
	          ,@BRANCH_CODE = 1
	END
	ELSE 
	IF ISNULL(@MAIN_ATT_CODE ,'') <> ''
	BEGIN
	    SELECT @BRANCH_CODE = 0
	END 
	
	-- 그룹코드 사용시 다른 조건 무시        
	IF ISNULL(@GROUP_CODE ,'') <> ''
	BEGIN
	    IF @PROVIDER IN (25) --CBS 투어
	    BEGIN
	        --불교 APPP0001 그룹코드제외         
	        SELECT @GROUP_CODE = STUFF(
	                   (
	                       SELECT (',''' + DATA + '''') AS [text()]
	                       FROM   [DBO].[FN_SPLIT] (@GROUP_CODE ,',')
	                       WHERE  DATA NOT IN ('APPP0001') FOR XML PATH('')
	                   )
	                  ,1
	                  ,1
	                  ,''
	               )
	    END
	    ELSE
	    BEGIN
	        SELECT @GROUP_CODE = STUFF(
	                   (
	                       SELECT (',''' + DATA + '''') AS [text()]
	                       FROM   [DBO].[FN_SPLIT] (@GROUP_CODE ,',') FOR XML PATH('')
	                   )
	                  ,1
	                  ,1
	                  ,''
	               )
	    END         
	    SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_GROUP WITH(NOLOCK) WHERE GROUP_CODE IN (' + @GROUP_CODE + '))'
	END
	ELSE
	BEGIN
	    IF @REGION_CODE = 'U'
	    BEGIN
	        SET @WHERE = @WHERE + ' AND A.SIGN_CODE IN (''U'', ''R'', ''S'')'
	    END
	    ELSE 
	    IF ISNULL(@REGION_CODE ,'') <> ''
	    BEGIN
	        SELECT @REGION_CODE = STUFF(
	                   (
	                       SELECT (',''' + DATA + '''') AS [text()]
	                       FROM   [DBO].[FN_SPLIT] (@REGION_CODE ,',') FOR XML PATH('')
	                   )
	                  ,1
	                  ,1
	                  ,''
	               )
	        
	        SET @WHERE = @WHERE + ' AND A.SIGN_CODE IN (' + @REGION_CODE + ')'
	    END        
	    
	    IF ISNULL(@ATT_CODE ,'') <> ''
	    BEGIN
	        SELECT @ATT_CODE = STUFF(
	                   (
	                       SELECT (',''' + DATA + '''') AS [text()]
	                       FROM   [DBO].[FN_SPLIT] (@ATT_CODE ,',') FOR XML PATH('')
	                   )
	                  ,1
	                  ,1
	                  ,''
	               )        
	        
	        SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_ATTRIBUTE AA WITH(NOLOCK) WHERE A.MASTER_CODE = AA.MASTER_CODE AND AA.ATT_CODE IN (' + @ATT_CODE + '))'
	    END
	    ELSE
	    BEGIN
	        SET @WHERE = @WHERE + ' AND A.ATT_CODE <> ''R''';
	    END 
	    
	    -- 대표속성 검색        
	    IF ISNULL(@MAIN_ATT_CODE ,'') <> ''
	    BEGIN
	        SET @WHERE = @WHERE + ' AND A.ATT_CODE = @MAIN_ATT_CODE'
	    END-- 그룹코드가 아닐 시 부산 담당 상품 제외
	       --SET @WHERE = @WHERE + ' AND A.NEW_CODE NOT IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE IN (' + @PUSAN_TEAM_CODE + '))'
	END        
	
	IF (ISNULL(@CITY_CODE ,'') <> '' OR ISNULL(@NATION_CODE ,'') <> '')
	BEGIN
	    SET @TEMP = ''        
	    
	    IF (ISNULL(@CITY_CODE ,'') <> '' AND ISNULL(@NATION_CODE ,'') <> '')
	    BEGIN
	        SELECT @CITY_CODE = STUFF(
	                   (
	                       SELECT (',''' + DATA + '''') AS [text()]
	                       FROM   [DBO].[FN_SPLIT] (@CITY_CODE ,',') FOR XML PATH('')
	                   )
	                  ,1
	                  ,1
	                  ,''
	               )
	        
	        SELECT @NATION_CODE = STUFF(
	                   (
	                       SELECT (',''' + DATA + '''') AS [text()]
	                       FROM   [DBO].[FN_SPLIT] (@NATION_CODE ,',') FOR XML PATH('')
	                   )
	                  ,1
	                  ,1
	                  ,''
	               )        
	        
	        SET @TEMP = @TEMP + 'SELECT AAA.CITY_CODE FROM PUB_CITY AAA WITH(NOLOCK) WHERE AAA.CITY_CODE IN (' + @CITY_CODE + ') AND AAA.NATION_CODE IN (' + @NATION_CODE + ')'
	    END
	    ELSE 
	    IF ISNULL(@CITY_CODE ,'') <> ''
	    BEGIN
	        SELECT @CITY_CODE = STUFF(
	                   (
	                       SELECT (',''' + DATA + '''') AS [text()]
	                       FROM   [DBO].[FN_SPLIT] (@CITY_CODE ,',') FOR XML PATH('')
	                   )
	                  ,1
	                  ,1
	                  ,''
	               )        
	        
	        SET @TEMP = @TEMP + @CITY_CODE
	    END
	    ELSE 
	    IF ISNULL(@NATION_CODE ,'') <> ''
	    BEGIN
	        SELECT @NATION_CODE = STUFF(
	                   (
	                       SELECT (',''' + DATA + '''') AS [text()]
	                       FROM   [DBO].[FN_SPLIT] (@NATION_CODE ,',') FOR XML PATH('')
	                   )
	                  ,1
	                  ,1
	                  ,''
	               )        
	        
	        SET @TEMP = @TEMP + 'SELECT AAA.CITY_CODE FROM PUB_CITY AAA WITH(NOLOCK) WHERE AAA.NATION_CODE IN (' + @NATION_CODE + ')'
	    END        
	    
	    SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_MASTER_SCH_CITY AA WITH(NOLOCK) WHERE A.MASTER_CODE = AA.MASTER_CODE AND AA.MAINCITY_YN = ''Y'' AND AA.CITY_CODE IN (' + @TEMP + '))'
	END        
	
	IF ISNULL(@MIN_PRICE ,'') <> ''
	BEGIN
	    -- SET @WHERE = @WHERE + ' AND A.HIGH_PRICE >= CONVERT(BIGINT, @MIN_PRICE)'        
	    SET @WHERE = @WHERE + ' AND A.LOW_PRICE >= CONVERT(BIGINT, @MIN_PRICE)'
	END        
	
	IF ISNULL(@MAX_PRICE ,'') <> ''
	BEGIN
	    -- SET @WHERE = @WHERE + ' AND A.LOW_PRICE <= CONVERT(BIGINT, @MAX_PRICE)'        
	    SET @WHERE = @WHERE + ' AND A.LOW_PRICE <= CONVERT(BIGINT, @MAX_PRICE)'
	END        
	
	IF (ISNULL(@DEP_DATE ,'') <> '')
	   OR (ISNULL(@DAY ,'') <> '')
	BEGIN
	    SET @TEMP = ''        
	    
	    IF (ISNULL(@DEP_DATE ,'') <> '')
	        SET @TEMP = ' AND AA.DEP_DATE = CONVERT(DATETIME, @DEP_DATE)'
	    ELSE
	        SET @TEMP = ' AND AA.DEP_DATE >= GETDATE()'        
	    
	    IF (ISNULL(@DAY ,'') <> '')
	    BEGIN
	        IF @DAY = '10'
	            SET @TEMP = @TEMP + ' AND AA.TOUR_DAY >= @DAY'
	        ELSE 
	        IF @DAY = '3'
	            SET @TEMP = @TEMP + ' AND AA.TOUR_DAY <= @DAY'
	        ELSE
	            SET @TEMP = @TEMP + ' AND AA.TOUR_DAY = @DAY'
	    END        
	    
	    SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_DETAIL AA WITH(NOLOCK) WHERE A.MASTER_CODE = AA.MASTER_CODE ' + @TEMP + ')'
	END
	ELSE
	BEGIN
	    SET @WHERE = @WHERE + ' AND A.LAST_DATE >= GETDATE() '
	END        
	
	IF ISNULL(@BRANCH_CODE ,'') <> ''
	BEGIN
	    SET @WHERE = @WHERE + ' AND A.BRANCH_CODE = CONVERT(INT, @BRANCH_CODE)'
	END        
	
	IF ISNULL(@KEYWORD ,'') <> ''
	BEGIN
	    -- 일본팀 요청 자전거 상품 검색 키워드 치환        
	    IF @KEYWORD = 'JPP3909'
	        SET @KEYWORD = 'JPM003' 
	    --ELSE IF @KEYWORD = 'JPP3903'
	    -- SET @KEYWORD = 'JPM001'        
	    
	    SELECT @TEMP = STUFF(
	               (
	                   SELECT (' AND "' + DATA + '"') AS [text()]
	                   FROM   [DBO].[FN_SPLIT](@KEYWORD ,' ')
	                   WHERE  DATA <> '' FOR XML PATH('')
	               )
	              ,1
	              ,5
	              ,''
	           )
	    
	    SELECT @KEYWORD = ' AND (CONTAINS(A.MASTER_NAME, ''' + @TEMP + ''') OR CONTAINS(A.KEYWORD, ''' + @TEMP + ''') OR CONTAINS(A.PKG_COMMENT, ''' + @TEMP + ''') OR CONTAINS(A.MASTER_CODE, ''' 
	           + REPLACE(@TEMP ,'" AND "' ,'" OR "') + ''') OR A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = ''' + @KEYWORD + '''))'        
	    
	    SET @WHERE = @WHERE + @KEYWORD
	END        
	
	
	IF ISNULL(@BRAND_TYPE ,'') <> ''
	BEGIN
	    /*        
	    IF @BRAND_TYPE = '9'        
	    BEGIN        
	    SET @WHERE = @WHERE + ' AND A.BRAND_TYPE IN(''1'', ''2'', ''3'', ''4'')'        
	    END         
	    ELSE         
	    BEGIN        
	    SET @WHERE = @WHERE + ' AND A.BRAND_TYPE = @BRAND_TYPE'        
	    END         
	    */        
	    
	    SET @WHERE = @WHERE + ' AND A.BRAND_TYPE IS NOT NULL '
	END 
	
	
	-- 2019 리뉴얼 조건 추가 시작 --    
	
	-- 출발일 확정여부    
	IF ISNULL(@CFM_YN ,'') = 'Y'
	BEGIN
	    SET @WHERE = @WHERE + ' AND (        
    SELECT COUNT(*)        
    FROM PKG_DETAIL AA WITH(NOLOCK)        
    WHERE AA.MASTER_CODE = A.MASTER_CODE AND AA.DEP_DATE >= GETDATE() AND AA.DEP_CFM_YN = ''Y''        
   ) > 0 '
	END 
	
	-- 출발지    
	IF ISNULL(@BRANCH_CODES ,'') <> ''
	BEGIN
	    SET @TEMP = 'SELECT A.MASTER_CODE FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE A.SEARCH_TYPE = ''S'' AND A.SEARCH_VALUE IN (' + @BRANCH_CODES + ')';      
	    SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (' + @TEMP + ')'
	END 
	
	-- 속성(패키지,라르고,자유여행)    
	IF ISNULL(@TYPE ,'') <> ''
	BEGIN
	    SET @TEMP = 'SELECT A.MASTER_CODE FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE A.SEARCH_TYPE = ''T'' AND A.SEARCH_VALUE IN (' + @TYPE + ')';      
	    SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (' + @TEMP + ')'
	END 
	
	-- 선호항공사    
	IF ISNULL(@AIRLINE_TYPE ,'') <> ''
	BEGIN
	    SET @TEMP = 'SELECT A.MASTER_CODE FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE A.SEARCH_TYPE = ''A'' AND A.SEARCH_VALUE IN (' + @AIRLINE_TYPE + ')';      
	    SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (' + @TEMP + ')'
	END 
	
	-- 호텔등급    
	IF ISNULL(@HOTEL_GRADE ,'') <> ''
	BEGIN
	    SET @TEMP = 'SELECT A.MASTER_CODE FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE A.SEARCH_TYPE = ''G'' AND A.SEARCH_VALUE IN (' + @HOTEL_GRADE + ')';      
	    SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (' + @TEMP + ')'
	END 
	
	-- 금액  
	IF ISNULL(@PRICE ,'') <> ''
	BEGIN
	    SET @TEMP = 'SELECT A.MASTER_CODE FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE A.SEARCH_TYPE = ''P'' AND A.SEARCH_VALUE IN (' + @PRICE + ')';      
	    SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (' + @TEMP + ')'
	END 
	
	-- 재검색 키워드    
	IF ISNULL(@RESEARCH_KEYWORD ,'') <> ''
	BEGIN
	    SELECT @KEYWORD = ' AND (CONTAINS(A.MASTER_NAME, ''' + @RESEARCH_KEYWORD + ''') OR CONTAINS(A.KEYWORD, ''' + @RESEARCH_KEYWORD + ''') OR CONTAINS(A.PKG_COMMENT, ''' + @RESEARCH_KEYWORD + ''') OR CONTAINS(A.MASTER_CODE, ''' 
	           + REPLACE(@RESEARCH_KEYWORD ,'" AND "' ,'" OR "') + ''') OR A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = ''' + @RESEARCH_KEYWORD + '''))'        
	    
	    SET @WHERE = @WHERE + @KEYWORD
	END 
	
	-- 2019 리뉴얼 조건 추가 끝 --    
	
	
	-- 필터 조건 추가        
	DECLARE @WEEKDAY VARCHAR(50)        
	SELECT @WEEKDAY = DBO.FN_PARAM(@KEY ,'Weekday')        
	
	IF ISNULL(@WEEKDAY ,'') <> ''
	BEGIN
	    SET @WHERE = @WHERE + ' AND (        
    SELECT COUNT(*)        
    FROM PKG_DETAIL AA WITH(NOLOCK)        
     INNER JOIN DBO.FN_SPLIT(@WEEKDAY, '','') CC        
     ON DATENAME(DW, AA.DEP_DATE) = CC.DATA        
    WHERE AA.MASTER_CODE = A.MASTER_CODE AND AA.DEP_DATE >= GETDATE() AND AA.SHOW_YN = ''Y''        
   ) > 0 '
	END        
	
	
	SET @SQLSTRING = N'        
 -- 전체 마스터 수        
 SELECT COUNT(*) AS TOTAL_COUNT        
 FROM PKG_MASTER A WITH(NOLOCK)        
 '
	
	IF @PROVIDER NOT IN ('0' ,'5' ,'16' ,'18' ,'25')
	    SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = CONVERT(INT, @PROVIDER) AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''        
 '        
	
	SET @SQLSTRING = @SQLSTRING + @WHERE;        
	
	
	SET @PARMDEFINITION = N'        
  @TOTAL_COUNT INT OUTPUT,        
  @PROVIDER VARCHAR(3),        
  @BRAND_TYPE VARCHAR(1),        
  @MIN_PRICE VARCHAR(10),        
  @MAX_PRICE VARCHAR(10),        
  @DEP_DATE VARCHAR(10),        
  @DAY VARCHAR(5),        
  @BRANCH_CODE VARCHAR(1),        
  @KEYWORD NVARCHAR(1000),        
  @MAIN_ATT_CODE VARCHAR(10),        
  @WEEKDAY VARCHAR(50)'; 
	
	--PRINT @SQLSTRING        
	
	EXEC SP_EXECUTESQL @SQLSTRING
	    ,@PARMDEFINITION
	    ,@TOTAL_COUNT OUTPUT
	    ,@PROVIDER
	    ,@BRAND_TYPE
	    ,@MIN_PRICE
	    ,@MAX_PRICE
	    ,@DEP_DATE
	    ,@DAY
	    ,@BRANCH_CODE
	    ,@KEYWORD
	    ,@MAIN_ATT_CODE
	    ,@WEEKDAY;
END
GO
