USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_PHONE_AUTH_INSERT
■ DESCRIPTION				: 휴대폰 번호 인증 등록(및수정)
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-07-18		박형만			최초생성
   2019-12-18       오준혁           생년월일 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_CUS_PHONE_AUTH_INSERT]
	@SEQ_NO	INT =0 ,
	@CUS_NAME	VARCHAR(50),
	@BIRTH_DATE DATETIME,
	@NOR_TEL1	VARCHAR(3),
	@NOR_TEL2	VARCHAR(4),
	@NOR_TEL3	VARCHAR(5),
	@CUS_NO		INT,
	@AUTH_KEY	VARCHAR(100),
	@AUTH_NO	VARCHAR(10),
	@AUTH_TYPE	INT,
	@SNS_COM_ID	INT,
	@CLIENT_IP	VARCHAR(20),
	@CUS_ID		VARCHAR(20),
	@REMARK		VARCHAR(1000)
AS 
BEGIN

 


--SELECT RETRY_CNT FROM CUS_PHONE_AUTH 
--WHERE SEQ_NO = 7

--SELECT RETRY_CNT FROM CUS_PHONE_AUTH 
--WHERE CUS_NAME = '박형만' AND NOR_TEL1 = '010' AND NOR_TEL2 = '9185' AND NOR_TEL3 = '2481'
--AND NEW_DATE > DATEADD( MI , -5 ,  GETDATE())  
--AND NEW_DATE < GETDATe()


	--SELECT DATEADD( MI , -5 ,  GETDATE()) 
	-- 등록전 체크 
	-- 하나의 요청에 10건 이상 재전송 
	IF( SELECT RETRY_CNT FROM CUS_PHONE_AUTH 
		WHERE SEQ_NO = @SEQ_NO ) >= 10 
	BEGIN
		SELECT 0 AS SEQ_NO , NULL AS AUTH_KEY , 91 AS AUTH_RESULT  -- 재전송 횟수 초과 
		RETURN  -- 종료 
	END 
	-- 단기간내에 많이 요청한 사람 BAN  
	-- 5분내 20건 ? 
	IF( SELECT SUM(ISNULL(RETRY_CNT,1)) FROM CUS_PHONE_AUTH 
		WHERE CUS_NAME = @CUS_NAME AND BIRTH_DATE = @BIRTH_DATE AND NOR_TEL1 = @NOR_TEL1 AND NOR_TEL2 = @NOR_TEL2 AND NOR_TEL3 = @NOR_TEL3
		AND NEW_DATE > DATEADD( MI , -5 ,  GETDATE())  
		AND NEW_DATE < GETDATe()) >= 20 
	BEGIN
		SELECT 0 AS SEQ_NO , NULL AS AUTH_KEY , 92 AS AUTH_RESULT  -- 단기간 많은 요청 
		RETURN -- 종료 
	END 

	--AND DATEADD( MI , -5 ,  GETDATE())  
	--AND DATADD(GETDATE() 


	--최초 인증번호 전송 클릭 
	-- 인증번호 재요청시 기준이 바뀌면 다시 생성 
	IF @SEQ_NO = 0 
	   OR ( @SEQ_NO > 0 AND NOT EXISTS ( SELECT * FROM CUS_PHONE_AUTH 
			WHERE SEQ_NO = @SEQ_NO AND CUS_NAME = @CUS_NAME AND BIRTH_DATE = @BIRTH_DATE AND NOR_TEL1 = @NOR_TEL1 AND NOR_TEL2 = @NOR_TEL2 AND NOR_TEL3 = @NOR_TEL3) ) 
	BEGIN
		INSERT INTO CUS_PHONE_AUTH ( CUS_NAME, BIRTH_DATE,NOR_TEL1,NOR_TEL2,NOR_TEL3,CUS_NO,AUTH_KEY,AUTH_NO,AUTH_TYPE,SNS_COM_ID,CLIENT_IP,CUS_ID)
		VALUES (@CUS_NAME,@BIRTH_DATE , @NOR_TEL1,@NOR_TEL2,@NOR_TEL3,@CUS_NO,@AUTH_KEY,@AUTH_NO,@AUTH_TYPE,@SNS_COM_ID,@CLIENT_IP,@CUS_ID) 	

		SELECT @@IDENTITY AS SEQ_NO , @AUTH_KEY AS AUTH_KEY , 0 AS AUTH_RESULT 
	END 
	ELSE 
	BEGIN
		--인증번호 재요청 클릭 (기존 seQ_no AUTH_KEY 업데이트  ) 
		-- BIZ 에서 이름, 휴대폰 번호가 바뀌지 않았을때만 처리 

		UPDATE CUS_PHONE_AUTH 
		SET AUTH_KEY = @AUTH_KEY 
		 , AUTH_NO = @AUTH_NO
		 , EDT_DATE = GETDATE() 
		 -- 상태 초기화 
		 , AUTH_RESULT = NULL 
		 , AUTH_DATE = NULL 
		 , RETRY_CNT = ISNULL(RETRY_CNT,0) +1 
		 , CUS_ID = @CUS_ID
		 , CUS_NO = @CUS_NO 
		WHERE SEQ_NO = @SEQ_NO 

		SELECT @SEQ_NO AS  SEQ_NO , @AUTH_KEY AS AUTH_KEY  , 0 AS AUTH_RESULT 
	END 
END 

GO
