USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_RECEIVE_SMS_CONFIRM_UPDATE
■ DESCRIPTION				: BTMS SMS 수신결과 수정
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
CREATE PROC [dbo].[XP_COM_RECEIVE_SMS_CONFIRM_UPDATE]
	@AGT_CODE		VARCHAR(10),
	@SMS_SEQ		INT,
	@RCV_STATE		INT
AS 
BEGIN
	
	UPDATE COM_RECEIVE_SMS SET RCV_STATE = @RCV_STATE WHERE AGT_CODE = @AGT_CODE AND SMS_SEQ = @SMS_SEQ

END 


GO
