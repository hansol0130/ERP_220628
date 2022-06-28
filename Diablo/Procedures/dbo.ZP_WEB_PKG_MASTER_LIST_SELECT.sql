USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================  
■ USP_NAME     : ZP_WEB_PKG_MASTER_LIST_SELECT  
■ DESCRIPTION    : 마스터 리스트 검색  
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
  
 SELECT @PAGE_INDEX=1,@PAGE_SIZE=30,@KEY=N'Provider=0&BrandType=&RegionCode=&CityCode=&NationCode=&AttCode=&GroupCode=&MinPrice=&MaxPrice=&DepDate=&Day=&BranchCode=1&Keyword=',@ORDER_BY=4  
  
 exec ZP_WEB_PKG_MASTER_LIST_SELECT @page_index, @page_size, @total_count output, @key, @order_by  
 SELECT @TOTAL_COUNT  
  
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
   2020-02-18  임원묵   XP_WEB_PKG_MASTER_LIST_SELECT -> ZP_WEB_PKG_MASTER_LIST_SELECT 로 복사 생성
================================================================================================================*/   
CREATE PROCEDURE [dbo].[ZP_WEB_PKG_MASTER_LIST_SELECT] 
(@PAGE_INDEX INT ,@PAGE_SIZE INT ,@TOTAL_COUNT INT OUTPUT ,@KEY VARCHAR(400) ,@ORDER_BY INT)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	
	DECLARE @SQLSTRING          NVARCHAR(MAX)
	       ,@SQLSTRING_ADD      NVARCHAR(MAX)
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
	
	DECLARE @MIN_PRICE         VARCHAR(10)
	       ,@MAX_PRICE         VARCHAR(10)
	       ,@DEP_DATE          VARCHAR(10)
	       ,@DAY               VARCHAR(5)
	       ,@BRANCH_CODE       VARCHAR(1)
	       ,@KEYWORD           NVARCHAR(1000)
	       ,@MAIN_ATT_CODE     VARCHAR(10) 
	
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
	      ,@WHERE = 'WHERE SHOW_YN = ''Y''' 
	--  SET @GROUP_CODE = 'APP0144,APP015,APP033,APP0521,APP0662,APP071,APP1001,APP1106,APP1199,APP2000,APP3500,APP4056,APP610,APPBKK,APPDAD,UPPQ666,UPPQ655,uppq654,UPPQ653,UPPQ652,uppq651,UPPP700,UPPG8002,UPPG701,UPPG657,UPPG656,UPPG655,UPPG654,UPPG6526';
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
	    SET @WHERE = @WHERE + ' AND A.HIGH_PRICE >= CONVERT(BIGINT, @MIN_PRICE)'
	END  
	
	IF ISNULL(@MAX_PRICE ,'') <> ''
	BEGIN
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
	    
	    SELECT @WHERE = @WHERE + @KEYWORD--, @ORDER_BY = 9 -- 키워드 전용 정렬
	END  
	
	IF ISNULL(@BRAND_TYPE ,'') <> ''
	BEGIN
	    IF @BRAND_TYPE = '9'
	    BEGIN
	        SET @WHERE = @WHERE + ' AND A.BRAND_TYPE IN(''1'', ''2'', ''3'', ''4'')'
	    END
	    ELSE
	    BEGIN
	        SET @WHERE = @WHERE + ' AND A.BRAND_TYPE = @BRAND_TYPE'
	    END
	END 
	
	-- SORT 조건 만들기    
	SELECT @SORT_STRING = (
	           CASE @ORDER_BY 
	                --   WHEN 1 THEN 'STAR_POINT DESC' -- 'A.REGION_ORDER' --2019-12-11 지역추천 순 --> 평점높은순으로 변경(TO_BE 지역추천 순 사용 안함)
	                WHEN 1 THEN 'A.REGION_ORDER'
	                WHEN 2 THEN 'A.THEME_ORDER'
	                WHEN 3 THEN 'A.GROUP_ORDER'
	                WHEN 4 THEN 'A.LOW_PRICE'
	                WHEN 5 THEN 'A.HIGH_PRICE DESC'
	                WHEN 6 THEN 'TOTAL_COUNT' -- 'A.MASTER_NAME' --2019-12-11 이름 순 --> 예약 많은 순으로 변경(TO_BE 이름 순 사용 안함)
	                WHEN 8 THEN 'STAR_POINT' -- 평점많은순 아직 미정
	                                         --WHEN 9 THEN '(CASE A.ATT_CODE WHEN ''P'' THEN 1 ELSE 2 END), A.REGION_ORDER'
	                ELSE 'A.REGION_ORDER'
	           END
	       )  
	
	SET @SQLSTRING = N'  
 -- 전체 마스터 수  
 SELECT @TOTAL_COUNT = COUNT(*)  
 FROM PKG_MASTER A WITH(NOLOCK)  
 '
	
	IF @PROVIDER NOT IN ('0' ,'5' ,'16' ,'18' ,'25')
	    SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = CONVERT(INT, @PROVIDER) AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''  
 '  
	
	SET @SQLSTRING = @SQLSTRING + N'  
 ' + @WHERE + N';

-- 최소, 최대값
SELECT MIN(LOW_PRICE) AS [LOW_PRICE], MAX(HIGH_PRICE) AS [HIGH_PRICE]
FROM PKG_MASTER A WITH(NOLOCK)
	'
	--IF @PROVIDER NOT IN('0','5','16','18')
	-- SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = CONVERT(INT, @PROVIDER) AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''
	--'  
	SET @SQLSTRING = @SQLSTRING + N'  
 ' + @WHERE + N';  
  
  
 WITH LIST AS  
 (  
  SELECT A.MASTER_CODE  
   ,  ISNULL(A3.STAR_POINT , 0) AS STAR_POINT  
   ,  ISNULL(A3.STAR_COUNT, 0) AS STAR_COUNT  
   ,  ISNULL(A3.TOTAL_COUNT, 0) AS TOTAL_COUNT  
  FROM PKG_MASTER A WITH(NOLOCK)  
  LEFT OUTER JOIN PKG_MASTER_PARTNER A3 WITH(NOLOCK) ON A.MASTER_CODE = A3.MASTER_CODE  
  '
	
	IF @PROVIDER NOT IN ('0' ,'5' ,'16' ,'18' ,'25')
	    SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = CONVERT(INT, @PROVIDER) AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''  
  '
	
	SET @SQLSTRING = @SQLSTRING + N'  
  ' + @WHERE + N'  
  ORDER BY ' + @SORT_STRING + 
	    ', A.MASTER_CODE  
  OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE  
  ROWS ONLY  
 )  
 SELECT A.MASTER_CODE  
  , A.MASTER_NAME  
  , A.PKG_COMMENT  
  , A.PKG_SUMMARY  
  , A.LOW_PRICE  
  , A.HIGH_PRICE  
  , A.EVENT_NAME  
  , ISNULL(A.NEXT_DATE, CONVERT(DATETIME, ''1900-01-01'')) AS NEXT_DATE  
  , A.EVENT_PRO_CODE  
  , ISNULL(A.EVENT_DEP_DATE, CONVERT(DATETIME, ''1900-01-01'')) AS EVENT_DEP_DATE  
  , A.ATT_CODE  
  , A.BRANCH_CODE  
  , A.SIGN_CODE  
  , A.BRAND_TYPE  
  , DBO.FN_GET_TOUR_NIGHY_DAY_TEXT(A.MASTER_CODE,0) AS TOUR_NIGHT_DAY  
  , (SELECT SUM(GRADE) / COUNT(GRADE) FROM PRO_COMMENT WITH(NOLOCK) WHERE MASTER_CODE = A.MASTER_CODE) AS [GRADE]  
  , (SELECT COUNT(*) FROM HBS_DETAIL WITH(NOLOCK) WHERE MASTER_SEQ = ''1'' AND MASTER_CODE = A.MASTER_CODE) AS [TRAVEL]  
  , B.FILE_CODE, B.REGION_CODE, B.NATION_CODE, B.STATE_CODE, B.CITY_CODE, B.KOR_NAME, B.ENG_NAME, B.FILE_TYPE, B.[FILE_NAME], B.EXTENSION_NAME, B.FILE_SIZE, B.FILE_NAME_S, B.FILE_NAME_M, B.FILE_NAME_L, B.FILE_REMARK, B.FILE_TAG, B.RESOLUTION, B.COPYRIGHT,
 B.COPYRIGHT_REMARK, B.SHOW_YN, B.NEW_CODE, B.NEW_NAME, ISNULL(B.NEW_DATE, CONVERT(DATETIME, ''1900-01-01'')) AS NEW_DATE, B.EDT_CODE, B.EDT_NAME, ISNULL(B.EDT_DATE, CONVERT(DATETIME, ''1900-01-01'')) AS EDT_DATE  
  , (SELECT KOR_NAME FROM PUB_REGION WITH(NOLOCK) WHERE REGION_CODE =B.REGION_CODE) AS REGION_NAME  
  --, C.TWO_COUNT, C.THREE_COUNT, C.FOUR_COUNT, C.FIVE_COUNT, C.TWO_PERCENT, C.THREE_PERCENT, C.FOUR_PERCENT, C.FIVE_PERCENT  
  
  -- 2019-12-03 추가  
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''W'') AS MASTER_W  
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''T'') AS MASTER_T  
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''D'') AS MASTER_D  
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''P'') AS MASTER_P  
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''A'') AS MASTER_A  
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''G'') AS MASTER_G  
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''S'') AS MASTER_S  
  , DBO.FN_GET_MASTER_TRANS_SELECT(Z.MASTER_CODE) AS MASTER_TRANS  
  , DBO.FN_GET_MASTER_COMMENT_SELECT(Z.MASTER_CODE) AS MASTER_BO  
  
  , A.TOUR_JOURNEY  
  , A.KEYWORD  
  , A.THEME_ORDER  
  , Z.STAR_POINT  
  , Z.TOTAL_COUNT  
  , Z.STAR_COUNT AS COMMENT_POINT  
  , DBO.FN_GET_PACKAGE(A.MASTER_CODE) AS PRO_CODE  
  -- 2019-12-03 추가  
  
 FROM LIST Z    
 INNER JOIN PKG_MASTER A WITH(NOLOCK) ON Z.MASTER_CODE = A.MASTER_CODE    
 LEFT OUTER JOIN INF_FILE_MASTER B WITH(NOLOCK) ON A.MAIN_FILE_CODE = B.FILE_CODE    
 --LEFT OUTER JOIN STS_PKG_RES_COUNT C WITH(NOLOCK) ON Z.MASTER_CODE = C.MASTER_CODE  
 ORDER BY ' + @SORT_STRING + ', A.MASTER_CODE;'  
	
	
	SET @PARMDEFINITION = N'  
  @PAGE_INDEX INT,  
  @PAGE_SIZE INT,  
  @TOTAL_COUNT INT OUTPUT,  
  @PROVIDER VARCHAR(3),  
  @BRAND_TYPE VARCHAR(1),  
  @MIN_PRICE VARCHAR(10),  
  @MAX_PRICE VARCHAR(10),  
  @DEP_DATE VARCHAR(10),  
  @DAY VARCHAR(5),  
  @BRANCH_CODE VARCHAR(1),  
  @KEYWORD NVARCHAR(1000),  
  @MAIN_ATT_CODE VARCHAR(10)'; 
	
	--PRINT SUBSTRING(@SQLSTRING, 1, 4000)
	--PRINT SUBSTRING(@SQLSTRING, 4001, 4000)
	--PRINT LEN(@SQLSTRING)  
	--PRINT @SQLSTRING
	
	EXEC SP_EXECUTESQL @SQLSTRING
	    ,@PARMDEFINITION
	    ,@PAGE_INDEX
	    ,@PAGE_SIZE
	    ,@TOTAL_COUNT OUTPUT
	    ,@PROVIDER
	    ,@BRAND_TYPE
	    ,@MIN_PRICE
	    ,@MAX_PRICE
	    ,@DEP_DATE
	    ,@DAY
	    ,@BRANCH_CODE
	    ,@KEYWORD
	    ,@MAIN_ATT_CODE;
END
GO
