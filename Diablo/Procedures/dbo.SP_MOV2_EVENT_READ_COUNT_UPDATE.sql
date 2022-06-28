USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_EVENT_READ_COUNT_UPDATE
■ DESCRIPTION				: 수정_이벤트_정보_조회수증가
■ INPUT PARAMETER			: EVT_SEQ
■ EXEC						: 
    -- EXEC SP_MOV2_EVENT_READ_COUNT_UPDATE 5398 

■ MEMO						: 이벤트_정보_조회수증가
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-28		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_EVENT_READ_COUNT_UPDATE]
	@EVT_SEQ		INT
AS
BEGIN
	UPDATE PUB_EVENT SET READ_COUNT = ISNULL(READ_COUNT, 0) + 1 WHERE EVT_SEQ = @EVT_SEQ
END           



GO
