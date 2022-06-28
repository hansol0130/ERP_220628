USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_PHONE_AUTH_UPDATE_COMP
■ DESCRIPTION				: 휴대폰 번호 인증 회원가입 완료
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_WEB_CUS_PHONE_AUTH_UPDATE_RESULT @SEQ_NO=24,@AUTH_KEY=NULL,@AUTH_NO=NULL,@AUTH_RESULT=0,@CUS_RESULT=-1,
		@DUP_CUS_NO='10630028,10286950',@REMARK=NULL

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-07-18		박형만			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_CUS_PHONE_AUTH_UPDATE_COMP]
	@SEQ_NO		INT,
	@AUTH_KEY	VARCHAR(100),
	--@AUTH_NO	VARCHAR(10),
	@CUS_ID VARCHAR(20),
	@REMARK VARCHAR(1000) = NULL 
AS 
BEGIN
	UPDATE CUS_PHONE_AUTH 
	SET  CUS_ID = CASE WHEN ISNULL(@CUS_ID,'') <> '' THEN @CUS_ID ELSE CUS_ID END -- 아이디 변수가 들어 왔을때만
	, COMP_YN = 'Y'  
	, REMARK  = ISNULL(@REMARK,'') 
	WHERE SEQ_NO = @SEQ_NO 
	AND AUTH_KEY = @AUTH_KEY 

	SELECT @@ROWCOUNT
END 



GO
