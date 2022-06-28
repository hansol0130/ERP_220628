USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_CLIENT_FILE_INFO_INSERT
■ DESCRIPTION				: BTMS 거래처 파일 정보 입력
■ INPUT PARAMETER			: AGT_CODE
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
	EXEC XP_COM_CLIENT_FILE_INFO_INSERT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-13		저스트고강태영			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_CLIENT_FILE_INFO_INSERT]
	@AGT_CODE varchar(10), @FILE_SEQ INT,@FILE_NAME varchar(200),@NEW_SEQ INT
AS 
BEGIN
		INSERT INTO COM_FILE
		(
			AGT_CODE,
			FILE_SEQ,
			[FILE_NAME],
			NEW_DATE,
			NEW_SEQ
		)
		VALUES
		(
			@AGT_CODE,
			@FILE_SEQ,
			@FILE_NAME,
			GETDATE(),
			@NEW_SEQ
		)
END 
GO
