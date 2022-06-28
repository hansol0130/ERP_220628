USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================          
■ USP_NAME			: [ZP_MOV2_EVENT_PRODUCT_SELECT]          
■ DESCRIPTION		: 이벤트 상세정보 조회          
■ INPUT PARAMETER	: @SNS_COMPANY, @SNS_ID          
■ EXEC				:           
    
    -- EXEC ZP_MOV2_EVENT_PRODUCT_SELECT 6635, 0, 0          
          
■ MEMO				: 이벤트 상세정보 조회          
------------------------------------------------------------------------------------------------------------------          
■ CHANGE HISTORY                             
------------------------------------------------------------------------------------------------------------------          
   DATE			AUTHOR			DESCRIPTION                     
------------------------------------------------------------------------------------------------------------------          
   2017-05-26	아이비솔루션	최초생성          
   2017-11-30	정지용			쿼리 다시 작성          
   2017-12-04	박형만			ATT_NAME 추가          
   2017-12-06	김성호			EVENT_PRO_NAME 조건 추가 (오늘 이후 출발 상품만 검색 되도록)           
   2019-12-11	지니웍스		리뉴얼 관련 select 항목 추가     
   2020-01-02	지니웍스		행사 출발 시간 추가 
   2020-03-02   지니웍스		PKG_SUMMARY 추가 
   2020-06-25   EHD(김영민)		CLEAN_YN컬럼추가 
   2020-06-29   오준혁          pro_code가 유효한 행사만 조회되게 수정
   2022-06-15   HCLEE           여행기간 조회TYPE 수정 'D.TOURDAY', EX) DBO.FN_GET_MASTER_SUMMARY('EPP4209' ,'D') => DBO.FN_GET_MASTER_SUMMARY('EPP4209' ,'D.TOURDAY')
================================================================================================================*/           
CREATE PROCEDURE [dbo].[ZP_MOV2_EVENT_PRODUCT_SELECT]
(
    -- Add the parameters for the stored procedure here          
    @EVT_SEQ          INT
   ,@CATEGORY         INT
   ,@SUB_CATEGORY     INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.          
	SET NOCOUNT ON; 
	
	WITH LIST AS (
	    SELECT A.EVT_SEQ
	          ,A.EVT_DATA_SEQ
	          ,A.CATEGORY
	          ,A.SUB_CATEGORY
	          ,A.MASTER_CODE
	          ,A.PRO_CODE
	          ,A.PRICE_SEQ
	          ,A.CODE_TYPE
	          ,A.SHOW_YN
	          ,A.SORT_NUM
	          ,'M' AS [FLAG]
	          ,B.SIGN_CODE
	          ,B.MASTER_NAME AS [NAME]
	          ,B.MASTER_CODE AS [CODE]
	          ,B.PKG_COMMENT
	          ,B.PKG_SUMMARY
	          ,(
	               SELECT TOP 1 PKG_INCLUDE
	               FROM   PKG_MASTER_PRICE WITH(NOLOCK)
	               WHERE  MASTER_CODE = A.MASTER_CODE
	               ORDER BY
	                      ADT_PRICE
	           ) AS [PKG_INCLUDE]
	          ,B.NEXT_DATE AS [DEP_DATE]
	          ,B.LOW_PRICE AS [PRICE]
	          ,C.FILE_CODE
	          ,C.REGION_CODE
	          ,C.NATION_CODE
	          ,C.STATE_CODE
	          ,C.CITY_CODE
	          ,C.KOR_NAME
	          ,C.ENG_NAME
	          ,C.FILE_TYPE
	          ,C.FILE_NAME
	          ,C.EXTENSION_NAME
	          ,C.FILE_SIZE
	          ,C.FILE_NAME_S
	          ,C.FILE_NAME_M
	          ,C.FILE_NAME_L
	          ,C.FILE_REMARK
	          ,C.FILE_TAG
	          ,C.RESOLUTION
	          ,C.COPYRIGHT
	          ,C.COPYRIGHT_REMARK
	          ,B.BRANCH_CODE
	          ,B.ATT_CODE
	          ,B.BRAND_TYPE
	          ,B.CLEAN_YN
	          ,(
	               SELECT TOP 1 PUB_VALUE
	               FROM   COD_PUBLIC AA WITH(NOLOCK)
	               WHERE  PUB_TYPE = 'PKG.ATTRIBUTE'
	                      AND AA.PUB_CODE = B.ATT_CODE
	           ) AS [ATT_NAME]
	          ,(
	               SELECT TOP 1 KOR_NAME
	               FROM   PUB_REGION WITH(NOLOCK)
	               WHERE  C.REGION_CODE = REGION_CODE
	           ) AS REGION_NAME
	          ,(
	               SELECT COUNT(*)
	               FROM   VR_CONTENT V2 WITH(NOLOCK)
	                      INNER JOIN VR_MASTER VM WITH(NOLOCK)
	                           ON  V2.VR_NO = VM.VR_NO
	               WHERE  B.MASTER_CODE = V2.MASTER_CODE
	                      AND VM.VR_TYPE = 1
	           ) AS [VR_COUNT]
	          ,(
	               SELECT COUNT(*)
	               FROM   PUB_EVENT_DATA A2 WITH(NOLOCK)
	                      INNER JOIN PUB_EVENT B2 WITH(NOLOCK)
	                           ON  A2.EVT_SEQ = B2.EVT_SEQ
	               WHERE  B2.EVT_YN = 'Y'
	                      AND A2.SHOW_YN = 'Y'
	                      AND B2.SHOW_YN = 'Y'
	                      AND A2.MASTER_CODE = B.MASTER_CODE
	                      AND B2.END_DATE >= GETDATE()
	           ) AS [EVENT_COUNT]
	          ,B.TAG AS [TAG]
	          ,B.EVENT_PRO_CODE 
	           
	           -- 2019 리뉴얼 추가
	          ,STUFF(
	               (
	                   SELECT (',' + UPPER(SEARCH_VALUE)) AS [text()]
	                   FROM   PKG_MASTER_SUMMARY WITH(NOLOCK)
	                   WHERE  MASTER_CODE = B.MASTER_CODE
	                          AND SEARCH_TYPE = 'W' FOR XML PATH('')
	               )
	              ,1
	              ,1
	              ,''
	           ) AS WEEK_DAY -- 출발일
	          ,DBO.FN_GET_MASTER_SUMMARY(B.MASTER_CODE ,'D.TOURDAY') AS TOUR_DAY
	          ,(
	               SELECT COUNT(DISTINCT SEARCH_VALUE)
	               FROM   PKG_MASTER_SUMMARY WITH(NOLOCK)
	               WHERE  B.MASTER_CODE = MASTER_CODE
	                      AND SEARCH_TYPE = 'D'
	           ) AS TOUR_DAY_COUNT -- 여행일정 ~부터 표시를 위해서 count를 확인함.
	          ,'0' AS TOUR_NIGHT -- 마스터는 박수 가져오려면 detail 에서 조합해서 .. 해야해서 안쓰기로했다고함.
	          ,B.TOUR_JOURNEY
	          ,B.AIRLINE_CODE
	          ,0 AS IS_MASTEREVENT_PRODUCT
	          ,'' DEP_DEP_TIME
	    FROM   PUB_EVENT_DATA A WITH(NOLOCK)
	           INNER JOIN PKG_MASTER B WITH(NOLOCK)
	                ON  A.MASTER_CODE = B.MASTER_CODE
	           INNER JOIN INF_FILE_MASTER C WITH(NOLOCK)
	                ON  B.MAIN_FILE_CODE = C.FILE_CODE
	    WHERE  B.SHOW_YN = 'Y'
	           AND (@EVT_SEQ IS NULL OR @EVT_SEQ = '' OR A.EVT_SEQ = @EVT_SEQ)
	           AND (
	                   @CATEGORY IS NULL
	                   OR @CATEGORY = ''
	                   OR CATEGORY = (
	                          SELECT TOP 1 EVT_CATE_SEQ
	                          FROM   PUB_EVENT_CATEGORY WITH(NOLOCK)
	                          WHERE  EVT_SEQ = @EVT_SEQ
	                                 AND EVT_CATEGORY = @CATEGORY
	                      )
	               )
	           AND (
	                   @SUB_CATEGORY IS NULL
	                   OR @SUB_CATEGORY = ''
	                   OR CATEGORY = (
	                          SELECT TOP 1 EVT_CATE_SEQ
	                          FROM   PUB_EVENT_CATEGORY WITH(NOLOCK)
	                          WHERE  EVT_SEQ = @EVT_SEQ
	                                 AND EVT_SUB_CATEGORY = @SUB_CATEGORY
	                      )
	               )
	           AND B.NEXT_DATE >= '2016-01-01' 
	    -- AND B.NEXT_DATE >= Convert(varchar(10), getDate(), 120)            
	    
	    UNION          
	    
	    SELECT A.EVT_SEQ
	          ,A.EVT_DATA_SEQ
	          ,A.CATEGORY
	          ,A.SUB_CATEGORY
	          ,A.MASTER_CODE
	          ,A.PRO_CODE
	          ,A.PRICE_SEQ
	          ,A.CODE_TYPE
	          ,A.SHOW_YN
	          ,A.SORT_NUM
	          ,'P' AS [FLAG]
	          ,D.SIGN_CODE
	          ,B.PRO_NAME AS [NAME]
	          ,B.PRO_CODE AS [CODE]
	          ,D.PKG_COMMENT
	          ,D.PKG_SUMMARY
	          ,C.PKG_INCLUDE
	          ,B.DEP_DATE
	          ,DBO.XN_PRO_DETAIL_SALE_PRICE_CUTTING(A.PRO_CODE ,A.PRICE_SEQ) AS [PRICE]
	          ,E.FILE_CODE
	          ,E.REGION_CODE
	          ,E.NATION_CODE
	          ,E.STATE_CODE
	          ,E.CITY_CODE
	          ,E.KOR_NAME
	          ,E.ENG_NAME
	          ,E.FILE_TYPE
	          ,E.FILE_NAME
	          ,E.EXTENSION_NAME
	          ,E.FILE_SIZE
	          ,E.FILE_NAME_S
	          ,E.FILE_NAME_M
	          ,E.FILE_NAME_L
	          ,E.FILE_REMARK
	          ,E.FILE_TAG
	          ,E.RESOLUTION
	          ,E.COPYRIGHT
	          ,E.COPYRIGHT_REMARK
	          ,D.BRANCH_CODE
	          ,D.ATT_CODE
	          ,D.BRAND_TYPE
	          ,D.CLEAN_YN
	          ,(
	               SELECT TOP 1 PUB_VALUE
	               FROM   COD_PUBLIC AA WITH(NOLOCK)
	               WHERE  PUB_TYPE = 'PKG.ATTRIBUTE'
	                      AND AA.PUB_CODE = D.ATT_CODE
	           ) AS [ATT_NAME]
	          ,(
	               SELECT TOP 1 KOR_NAME
	               FROM   PUB_REGION WITH(NOLOCK)
	               WHERE  E.REGION_CODE = REGION_CODE
	           ) AS REGION_NAME
	          ,(
	               SELECT COUNT(*)
	               FROM   VR_CONTENT V2 WITH(NOLOCK)
	                      INNER JOIN VR_MASTER VM WITH(NOLOCK)
	                           ON  V2.VR_NO = VM.VR_NO
	               WHERE  D.MASTER_CODE = V2.MASTER_CODE
	                      AND VM.VR_TYPE = 1
	           ) AS [VR_COUNT]
	          ,(
	               SELECT COUNT(*)
	               FROM   PUB_EVENT_DATA A2 WITH(NOLOCK)
	                      INNER JOIN PUB_EVENT B2 WITH(NOLOCK)
	                           ON  A2.EVT_SEQ = B2.EVT_SEQ
	               WHERE  B2.EVT_YN = 'Y'
	                      AND A2.SHOW_YN = 'Y'
	                      AND B2.SHOW_YN = 'Y'
	                      AND A2.MASTER_CODE = D.MASTER_CODE
	                      AND B2.END_DATE >= GETDATE()
	           ) AS [EVENT_COUNT]
	          ,D.TAG AS [TAG]
	          ,D.EVENT_PRO_CODE 
	           
	           -- 2019 리뉴얼 추가
	          ,CAST(DATEPART(DW ,DEP_DATE) AS CHAR(1)) AS WEEK_DAY
	          ,CAST(B.TOUR_DAY AS NVARCHAR(5)) AS TOUR_DAY
	          ,1 AS TOUR_DAY_COUNT
	          ,B.TOUR_NIGHT
	          ,B.TOUR_JOURNEY
	          ,D.AIRLINE_CODE
	          ,(
	               CASE 
	                    WHEN EXISTS(
	                             SELECT *
	                             FROM   PKG_MASTER PM WITH(NOLOCK)
	                             WHERE  PM.EVENT_PRO_CODE = A.PRO_CODE
	                         ) THEN 1
	                    ELSE 0
	               END
	           ) AS IS_MASTEREVENT_PRODUCT
	          ,F.DEP_DEP_TIME
	    FROM   PUB_EVENT_DATA A WITH(NOLOCK)
	           INNER JOIN PKG_DETAIL B WITH(NOLOCK)
	                ON  A.PRO_CODE = B.PRO_CODE
	           INNER JOIN PRO_TRANS_SEAT F WITH(NOLOCK)
	                ON  B.SEAT_CODE = F.SEAT_CODE
	           INNER JOIN PKG_DETAIL_PRICE C WITH(NOLOCK)
	                ON  A.PRO_CODE = C.PRO_CODE
	                    AND A.PRICE_SEQ = C.PRICE_SEQ
	           INNER JOIN PKG_MASTER D WITH(NOLOCK)
	                ON  B.MASTER_CODE = D.MASTER_CODE
	           INNER JOIN INF_FILE_MASTER E WITH(NOLOCK)
	                ON  D.MAIN_FILE_CODE = E.FILE_CODE
	    WHERE  D.SHOW_YN = 'Y'
	           AND B.MASTER_CODE  IN (SELECT DISTINCT MASTER_CODE
	                                  FROM   PKG_DETAIL
	                                  WHERE  SHOW_YN = 'Y'
	                                         AND DEP_DATE >= GETDATE()
	                                         AND MASTER_CODE = B.MASTER_CODE)
	           AND B.SHOW_YN = 'Y'
	           AND (@EVT_SEQ IS NULL OR @EVT_SEQ = '' OR A.EVT_SEQ = @EVT_SEQ)
	           AND (
	                   @CATEGORY IS NULL
	                   OR @CATEGORY = ''
	                   OR CATEGORY = (
	                          SELECT TOP 1 EVT_CATE_SEQ
	                          FROM   PUB_EVENT_CATEGORY WITH(NOLOCK)
	                          WHERE  EVT_SEQ = @EVT_SEQ
	                                 AND EVT_CATEGORY = @CATEGORY
	                      )
	               )
	           AND (
	                   @SUB_CATEGORY IS NULL
	                   OR @SUB_CATEGORY = ''
	                   OR CATEGORY = (
	                          SELECT TOP 1 EVT_CATE_SEQ
	                          FROM   PUB_EVENT_CATEGORY WITH(NOLOCK)
	                          WHERE  EVT_SEQ = @EVT_SEQ
	                                 AND EVT_SUB_CATEGORY = @SUB_CATEGORY
	                      )
	               )
	)      
	
	
	SELECT Z.*
	      ,(
	           SELECT CONVERT(VARCHAR(100) ,A1.PRO_NAME ,120)
	           FROM   PKG_DETAIL A1 WITH(NOLOCK)
	           WHERE  A1.PRO_CODE = Z.EVENT_PRO_CODE
	                  AND A1.DEP_DATE >= GETDATE()
	       ) AS [EVENT_NAME]
	      ,(
	           SELECT CONVERT(VARCHAR(10) ,A1.DEP_DATE ,120)
	           FROM   PKG_DETAIL A1 WITH(NOLOCK)
	           WHERE  A1.PRO_CODE = Z.EVENT_PRO_CODE
	                  AND A1.DEP_DATE >= GETDATE()
	       ) AS [EVENT_PRO_DATE] -- 마스터 = > 연결된 이벤트 상품 출발일 / 디테일 => 이벤트 상품 출발일
	      ,(
	           SELECT CONVERT(VARCHAR(10) ,A1.ARR_DATE ,120)
	           FROM   PKG_DETAIL A1 WITH(NOLOCK)
	           WHERE  A1.PRO_CODE = Z.EVENT_PRO_CODE
	                  AND A1.DEP_DATE >= GETDATE()
	       ) AS [EVENT_PRO_ARR_DATE] -- 연결된 이벤트 상품 도착일
	      ,(
	           SELECT A1.PRO_NAME
	           FROM   PKG_DETAIL A1 WITH(NOLOCK)
	           WHERE  A1.PRO_CODE = Z.EVENT_PRO_CODE
	                  AND A1.DEP_DATE >= GETDATE()
	       ) AS [EVENT_PRO_NAME] -- 연결된 이벤트 상품 명
	      ,(
	           SELECT TOP 1 A1.ADT_PRICE
	           FROM   PKG_DETAIL_PRICE AS A1 WITH(NOLOCK)
	           WHERE  A1.PRO_CODE = Z.EVENT_PRO_CODE
	           ORDER BY
	                  PRICE_SEQ
	       ) AS [EVENT_PRO_PRICE] -- 연결된 이벤트 상품 가격
	      ,COMMENT.GRADE
	      ,COMMENT.NICKNAME
	      ,COMMENT.CONTENTS
	      ,AIRLINE.AIRLINE_CODE
	      ,AIRLINE.KOR_NAME AS AIRLINE_NAME
	FROM   LIST Z
	       OUTER APPLY (
							SELECT TOP 1 * 
							FROM   PRO_COMMENT AS COMMENT WITH(NOLOCK)
							WHERE  Z.MASTER_CODE = COMMENT.MASTER_CODE
							ORDER BY
								   COMMENT.NEW_DATE DESC
								  ,COM_SEQ DESC
						) AS COMMENT 
			LEFT OUTER JOIN PUB_AIRLINE AS AIRLINE
						ON  AIRLINE.AIRLINE_CODE = Z.AIRLINE_CODE
	WHERE EXISTS (
					SELECT MASTER_CODE
					FROM   PKG_DETAIL WITH(NOLOCK)
					WHERE  MASTER_CODE = Z.MASTER_CODE
							AND DEP_DATE >= GETDATE()
							AND SHOW_YN = 'Y'
							AND RES_ADD_YN = 'Y'
							AND (MAX_COUNT = 0 OR (MAX_COUNT - DBO.FN_PRO_GET_RES_COUNT(PRO_CODE) > 0))
	)						
	ORDER BY
	       SORT_NUM ASC; 
	
	/*          
	-- Insert statements for procedure here          
	SELECT 'M' AS [FLAG], B.SIGN_CODE, A.*, B.MASTER_NAME AS [NAME], B.MASTER_CODE AS [CODE], B.PKG_COMMENT          
	, (SELECT TOP 1 PKG_INCLUDE FROM PKG_MASTER_PRICE WITH(NOLOCK) WHERE MASTER_CODE = A.MASTER_CODE ORDER BY ADT_PRICE) AS [PKG_INCLUDE]          
	, B.NEXT_DATE AS [DEP_DATE], B.LOW_PRICE AS [PRICE]          
	, C.*, B.BRANCH_CODE, B.ATT_CODE, B.BRAND_TYPE          
	, (SELECT TOP 1 KOR_NAME FROM PUB_REGION WITH(NOLOCK) WHERE C.REGION_CODE = REGION_CODE) AS REGION_NAME          
	
	, (SELECT COUNT(*) FROM VR_CONTENT V2 WITH(NOLOCK) INNER JOIN VR_MASTER VM WITH(NOLOCK) ON V2.VR_NO = VM.VR_NO WHERE B.MASTER_CODE = V2.MASTER_CODE AND VM.VR_TYPE = 1) AS [VR_COUNT]          
	, (SELECT COUNT(*) FROM PUB_EVENT_DATA A2 WITH(NOLOCK) INNER JOIN PUB_EVENT B2 WITH(NOLOCK) ON A2.EVT_SEQ = B2.EVT_SEQ WHERE B2.EVT_YN = 'Y' AND A2.SHOW_YN = 'Y' AND B2.SHOW_YN = 'Y' AND A2.MASTER_CODE = B.MASTER_CODE AND B2.END_DATE >= GETDATE()) AS [
	
	
	
	
	EVENT_COUNT]          
	, B.TAG AS [TAG]           
	, B.EVENT_PRO_CODE          
	
	FROM PUB_EVENT_DATA A WITH(NOLOCK)          
	INNER JOIN PKG_MASTER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE          
	INNER JOIN INF_FILE_MASTER C WITH(NOLOCK) ON B.MAIN_FILE_CODE = C.FILE_CODE          
	WHERE B.SHOW_YN ='Y'          
	AND (@EVT_SEQ IS NULL OR @EVT_SEQ='' OR A.EVT_SEQ = @EVT_SEQ)          
	AND(@CATEGORY IS NULL OR @CATEGORY='' OR CATEGORY=(SELECT TOP 1 EVT_CATE_SEQ FROM PUB_EVENT_CATEGORY WHERE EVT_SEQ = @EVT_SEQ AND EVT_CATEGORY = @CATEGORY))          
	AND(@SUB_CATEGORY IS NULL OR @SUB_CATEGORY='' OR CATEGORY=(SELECT TOP 1 EVT_CATE_SEQ FROM PUB_EVENT_CATEGORY WHERE EVT_SEQ = @EVT_SEQ AND EVT_SUB_CATEGORY = @SUB_CATEGORY))          
	AND B.NEXT_DATE >= '2016-01-01'          
	-- AND B.NEXT_DATE >= Convert(varchar(10), getDate(), 120)            
	
	UNION           
	SELECT 'P' AS [FLAG], D.SIGN_CODE, A.*, B.PRO_NAME AS [NAME], B.PRO_CODE AS [CODE], D.PKG_COMMENT          
	, C.PKG_INCLUDE, B.DEP_DATE, DBO.XN_PRO_DETAIL_SALE_PRICE_CUTTING(A.PRO_CODE, A.PRICE_SEQ) AS [PRICE]          
	, E.*, D.BRANCH_CODE, D.ATT_CODE, D.BRAND_TYPE          
	, (SELECT TOP 1 KOR_NAME FROM PUB_REGION WITH(NOLOCK) WHERE E.REGION_CODE = REGION_CODE) AS REGION_NAME          
	
	, (SELECT COUNT(*) FROM VR_CONTENT V2 WITH(NOLOCK) INNER JOIN VR_MASTER VM WITH(NOLOCK) ON V2.VR_NO = VM.VR_NO WHERE D.MASTER_CODE = V2.MASTER_CODE AND VM.VR_TYPE = 1) AS [VR_COUNT]          
	, (SELECT COUNT(*) FROM PUB_EVENT_DATA A2 WITH(NOLOCK) INNER JOIN PUB_EVENT B2 WITH(NOLOCK) ON A2.EVT_SEQ = B2.EVT_SEQ WHERE B2.EVT_YN = 'Y' AND A2.SHOW_YN = 'Y' AND B2.SHOW_YN = 'Y' AND A2.MASTER_CODE = D.MASTER_CODE AND B2.END_DATE >= GETDATE()) AS [
	
	
	
	
	EVENT_COUNT]          
	, D.TAG AS [TAG]           
	, D.EVENT_PRO_CODE          
	
	FROM PUB_EVENT_DATA A WITH(NOLOCK)          
	INNER JOIN PKG_DETAIL B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE          
	INNER JOIN PKG_DETAIL_PRICE C WITH(NOLOCK) ON A.PRO_CODE = C.PRO_CODE AND A.PRICE_SEQ = C.PRICE_SEQ          
	INNER JOIN PKG_MASTER D WITH(NOLOCK) ON B.MASTER_CODE = D.MASTER_CODE          
	INNER JOIN INF_FILE_MASTER E WITH(NOLOCK) ON D.MAIN_FILE_CODE = E.FILE_CODE          
	WHERE D.SHOW_YN = 'Y'          
	AND B.SHOW_YN ='Y'           
	AND (@EVT_SEQ IS NULL OR @EVT_SEQ='' OR A.EVT_SEQ = @EVT_SEQ)          
	AND(@CATEGORY IS NULL OR @CATEGORY='' OR CATEGORY=(SELECT TOP 1 EVT_CATE_SEQ FROM PUB_EVENT_CATEGORY WHERE EVT_SEQ = @EVT_SEQ AND EVT_CATEGORY = @CATEGORY))          
	AND(@SUB_CATEGORY IS NULL OR @SUB_CATEGORY='' OR CATEGORY=(SELECT TOP 1 EVT_CATE_SEQ FROM PUB_EVENT_CATEGORY WHERE EVT_SEQ = @EVT_SEQ AND EVT_SUB_CATEGORY = @SUB_CATEGORY))          
	ORDER BY A.SORT_NUM ASC          
	*/
END 
GO
