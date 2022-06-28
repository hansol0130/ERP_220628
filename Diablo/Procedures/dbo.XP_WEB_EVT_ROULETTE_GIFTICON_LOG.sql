USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_WEB_EVT_ROULETTE_GIFTICON_LOG
■ DESCRIPTION				: 기프티콘 발송 로그
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
CREATE PROC [dbo].[XP_WEB_EVT_ROULETTE_GIFTICON_LOG]
	@LOG_TYPE INT,
	@EVT_ROU_SEQ INT,
	@CUS_CODE INT,
	@TEL_NUMBER VARCHAR(11),
	@ORDER_ID VARCHAR(20),
	@PRD_ID CHAR(8),
	@LOG_MSG VARCHAR(200),
	@NEW_CODE CHAR(7)
	
AS 
BEGIN	
	SET NOCOUNT ON;

	INSERT INTO EVT_ROULETTE_GIFTICON_LOG ( LOG_TYPE, EVT_ROU_SEQ, CUS_CODE, TEL_NUMBER, ORDER_ID, PRD_ID, LOG_MSG, NEW_CODE, NEW_DATE)
	VALUES( @LOG_TYPE, @EVT_ROU_SEQ, @CUS_CODE, @TEL_NUMBER, @ORDER_ID, @PRD_ID, @LOG_MSG, @NEW_CODE, GETDATE() )		
END 
GO
