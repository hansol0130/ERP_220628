USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_EVT_ROULETTE_GIFTICON_SELECT
■ DESCRIPTION				: 회원의 룰렛이벤트 기프티콘 사용 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
EXEC XP_WEB_EVT_ROULETTE_GIFTICON_SELECT 2, 15
select * from EVT_ROULETTE
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-05-20		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_EVT_ROULETTE_GIFTICON_SELECT]
	@EVT_ROU_SEQ INT,
	@CUS_NO INT
AS 
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 
		COUNT(1)
	FROM EVT_ROULETTE
	WHERE EVT_ROU_SEQ = @EVT_ROU_SEQ AND CUS_CODE = @CUS_NO AND COP_USE_YN = 'Y' AND GIFT_SEND_YN = 'N'
	
END 
GO
