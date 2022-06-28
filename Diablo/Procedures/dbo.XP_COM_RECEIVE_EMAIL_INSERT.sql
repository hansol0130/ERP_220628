USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_RECEIVE_EMAIL_INSERT
■ DESCRIPTION				: BTMS EMAIL 전송 저장
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
CREATE PROC [dbo].[XP_COM_RECEIVE_EMAIL_INSERT]
	@AGT_CODE		VARCHAR(10),
	@MAIL_TYPE		INT,
	@EMP_SEQ		INT,
	@SND_EMAIL		VARCHAR(50),
	@SND_EMP_CODE	CHAR(7),
	@RCV_EMAIL		VARCHAR(50),
	@RCV_NAME		VARCHAR(20),
	@TITLE			VARCHAR(100),
	@BODY			VARCHAR(MAX),
	@RCV_STATE		INT,
	@RES_CODE		CHAR(12)
AS 
BEGIN
	DECLARE @EMAIL_SEQ INT;
	SELECT @EMAIL_SEQ = (ISNULL((SELECT MAX(EMAIL_SEQ) FROM COM_RECEIVE_EMAIL A WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE), 0) + 1)

	INSERT INTO COM_RECEIVE_EMAIL ( AGT_CODE, EMAIL_SEQ, MAIL_TYPE, EMP_SEQ, SND_EMAIL, SND_EMP_CODE, RCV_EMAIL, RCV_NAME, TITLE, BODY, RCV_STATE, RCV_DATE, CFM_DATE, RES_CODE )
	VALUES ( @AGT_CODE, @EMAIL_SEQ, @MAIL_TYPE, @EMP_SEQ, @SND_EMAIL, @SND_EMP_CODE, @RCV_EMAIL, @RCV_NAME, @TITLE, @BODY, @RCV_STATE, GETDATE(), NULL, @RES_CODE )
	
	SELECT @EMAIL_SEQ;
END 


GO
