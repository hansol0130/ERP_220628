USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BTMS_BOARD_AGENT_DELETE
■ DESCRIPTION				: BTMS 공지 게시판 거래처 삭제
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE					AUTHOR				DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-05-18		저스트고이유라			최초 생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BTMS_BOARD_AGENT_DELETE]
	@MASTER_SEQ		INT,
	@BOARD_SEQ		INT
AS 
BEGIN

DELETE FROM COM_BBS_NOTICE WHERE MASTER_SEQ = @MASTER_SEQ AND BOARD_SEQ = @BOARD_SEQ

END

GO
