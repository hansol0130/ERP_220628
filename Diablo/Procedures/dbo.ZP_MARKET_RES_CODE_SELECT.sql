USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_MARKET_ORDER_SELECT
■ DESCRIPTION					: 참좋은마켓 주문정보화면 데이터
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2021-07-30		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_MARKET_RES_CODE_SELECT]
	
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @RES_CODE RES_CODE
	EXEC SP_RES_GET_RES_CODE 'P', @RES_CODE OUTPUT;
	SELECT @RES_CODE
END
GO
