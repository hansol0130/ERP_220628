USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PRI_NOTE_RECEIPT_INSERT
■ DESCRIPTION				: 대외업무시스템 사내메일 수신자 등록
■ INPUT PARAMETER			: 
	@NOTE_SEQ_NO	INT,
	@RCV_SEQ_NO		INT,
	@EMP_CODE		CHAR(7),
	@RCV_TYPE		CHAR(1),
	@TEAM_NAME		VARCHAR(20)
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-02-20		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_PRI_NOTE_RECEIPT_INSERT]
(
	@NOTE_SEQ_NO	INT,
	@RCV_SEQ_NO		INT,
	@EMP_CODE		CHAR(7),
	@RCV_TYPE		CHAR(1),
	@TEAM_NAME		VARCHAR(50)
)
AS  
BEGIN

	INSERT INTO PRI_NOTE_RECEIPT
	(NOTE_SEQ_NO, RCV_SEQ_NO, EMP_CODE, RCV_TYPE, TEAM_NAME,SEND_CAT_SEQ_NO)
	VALUES
	(@NOTE_SEQ_NO, @RCV_SEQ_NO, @EMP_CODE, @RCV_TYPE, @TEAM_NAME, 0)

END


GO
