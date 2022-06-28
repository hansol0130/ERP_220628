USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_DHS_ERP_HOTEL_RES_NAME_SELECT
■ DESCRIPTION					: 조회_홈쇼핑호텔_예약자정보
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 

EXEC [dbo].[ZP_DHS_ERP_HOTEL_RES_NAME_SELECT] 'RP2201177236'

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-24		오준혁			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DHS_ERP_HOTEL_RES_NAME_SELECT]
	 @RES_CODE     VARCHAR(12)
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- 최대 인원
	DECLARE @MASTER_CODE       VARCHAR(10)
	       ,@PRICE_SEQ         INT
	       ,@ADT_MAX_COUNT     INT
	       ,@CHD_MAX_COUNT     INT
	
	SELECT @MASTER_CODE = MASTER_CODE
	      ,@PRICE_SEQ = SUBSTRING(PRO_CODE, CHARINDEX('-', PRO_CODE)+7, LEN(PRO_CODE))
	FROM   dbo.RES_MASTER_damo
	WHERE  RES_CODE = @RES_CODE
	
	
	SELECT @ADT_MAX_COUNT = ADT_MAX_COUNT
	      ,@CHD_MAX_COUNT = CHD_MAX_COUNT
	FROM   dbo.PKG_MASTER_PRICE_DHS_MASTER
	WHERE  MASTER_CODE = @MASTER_CODE
	       AND PRICE_SEQ = @PRICE_SEQ
	

	
	-- 개인정보
	SELECT RES_CODE
	      ,RES_NAME
	      ,ISNULL(NOR_TEL1,'') + '-' + ISNULL(NOR_TEL2,'') + '-' + ISNULL(NOR_TEL3,'') AS 'NOR_TEL'
	      ,PNR_INFO
	      ,@ADT_MAX_COUNT AS 'ADT_MAX_COUNT'
	      ,@CHD_MAX_COUNT AS 'CHD_MAX_COUNT'
	FROM   dbo.RES_MASTER_damo
	WHERE  RES_CODE = @RES_CODE
	
END
GO
