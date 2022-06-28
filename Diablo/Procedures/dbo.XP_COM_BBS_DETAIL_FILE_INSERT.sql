USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BBS_DETAIL_FILE_INSERT
■ DESCRIPTION				: 게시물 파일 재등록
■ INPUT PARAMETER			: 
	@XML NVARCHAR(MAX)		: BoardFileRS 클래스의 SerializeXml 문자열
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC XP_COM_BBS_DETAIL_FILE_INSERT 1, 1406, ''
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-27		저스트고-백경훈		최초생성   
================================================================================================================*/ 
 CREATE PROCEDURE [dbo].[XP_COM_BBS_DETAIL_FILE_INSERT]
(
	@MASTER_SEQ	INT,
	@BOARD_SEQ	INT,
	@XML		NVARCHAR(MAX)
) 
AS 
BEGIN

	-- 기존 파일 삭제
	DELETE FROM COM_BBS_FILE WHERE MASTER_SEQ = @MASTER_SEQ AND BOARD_SEQ = @BOARD_SEQ

	IF ISNULL(@XML, '') <> ''
	BEGIN
		DECLARE @DOCHANDLE INT

		EXEC SP_XML_PREPAREDOCUMENT @DOCHANDLE OUTPUT, @XML;

		INSERT INTO COM_BBS_FILE (MASTER_SEQ, BOARD_SEQ, FILE_SEQ, [FILE_NAME], FILE_PATH)
		SELECT A.MASTER_SEQ, A.BOARD_SEQ, ROW_NUMBER() OVER (ORDER BY [FILE_NAME]) AS [FILE_SEQ], A.[FILE_NAME], A.FILE_PATH
		FROM
		OPENXML(@DOCHANDLE, N'/ArrayOfBoardFileRS/BoardFileRS', 0)
		WITH
		(
			MASTER_SEQ	INT				'./MasterSeq',
			BOARD_SEQ	INT				'./BoardSeq',
			--FILE_SEQ	INT				'./FileSeq',
			[FILE_NAME]	NVARCHAR(500)	'./FileName',
			FILE_PATH	NVARCHAR(500) 	'./FilePath'
		) A

		EXEC SP_XML_REMOVEDOCUMENT @DOCHANDLE
	END

END
GO
