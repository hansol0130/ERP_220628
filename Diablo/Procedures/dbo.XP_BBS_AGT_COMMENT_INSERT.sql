USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_BBS_AGT_COMMENT_INSERT
■ DESCRIPTION				: 대외업무관리 자유게시판 덧글입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
	@BBS_SEQ INT OUTPUT		: 게시판 순번 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-25		김성호			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_BBS_AGT_COMMENT_INSERT]
(
	@MASTER_SEQ		INT,
	@BBS_SEQ		INT,
	@COMMENT_SEQ	INT OUTPUT,
	@CONTENTS		VARCHAR(3000),
	@TEAM_CODE		VARCHAR(3),
	@TEAM_NAME		VARCHAR(50),
	@NEW_CODE		VARCHAR(7),
	@NEW_NAME		VARCHAR(20)
)
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT TOP 1 @COMMENT_SEQ  = ISNULL(MAX(COMMENT_SEQ),0) + 1 FROM BBS_COMMENT   WITH (UPDLOCK)  WHERE BBS_SEQ = @BBS_SEQ AND MASTER_SEQ = @MASTER_SEQ
	
	INSERT INTO BBS_COMMENT (MASTER_SEQ, BBS_SEQ, COMMENT_SEQ, CONTENTS, TEAM_CODE, TEAM_NAME, NEW_CODE, NEW_NAME, NEW_DATE)
	VALUES (@MASTER_SEQ, @BBS_SEQ, @COMMENT_SEQ, @CONTENTS, @TEAM_CODE, @TEAM_NAME, @NEW_CODE, @NEW_NAME, GETDATE())
	
	UPDATE BBS_DETAIL SET COMMENT_COUNT = COMMENT_COUNT + 1 WHERE BBS_SEQ=@BBS_SEQ AND MASTER_SEQ=@MASTER_SEQ
END



GO
