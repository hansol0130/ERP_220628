USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================        
■ USP_NAME     : ZP_PKG_URGENT_PRODUCT_REGION_COUNT        
■ DESCRIPTION    : 긴급모객 상품 지역 카운트        
■ INPUT PARAMETER   :         
■ OUTPUT PARAMETER   :         
■ EXEC      :         
 EXEC ZP_PKG_URGENT_PRODUCT_REGION_COUNT 'VGT'        
■ MEMO      :         
------------------------------------------------------------------------------------------------------------------        
■ CHANGE HISTORY                           
------------------------------------------------------------------------------------------------------------------        
   DATE    AUTHOR   DESCRIPTION                   
------------------------------------------------------------------------------------------------------------------        
   2018-04-20  정지용   최초생성        
   2018-05-28  정지용   모객인원이 0 이상 인것만 카운팅 되도록 수정        
   2019-12-18  임검제   SITE CODE VGT 로 고정되있던것 파라미터로 수정   , 공백일 시 전체 SITECODE검색 추가   
   2020-02-18  임원묵	  SP_PKG_URGENT_PRODUCT_REGION_COUNT -> ZP_PKG_URGENT_PRODUCT_REGION_COUNT 로 복사 생성   
================================================================================================================*/         
CREATE PROCEDURE [dbo].[ZP_PKG_URGENT_PRODUCT_REGION_COUNT] 
(@SITE_CODE CHAR(3))
AS
BEGIN
	DECLARE @TEXT VARCHAR(MAX);        
	SELECT @TEXT = (
	           SELECT (',' + A.REGION_CODE + '') AS [text()]
	           FROM   PKG_URGENT_MASTER A WITH(NOLOCK)
	                  INNER JOIN PKG_DETAIL B WITH(NOLOCK)
	                       ON  B.PRO_CODE = A.PRO_CODE
	           WHERE  (ISNULL(@SITE_CODE ,'') = '' OR A.SITE_CODE = @SITE_CODE)
	                  AND A.SHOW_YN = 'Y'
	                  AND A.SEAT_CNT > 0
	                  AND B.DEP_DATE >= CONVERT(VARCHAR(10) ,DATEADD(DAY ,2 ,GETDATE()) ,121)
	                  AND B.DEP_DATE <= CONVERT(VARCHAR(10) ,DATEADD(DAY ,7 ,GETDATE()) ,121) 
	                      FOR XML PATH('')
	       )        
	
	SELECT DATA
	      ,COUNT(*) AS COUNT
	FROM   DBO.FN_SPLIT(@TEXT ,',')
	GROUP BY
	       DATA;
END
GO
