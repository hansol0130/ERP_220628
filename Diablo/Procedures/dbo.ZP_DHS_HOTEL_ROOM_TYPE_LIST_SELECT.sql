USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_DHS_HOTEL_ROOM_TYPE_LIST_SELECT
■ DESCRIPTION					: 조회_호텔룸타입_리스트
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-11		오준혁			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DHS_HOTEL_ROOM_TYPE_LIST_SELECT]
	@MASTER_CODE VARCHAR(10)
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	-- 호텔룸타입
	SELECT a.PRICE_SEQ
		  ,a.PRICE_NAME
	FROM   dbo.PKG_MASTER_PRICE a
	WHERE  a.MASTER_CODE = @MASTER_CODE

END
GO
