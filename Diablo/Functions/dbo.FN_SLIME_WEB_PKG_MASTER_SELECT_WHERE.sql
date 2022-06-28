USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================          
■ FN_NAME			: [FN_SLIME_WEB_PKG_MASTER_SELECT_WHERE]          
■ DESCRIPTION		: LIST 조회시 WHERE 절을 통합관리하기 위한 함수          
■ INPUT PARAMETER	: 
■ EXEC				:           
    
    -- SELECT DBO.FN_SLIME_WEB_PKG_MASTER_SELECT_WHERE('');
          
■ MEMO				:           
------------------------------------------------------------------------------------------------------------------          
■ CHANGE HISTORY                             
------------------------------------------------------------------------------------------------------------------          
   DATE			AUTHOR			DESCRIPTION                     
------------------------------------------------------------------------------------------------------------------          
   2020-01-09	임검제			최초생성
   2020-02-10	임검제			기준 사용처 SP_SLIME_WEB_PKG_MASTER_SELECT, SP_SLIME_WEB_PKG_MASTER_COUNT_SELECT ,SP_SLIME_WEB_PKG_MASTER_FILTER_SELECT )
   2020-03-03	임검제			KEYWORD 조회 로직 수정
   2020-05-06	김성호			KEYWORD 조회 시 지역 예외처리 추가 (제주,울릉도 등)
   2020-05-19	홍종우			맞춤검색 조회건수 누락 수정
   2021-08-31	홍종우			참좋은마켓 검색 제외처리(att_code <> '1')
================================================================================================================*/    
CREATE FUNCTION [dbo].[FN_SLIME_WEB_PKG_MASTER_SELECT_WHERE]
(
	@KEY NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
                            
BEGIN
	DECLARE @PARMDEFINITION NVARCHAR(1000);                                        
	DECLARE @INNER_TABLE     NVARCHAR(1000)
	       ,@WHERE           NVARCHAR(MAX)
	       ,@SORT_STRING     VARCHAR(50);                                        
	DECLARE @PUSAN_TEAM_CODE     VARCHAR(100)
	       ,@TEMP                NVARCHAR(2000);                                        
	
	DECLARE @PROVIDER        VARCHAR(3)
	       ,@BRAND_TYPE      VARCHAR(1)
	       ,@REGION_CODE     VARCHAR(50)
	       ,@CITY_CODE       VARCHAR(50)
	       ,@NATION_CODE     VARCHAR(50)
	       ,@ATT_CODE        VARCHAR(50)
	       ,@GROUP_CODE      NVARCHAR(MAX);                                        
	DECLARE @MIN_PRICE         VARCHAR(10)
	       ,@MAX_PRICE         VARCHAR(10)
	       ,@DEP_DATE          VARCHAR(10)
	       ,@BRANCH_CODE       VARCHAR(1)
	       ,@KEYWORD           NVARCHAR(2000)
	       ,@MAIN_ATT_CODE     VARCHAR(10)
	       ,@WEEKDAY           VARCHAR(50)
	       ,@AIRLINE_TYPE      VARCHAR(50)
	       ,@HOTEL_GRADE       VARCHAR(50)
	       ,@PRICE             VARCHAR(50);                                        
	DECLARE @MIN_DAY              VARCHAR(5)
	       ,@MAX_DAY              VARCHAR(5)
	       ,@CFM_YN               CHAR(1)
	       ,@BRANCH_CODES         VARCHAR(50)
	       ,@TYPE                 VARCHAR(50)
	       ,@RESEARCH_KEYWORD     VARCHAR(2000)
	       ,@DAY                  VARCHAR(20); 
	
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
	      ,@WEEKDAY = DBO.FN_PARAM(@KEY ,'Weekday')
	      ,@MIN_DAY = DBO.FN_PARAM(@KEY ,'MinDay')
	      ,@MAX_DAY = DBO.FN_PARAM(@KEY ,'MaxDay')
	      ,@CFM_YN = DBO.FN_PARAM(@KEY ,'CfmYN')
	      ,-- 20191128 리뉴얼 선호항공, 호텔등급, 가격범위, 출발지역 조회조건 추가                                                      
	       @AIRLINE_TYPE = DBO.FN_PARAM(@KEY ,'AirlineType')
	      ,@HOTEL_GRADE = DBO.FN_PARAM(@KEY ,'HotelGrade')
	      ,@PRICE = DBO.FN_PARAM(@KEY ,'PRICE')
	      ,@BRANCH_CODES = DBO.FN_PARAM(@KEY ,'BranchCodes')
	      ,@TYPE = DBO.FN_PARAM(@KEY ,'Type')
	      ,@RESEARCH_KEYWORD = dbo.FN_PARAM(@KEY ,'ResearchKeyword')
	      ,@WHERE = N'WHERE SHOW_YN = ''Y''' 
	
	-- IF (ISNULL(@RESEARCH_KEYWORD,'') <> '')
	--BEGIN
	-- IF (ISNULL(@KEYWORD,'') <> '')
	-- BEGIN
	--  SET @KEYWORD = @KEYWORD + ' ' + @RESEARCH_KEYWORD
	-- END
	-- ELSE
	-- BEGIN
	--  SET @KEYWORD =  @RESEARCH_KEYWORD
	-- END
	--END                                        
	
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
	    ELSE IF LEN(@KEYWORD) > 0 AND PATINDEX('%' + @KEYWORD + '%', '제주,제주도,울릉도,국내') > 0
		BEGIN
			SET @WHERE = @WHERE + ' AND A.SIGN_CODE = ''K'''
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
	    --SET @WHERE = @WHERE + ' AND A.HIGH_PRICE >= CONVERT(BIGINT, @MIN_PRICE)'                               
	    SET @WHERE = @WHERE + ' AND A.LOW_PRICE >= CONVERT(BIGINT, @MIN_PRICE)'
	END                                        
	
	IF ISNULL(@MAX_PRICE ,'') <> ''
	BEGIN
	    SET @WHERE = @WHERE + ' AND A.LOW_PRICE <= CONVERT(BIGINT, @MAX_PRICE)'
	END                                        
	
	IF (ISNULL(@DEP_DATE ,'') <> '')
	   OR (ISNULL(@CFM_YN ,'') = 'Y')
	BEGIN
	    SET @TEMP = ''                                        
	    IF (ISNULL(@DEP_DATE ,'') <> '')
	        SET @TEMP = ' AND AA.DEP_DATE = CONVERT(DATETIME, @DEP_DATE)'
	    ELSE
	        SET @TEMP = ' AND AA.DEP_DATE >= GETDATE()'                                        
	    
	    IF ISNULL(@CFM_YN ,'') = 'Y'
	    BEGIN
	        SET @TEMP = @TEMP + ' AND AA.DEP_CFM_YN IN (''Y'',''F'') '
	    END
	    
	    SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_DETAIL AA WITH(NOLOCK) WHERE A.MASTER_CODE = AA.MASTER_CODE AND SHOW_YN = ''Y'' ' + @TEMP + ')'
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
	           + REPLACE(@TEMP ,'" AND "' ,'" OR "') + ''') OR A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = ''' + REPLACE(@TEMP ,'" AND "' ,'" OR "') + '''))'                                        
	    
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
	    
	    IF @BRAND_TYPE = '2'
	    BEGIN
	        SET @WHERE = @WHERE + ' AND A.BRAND_TYPE = @BRAND_TYPE'
	    END
	    ELSE
	    BEGIN
	        SET @WHERE = @WHERE + ' AND A.BRAND_TYPE IS NOT NULL'
	    END
	END 
	
	-- 2019 리뉴얼 조건 추가 시작 --                              
	
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
	    SET @WHERE = @WHERE + ' AND (      
        A.MASTER_CODE IN (' + @TEMP + ')'                
	    
	    
	    
	    IF CHARINDEX('3' ,@HOTEL_GRADE) > 0
	    BEGIN
	        SET @WHERE = @WHERE + ' OR ISNULL(A.HOTEL_GRADE,''000'') = ''000'' '
	    END      
	    
	    SET @WHERE = @WHERE + ')'
	END 
	
	-- 금액                            
	IF ISNULL(@PRICE ,'') <> ''
	BEGIN
	    SET @TEMP = 'SELECT A.MASTER_CODE FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE A.SEARCH_TYPE = ''P'' AND A.SEARCH_VALUE IN (' + @PRICE + ')';                                
	    SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (' + @TEMP + ')'
	END 
	
	-- 여행기간                            
	IF ISNULL(@DAY ,'') <> ''
	BEGIN
	    SET @TEMP = 'SELECT A.MASTER_CODE FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE A.SEARCH_TYPE = ''D'' AND A.SEARCH_VALUE IN (' + @DAY + ')';                                
	    SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (' + @TEMP + ')'
	END 
	
	
	-- 출발요일                            
	IF ISNULL(@WEEKDAY ,'') <> ''
	BEGIN
	    SET @TEMP = 'SELECT A.MASTER_CODE FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE A.SEARCH_TYPE = ''W'' AND A.SEARCH_VALUE IN (' + @WEEKDAY + ')';                                
	    SET @WHERE = @WHERE + ' AND A.MASTER_CODE IN (' + @TEMP + ')'
	END 
	
	-- 재검색 키워드                              
	IF ISNULL(@RESEARCH_KEYWORD ,'') <> ''
	BEGIN
	    SELECT @TEMP = STUFF(
	               (
	                   SELECT (' AND "' + DATA + '"') AS [text()]
	                   FROM   [DBO].[FN_SPLIT](@RESEARCH_KEYWORD ,' ')
	                   WHERE  DATA <> '' FOR XML PATH('')
	               )
	              ,1
	              ,5
	              ,''
	           )
	    
	    SELECT @KEYWORD = ' AND (CONTAINS(A.MASTER_NAME, ''' + @TEMP + ''') OR CONTAINS(A.KEYWORD, ''' + @TEMP + ''') OR CONTAINS(A.PKG_COMMENT, ''' + @TEMP + ''') OR CONTAINS(A.MASTER_CODE, ''' 
	           + REPLACE(@TEMP ,'" AND "' ,'" OR "') + ''') OR A.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = ''' + REPLACE(@TEMP ,'" AND "' ,'" OR "') + '''))'                                  
	    
	    SET @WHERE = @WHERE + @KEYWORD
	END 
	
	-- 2019 리뉴얼 조건 추가 끝 --                             
	
	-- 20210831 참좋은마켓 검색리스트 제외처리
	SET @WHERE = @WHERE + ' AND A.ATT_CODE <> ''1'''
	
	
	RETURN @WHERE
END 
GO
