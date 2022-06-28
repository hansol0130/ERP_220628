USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_WEB_EVT_ROULETTE_GIFTICON_USE_UPDATE
■ DESCRIPTION				: 기프티콘 발송 상태값 업데이트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-05-20		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_EVT_ROULETTE_GIFTICON_USE_UPDATE]
	@EVT_ROU_SEQ INT,
	@CUS_CODE INT
AS 
BEGIN	
	SET NOCOUNT ON;
	UPDATE EVT_ROULETTE SET GIFT_SEND_YN = 'Y' WHERE EVT_ROU_SEQ = @EVT_ROU_SEQ AND CUS_CODE = @CUS_CODE
END 

GO
