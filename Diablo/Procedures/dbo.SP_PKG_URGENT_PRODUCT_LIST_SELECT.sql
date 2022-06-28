USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================    
■ USP_NAME				: SP_PKG_URGENT_PRODUCT_LIST_SELECT    
■ DESCRIPTION			: 긴급모객 상품 검색    
■ INPUT PARAMETER		:     
	 @PAGE_INDEX INT	: 현재 페이지    
	 @PAGE_SIZE  INT	: 한 페이지 표시 게시물 수    
	 @KEY  VARCHAR(400)	: 검색 키    
	 @ORDER_BY INT		: 정렬 순서    
■ OUTPUT PARAMETER		:     
■ EXEC					:
declare @p5 int    
set @p5=NULL    
exec SP_PKG_URGENT_PRODUCT_LIST_SELECT @PAGE_INDEX=1,@PAGE_SIZE=10,@KEY=N'SiteCode=VGT&SignCode=&EmpCode=2015006&TeamCode=529&SearchType=ProCode&SearchValue=&Condition=E',@ORDER_BY=1,@TOTAL_COUNT=@p5 output    
select @p5    
■ MEMO      :     
------------------------------------------------------------------------------------------------------------------    
■ CHANGE HISTORY                       
------------------------------------------------------------------------------------------------------------------    
	DATE		AUTHOR		DESCRIPTION               
------------------------------------------------------------------------------------------------------------------    
	2018-04-18	정지용		최초생성    
	2019-12-23	임검제		SITE_CODE 공백일시 전체 조회로 수정   
================================================================================================================*/     
CREATE PROCEDURE [dbo].[SP_PKG_URGENT_PRODUCT_LIST_SELECT]    
(    
	@PAGE_INDEX  INT,    
	@PAGE_SIZE  INT,    
	@TOTAL_COUNT INT OUTPUT,    
	@KEY  VARCHAR(500),    
	@ORDER_BY INT    
)    
AS      
BEGIN    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
 DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(4000), @SORT_STRING VARCHAR(50);     
 DECLARE @SITE_CODE VARCHAR(3), @SIGN_CODE VARCHAR(30);    
 DECLARE @SEARCH_TYPE VARCHAR(10), @SEARCH_VALUE VARCHAR(100), @TEAM_CODE VARCHAR(3), @EMP_CODE VARCHAR(7), @CONDITION VARCHAR(1);    
      
 SELECT    
	@SITE_CODE = DBO.FN_PARAM(@KEY, 'SiteCode'),    
	@SIGN_CODE = DBO.FN_PARAM(@KEY, 'SignCode'),    
	@SEARCH_TYPE = DBO.FN_PARAM(@KEY, 'SearchType'),    
	@SEARCH_VALUE = DBO.FN_PARAM(@KEY, 'SearchValue'),    
	@TEAM_CODE = DBO.FN_PARAM(@KEY, 'TeamCode'),    
	@EMP_CODE = DBO.FN_PARAM(@KEY, 'EmpCode'),    
	@CONDITION = DBO.FN_PARAM(@KEY, 'Condition'),    
	@WHERE = 'WHERE (ISNULL(@SITE_CODE,'''') = '''' OR A.SITE_CODE = @SITE_CODE) AND A.SHOW_YN = ''Y''';    
    
 --IF @SITE_CODE = ''    
 --BEGIN     
 -- SET @SITE_CODE = 'VGT';    
 --END

   IF ISNULL(@SIGN_CODE, '') <> ''
   BEGIN
       SET @WHERE = @WHERE + ' AND CHARINDEX(@SIGN_CODE, A.REGION_CODE) > 0'
   END
   
   IF ISNULL(@CONDITION, '') = 'W'
   BEGIN
       -- 출발일이 최소 1일 최대 7일 까지만 보여지도록
       SET @WHERE = @WHERE + ' AND B.DEP_DATE >= CONVERT(VARCHAR(10), DATEADD(DAY, 2, GETDATE()), 121) AND B.DEP_DATE <= CONVERT(VARCHAR(10), DATEADD(DAY, 7, GETDATE()), 121)'
   END    
   ELSE
   BEGIN 
       SET @WHERE = @WHERE + ' AND B.DEP_DATE >= CONVERT(VARCHAR(10), GETDATE(), 121)'
   END

   IF ISNULL(@EMP_CODE, '') <> 'all' AND ISNULL(@EMP_CODE, '') <> ''
   BEGIN
       SET @WHERE = @WHERE + ' AND A.NEW_CODE = @EMP_CODE';
   END
   ELSE 
   BEGIN
       IF ISNULL(@TEAM_CODE, '') <> 'all' AND ISNULL(@TEAM_CODE, '') <> ''
       BEGIN
           SET @WHERE = @WHERE + ' AND A.NEW_CODE IN ( SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE = @TEAM_CODE )';
       END
   END

   IF ISNULL(@SEARCH_VALUE, '') <> ''
   BEGIN
       IF ISNULL(@SEARCH_TYPE, '') = 'ProCode'
       BEGIN
           SET @WHERE = @WHERE + ' AND A.PRO_CODE LIKE @SEARCH_VALUE + ''%''';
       END
       ELSE IF ISNULL(@SEARCH_TYPE, '') = 'ProName'
       BEGIN
           SET @WHERE = @WHERE + ' AND A.PRO_NAME LIKE ''%'' + @SEARCH_VALUE + ''%''';
       END
   END 

   -- SORT 조건 만들기  
   SELECT @SORT_STRING = (
       CASE @ORDER_BY  
           WHEN 1 THEN 'A.NEW_DATE DESC'
           WHEN 2 THEN 'F.DEP_DEP_DATE ASC, F.DEP_DEP_TIME ASC'
           ELSE 'A.NEW_DATE DESC'
       END
   )

   SET @SQLSTRING = N'
   -- 전체 마스터 수
   SELECT @TOTAL_COUNT = COUNT(*)
   FROM PKG_URGENT_MASTER A WITH(NOLOCK)
   LEFT JOIN PKG_DETAIL B WITH(NOLOCK) ON B.PRO_CODE = A.PRO_CODE
   LEFT JOIN PRO_TRANS_SEAT F WITH(NOLOCK) ON B.SEAT_CODE = F.SEAT_CODE
   ' + @WHERE + N';

   WITH LIST AS
   (
       SELECT SITE_CODE, U_SEQ
           , CASE WHEN ISNULL(DEP_DEP_DATE, '''') = '''' THEN B.DEP_DATE ELSE F.DEP_DEP_DATE END AS DEP_DEP_DATE
           , CASE WHEN ISNULL(DEP_DEP_TIME, '''') = '''' THEN '''' ELSE F.DEP_DEP_TIME END AS DEP_DEP_TIME
           , (SELECT TOP 1 PRICE_SEQ FROM PKG_DETAIL_PRICE AA WITH(NOLOCK) WHERE AA.PRO_CODE = A.PRO_CODE ORDER BY ADT_PRICE) AS [PRICE_SEQ]
           , (SELECT TOP 1 FILE_CODE FROM PKG_DETAIL_FILE WITH(NOLOCK) WHERE PRO_CODE = A.PRO_CODE ORDER BY SHOW_ORDER) AS [FILE_CODE]
       FROM PKG_URGENT_MASTER A WITH(NOLOCK)
       LEFT JOIN PKG_DETAIL B WITH(NOLOCK) ON B.PRO_CODE = A.PRO_CODE
       LEFT JOIN PRO_TRANS_SEAT F WITH(NOLOCK) ON B.SEAT_CODE = F.SEAT_CODE
       ' + @WHERE + N'
       ORDER BY ' + @SORT_STRING + '
       OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
       ROWS ONLY
   )    
   SELECT A.SITE_CODE, A.U_SEQ, A.PRO_CODE, A.PRO_NAME, A.SEAT_CNT, A.REGION_CODE AS SIGN_CODE, DBO.XN_PRO_DETAIL_SALE_PRICE_CUTTING(B.PRO_CODE, B.PRICE_SEQ) AS [ADT_PRICE], DEP_DEP_DATE, DEP_DEP_TIME, D.PUB_VALUE AS REGION_NAME, C.*
   FROM LIST Z
   INNER JOIN PKG_URGENT_MASTER A WITH(NOLOCK) ON A.SITE_CODE = Z.SITE_CODE AND A.U_SEQ = Z.U_SEQ
   LEFT JOIN PKG_DETAIL_PRICE B WITH(NOLOCK) ON B.PRO_CODE = A.PRO_CODE AND B.PRICE_SEQ = Z.PRICE_SEQ
   LEFT JOIN INF_FILE_MASTER C WITH(NOLOCK) ON C.FILE_CODE = Z.FILE_CODE
   LEFT JOIN COD_PUBLIC D WITH(NOLOCK) ON A.REGION_CODE = D.PUB_CODE AND PUB_TYPE = ''EVENT.REGION'''
   

   SET @PARMDEFINITION = N'
       @PAGE_INDEX INT,
       @PAGE_SIZE INT,
       @TOTAL_COUNT INT OUTPUT,
       @SITE_CODE VARCHAR(3),
       @SIGN_CODE VARCHAR(30),
       @SEARCH_TYPE VARCHAR(10),
       @SEARCH_VALUE VARCHAR(100),
       @TEAM_CODE VARCHAR(3),
       @EMP_CODE VARCHAR(7),
       @CONDITION VARCHAR(1)';

   --PRINT @SQLSTRING
       
   EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
       @PAGE_INDEX,
       @PAGE_SIZE,
       @TOTAL_COUNT OUTPUT,
       @SITE_CODE,
       @SIGN_CODE,
       @SEARCH_TYPE,
       @SEARCH_VALUE,
       @TEAM_CODE,
       @EMP_CODE,
       @CONDITION

END    
GO
