USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_PHONE_AUTH_CONFIRM
■ DESCRIPTION				: 휴대폰 번호 인증 처리 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	XP_WEB_CUS_PHONE_AUTH_CONFIRM  6 , '','010','9185','2481','NWbbtkhH1J2EHJKquZHUXioopVrj4++rQ4KaJ6h6Epo=' ,  '3827','' 

	exec XP_WEB_CUS_PHONE_AUTH_CONFIRM @SEQ_NO=7,@CUS_NAME=N'이혜진',@NOR_TEL1=N'010',@NOR_TEL2=N'5515',@NOR_TEL3=N'1378',@AUTH_KEY=N'HVyt1lTaorhZko2jHTzVDL3rw/WfDGxy7+wFUl7kH+E=',@AUTH_NO=N'7437',@CUS_ID=N'jerryhm',@REMARK=NULL

	exec XP_WEB_CUS_PHONE_AUTH_CONFIRM @SEQ_NO=24,@CUS_NAME='박형만',
		@NOR_TEL1='010',@NOR_TEL2='9185',@NOR_TEL3='2481',
		@AUTH_KEY='LXKo2bRmB9WokvMivvbNLyP8qQ56p3zhaEGdKWl413M=',@AUTH_NO='3535',@REMARK=NULL
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-07-18		박형만			최초생성
   2019-12-18       오준혁           생년월일 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_CUS_PHONE_AUTH_CONFIRM]
	@SEQ_NO		INT,
	@CUS_NAME	VARCHAR(50),
	@BIRTH_DATE DATETIME,
	@NOR_TEL1	VARCHAR(3),
	@NOR_TEL2	VARCHAR(4),
	@NOR_TEL3	VARCHAR(5),
	@AUTH_KEY	VARCHAR(100),
	@AUTH_NO	VARCHAR(10),
	@REMARK VARCHAR(1000),

	@CUS_ID		VARCHAR(20)= NULL
AS 
BEGIN

	-- 인증번호 승인처리 
	-- 기존회원 및 상이한 정보는 BIZ 에서 처리 

	--  결과 업데이트 
	--  중복회원 업데이트
	--  상이한정보시 해당회원 REMARK 에 넣기 

	-- 인증처리 전에 
	-- 실패 결과 처리가 있다면 

	DECLARE @ORG_CUS_NAME     VARCHAR(50)
	       ,@ORG_BIRTH_DATE   DATETIME
	       ,@ORG_NOR_TEL1     VARCHAR(3)
	       ,@ORG_NOR_TEL2     VARCHAR(4)
	       ,@ORG_NOR_TEL3     VARCHAR(5)
	       ,@ORG_AUTH_KEY     VARCHAR(100)
	       ,@ORG_AUTH_NO      VARCHAR(10)
		   -- 비번찾기시만
	       ,@ORG_CUS_ID		  VARCHAR(20)

	DECLARE @AUTH_RESULT     INT
	       ,@AUTH_TYPE       VARCHAR(1)
	
	SET @AUTH_RESULT = -1 

	IF @SEQ_NO > 0 AND EXISTS ( SELECT * FROM CUS_PHONE_AUTH WHERE SEQ_NO = @SEQ_NO)
	BEGIN
		SELECT @ORG_CUS_NAME = CUS_NAME
		      ,@ORG_BIRTH_DATE = BIRTH_DATE
		      ,@ORG_NOR_TEL1 = NOR_TEL1
		      ,@ORG_NOR_TEL2 = NOR_TEL2
		      ,@ORG_NOR_TEL3 = NOR_TEL3
		      ,@ORG_AUTH_KEY = AUTH_KEY
		      ,@ORG_AUTH_NO = AUTH_NO
		      ,@AUTH_TYPE = AUTH_TYPE
		      ,@ORG_CUS_ID = CUS_ID
		FROM   CUS_PHONE_AUTH
		WHERE  SEQ_NO = @SEQ_NO


		SET @AUTH_RESULT = CASE WHEN @ORG_AUTH_KEY <> ISNULL(@AUTH_KEY,'') THEN 1 
			WHEN @ORG_AUTH_NO <> ISNULL(@AUTH_NO,'') THEN 2 
			WHEN @ORG_CUS_NAME <> ISNULL(@CUS_NAME,'') THEN 3
			WHEN @ORG_NOR_TEL1+@ORG_NOR_TEL2+@ORG_NOR_TEL3 <> ISNULL(@NOR_TEL1+@NOR_TEL2+@NOR_TEL3,'')  THEN 4 
			WHEN @ORG_CUS_ID <> @CUS_ID AND ISNULL(@CUS_ID,'') <> '' THEN 5 
			WHEN @ORG_BIRTH_DATE <> ISNULL(@BIRTH_DATE,'') THEN 6
			ELSE 0 END 

		SET @REMARK = CASE WHEN @AUTH_RESULT = 1  THEN '인증키 다름' 
			WHEN @AUTH_RESULT = 2  THEN '인증번호 다름'  
			WHEN @AUTH_RESULT = 3 THEN '요청이름과 다름'  
			WHEN @AUTH_RESULT = 4  THEN '요청휴대폰과 다름'   
			WHEN @AUTH_RESULT = 5  THEN '요청아이디와 다름'   
			WHEN @AUTH_RESULT = 6  THEN '요청생년월일과 다름'
			ELSE NULL END 

		--UPDATE CUS_PHONE_AUTH 
		--SET  AUTH_RESULT = @AUTH_RESULT 
		--	, AUTH_DATE = GETDATE()
		--	, REMARK  = @REMARK 
		--WHERE SEQ_NO = @SEQ_NO 

		-- 인증처리 실패 기타사유로 인한 ( 상이한 정보 및 기존회원 있음) 
		-- 승인실패업데이트 
		
		UPDATE CUS_PHONE_AUTH 
		SET  AUTH_RESULT = @AUTH_RESULT 
		-- 정상인증일때 
		, AUTH_DATE =  GETDATE()  --CASE WHEN /*AUTH_DATE IS NOT NULL and*/ @AUTH_RESULT = 0  THEN GETDATE() END -- 정상일때 인증일 
		--, CUS_RESULT = @CUS_RESULT 
		--, CUS_NO = @CUS_NO 
		--, CUS_ID = @CUS_ID 
		--, DUP_CUS_NO = @DUP_CUS_NO -- 중복검색된 고객들  
		, REMARK = @REMARK  -- 상세사유 
		WHERE SEQ_NO = @SEQ_NO 
		--AND AUTH_KEY = @AUTH_KEY 
	END 

	SELECT @AUTH_RESULT AS AUTH_RESULT  , @REMARK AS REMARK --, @AUTH_TYPE AS AUTH_TYPE , @AUTH_KEY AS AUTH_KEY, @SEQ_NO AS SEQ_NO  

END 


GO
