USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_EVT_RECOMMEND_ADSYNC_RETURN_INSERT
■ DESCRIPTION					: 애드싱크 리턴값 입력
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    :
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2020-07-15		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_EVT_RECOMMEND_ADSYNC_RETURN_INSERT]
	@SEQ					INT,
	@CUS_NO					INT,
	@CUS_NO_RECOM			INT,
	@URL_VALUE				VARCHAR(1000),
	@RETURN_VALUE			VARCHAR(1000)
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	INSERT INTO EVT_RECOMMEND_ADSYNC_RETURN
	SELECT @SEQ
		  ,@CUS_NO
		  ,@CUS_NO_RECOM
		  ,@URL_VALUE
		  ,@RETURN_VALUE
		  ,GETDATE()
END
GO
