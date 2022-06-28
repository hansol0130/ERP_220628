USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================                  
■ USP_NAME     : SP_SLIME_WEB_PKG_MASTER_COUNT_SELECT                   
■ DESCRIPTION    : 함수_마스터_상품리스트_검색수                  
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
   2017-08-26  ibsolution  SP_SLIME_WEB_PKG_MASTER_SELECT 에서 전체 갯수만 구함                  
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
CREATE PROCEDURE [dbo].[SP_SLIME_WEB_PKG_MASTER_COUNT_SELECT]                  
(                  
 @TOTAL_COUNT INT OUTPUT,                  
 @KEY  NVARCHAR(MAX)                  
)                  
                  
AS                    
BEGIN                  
                  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                  
                   
 DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);                  
 DECLARE @INNER_TABLE NVARCHAR(1000), @WHERE NVARCHAR(4000), @SORT_STRING VARCHAR(50);                  
 DECLARE @PUSAN_TEAM_CODE VARCHAR(100), @TEMP NVARCHAR(1000)                  
              
 DECLARE @PROVIDER VARCHAR(3), @BRAND_TYPE VARCHAR(1), @REGION_CODE VARCHAR(50), @CITY_CODE VARCHAR(50), @NATION_CODE VARCHAR(50), @ATT_CODE VARCHAR(50), @GROUP_CODE nVARCHAR(max)                  
 DECLARE @MIN_PRICE VARCHAR(10), @MAX_PRICE VARCHAR(10), @DEP_DATE VARCHAR(10), @BRANCH_CODE VARCHAR(1), @KEYWORD NVARCHAR(1000), @MAIN_ATT_CODE VARCHAR(10)              
 DECLARE @CFM_YN CHAR(1), @BRANCH_CODES VARCHAR(9), @TYPE VARCHAR(5), @AIRLINE_TYPE VARCHAR(7), @HOTEL_GRADE VARCHAR(50), @RESEARCH_KEYWORD NVARCHAR(1000), @PRICE VARCHAR(10), @DAY VARCHAR(10)            
              
                  
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
  @BRANCH_CODE = DBO.FN_PARAM(@KEY, 'BranchCode'),                  
  @KEYWORD = DBO.FN_PARAM(@KEY, 'Keyword'),                  
                
  -- 2019 리뉴얼 추가 시작                
  @CFM_YN = DBO.FN_PARAM(@KEY, 'CfmYN'),     -- 출발일 확정 여부                           
  @BRANCH_CODES = DBO.FN_PARAM(@KEY, 'BranchCodes'),  -- 출발지                    
  @TYPE = DBO.FN_PARAM(@KEY, 'Type'),      -- 속성(패키지,라르고,자유여행)              
  @AIRLINE_TYPE = DBO.FN_PARAM(@KEY, 'AirlineType'),  -- 선호항공사              
  @HOTEL_GRADE = DBO.FN_PARAM(@KEY, 'HotelGrade'),          -- 호텔등급              
  @RESEARCH_KEYWORD = DBO.FN_PARAM(@KEY, 'ResearchKeyword'),-- 재검색 키워드              
  @PRICE = DBO.FN_PARAM(@KEY, 'Price'),-- 금액            
  @DAY = DBO.FN_PARAM(@KEY, 'Day'),                  
  -- 2019 리뉴얼 추가 끝                
                
  @WHERE = ''                  
 SELECT @WHERE = DBO.FN_SLIME_WEB_PKG_MASTER_SELECT_WHERE(@KEY);            
 
                  
 SET @SQLSTRING = N'                  
 -- 전체 마스터 수                  
 SELECT  ISNULL([0] ,0) AS  [ICN],           
 ISNULL([1] ,0) AS  [PUS],          
 ISNULL([2] ,0) AS  [TAE],          
 ISNULL([3] ,0) AS  [CJJ],          
 ISNULL([4] ,0) AS  [KWJ],          
 ISNULL([99],0)  AS [ETC],          
 (ISNULL([0]  ,0) +           
  ISNULL([1]  ,0) +           
  ISNULL([2]  ,0) +           
  ISNULL([3]  ,0) +           
  ISNULL([4]  ,0) +           
  ISNULL([99],0)) AS [TOTAL_COUNT]          
FROM (          
 SELECT           
 BRANCH_CODE, COUNT(*) AS [COUNT]          
 FROM PKG_MASTER A WITH(NOLOCK)                  
 '                  
 IF @PROVIDER NOT IN('0','5','16','18','25')                  
  SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = CONVERT(INT, @PROVIDER) AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''                  
 '                  
                  
 SET @SQLSTRING = @SQLSTRING + @WHERE;                  
 SET @SQLSTRING = @SQLSTRING + N' GROUP BY BRANCH_CODE          
) AS RAW_DATA          
PIVOT          
(          
 SUM([COUNT])          
 FOR BRANCH_CODE IN ([0],[1],[2],[3],[4],[99])          
) AS PIVOT_DATA          
'          
                  
 SET @PARMDEFINITION = N'                  
  @TOTAL_COUNT INT OUTPUT,                  
  @PROVIDER VARCHAR(3),                  
  @BRAND_TYPE VARCHAR(1),                  
  @MIN_PRICE VARCHAR(10),                  
  @MAX_PRICE VARCHAR(10),                  
  @DEP_DATE VARCHAR(10),                  
  @DAY VARCHAR(10),                  
  @BRANCH_CODE VARCHAR(1),                  
  @KEYWORD NVARCHAR(1000),                  
  @MAIN_ATT_CODE VARCHAR(10)';                  
                  
 --PRINT @SQLSTRING                  
                    
 EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,                  
  @TOTAL_COUNT OUTPUT,                  
  @PROVIDER,                  
  @BRAND_TYPE,                  
  @MIN_PRICE,                  
  @MAX_PRICE,                  
  @DEP_DATE,                  
  @DAY,                  
  @BRANCH_CODE,                  
  @KEYWORD,                  
  @MAIN_ATT_CODE      
                  
END 
GO
