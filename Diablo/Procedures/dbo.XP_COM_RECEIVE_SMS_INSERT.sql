USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_RECEIVE_SMS_INSERT
■ DESCRIPTION				: BTMS SMS 전송 저장
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
CREATE PROC [dbo].[XP_COM_RECEIVE_SMS_INSERT]
	@AGT_CODE		VARCHAR(10),
	@SND_NUMBER		VARCHAR(20),
	@SND_EMP_CODE	CHAR(7),
	@RCV_NUMBER		VARCHAR(20),
	@RCV_NAME		VARCHAR(20),
	@EMP_SEQ		INT,
	@BODY			VARCHAR(500),
	@RCV_STATE		INT,
	@RES_CODE		CHAR(12)
AS 
BEGIN
	DECLARE @SMS_SEQ INT;
	SELECT @SMS_SEQ = (ISNULL((SELECT MAX(SMS_SEQ) FROM COM_RECEIVE_SMS A WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE), 0) + 1)

	INSERT INTO COM_RECEIVE_SMS ( AGT_CODE, SMS_SEQ, SND_NUMBER, SND_EMP_CODE, RCV_NUMBER, RCV_NAME, EMP_SEQ, BODY, RCV_STATE, RCV_DATE, RES_CODE )
	VALUES ( @AGT_CODE, @SMS_SEQ, @SND_NUMBER, @SND_EMP_CODE, @RCV_NUMBER, @RCV_NAME,  @EMP_SEQ, @BODY, @RCV_STATE, GETDATE(), @RES_CODE )
	
	SELECT @SMS_SEQ;
END 


GO
