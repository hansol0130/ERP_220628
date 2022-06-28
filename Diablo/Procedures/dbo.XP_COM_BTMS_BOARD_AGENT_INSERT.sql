USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BTMS_BOARD_AGENT_INSERT
■ DESCRIPTION				: BTMS 공지 게시판 거래처 입력
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
CREATE PROC [dbo].[XP_COM_BTMS_BOARD_AGENT_INSERT]
	@MASTER_SEQ		INT,
	@BOARD_SEQ		INT,
	@SEQNO			INT,
	@AGT_CODE		VARCHAR(10),
	@AGT_NAME		VARCHAR(50),
	@EMP_CODE		INT
AS 
BEGIN

	INSERT INTO COM_BBS_NOTICE
	(
		MASTER_SEQ,
		BOARD_SEQ,
		SEQNO,
		AGT_CODE,
		AGT_NAME,
		EMP_CODE
	)
	VALUES
	(
		@MASTER_SEQ,
		@BOARD_SEQ,
		@SEQNO,
		@AGT_CODE,
		@AGT_NAME,
		@EMP_CODE
	)
END



GO
