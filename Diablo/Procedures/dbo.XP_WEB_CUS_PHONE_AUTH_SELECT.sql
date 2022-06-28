USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_PHONE_AUTH_SELECT
■ DESCRIPTION				: 휴대폰 번호 인증 결과 조회  
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	XP_WEB_CUS_PHONE_AUTH_SELECT  6 , '','010','9185','2481','NWbbtkhH1J2EHJKquZHUXioopVrj4++rQ4KaJ6h6Epo=' ,  '3827','' 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-07-18		박형만			최초생성
================================================================================================================*/ 
create PROC [dbo].[XP_WEB_CUS_PHONE_AUTH_SELECT]
	@SEQ_NO		INT,
	@AUTH_KEY	VARCHAR(100)
AS 
BEGIN
	-- 인증처리 실패 기타사유로 인한 ( 상이한 정보 및 기존회원 있음) 
	-- 승인실패업데이트 
	SELECT * FROM  CUS_PHONE_AUTH 
	WHERE SEQ_NO = @SEQ_NO 
	AND AUTH_KEY = @AUTH_KEY 
END 

GO
