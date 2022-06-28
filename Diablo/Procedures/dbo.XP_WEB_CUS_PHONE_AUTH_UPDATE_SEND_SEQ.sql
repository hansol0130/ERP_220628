USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_PHONE_AUTH_UPDATE_SEND_SEQ
■ DESCRIPTION				: 휴대폰 번호 인증 발송 SMS , 알림톡 KEY 갱신 

@ALIM_SEQ  - 알림톡  SN 
@SMS_SEQ - SMS TRAN_PR 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_WEB_CUS_PHONE_AUTH_UPDATE_SEND_SEQ @SEQ_NO=24,@AUTH_KEY=NULL,
		@ALIM_SEQ = , @SMS_SEQ = 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-02-28		박형만			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_CUS_PHONE_AUTH_UPDATE_SEND_SEQ]
	@SEQ_NO		INT,
	@AUTH_KEY	VARCHAR(100),
	--@AUTH_NO	VARCHAR(10),
	@ALIM_SEQ VARCHAR(100) = NULL , -- SN 
	@SMS_SEQ INT = NULL -- TRAN_PR 
AS 
BEGIN
	UPDATE CUS_PHONE_AUTH 
	SET ALIM_SEQ =  @ALIM_SEQ 
	 ,SMS_SEQ =  @SMS_SEQ 
	WHERE SEQ_NO = @SEQ_NO 
	AND AUTH_KEY = @AUTH_KEY 

	SELECT @@ROWCOUNT
END 

GO
