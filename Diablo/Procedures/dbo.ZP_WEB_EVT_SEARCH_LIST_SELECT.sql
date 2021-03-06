USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------        
■ Server     :         
■ Database     : DIABLO        
■ USP_Name     : ZP_WEB_EVT_SEARCH_LIST_SELECT        
■ Description    : 기획전/이벤트 리스트 검색        
■ Input Parameter   :         
          
■ Output Parameter   :                          
■ Output Value    :                         
■ Exec      :         
        
 declare @total int        
 exec [dbo].[ZP_WEB_EVT_SEARCH_LIST_SELECT] 1, 20, @total output, 'PlanType=A&IsEvent=N&AttrCode=T&EventName=', 0        
        
declare @p5 int        
set @p5=0        
exec ZP_WEB_EVT_SEARCH_LIST_SELECT @PAGE_INDEX=1,@PAGE_SIZE=12,@KEY=N'PlanType=M&IsEvent=Y&IsClose=',@ORDER_BY=0,@TOTAL_COUNT=@p5 output        
select @p5        
        
---------------------------------------------------------------------------------------------------        
■ Change History                           
---------------------------------------------------------------------------------------------------        
 Date   Author   Description                   
---------------------------------------------------------------------------------------------------        
 2013-05-27  차지훈   최초생성        
 2013-06-10  김성호   WITH(NOLOCK) 추가        
 2017-05-29  정지용   대구 출발 조건 추가        
 2018-02-21  정지용   SORT 추가 ( 기획전 롱배너에서 사용 )        
 2018-07-31  정지용   청추출발 추가        
 2018-11-29  박형만   이벤트 지역추가 (PLANTYPE=E)         
 2019-12-18  임검제 리뉴얼 정렬 조건 추가 시작      
 2020-01-30  임검제 마스터 코드 검색조건 추가
 2020-03-10  지니웍스 임검제 기획전 목록 마스터 코드 조회 시 마스터 상의 SHOW YN 참조 
-------------------------------------------------------------------------------------------------*/         
CREATE PROCEDURE [dbo].[ZP_WEB_EVT_SEARCH_LIST_SELECT] 
(@PAGE_INDEX INT ,@PAGE_SIZE INT ,@TOTAL_COUNT INT OUTPUT ,@KEY VARCHAR(200) ,@ORDER_BY INT)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED         
	
	DECLARE @SQLSTRING          NVARCHAR(4000)
	       ,@WHERE              NVARCHAR(4000)
	       ,@PARMDEFINITION     NVARCHAR(1000)
	       ,@SORT_STRING        VARCHAR(100);        
	
	DECLARE @PLAN_TYPE CHAR(1)        
	DECLARE @SIGN_CODE CHAR(1)        
	DECLARE @ATT_CODE VARCHAR(2)        
	DECLARE @PRO_CODE VARCHAR(20)        
	DECLARE @EVT_NAME VARCHAR(100)        
	DECLARE @EVT_YN CHAR(1)        
	DECLARE @CLOSE_YN CHAR(1)        
	DECLARE @BEST_YN CHAR(1)        
	DECLARE @KEYWORD VARCHAR(100)        
	
	SELECT @PLAN_TYPE = DBO.FN_PARAM(@KEY ,'PlanType')
	      ,@SIGN_CODE = DBO.FN_PARAM(@KEY ,'SignCode')
	      ,@ATT_CODE = DBO.FN_PARAM(@KEY ,'AttrCode')
	      ,@PRO_CODE = DBO.FN_PARAM(@KEY ,'ProductCode')
	      ,@EVT_NAME = DBO.FN_PARAM(@KEY ,'EventName')
	      ,@EVT_YN = DBO.FN_PARAM(@KEY ,'IsEvent')
	      ,@CLOSE_YN = DBO.FN_PARAM(@KEY ,'IsClose')
	      ,@BEST_YN = DBO.FN_PARAM(@KEY ,'IsBest')
	      ,@KEYWORD = DBO.FN_PARAM(@KEY ,'Keyword')        
	
	SET @WHERE = ' AND A.SHOW_YN = ''Y'' '        
	
	IF @CLOSE_YN = 'Y'
	    SET @WHERE = @WHERE + ' AND (CONVERT(VARCHAR(10), GETDATE(), 120) > CONVERT(VARCHAR(10), A.END_DATE, 120)) '
	ELSE
	    SET @WHERE = @WHERE + ' AND (A.END_DATE IS NULL OR CONVERT(VARCHAR(10), GETDATE(), 120) <= CONVERT(VARCHAR(10), A.END_DATE, 120) ) ' 
	
	-- 기획전 지역은 R , 이벤트 지역은 E         
	IF ISNULL(@PLAN_TYPE ,'R') = 'R'
	   OR ISNULL(@PLAN_TYPE ,'E') = 'E'
	BEGIN
	    SET @WHERE = @WHERE + ' AND (A.SIGN_CODE IS NOT NULL OR A.SIGN_CODE <> '''') '
	END         
	
	
	IF @PLAN_TYPE = 'B'
	    SET @WHERE = @WHERE + ' AND A.DEP_AIRLINE_CODE = ''PUS'' '
	ELSE 
	IF @PLAN_TYPE = 'D'
	    SET @WHERE = @WHERE + ' AND A.DEP_AIRLINE_CODE = ''TAE'' '
	ELSE 
	IF @PLAN_TYPE = 'C'
	    SET @WHERE = @WHERE + ' AND A.DEP_AIRLINE_CODE = ''CJJ'' '
	ELSE 
	IF @PLAN_TYPE = 'M'
	    SET @WHERE = @WHERE + ' AND A.DEP_AIRLINE_CODE = ''MWX'' '
	ELSE
	    SET @WHERE = @WHERE + ' AND (A.DEP_AIRLINE_CODE = ''ICN''  OR A.DEP_AIRLINE_CODE IS NULL ) ' 
	/*        
	IF @PLAN_TYPE = 'B'        
	SET @WHERE = @WHERE + ' AND DEP_AIRLINE_CODE = ''PUS'' '        
	ELSE        
	SET @WHERE = @WHERE + ' AND DEP_AIRLINE_CODE <> ''PUS'' '        
	*/        
	
	IF ISNULL(@SIGN_CODE ,'') <> ''
	    SET @WHERE = @WHERE + ' AND A.SIGN_CODE LIKE ''%'' + @SIGN_CODE + ''%'' '        
	
	IF ISNULL(@ATT_CODE ,'') <> ''
	    SET @WHERE = @WHERE + ' AND A.ATT_CODE LIKE ''%'' + @ATT_CODE + ''%'' '        
	
	IF ISNULL(@PRO_CODE ,'') <> ''
	    SET @WHERE = @WHERE + ' AND A.PRO_CODE = @PRO_CODE '        
	
	IF ISNULL(@EVT_NAME ,'') <> ''
	    SET @WHERE = @WHERE + ' AND A.EVT_NAME LIKE ''%'' + @EVT_NAME + ''%'' '        
	
	IF ISNULL(@EVT_YN ,'') <> ''
	    SET @WHERE = @WHERE + ' AND A.EVT_YN = ''' + @EVT_YN + ''''          
	
	IF ISNULL(@BEST_YN ,'') <> ''
	    SET @WHERE = @WHERE + ' AND A.BEST_YN = ''' + @BEST_YN + ''''
	ELSE
	    SET @WHERE = @WHERE + ' AND A.BEST_YN = ''N'' ' 
	
	
	-- 2019 리뉴얼 상품코드 + 이벤트명 조회조건 추가    
	IF ISNULL(@KEYWORD ,'') <> ''
	BEGIN
	    SET @WHERE = @WHERE + ' AND (A.EVT_NAME LIKE ''%'' + @KEYWORD + ''%'' OR EVT_SEQ IN (SELECT EVT_SEQ FROM PUB_EVENT_DATA WHERE MASTER_CODE = @KEYWORD))'
	END 
	
	
	-- SORT 조건 만들기          
	SELECT @SORT_STRING = (
	           CASE @ORDER_BY
	                WHEN 0 THEN ' A.BEST_YN DESC, A.NEW_DATE DESC'
	                WHEN 1 THEN ' A.BEST_YN DESC, A.SHOW_ORDER ASC' 
	                     -- 1910 리뉴얼 정렬 조건 추가 시작
	                WHEN 2 THEN 'A.BEST_YN DESC,A.NEW_DATE DESC  ' -- 최근등록일순
	                WHEN 3 THEN 'A.BEST_YN DESC,A.START_DATE DESC' -- 이벤트 시작 최신순
	                WHEN 4 THEN 'A.BEST_YN DESC,A.END_DATE DESC  ' -- 이벤트 종료 최신순
	                                                               -- 1910 리뉴얼 정렬 조건 추가 끝
	                ELSE ' A.BEST_YN DESC, A.NEW_DATE DESC'
	           END
	       )        
	
	SET @SQLSTRING = N'        
SELECT @TOTAL_COUNT = COUNT(*)        
FROM PUB_EVENT A WITH(NOLOCK)        
WHERE 1 = 1 ' + @WHERE + 
	    ';        
        
WITH LIST AS         
(        
 SELECT        
  A.EVT_SEQ,A.PRO_CODE,A.SIGN_CODE,A.ATT_CODE,A.EVT_NAME,A.EVT_SHORT_REMARK,        
  A.EVT_URL,A.BANNER_URL,A.SHOW_ORDER,A.EVT_YN,A.BEST_YN,A.SHOW_YN,A.COMMENT_YN,        
  A.START_DATE,A.END_DATE,A.DEV_YN,A.DEV_SHOW_TYPE,A.PROVIDER,A.NEW_DATE,A.NEW_CODE,A.EDT_DATE,A.EDT_CODE,        
  A.READ_COUNT,A.BEST_BANNER_URL,A.DEP_AIRLINE_CODE,A.MOBILE_URL,        
  A.EVT_DESC,A.MASTER_CODE,        
  STUFF((         
  SELECT ('', ''+UPPER(ped.MASTER_CODE)) as [text()] FROM PUB_EVENT_DATA AS ped WITH(NOLOCK) 
													JOIN PKG_MASTER AS pm WITH(NOLOCK) ON ped.MASTER_CODE = pm.MASTER_CODE AND pm.SHOW_YN = ''Y''
													WHERE EVT_SEQ = A.EVT_SEQ         
  FOR XML PATH('''')), 1, 1, '''') AS DATA_MASTER,        
  STUFF((         
  SELECT ('',''+PUB_VALUE) as [text()] FROM COD_PUBLIC WHERE PUB_TYPE = ''EVENT.REGION'' AND  charindex( PUB_CODE ,A.SIGN_CODE  ) > 0          
  FOR XML PATH('''')), 1, 1, '''') AS REGION_NAME ,        
        
  C.REGION_CODE +''/''+        
  C.NATION_CODE +''/''+        
  C.STATE_CODE +''/''+        
  C.CITY_CODE +''/''+        
  + CASE WHEN C.FILE_TYPE = 1  THEN ''image''        
  WHEN C.FILE_TYPE = 2  THEN ''movie''        
  WHEN C.FILE_TYPE = 3 THEN ''document''        
  ELSE ''image'' END  + ''/''  AS CONTENTS_PATH ,        
  C.[FILE_NAME] + ''.'' + C.EXTENSION_NAME AS [FILE_NAME] ,         
  CASE WHEN ISNULL(C.[FILE_NAME_S],'''') ='''' THEN C.[FILE_NAME] + ''.'' + C.EXTENSION_NAME  ELSE C.[FILE_NAME_S] END AS SMALL_IMG,        
  CASE WHEN ISNULL(C.[FILE_NAME_M],'''') ='''' THEN C.[FILE_NAME] + ''.'' + C.EXTENSION_NAME  ELSE C.[FILE_NAME_M] END AS MIDDLE_IMG,        
  CASE WHEN ISNULL(C.[FILE_NAME_L],'''') ='''' THEN C.[FILE_NAME] + ''.'' + C.EXTENSION_NAME  ELSE C.[FILE_NAME_L] END AS BIG_IMG        
        
 FROM PUB_EVENT A WITH(NOLOCK)        
 LEFT JOIN PKG_MASTER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE          
 LEFT JOIN INF_FILE_MASTER C WITH(NOLOCK) ON B.MAIN_FILE_CODE = C.FILE_CODE    
 WHERE 1=1 ' + @WHERE + '        
 ORDER BY ' + @SORT_STRING + '        
 OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE        
 ROWS ONLY        
)        
SELECT        
 *        
FROM LIST A        
ORDER BY ' + @SORT_STRING        
	
	SET @PARMDEFINITION = N'        
 @PAGE_INDEX INT,        
 @PAGE_SIZE INT,        
 @PLAN_TYPE CHAR(1),        
 @SIGN_CODE CHAR(1),        
 @ATT_CODE VARCHAR(2),        
 @PRO_CODE VARCHAR(20),        
 @EVT_NAME VARCHAR(100),        
 @CLOSE_YN CHAR(1),        
 @KEYWORD VARCHAR(100),        
 @TOTAL_COUNT INT OUTPUT'; 
	
	--print @SQLSTRING        
	
	EXEC SP_EXECUTESQL @SQLSTRING
	    ,@PARMDEFINITION
	    ,@PAGE_INDEX
	    ,@PAGE_SIZE
	    ,@PLAN_TYPE
	    ,@SIGN_CODE
	    ,@ATT_CODE
	    ,@PRO_CODE
	    ,@EVT_NAME
	    ,@CLOSE_YN
	    ,@KEYWORD
	    ,@TOTAL_COUNT OUTPUT;
END 
GO
