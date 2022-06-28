USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_WEB_EVT_ROULETTE_CNT
■ DESCRIPTION				: 회원의 룰렛이벤트 카운트를 조회한다.
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-05-16		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_EVT_ROULETTE_CNT]
	@CUS_NO INT
AS 
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 
		COUNT(1)
	FROM EVT_ROULETTE
	WHERE CUS_CODE = @CUS_NO AND COP_USE_YN = 'N'
	
END 

GO
