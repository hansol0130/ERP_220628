USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_CLIENT_FILE_INFO_UPDATE
■ DESCRIPTION				: BTMS 거래처 파일 정보 수정
■ INPUT PARAMETER			: AGT_CODE
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
	EXEC XP_COM_CLIENT_FILE_INFO_UPDATE
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-13		저스트고강태영			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_CLIENT_FILE_INFO_UPDATE]
	@AGT_CODE varchar(10), @FILE_SEQ INT,@FILE_NAME varchar(200),@NEW_SEQ INT
AS 
BEGIN
	UPDATE COM_FILE SET
	[FILE_NAME] = @FILE_NAME,
	NEW_DATE = GETDATE(),
	NEW_SEQ = @NEW_SEQ
	WHERE AGT_CODE = @AGT_CODE
	AND FILE_SEQ = @FILE_SEQ
END 

GO
