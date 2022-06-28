USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_EVT_RECOMMEND_ADSYNC_INSERT
■ DESCRIPTION					: 애드싱크 리워드키 입력
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
   2020-07-14		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_EVT_RECOMMEND_ADSYNC_INSERT]
	@CUS_NO					INT,
	@UID_NUM			VARCHAR(100),
	@AD_NO				VARCHAR(100),
	@REWARD_KEY			VARCHAR(100)
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	INSERT INTO EVT_RECOMMEND_ADSYNC
	SELECT @CUS_NO
		  ,@UID_NUM
		  ,@AD_NO
		  ,@REWARD_KEY
		  ,GETDATE()
END
GO
