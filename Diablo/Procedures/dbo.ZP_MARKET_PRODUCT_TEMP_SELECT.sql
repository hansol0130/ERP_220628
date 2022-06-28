USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_MARKET_PRODUCT_TEMP_SELECT
■ DESCRIPTION					: 참좋은마켓 상품정보 TEMP 데이터
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2021-08-12		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_MARKET_PRODUCT_TEMP_SELECT]
	@RES_CODE				CHAR(12)
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT PRO_CODE
	      ,RES_CODE
	      ,NAME
	      ,TEL
	      ,EMAIL
	      ,DELIVERY_NAME
	      ,DELIVERY_TEL
	      ,ZIP_CODE
	      ,ADDR1
	      ,ADDR2
	      ,COUNT
	      ,PAY_PRICE
	      ,NEW_DATE
	FROM   MARKET_PRODUCT_TEMP
	WHERE  RES_CODE = @RES_CODE
	       AND SEQ = (
	               SELECT MAX(SEQ)
	               FROM   MARKET_PRODUCT_TEMP
	               WHERE  RES_CODE = @RES_CODE
	           )
	       AND RES_CODE NOT IN (SELECT RES_CODE
	                            FROM   RES_MASTER_DAMO
	                            WHERE  RES_CODE = @RES_CODE)
END
GO
