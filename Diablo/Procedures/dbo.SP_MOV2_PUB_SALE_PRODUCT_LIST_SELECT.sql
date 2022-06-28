USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================          
■ USP_NAME     : [SP_MOV2_PUB_SALE_PRODUCT_LIST_SELECT]          
■ DESCRIPTION    : 주말 할인 상품 리스트.          
■ INPUT PARAMETER   : @VR_NO@VR_NAME @VR_DESC @VR_CREATOR @nowPage           
■ EXEC      :            
    -- [SP_MOV2_PUB_SALE_PRODUCT_LIST_SELECT]               
DECLARE @TotalCount INT          
EXEC [SP_MOV2_PUB_SALE_PRODUCT_LIST_SELECT] '2016-10-28', 1, 10, @TotalCount OUT, 'VGT', 'J'          
SELECT @TotalCount          
■ MEMO      : 주말 할인 상품 리스트.          
------------------------------------------------------------------------------------------------------------------          
■ CHANGE HISTORY                               
------------------------------------------------------------------------------------------------------------------          
   DATE			AUTHOR			DESCRIPTION                     
------------------------------------------------------------------------------------------------------------------          
   2017-05-26   아이비솔루션		최초생성          
   2019-12-18   임검제			리뉴얼 조회 값 추가, SITE_CODE 공백일시 전체 조회       
   2020-01-02   임검제			행사 출발 시간 추가     
================================================================================================================*/           
CREATE PROCEDURE [dbo].[SP_MOV2_PUB_SALE_PRODUCT_LIST_SELECT] 

-- Add the parameters for the stored procedure here          
	@DATE DATE, 
	@nowPage INT = 1, 
	@pageSize INT = 10, 
	@TOTAL_COUNT INT OUT, 
	@SITE_CODE CHAR(7) = 'VGT', 
	@REGION_CODE CHAR(2)
AS
BEGIN
	DECLARE @Start INT = ((@nowPage -1) * @pageSize) 
	
	;WITH LIST AS 
	(
	    SELECT SITE_CODE
	          ,SALE_SEQ
	          ,(
	               SELECT TOP 1 PRICE_SEQ
	               FROM   PKG_DETAIL_PRICE AA WITH(NOLOCK)
	               WHERE  AA.PRO_CODE = A.PRO_CODE
	               ORDER BY
	                      ADT_PRICE
	           ) AS [PRICE_SEQ]
	          ,(
	               SELECT TOP 1 FILE_CODE
	               FROM   PKG_DETAIL_FILE WITH(NOLOCK)
	               WHERE  PRO_CODE = A.PRO_CODE
	               ORDER BY
	                      SHOW_ORDER
	           ) AS [FILE_CODE]
	          ,A.SIGN_CODE
	    FROM   SALE_MASTER AS A WITH(NOLOCK)
	    WHERE  (ISNULL(@SITE_CODE ,'') = '' OR SITE_CODE = @SITE_CODE)
	           AND SHOW_YN = 'Y'
	           AND (@DATE IS NULL OR @DATE = '' OR CONVERT(DATETIME ,@DATE) BETWEEN A.START_DATE AND A.END_DATE)
	           AND (@REGION_CODE IS NULL OR @REGION_CODE = '' OR @REGION_CODE = A.SIGN_CODE)
	    ORDER BY
	           A.SITE_CODE ASC
	          ,A.ORDER_NUM DESC
	          ,A.SALE_SEQ DESC 
	           OFFSET @Start ROWS
	
	FETCH NEXT @pageSize ROWS ONLY 
	)          
	
	SELECT A.*
	      ,B.PRO_NAME
	      ,DBO.XN_PRO_DETAIL_SALE_PRICE_CUTTING(C.PRO_CODE ,C.PRICE_SEQ) AS [ADT_PRICE]
	      ,D.*
	      ,B.MASTER_CODE
	      ,P.ATT_CODE
	      ,Z.PRICE_SEQ
	      ,(
	           SELECT COUNT(*)
	           FROM   VR_CONTENT V2 WITH(NOLOCK)
	                  INNER JOIN VR_MASTER VM WITH(NOLOCK)
	                       ON  V2.VR_NO = VM.VR_NO
	           WHERE  P.MASTER_CODE = V2.MASTER_CODE
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
	                  AND A2.MASTER_CODE = P.MASTER_CODE
	                  AND B2.END_DATE >= GETDATE()
	       ) AS [EVENT_COUNT]
	      ,P.TAG AS [TAG]
	      ,P.BRAND_TYPE
	      ,P.EVENT_PRO_CODE 
	       
	       --2019 리뉴얼 추가
	      ,B.TOUR_NIGHT -- 박
	      ,B.TOUR_DAY -- 일
	      ,P.BRANCH_CODE -- 출발지역
	      ,B.DEP_DATE -- 출발일
	      ,(
	           SELECT TOP 1 PUB_VALUE
	           FROM   COD_PUBLIC AA WITH(NOLOCK)
	           WHERE  PUB_TYPE = 'PKG.ATTRIBUTE'
	                  AND AA.PUB_CODE = P.ATT_CODE
	       ) AS [ATT_NAME]
	      ,(
	           SELECT TOP 1 KOR_NAME
	           FROM   PUB_REGION AA WITH(NOLOCK)
	           WHERE  AA.SIGN = P.SIGN_CODE
	       ) AS [REGION_NAME]
	      ,E.DEP_DEP_TIME
	FROM   LIST Z
	       INNER JOIN SALE_MASTER A WITH(NOLOCK)
	            ON  A.SITE_CODE = Z.SITE_CODE
	                AND A.SALE_SEQ = Z.SALE_SEQ
	       LEFT JOIN PKG_DETAIL B WITH(NOLOCK)
	            ON  B.PRO_CODE = A.PRO_CODE
	       LEFT OUTER JOIN PRO_TRANS_SEAT E WITH(NOLOCK)
	            ON  B.SEAT_CODE = E.SEAT_CODE
	       INNER JOIN PKG_MASTER AS P
	            ON  B.MASTER_CODE = P.MASTER_CODE
	       LEFT JOIN PKG_DETAIL_PRICE C WITH(NOLOCK)
	            ON  C.PRO_CODE = A.PRO_CODE
	                AND C.PRICE_SEQ = Z.PRICE_SEQ
	       LEFT JOIN INF_FILE_MASTER D WITH(NOLOCK)
	            ON  D.FILE_CODE = Z.FILE_CODE          
	
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM   SALE_MASTER AS A WITH(NOLOCK)
	WHERE  (ISNULL(@SITE_CODE ,'') = '' OR SITE_CODE = @SITE_CODE)
	       AND SHOW_YN = 'Y'
	       AND (@DATE IS NULL OR @DATE = '' OR CONVERT(DATETIME ,@DATE) BETWEEN A.START_DATE AND A.END_DATE)
	       AND (@REGION_CODE IS NULL OR @REGION_CODE = '' OR @REGION_CODE = A.SIGN_CODE)
END
GO
