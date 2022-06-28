USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_MARKET_CANCEL_REQUEST_INSERT
■ DESCRIPTION					: 참좋은 마켓 취소요청
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2020-08-24		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_MARKET_CANCEL_REQUEST_INSERT]
	@RES_CODE				CHAR(12)
	
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	IF NOT EXISTS (
	       SELECT 1
	       FROM   MARKET_CANCEL_REQUEST
	       WHERE  RES_CODE = @RES_CODE
	)
	BEGIN
		INSERT INTO MARKET_CANCEL_REQUEST
	    SELECT @RES_CODE
	          ,'N'
	          ,NULL
	          ,GETDATE()
	END
	ELSE
	BEGIN
		UPDATE MARKET_CANCEL_REQUEST
		SET CANCEL_STATE = 'N'
		,EDT_DATE = GETDATE()
		WHERE RES_CODE = @RES_CODE
	END	
	    
END
GO
