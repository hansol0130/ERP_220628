USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_SEND_DELETE
■ DESCRIPTION				: 삭제_큐레이션발송정보
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- EXEC SP_MOV2_CURATION_SEND_DELETE 10
■ MEMO						: 큐레이션발송정보 삭제
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-05		IBSOLUTION			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_SEND_DELETE]
	@HIS_NO						INT
AS
BEGIN

		DELETE FROM CUVE_HISTORY WHERE HIS_NO = @HIS_NO

END           



GO
