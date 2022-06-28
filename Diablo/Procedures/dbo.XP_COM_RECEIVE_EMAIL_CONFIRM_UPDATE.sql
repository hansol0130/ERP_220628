USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_RECEIVE_EMAIL_CONFIRM_UPDATE
■ DESCRIPTION				: BTMS EMAIL 전송 완료 업데이트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-07		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_RECEIVE_EMAIL_CONFIRM_UPDATE]
	@AGT_CODE		VARCHAR(10),
	@EMAIL_SEQ		INT,
	@RCV_STATE		INT
AS 
BEGIN
	
	UPDATE COM_RECEIVE_EMAIL SET RCV_STATE = @RCV_STATE, CFM_DATE = GETDATE() WHERE AGT_CODE = @AGT_CODE AND EMAIL_SEQ = @EMAIL_SEQ

END 


GO
