USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_EVENT_INFO_SELECT
■ DESCRIPTION				: 검색_이벤트_정보
■ INPUT PARAMETER			: EVT_SEQ
■ EXEC						: 
    -- EXEC SP_MOV2_EVENT_INFO_SELECT 5398 

■ MEMO						: 이벤트 정보 가져한다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-28		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_EVENT_INFO_SELECT]
	@EVT_SEQ		INT
AS
BEGIN
	SELECT * FROM PUB_EVENT WITH(NOLOCK) WHERE EVT_SEQ = @EVT_SEQ
END           



GO
