USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME						: ZP_VACCOUNT_DEPOSIT_INSERT
■ DESCRIPTION					: 호텔 가상계좌 입금
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    :
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2021-04-26		오준혁			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_VACCOUNT_DEPOSIT_INSERT]
	@RESV_NO	VARCHAR(20),
	@TRANS_NO	VARCHAR(20),		
	@PAY_USER	VARCHAR(20),		
	@PRICE		INT
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	EXEC JGHotel.dbo.VACCOUNT_DEPOSIT_INSERT 
		@RESV_NO,
		@TRANS_NO,
		@PAY_USER,
		@PRICE
	

END
GO
