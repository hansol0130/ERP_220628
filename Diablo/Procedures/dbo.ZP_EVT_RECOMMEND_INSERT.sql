USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_EVT_RECOMMEND_INSERT
■ DESCRIPTION					: 친구추천 추천 입력
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
   2020-06-18		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_EVT_RECOMMEND_INSERT]
	@CUS_NO					INT,
	@CUS_NO_RECOM			INT
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	INSERT INTO EVT_RECOMMEND
	SELECT @CUS_NO
		  ,@CUS_NO_RECOM
		  ,GETDATE()
END
GO
