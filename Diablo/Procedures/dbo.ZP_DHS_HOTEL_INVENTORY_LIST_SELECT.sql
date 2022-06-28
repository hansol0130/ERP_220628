USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_DHS_HOTEL_INVENTORY_LIST_SELECT
■ DESCRIPTION					: 조회_호텔명_재고_리스트
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-17		오준혁			최초생성
   2022-02-03		김성호			예약수 조회 쿼리 수정
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DHS_HOTEL_INVENTORY_LIST_SELECT]
	 @MASTER_CODE     VARCHAR(10)
    ,@BIT_CODE        VARCHAR(4)
    ,@SEARCH_DATE     DATE
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SEARCH_WORD VARCHAR(20)
	
	SET @SEARCH_WORD = (@MASTER_CODE + '-______' + @BIT_CODE)
	
	-- 재고 리스트
	SELECT A.PRO_CODE
	      ,FORMAT(A.DEP_DATE ,'yyyy-MM-dd') AS DEP_DATE
	      ,PDP.PRICE_SEQ
	      ,PDP.SGL_PRICE
	      ,A.RES_ADD_YN
	      ,A.MAX_COUNT
	      ,A.RES_COUNT
	      ,(CASE WHEN A.RES_ADD_YN = 'Y' AND A.MAX_COUNT > A.RES_COUNT THEN 'Y' ELSE 'N' END) AS RES_ADD_YN2
	      ,(A.MAX_COUNT - A.RES_COUNT) AS REST_RES_COUNT
	FROM   (
	           SELECT PD.PRO_CODE
	                 ,PD.DEP_DATE
	                 ,ISNULL(PD.MAX_COUNT ,0) AS MAX_COUNT
	                 ,ISNULL(PD.RES_ADD_YN ,'N') AS RES_ADD_YN
	                 ,ISNULL(
	                      (
	                          SELECT COUNT(*)
	                          FROM   dbo.RES_MASTER_damo RM
	                          WHERE  RM.PRO_CODE = PD.PRO_CODE
	                                 AND RM.RES_STATE < 7
	                          GROUP BY
	                                 RM.PRO_CODE
	                      )
	                     ,0
	                  ) AS RES_COUNT
	           FROM   dbo.PKG_MASTER PM
	                  INNER JOIN dbo.PKG_DETAIL PD
	                       ON  PM.MASTER_CODE = PD.MASTER_CODE
	           WHERE  PM.MASTER_CODE = @MASTER_CODE
	                  AND PD.DEP_DATE >= @SEARCH_DATE
	                  AND PD.DEP_DATE < DATEADD(MM ,1 ,@SEARCH_DATE)
	                  AND PD.PRO_CODE LIKE @SEARCH_WORD
	       ) A
	       INNER JOIN dbo.PKG_DETAIL_PRICE PDP
	            ON  A.PRO_CODE = PDP.PRO_CODE

END
GO
