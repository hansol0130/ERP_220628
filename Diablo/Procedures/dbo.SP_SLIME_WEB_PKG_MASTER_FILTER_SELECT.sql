USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                
                
/*================================================================================================================                
■ USP_NAME     : SP_SLIME_WEB_PKG_MASTER_FILTER_SELECT ( <= XP_WEB_PKG_MASTER_LIST_SELECT 에 정렬방식 추가)                 
■ DESCRIPTION    : 마스터 리스트 필터 검색                
■ INPUT PARAMETER   :                 
 @PAGE_INDEX  INT  : 현재 페이지                
 @PAGE_SIZE  INT   : 한 페이지 표시 게시물 수                
 @KEY  VARCHAR(400): 검색 키                
 @ORDER_BY INT   : 정렬 순서                
■ OUTPUT PARAMETER   :                 
 @TOTAL_COUNT INT OUTPUT : 총 메일 수                       
■ EXEC      :                 
                
 DECLARE @PAGE_INDEX INT,                
 @PAGE_SIZE  INT,                
 @TOTAL_COUNT INT,                 
 @KEY  VARCHAR(400),                
 @ORDER_BY INT                
                
 SELECT @PAGE_INDEX=1,@PAGE_SIZE=30,@KEY=N'Provider=0&RegionCode=A&AttCode=W&MinPrice=&MaxPrice=',@ORDER_BY=9                
                
 exec SP_MOV2_WEB_PKG_MASTER_LIST_SELECT @page_index, @page_size, @total_count output, @key, @order_by                
 SELECT @TOTAL_COUNT                
                
 declare @p5 int                
 set @p5=NULL                
 exec SP_MOV2_WEB_PKG_MASTER_LIST_SELECT @PAGE_INDEX=1,@PAGE_SIZE=20,@KEY=N'Provider=0&RegionCode=E',@ORDER_BY=6,@TOTAL_COUNT=@p5 output                
 select @p5                
                
 declare @p5 int                
 set @p5=849                
 exec SP_MOV2_WEB_PKG_MASTER_LIST_SELECT @PAGE_INDEX=1,@PAGE_SIZE=20,@KEY=N'Provider=0&RegionCode=E',@ORDER_BY=1,@TOTAL_COUNT=@p5 output                
 select @p5                
                
                
■ MEMO      : 수정 시 XP_WEB_PKG_MASTER_CATEGORY_LIST_SELECT 프로시저와 검색 조건 동기화 해야함                
------------------------------------------------------------------------------------------------------------------                
■ CHANGE HISTORY                                   
------------------------------------------------------------------------------------------------------------------                
   DATE    AUTHOR   DESCRIPTION                           
------------------------------------------------------------------------------------------------------------------                
   2013-03-20  김성호   최초생성                
   2013-05-20  김성호   날짜가 없을때 LAST_DATE >= GETDATE() 조건 추가                
   2013-05-24  김성호   정렬 순서 변경                
   2013-06-05  김성호   검색 조건 수정 (도시코드, 국가코드, 날짜)                
   2013-06-09  김성호   PRO_CODE 검색 추가                
   2013-06-10  김성호   WITH(NOLOCK) 추가                
   2013-06-18  김성호   @SQLSTRING NVARCHAR(MAX)로 수정 및 @PROVIDER 부분 수정                
   2013-07-09  김성호   BranchCode 검색어 추가                
   2013-07-29  김성호   @BRAND_TYPE VARCHAR(1) 선언                
   2013-09-11  이동호   REGION_NAME 지역명 추가 불러옴                
   2014-12-08  김성호   일본 자전가 상품 키워드 치환 작업                
   2015-03-25  박형만   크루즈 불교상품 제외                
   2017-04-04  정지용   MIN_PRICE / MAX_PRICE CONVERT시에 INT -> BIGINT로 변경                
   2017-07-11  오준욱   XP_WEB_PKG_MASTER_LIST_SELECT 에 필터/정렬방식추가                
   2017-10-27  김성호   변수 파라메터처리 및 동반자 테이블 변경에 따른 전체적인 수정 작업                
   2017-10-31  김성호   동반자 정렬 시 여권 정보 배제                
   2017-11-03  김성호   동반자 정렬 시 상품속성(허니문) 무조건 뒤로 (동반자 커플은 제외)                
   2017-11-15  박형만   대표속성 ATT_NAME 추가                 
   2017-11-17  김성호   이벤트명, 이벤트행사 출발일자 항목 추가                
   2017-11-24  박형만   REGION_NAME 속성 변경 REGION_CODE -> SIGN                 
   2017-11-28  정지용   실시간 항공 마스터 조회되는 경우 때문에 ATT_CODE가 조건에 없을 경우 ATT_CODE R:실시간항공 제외하도록..                
   2017-11-28  정지용   @KEYWORD NVARCHAR(2000) 으로 변경                
   2017-01-18  정지용   MIN_DAY / MAX_DAY / CFM_YN 추가                
   2017-01-19  정지용   조건 쿼리 정리                 
   2019-01-22  이명훈   라르고 페이지 라르고 상품만 나오게(BRAND_TYPE = '2')                
   2019-05-13  이명훈   REGION_CODE = 'U'(미주일 때) R, S 남미 중미 추가                
   2019-11-27  박형만   CFM_YN 일때 출발확정 전체 DEP_CFM_YN IN (Y,F인것)                
   2019-11-28  임검제   리뉴얼 선호항공, 호텔등급, 가격범위, 출발지역 조회조건 추가                
   2019-12-20  김성호   정렬조건 '상품평 많은순' 추가                
   2019-12-27  임검제   상품평 내용 조회 Select 항목 추가 ( MASTER_BO )              
   2019-12-31  임검제   여행일자 갯수 카운트를 위한 필드 추가 TOUR_DAY_COUNT            
================================================================================================================*/                 
CREATE  PROCEDURE [dbo].[SP_SLIME_WEB_PKG_MASTER_FILTER_SELECT]        
(                
 @KEY  NVARCHAR(MAX)        
)                
                
AS                  
BEGIN                
                
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                
 	                
 DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);                
 DECLARE @INNER_TABLE NVARCHAR(1000), @WHERE NVARCHAR(4000), @SORT_STRING VARCHAR(50);                
 DECLARE @PUSAN_TEAM_CODE VARCHAR(100), @TEMP NVARCHAR(2000);                
                 
 DECLARE @PROVIDER VARCHAR(3), @BRAND_TYPE VARCHAR(1), @REGION_CODE VARCHAR(50), @CITY_CODE VARCHAR(50), @NATION_CODE VARCHAR(50), @ATT_CODE VARCHAR(50), @GROUP_CODE NVARCHAR(MAX);                
 DECLARE @MIN_PRICE VARCHAR(10), @MAX_PRICE VARCHAR(10), @DEP_DATE VARCHAR(10), @BRANCH_CODE VARCHAR(1), @KEYWORD NVARCHAR(2000), @MAIN_ATT_CODE VARCHAR(10), @WEEKDAY VARCHAR(50)                
   , @AIRLINE_TYPE VARCHAR(50), @HOTEL_GRADE VARCHAR(50), @PRICE VARCHAR(50);                
 DECLARE @MIN_DAY VARCHAR(5), @MAX_DAY VARCHAR(5), @CFM_YN CHAR(1), @BRANCH_CODES VARCHAR(50), @TYPE VARCHAR(50), @RESEARCH_KEYWORD VARCHAR(2000), @DAY VARCHAR(10);                
                
 -- 검색 제외팀                
 --SET @PUSAN_TEAM_CODE = '''514'', ''515'', ''516'', ''524'', ''531''';                
                
 SELECT                
  @PROVIDER = DBO.FN_PARAM(@KEY, 'Provider'),                
  @BRAND_TYPE = DBO.FN_PARAM(@KEY, 'BrandType'),                
  @REGION_CODE = DBO.FN_PARAM(@KEY, 'RegionCode'),                
  @CITY_CODE = DBO.FN_PARAM(@KEY, 'CityCode'),                
  @NATION_CODE = DBO.FN_PARAM(@KEY, 'NationCode'),                
  @MAIN_ATT_CODE = DBO.FN_PARAM(@KEY, 'MainAttCode'),                
  @ATT_CODE = DBO.FN_PARAM(@KEY, 'AttCode'),                
  @GROUP_CODE = DBO.FN_PARAM(@KEY, 'GroupCode'),                
  @MIN_PRICE = DBO.FN_PARAM(@KEY, 'MinPrice'),                
  @MAX_PRICE = DBO.FN_PARAM(@KEY, 'MaxPrice'),                
  @DEP_DATE = DBO.FN_PARAM(@KEY, 'DepDate'),                
  @DAY = DBO.FN_PARAM(@KEY, 'Day'),                
  @BRANCH_CODE = DBO.FN_PARAM(@KEY, 'BranchCode'),                
  @KEYWORD = DBO.FN_PARAM(@KEY, 'Keyword'),                
  @WEEKDAY = DBO.FN_PARAM(@KEY, 'Weekday'),                
  @MIN_DAY = DBO.FN_PARAM(@KEY, 'MinDay'),                
  @MAX_DAY = DBO.FN_PARAM(@KEY, 'MaxDay'),                
  @CFM_YN = DBO.FN_PARAM(@KEY, 'CfmYN'),                
                
  -- 20191128 리뉴얼 선호항공, 호텔등급, 가격범위, 출발지역 조회조건 추가                              
  @AIRLINE_TYPE = DBO.FN_PARAM(@KEY, 'AirlineType'),                                  
  @HOTEL_GRADE = DBO.FN_PARAM(@KEY, 'HotelGrade'),                                  
  @PRICE = DBO.FN_PARAM(@KEY, 'PRICE'),                                  
  @BRANCH_CODES = DBO.FN_PARAM(@KEY, 'BranchCodes'),                                  
  @TYPE = DBO.FN_PARAM(@KEY,'Type'),                          
  @RESEARCH_KEYWORD = dbo.FN_PARAM(@KEY,'ResearchKeyword'),                   
                
  @WHERE = 'WHERE SHOW_YN = ''Y'''                
                
   IF (ISNULL(@RESEARCH_KEYWORD,'') <> '')                        
  BEGIN                        
   IF (ISNULL(@KEYWORD,'') <> '')                        
   BEGIN                        
    SET @KEYWORD = @KEYWORD + ' ' + @RESEARCH_KEYWORD                        
   END                        
   ELSE                        
   BEGIN                        
    SET @KEYWORD =  @RESEARCH_KEYWORD         
   END                        
  END                
                
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
                
  IF @PROVIDER IN ( 25 )  --CBS 투어                 
  BEGIN                
   --불교 APPP0001 그룹코드제외                 
   SELECT @GROUP_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@GROUP_CODE, ',') WHERE DATA NOT IN ('APPP0001')  FOR XML PATH('')), 1, 1, '')                
  END                 
  ELSE                 
  BEGIN                
   SELECT @GROUP_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@GROUP_CODE, ',') FOR XML PATH('')), 1, 1, '')                
  END                 
  SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_GROUP WITH(NOLOCK) WHERE GROUP_CODE IN (' + @GROUP_CODE + '))'                
                
 END                
 ELSE                
 BEGIN                
  IF @REGION_CODE = 'U'                
  BEGIN                
   SET @WHERE = @WHERE + ' AND A.SIGN_CODE IN (''U'', ''R'', ''S'')'                
  END                
  ELSE IF ISNULL(@REGION_CODE, '') <> ''                
  BEGIN                
   SELECT @REGION_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@REGION_CODE, ',') FOR XML PATH('')), 1, 1, '')                
   SET @WHERE = @WHERE + ' AND A.SIGN_CODE IN (' + @REGION_CODE + ')'                
  END                
                
  IF ISNULL(@ATT_CODE, '') <> ''                
  BEGIN                
   SELECT @ATT_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@ATT_CODE, ',') FOR XML PATH('')), 1, 1, '')                
                
   SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_ATTRIBUTE AA WITH(NOLOCK) WHERE A.MASTER_CODE = AA.MASTER_CODE AND AA.ATT_CODE IN (' + @ATT_CODE + '))'                  
  END                
  ELSE                
  BEGIN                 
   SET @WHERE = @WHERE + ' AND A.ATT_CODE <> ''R''';                
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
                
  IF (ISNULL(@CITY_CODE, '') <> '' AND ISNULL(@NATION_CODE, '') <> '')                
  BEGIN                
   SELECT @CITY_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@CITY_CODE, ',') FOR XML PATH('')), 1, 1, '')                
   SELECT @NATION_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@NATION_CODE, ',') FOR XML PATH('')), 1, 1, '')                
                
   SET @TEMP = @TEMP + 'SELECT AAA.CITY_CODE FROM PUB_CITY AAA WITH(NOLOCK) WHERE AAA.CITY_CODE IN (' + @CITY_CODE + ') AND AAA.NATION_CODE IN (' + @NATION_CODE + ')'                
                
  END                
  ELSE IF ISNULL(@CITY_CODE, '') <> ''                
  BEGIN                
   SELECT @CITY_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@CITY_CODE, ',') FOR XML PATH('')), 1, 1, '')                
                
   SET @TEMP = @TEMP + @CITY_CODE                
  END                
  ELSE IF ISNULL(@NATION_CODE, '') <> ''                
  BEGIN                
   SELECT @NATION_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@NATION_CODE, ',') FOR XML PATH('')), 1, 1, '')                
                
   SET @TEMP = @TEMP + 'SELECT AAA.CITY_CODE FROM PUB_CITY AAA WITH(NOLOCK) WHERE AAA.NATION_CODE IN (' + @NATION_CODE + ')'        
  END                
                
  SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_MASTER_SCH_CITY AA WITH(NOLOCK) WHERE A.MASTER_CODE = AA.MASTER_CODE AND AA.MAINCITY_YN = ''Y'' AND AA.CITY_CODE IN (' + @TEMP + '))'                
                
 END                
                
 IF ISNULL(@MIN_PRICE, '') <> ''                
 BEGIN                
  --SET @WHERE = @WHERE + ' AND A.HIGH_PRICE >= CONVERT(BIGINT, @MIN_PRICE)'                
   SET @WHERE = @WHERE + ' AND A.LOW_PRICE >= CONVERT(BIGINT, @MIN_PRICE)'                
 END                
                
 IF ISNULL(@MAX_PRICE, '') <> ''                
 BEGIN                
  SET @WHERE = @WHERE + ' AND A.LOW_PRICE <= CONVERT(BIGINT, @MAX_PRICE)'                
 END                
                
 IF (ISNULL(@DEP_DATE, '') <> '') OR (ISNULL(@DAY, '') <> '' OR (ISNULL(@MIN_DAY, '') <> '' AND ISNULL(@MAX_DAY, '') <> '')) OR (ISNULL(@CFM_YN, '') = 'Y') OR (ISNULL(@WEEKDAY, '') <> '')                
 BEGIN                
  SET @TEMP = ''                
  IF (ISNULL(@DEP_DATE, '') <> '')                
   SET @TEMP = ' AND AA.DEP_DATE = CONVERT(DATETIME, @DEP_DATE)'                
  ELSE                
   SET @TEMP = ' AND AA.DEP_DATE >= GETDATE()'                
                
  --IF (ISNULL(@DAY, '') <> '')                
  --BEGIN                
  -- IF @DAY = '10'                
  --  SET @TEMP = @TEMP + ' AND AA.TOUR_DAY >= @DAY'                
  -- ELSE IF @DAY = '3'                
  --  SET @TEMP = @TEMP + ' AND AA.TOUR_DAY <= @DAY'                
  -- ELSE                
  --  SET @TEMP = @TEMP + ' AND AA.TOUR_DAY = @DAY'                
  --END                
                
  IF (ISNULL(@MIN_DAY, '') <> '' AND ISNULL(@MAX_DAY, '') <> '')                
  BEGIN                
   IF @MAX_DAY = '10'                
    SET @TEMP = @TEMP + ' AND AA.TOUR_DAY >= @MAX_DAY'                
   ELSE IF @MIN_DAY = '3'                
    SET @TEMP = @TEMP + ' AND AA.TOUR_DAY <= @MIN_DAY'                
   ELSE IF @MIN_DAY = @MAX_DAY                
    SET @TEMP = @TEMP + ' AND AA.TOUR_DAY = @MIN_DAY'                
   ELSE                
    SET @TEMP = @TEMP + ' AND AA.TOUR_DAY >= @MIN_DAY AND AA.TOUR_DAY <= @MAX_DAY';                
  END                
                
  IF ISNULL(@CFM_YN, '') = 'Y'                
  BEGIN                 
   SET @TEMP = @TEMP + ' AND AA.DEP_CFM_YN IN (''Y'',''F'') '                
  END                
                
  IF ISNULL(@WEEKDAY, '') <> ''                
  BEGIN                
   SET @TEMP = @TEMP + ' AND DATENAME(DW, AA.DEP_DATE) IN (SELECT DATA FROM DBO.FN_SPLIT(@WEEKDAY, '',''))'                   
  END                
                
  SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_DETAIL AA WITH(NOLOCK) WHERE A.MASTER_CODE = AA.MASTER_CODE AND SHOW_YN = ''Y'' ' + @TEMP + ')'                
 END                
 ELSE                
 BEGIN                
  SET @WHERE = @WHERE + ' AND A.LAST_DATE >= GETDATE() '                
 END                
                
 /* 조건만 다른 같은 쿼리 합침.. 정군 : 2017-01-19                
  IF (ISNULL(@DEP_DATE, '') <> '') OR (ISNULL(@DAY, '') <> '')                
  BEGIN                
   SET @TEMP = ''                
                
   IF (ISNULL(@DEP_DATE, '') <> '')                
    SET @TEMP = ' AND AA.DEP_DATE = CONVERT(DATETIME, @DEP_DATE)'                
   ELSE                
    SET @TEMP = ' AND AA.DEP_DATE >= GETDATE()'                
                
   IF (ISNULL(@DAY, '') <> '')                
   BEGIN              
    IF @DAY = '10'                
     SET @TEMP = @TEMP + ' AND AA.TOUR_DAY >= @DAY'                
    ELSE IF @DAY = '3'                
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
                
  IF ISNULL(@BRANCH_CODE, '') <> ''                
  BEGIN                
   SET @WHERE = @WHERE + ' AND A.BRANCH_CODE = CONVERT(INT, @BRANCH_CODE)'                
  END                
                
  IF ISNULL(@WEEKDAY, '') <> ''                
  BEGIN                
   SET @WHERE = @WHERE + N' AND A.MASTER_CODE IN (                
  SELECT MASTER_CODE                 
  FROM PKG_DETAIL AA WITH(NOLOCK)                 
  WHERE AA.MASTER_CODE = A.MASTER_CODE AND AA.DEP_DATE >= GETDATE() AND AA.SHOW_YN = ''Y''                
   AND DATENAME(DW, AA.DEP_DATE) IN (SELECT DATA FROM DBO.FN_SPLIT(@WEEKDAY, '','')))'                
                
   --SET @WHERE = @WHERE + ' AND (                
   --  SELECT COUNT(*)                
   --  FROM PKG_DETAIL AA WITH(NOLOCK)                
   --   INNER JOIN DBO.FN_SPLIT(@WEEKDAY, '','') CC                
   --   ON DATENAME(DW, AA.DEP_DATE) = CC.DATA                
   --  WHERE AA.MASTER_CODE = A.MASTER_CODE AND AA.DEP_DATE >= GETDATE() AND AA.SHOW_YN = ''Y''                
   -- ) > 0 '                
  END                
 */                
                
 IF ISNULL(@BRANCH_CODE, '') <> ''                
 BEGIN                
  SET @WHERE = @WHERE + ' AND A.BRANCH_CODE = CONVERT(INT, @BRANCH_CODE)'                
 END                
                
 IF ISNULL(@KEYWORD, '') <> ''                
 BEGIN                
  -- 일본팀 요청 자전거 상품 검색 키워드 치환                
  IF @KEYWORD = 'JPP3909'                
   SET @KEYWORD = 'JPM003'                
  --ELSE IF @KEYWORD = 'JPP3903'                
  -- SET @KEYWORD = 'JPM001'                
                
  SELECT @TEMP = STUFF((SELECT (' AND "' + DATA + '"') AS [text()] FROM [DBO].[FN_SPLIT](@KEYWORD, ' ') WHERE DATA <> '' FOR XML PATH('')), 1, 5, '')                
  SELECT @KEYWORD = ' AND (CONTAINS(A.MASTER_NAME, ''' + @TEMP + ''') OR CONTAINS(A.KEYWORD, ''' + @TEMP + ''') OR CONTAINS(A.PKG_COMMENT, ''' + @TEMP + ''') OR CONTAINS(A.MASTER_CODE, '''                 
   + REPLACE(@TEMP,'" AND "','" OR "') + ''') OR A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = ''' + @KEYWORD + '''))'                
                
  SET @WHERE = @WHERE + @KEYWORD                
 END                
                
                 
 IF ISNULL(@BRAND_TYPE, '') <> ''                
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
                
  IF @BRAND_TYPE = '2'                
  BEGIN                
   SET @WHERE = @WHERE + ' AND A.BRAND_TYPE = @BRAND_TYPE'                
  END                
  ELSE                
  BEGIN                
   SET @WHERE = @WHERE + ' AND A.BRAND_TYPE IS NOT NULL'                
  END                
 END                
                
 -- 20191128 리뉴얼 선호항공 , 호텔등급 , 출발지역(summary table 사용) 조회조건 추가                              
 IF ISNULL(@AIRLINE_TYPE,'') <> ''                
 BEGIN                
  SELECT @AIRLINE_TYPE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@AIRLINE_TYPE, ',') FOR XML PATH('')), 1, 1, '')                
  SET @TEMP = 'SELECT A.MASTER_CODE FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE A.SEARCH_TYPE = ''A'' AND A.SEARCH_VALUE IN (' + @AIRLINE_TYPE + ')';                
  SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (' + @TEMP + ')'                
 END                
                
 IF ISNULL(@HOTEL_GRADE,'') <> ''                
 BEGIN                
  SELECT @HOTEL_GRADE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@HOTEL_GRADE, ',') FOR XML PATH('')), 1, 1, '')                
  SET @TEMP = 'SELECT A.MASTER_CODE    FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE A.SEARCH_TYPE = ''G'' AND A.SEARCH_VALUE IN (' + @HOTEL_GRADE + ')';                
  SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (' + @TEMP + ')'                
 END                
                             
 IF ISNULL(@PRICE,'') <> ''                
 BEGIN                
  SELECT @PRICE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@PRICE, ',') FOR XML PATH('')), 1, 1, '')                
  SET @TEMP = 'SELECT A.MASTER_CODE    FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE A.SEARCH_TYPE = ''P'' AND A.SEARCH_VALUE IN (' + @PRICE + ')';                
  SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (' + @TEMP + ')'                
 END                
                  
 IF ISNULL(@BRANCH_CODES,'') <> ''                
 BEGIN                
  SELECT @BRANCH_CODES = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@BRANCH_CODES, ',') FOR XML PATH('')), 1, 1, '')                
  SET @TEMP = 'SELECT A.MASTER_CODE    FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE A.SEARCH_TYPE = ''S'' AND A.SEARCH_VALUE IN (' + @BRANCH_CODES + ')';                
  --PRINT @TEMP                
  SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (' + @TEMP + ')'                
 END                
                
 IF ISNULL(@TYPE,'') <> ''                
 BEGIN                
  SELECT @TYPE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@TYPE, ',') FOR XML PATH('')), 1, 1, '')                
  SET @TEMP = 'SELECT A.MASTER_CODE    FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE A.SEARCH_TYPE = ''T'' AND A.SEARCH_VALUE IN (' + @TYPE +')';                
  --print @temp                          
  SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (' + @TEMP + ')'                
 END                
                             
 IF ISNULL(@DAY,'') <> ''                
 BEGIN                
  SELECT @DAY = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@DAY, ',') FOR XML PATH('')), 1, 1, '')                
  SET @TEMP = 'SELECT A.MASTER_CODE FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE A.SEARCH_TYPE = ''D'' AND A.SEARCH_VALUE IN (' + @DAY + ')';                
  SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (' + @TEMP + ')'                
 END                
                
 SET @SQLSTRING = N'                
 -- 마스터 서머리                
 SELECT DISTINCT SUM.SEARCH_TYPE, SUM.SEARCH_VALUE      
 FROM PKG_MASTER A WITH(NOLOCK)                
 JOIN PKG_MASTER_SUMMARY SUM WITH(NOLOCK) ON A.MASTER_CODE = SUM.MASTER_CODE      
 '                
 IF @PROVIDER NOT IN('0','5','16','18','25')                
  SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = CONVERT(INT, @PROVIDER) AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''                
 '                
       
 SET @SQLSTRING = @SQLSTRING + N'                
 ' + @WHERE ;
                
 SET @PARMDEFINITION = N'                
  @PROVIDER VARCHAR(3),           
  @BRAND_TYPE VARCHAR(1),                
  @MIN_PRICE VARCHAR(10),                
  @MAX_PRICE VARCHAR(10),                
  @DEP_DATE VARCHAR(10),                
  @DAY VARCHAR(10),                
  @BRANCH_CODE VARCHAR(1),                
  @KEYWORD NVARCHAR(1000),                
  @MAIN_ATT_CODE VARCHAR(10),                
  @WEEKDAY VARCHAR(50),                
  @MIN_DAY VARCHAR(5),                
  @MAX_DAY VARCHAR(5),                
  @CFM_YN CHAR(1)';                
                
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
  @MAIN_ATT_CODE,                
  @WEEKDAY,                
  @MIN_DAY,                
  @MAX_DAY,                
  @CFM_YN;                
                
END 
GO
