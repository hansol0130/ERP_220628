USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_SAFE_INFO_TRAVEL_NOTICE_DETAIL_UPDATE
■ DESCRIPTION				: 안전 정보 국가별 공지사항 상세내용 업데이트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-14		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_SAFE_INFO_TRAVEL_NOTICE_DETAIL_UPDATE]
	@ID VARCHAR(20),
	@CONTENTS_HTML VARCHAR(MAX),
	@CONTENTS VARCHAR(3000)

AS 
BEGIN
	UPDATE SAFE_INFO_COUNTRY_NOTICE SET
		CONTENTS_HTML = @CONTENTS_HTML,
		CONTENTS = @CONTENTS
	WHERE ID = @ID AND CONTENTS_HTML IS NULL AND CONTENTS IS NULL;
END


GO
