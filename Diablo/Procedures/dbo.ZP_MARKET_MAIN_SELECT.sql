USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_MARKET_NOTICE_SELECT
■ DESCRIPTION					: 참좋은마켓 메인 공지사항 및 상품내역
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2021-07-20		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_MARKET_MAIN_SELECT]
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	-- 공지사항
	SELECT BOARD_SEQ
	      ,SUBJECT
	FROM   (
	           SELECT BOARD_SEQ
	                 ,SUBJECT
	                 ,ROW_NUMBER() OVER(ORDER BY BOARD_SEQ DESC) RANKING
	           FROM   HBS_DETAIL
	           WHERE  MASTER_SEQ = 3
	                  AND CATEGORY_SEQ = 11
	       ) A
	WHERE  RANKING <= 1
	
	-- 상품내역
	SELECT IT.GRP_SEQ
	      ,IT.ITEM_SEQ
	      ,IT.PRO_CODE
	      ,IT.IMG_URL
	      ,IT.PRO_NAME
	      ,IT.PKG_COMMENT
	      ,IT.DTI_ITEM1 FROM_DATE
	      ,IT.DTI_ITEM2 TO_DATE
	      ,PR.ADT_PRICE MEMBER_PRICE
	      ,PR.CHD_PRICE NONMEMBER_PRICE
	       -- 0;입력오류(slod out) 1;coming soon 2;on sale 3;slod out
	      ,CASE 
	            WHEN IT.DTI_ITEM1 = '준비중' THEN 1
	            WHEN ISDATE(IT.DTI_ITEM1) = 0 THEN 0
	            WHEN DATEDIFF(DD ,IT.DTI_ITEM1 ,GETDATE()) >= 0 AND IT.DTI_ITEM2 = '재고소진시' THEN 2
	            WHEN DATEDIFF(DD ,IT.DTI_ITEM1 ,GETDATE()) < 0 THEN 1
	            WHEN ISDATE(IT.DTI_ITEM2) = 0 THEN 0
	            WHEN DATEDIFF(DD ,IT.DTI_ITEM2 ,GETDATE()) < 0 THEN 2
	            ELSE 3
	       END SALE_TYPE
	FROM   MNU_MNG_ITEM IT
	       INNER JOIN PKG_DETAIL_PRICE PR
	            ON  PR.PRO_CODE = IT.PRO_CODE
	       INNER JOIN PKG_DETAIL DE
	            ON  DE.PRO_CODE = IT.PRO_CODE
	       INNER JOIN PKG_MASTER MA
	            ON  MA.MASTER_CODE = DE.MASTER_CODE
	                --INNER JOIN INF_FILE_MASTER FI
	                --ON FI.FILE_CODE = MA.MAIN_FILE_CODE
	WHERE  SITE_CODE = 'VG2'
	       AND MENU_CODE = '10712'
	       AND SEC_CODE = '2'
END
GO
