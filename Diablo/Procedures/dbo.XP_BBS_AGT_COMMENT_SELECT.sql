USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_BBS_AGT_COMMENT_SELECT
■ DESCRIPTION				: 대외업무관리 자유게시판 덧글 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-25		김성호			최초생성
   2013-06-10		김성호			WITH(NOLOCK) 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_BBS_AGT_COMMENT_SELECT]
(
	@MASTER_SEQ		INT,
	@BBS_SEQ		INT,
	@COMMENT_SEQ	INT
)
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT * 
		, DBO.XN_COM_GET_COM_TYPE(A.NEW_CODE) AS [COM_TYPE]
		, DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS [AGT_NAME]
	FROM BBS_COMMENT A WITH(NOLOCK)
	WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BBS_SEQ = @BBS_SEQ AND A.COMMENT_SEQ = @COMMENT_SEQ

END





GO
