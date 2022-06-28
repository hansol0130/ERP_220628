USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_BBS_AGT_BOARD_FILE_SELECT
■ DESCRIPTION				: 대외업무시스템 게시판 게시물 파일 검색
■ INPUT PARAMETER			: 
	@MASTER_SEQ		INT		: 사내메일 순번
	@BBS_SEQ		INT		: 수신자 순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_BBS_AGT_BOARD_FILE_SELECT 41, 2807

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-03		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_BBS_AGT_BOARD_FILE_SELECT]
(
	@MASTER_SEQ		INT,
	@BBS_SEQ		INT
)
AS  
BEGIN

	SELECT * FROM BBS_FILE A WITH(NOLOCK)
	WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BBS_SEQ = @BBS_SEQ

END

GO
