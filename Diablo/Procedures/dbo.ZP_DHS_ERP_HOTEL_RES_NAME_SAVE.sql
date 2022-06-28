USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_DHS_ERP_HOTEL_RES_NAME_SAVE
■ DESCRIPTION					: 수정_홈쇼핑호텔_체크인날짜
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-24		오준혁			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DHS_ERP_HOTEL_RES_NAME_SAVE]
	 @RES_CODE     CHAR(12)
	,@RES_NAME     VARCHAR(40)
	,@NOR_TEL1     VARCHAR(6)
	,@NOR_TEL2     VARCHAR(5)
	,@NOR_TEL3     VARCHAR(4)
	,@PNR_INFO     VARCHAR(MAX)
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	UPDATE dbo.RES_MASTER_damo
	SET    RES_NAME = @RES_NAME
	      ,NOR_TEL1 = @NOR_TEL1
	      ,NOR_TEL2 = @NOR_TEL2
	      ,NOR_TEL3 = @NOR_TEL3
	      ,PNR_INFO = @PNR_INFO
	WHERE  RES_CODE = @RES_CODE
	
END
GO
