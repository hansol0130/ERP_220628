USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME						: ZP_DHS_HOTEL_INVENTORY_UPDATE
■ DESCRIPTION					: 수정_호텔재고
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
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DHS_HOTEL_INVENTORY_UPDATE]
	 @PRO_CODE     VARCHAR(20)
    ,@MAX_COUNT    INT
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	UPDATE dbo.PKG_DETAIL
	SET    MAX_COUNT = @MAX_COUNT
	WHERE  PRO_CODE = @PRO_CODE

END

GO
