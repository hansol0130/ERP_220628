USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_BBS_AGT_BOARD_FILE_DELETE
■ DESCRIPTION				: 대외업무시스템 게시물 파일 삭제
■ INPUT PARAMETER			: 
	@MASTER_SEQ		INT		:		마스터 순번
	@BBS_SEQ		INT		:		게시물 순번
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

CREATE PROCEDURE [dbo].[XP_BBS_AGT_BOARD_FILE_DELETE]
	
	@MASTER_SEQ		INT,
	@BBS_SEQ		INT
	--@NEW_CODE		CHAR(7)
AS
BEGIN
	SET NOCOUNT OFF;

	--IF ISNULL(@MASTER_SEQ, 0) = 0
	--BEGIN
	--	SELECT @MASTER_SEQ = MASTER_SEQ FROM BBS_MASTER_AGT_LINK WHERE AGT_CODE IN (SELECT AGT_CODE FROM AGT_MEMBER WHERE MEM_CODE = @NEW_CODE)
	--END
		
	BEGIN

		DELETE BBS_FILE WHERE BBS_SEQ = @BBS_SEQ AND MASTER_SEQ = @MASTER_SEQ

	END
END


GO
