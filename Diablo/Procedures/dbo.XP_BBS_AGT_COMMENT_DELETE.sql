USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_BBS_AGT_COMMENT_DELETE
■ DESCRIPTION				: 대외업무관리 자유게시판 덧글 삭제
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
CREATE PROCEDURE [dbo].[XP_BBS_AGT_COMMENT_DELETE]
(
	@MASTER_SEQ		INT,
	@BBS_SEQ		INT,
	@COMMENT_SEQ	INT
)
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	UPDATE BBS_DETAIL SET COMMENT_COUNT = (COMMENT_COUNT - 1)
	WHERE MASTER_SEQ = @MASTER_SEQ and BBS_SEQ = @BBS_SEQ

	DELETE FROM BBS_COMMENT
	WHERE MASTER_SEQ = @MASTER_SEQ AND BBS_SEQ = @BBS_SEQ AND COMMENT_SEQ = @COMMENT_SEQ

END





GO
