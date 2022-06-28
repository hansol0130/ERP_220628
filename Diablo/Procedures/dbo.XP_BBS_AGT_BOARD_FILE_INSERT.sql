USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_BBS_AGT_BOARD_FILE_INSERT
■ DESCRIPTION				: 대외업무시스템 게시물 파일 등록
■ INPUT PARAMETER			: 
	@MASTER_SEQ		INT		:		마스터 순번
	@BBS_SEQ		INT		:		게시물 순번
	@FILE_SEQ		INT		:		파일 순번
	@FILENAME		VARCHAR(100)	파일명
	@FILEURL		VARCHAR(200)	파일 URL
	@NEW_CODE		CHAR(7)			작성자
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-12		김성호			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_BBS_AGT_BOARD_FILE_INSERT]
	
	@MASTER_SEQ		INT,
	@BBS_SEQ		INT,
	@FILE_SEQ		INT,
	@FILENAME		VARCHAR(100),
	@FILEURL		VARCHAR(200)
--	@NEW_CODE		CHAR(7)
AS
BEGIN
	SET NOCOUNT OFF;

	--IF ISNULL(@MASTER_SEQ, 0) = 0
	--BEGIN
	--	SELECT @MASTER_SEQ = MASTER_SEQ FROM BBS_MASTER_AGT_LINK WHERE AGT_CODE IN (SELECT AGT_CODE FROM AGT_MEMBER WHERE MEM_CODE = @NEW_CODE)
	--END
		
	BEGIN

		INSERT INTO BBS_FILE (
			FILE_SEQ, BBS_SEQ, MASTER_SEQ, [FILENAME], FILEURL
		) VALUES (
			@FILE_SEQ, @BBS_SEQ, @MASTER_SEQ, @FILENAME, @FILEURL
		)

	END
END



GO
