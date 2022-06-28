USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_MARKET_PRODUCT_TEMP_INSERT
■ DESCRIPTION					: 마켓 주문정보 TEMP TABLE
■ INPUT PARAMETER				: 
	@CUS_NO			INT			: 고객번호
	@CUS_NO_RECOM	INT			: 추천고객번호
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    :
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2020-08-11		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_MARKET_PRODUCT_TEMP_INSERT]
	@PRO_CODE VARCHAR(20),
	@RES_CODE CHAR(12),
	@NAME VARCHAR(40),
	@TEL VARCHAR(40),
	@EMAIL VARCHAR(100),
	@DELIVERY_NAME VARCHAR(40),
	@DELIVERY_TEL VARCHAR(40),
	@ZIP_CODE VARCHAR(7),
	@ADDR1 VARCHAR(100),
	@ADDR2 VARCHAR(100),
	@COUNT INT,
	@PAY_PRICE MONEY,
	@PAY_TYPE CHAR(1)

AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	INSERT INTO MARKET_PRODUCT_TEMP
	SELECT @PRO_CODE
		  ,@RES_CODE
		  ,@NAME
		  ,@TEL
		  ,@EMAIL
		  ,@DELIVERY_NAME
		  ,@DELIVERY_TEL
		  ,@ZIP_CODE
		  ,@ADDR1
		  ,@ADDR2
		  ,@COUNT
		  ,@PAY_PRICE
		  ,@PAY_TYPE
		  ,GETDATE()
END
GO
