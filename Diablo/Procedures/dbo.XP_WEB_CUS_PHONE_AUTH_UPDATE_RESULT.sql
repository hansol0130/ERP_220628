USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_PHONE_AUTH_UPDATE_RESULT
■ DESCRIPTION				: 휴대폰 번호 인증 결과 처리 
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
CREATE PROC [dbo].[XP_WEB_CUS_PHONE_AUTH_UPDATE_RESULT]
	@SEQ_NO		INT,
	@AUTH_KEY	VARCHAR(100),
	--@AUTH_NO	VARCHAR(10),
	@CUS_RESULT INT , 
	@CUS_NO INT,
	@DUP_CUS_NO VARCHAR(1000),
	@REMARK VARCHAR(1000)
AS 
BEGIN
	-- 인증처리 실패 기타사유로 인한 ( 상이한 정보 및 기존회원 있음) 
	-- 승인실패업데이트 
	UPDATE CUS_PHONE_AUTH 
	SET  CUS_RESULT = @CUS_RESULT 
	, CUS_NO = @CUS_NO 
	, DUP_CUS_NO = @DUP_CUS_NO -- 중복검색된 고객들  
	, REMARK = @REMARK  -- 상세사유 
	WHERE SEQ_NO = @SEQ_NO 
	AND AUTH_KEY = @AUTH_KEY 

	SELECT @@ROWCOUNT
END 
GO
