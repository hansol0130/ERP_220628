USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_CUS_CLEAR_TARGET_UPDATE
■ DESCRIPTION				: 고객정보 매핑 통합 대상 회원 테이블 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 


------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2018-05-17		박형만			최초생성 
	2021-05-03		김영민			기존정보갱신일때 BIRTH_DATE 값 입력해주도록 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_CUS_CLEAR_TARGET_UPDATE]
	--@ERROR_MSG		VARCHAR(1000) OUTPUT,
	@RES_CODE	RES_CODE,
	@SEQ_NO	INT,
	@STATUS INT,
	@MERGE_INFO VARCHAR(1000),
	@EMP_CODE	EMP_CODE =NULL,
	@COMP_YN CHAR(1) = NULL ,
	@REMARK	VARCHAR(1000) = NULL ,

	@NEW_CUS_NO INT

AS
BEGIN

	---- 신규 정보 생성 은 biz 에서  처리 
	--IF( @OLD_CUS_NO = 1 )
	--BEGIN
	--	INSERT INTO 
	--END 

	--생년월일
		DECLARE @BIRTHDAY DATETIME
	 SET @BIRTHDAY = ISNULL(ISNULL((SELECT BIRTH_DATE  FROM VIEW_MEMBER WHERE CUS_NO = @NEW_CUS_NO),(SELECT BIRTH_DATE  FROM CUS_CUSTOMER_damo WHERE CUS_NO = @NEW_CUS_NO)),NULL)

	-- 새로운거 없이 기존 CUS_NO 유지 
	--IF @NEW_CUS_NO = 0 
	--BEGIN 

	IF( @STATUS <> 3 )
	BEGIN
		-- 예약자 
		IF( @SEQ_NO =0 )
		BEGIN
			IF( @NEW_CUS_NO > 0 )
			BEGIN
				UPDATE RES_MASTER_DAMO 
				SET CUS_NO = @NEW_CUS_NO 
				WHERE RES_CODE = @RES_CODE

				-- 고객 테이블에 없고
				-- 예약자 정보에 있을 경우 갱신 ( 예약자->고객정보)
				UPDATE A 
				SET A.GENDER = (CASE WHEN ISNULL(A.GENDER,'') = '' AND ISNULL(B.GENDER,'') <> ''  THEN  B.GENDER ELSE A.GENDER END) 
				, A.BIRTH_DATE = (CASE WHEN A.BIRTH_DATE IS NULL AND B.BIRTH_DATE IS NOT NULL  THEN  B.BIRTH_DATE ELSE A.BIRTH_DATE END )
				, A.NOR_TEL1 = CASE WHEN  ISNULL(A.NOR_TEL1,'') = '' AND ISNULL(B.NOR_TEL1,'') <> ''  THEN  B.NOR_TEL1 ELSE A.NOR_TEL1 END 
				, A.NOR_TEL2 = CASE WHEN  ISNULL(A.NOR_TEL2,'') = '' AND ISNULL(B.NOR_TEL2,'') <> ''  THEN  B.NOR_TEL2 ELSE A.NOR_TEL2 END 
				, A.NOR_TEL3 = CASE WHEN  ISNULL(A.NOR_TEL3,'') = '' AND ISNULL(B.NOR_TEL3,'') <> ''  THEN  B.NOR_TEL3 ELSE A.NOR_TEL3 END 
				, A.EMAIL = CASE WHEN  ISNULL(A.EMAIL,'') = '' AND ISNULL(B.RES_EMAIL,'') <> ''  THEN  B.RES_EMAIL ELSE A.EMAIL END  
				--, A.SEC_PASS_NUM = CASE WHEN  ISNULL(A.SEC_PASS_NUM,'') = '' AND ISNULL(B.SEC_PASS_NUM,'') <> ''  THEN  B.SEC_PASS_NUM ELSE A.SEC_PASS_NUM END  -- 여권번호 추가!
				FROM CUS_CUSTOMER_DAMO A 
					LEFT JOIN RES_MASTER_DAMO B
						ON	B.RES_CODE = @RES_CODE
				WHERE A.CUS_NO = @NEW_CUS_NO

			END 
			
		END 
		ELSE 
		BEGIN
			IF( @NEW_CUS_NO > 0 )
			BEGIN
				UPDATE RES_CUSTOMER_DAMO 
				SET CUS_NO = @NEW_CUS_NO 
				,BIRTH_DATE = @BIRTHDAY
				WHERE RES_CODE = @RES_CODE
				AND  SEQ_NO = @SEQ_NO 


				-- 고객 테이블에 없고
				-- 출발자 정보에 있을 경우 갱신 ( 출발자->고객정보)
				UPDATE A 
				SET A.GENDER = CASE WHEN ISNULL(A.GENDER,'') = '' AND ISNULL(B.GENDER,'') <> ''  THEN  B.GENDER ELSE A.GENDER END 
				, A.BIRTH_DATE = CASE WHEN A.BIRTH_DATE IS NULL AND B.BIRTH_DATE IS NOT NULL  THEN  B.BIRTH_DATE ELSE A.BIRTH_DATE END 
				, A.NOR_TEL1 = CASE WHEN  ISNULL(A.NOR_TEL1,'') = '' AND ISNULL(B.NOR_TEL1,'') <> ''  THEN  B.NOR_TEL1 ELSE A.NOR_TEL1 END 
				, A.NOR_TEL2 = CASE WHEN  ISNULL(A.NOR_TEL2,'') = '' AND ISNULL(B.NOR_TEL2,'') <> ''  THEN  B.NOR_TEL2 ELSE A.NOR_TEL2 END 
				, A.NOR_TEL3 = CASE WHEN  ISNULL(A.NOR_TEL3,'') = '' AND ISNULL(B.NOR_TEL3,'') <> ''  THEN  B.NOR_TEL3 ELSE A.NOR_TEL3 END 
				, A.EMAIL = CASE WHEN  ISNULL(A.EMAIL,'') = '' AND ISNULL(B.EMAIL,'') <> ''  THEN  B.EMAIL ELSE A.EMAIL END 

				, A.LAST_NAME = CASE WHEN  ISNULL(A.LAST_NAME,'') = '' AND ISNULL(B.LAST_NAME,'') <> ''  THEN  B.LAST_NAME ELSE A.LAST_NAME END 
				, A.FIRST_NAME = CASE WHEN  ISNULL(A.FIRST_NAME,'') = '' AND ISNULL(B.FIRST_NAME,'') <> ''  THEN  B.FIRST_NAME ELSE A.FIRST_NAME END 

				--damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM',damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM', SEC_SOC_NUM2) )
				--damo.dbo.pred_meta_plain_v(@PASS_NUM, 'DIABLO', 'dbo.CUS_CUSTOMER', 'PASS_NUM') ,
				
				, A.SEC_PASS_NUM = CASE WHEN  A.SEC_PASS_NUM IS NULL AND B.SEC_PASS_NUM IS NOT NULL 
					THEN damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM',UPPER(damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM', B.SEC_PASS_NUM)) )
					ELSE damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM',UPPER(damo.dbo.dec_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM', A.SEC_PASS_NUM)) ) END    -- 여권번호 추가!

				, A.SEC1_PASS_NUM = CASE WHEN  A.SEC_PASS_NUM IS NULL AND B.SEC_PASS_NUM IS NOT NULL 
					THEN damo.dbo.pred_meta_plain_v(UPPER(damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM', B.SEC_PASS_NUM)) ,'DIABLO', 'dbo.CUS_CUSTOMER', 'PASS_NUM')
					ELSE damo.dbo.pred_meta_plain_v(UPPER(damo.dbo.dec_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM', A.SEC_PASS_NUM)) ,'DIABLO', 'dbo.CUS_CUSTOMER', 'PASS_NUM') END    -- 여권번호 추가!

				, A.PASS_EXPIRE = CASE WHEN  A.PASS_EXPIRE IS NULL AND B.PASS_EXPIRE IS NOT NULL 
					THEN B.PASS_EXPIRE ELSE A.PASS_EXPIRE END 

				--, A.CUS_NO = @NEW_CUS_NO 
				FROM CUS_CUSTOMER_DAMO A 
					LEFT JOIN RES_CUSTOMER_DAMO B
						ON B.RES_CODE = @RES_CODE
						AND  B.SEQ_NO = @SEQ_NO 
				WHERE A.CUS_NO = @NEW_CUS_NO
			END 
		END 
	 
	END 

	--END 

	--ELSE 
	--BEGIN 
	--	-- 예약/출발자 기본정보 갱신 
	--	-- 예약자 
	--	IF( @SEQ_NO =0 )
	--	BEGIN 
	--		-- 현재 테이블에 없고,
	--		-- 새로운 CUS_NO 로 부터 새로운 정보가 있을경우 갱신 (고객정보->예약자)
	--		UPDATE A 
	--			SET A.GENDER = CASE WHEN ISNULL(A.GENDER,'') = '' AND ISNULL(B.GENDER,'') <> ''  THEN  B.GENDER ELSE A.GENDER END 
	--			, A.BIRTH_DATE = CASE WHEN A.BIRTH_DATE IS NULL AND B.BIRTH_DATE IS NOT NULL  THEN  B.BIRTH_DATE ELSE A.BIRTH_DATE END 
	--			, A.NOR_TEL1 = CASE WHEN  ISNULL(A.NOR_TEL1,'') = '' AND ISNULL(B.NOR_TEL1,'') <> ''  THEN  B.NOR_TEL1 ELSE A.NOR_TEL1 END 
	--			, A.NOR_TEL2 = CASE WHEN  ISNULL(A.NOR_TEL2,'') = '' AND ISNULL(B.NOR_TEL2,'') <> ''  THEN  B.NOR_TEL2 ELSE A.NOR_TEL2 END 
	--			, A.NOR_TEL3 = CASE WHEN  ISNULL(A.NOR_TEL3,'') = '' AND ISNULL(B.NOR_TEL3,'') <> ''  THEN  B.NOR_TEL3 ELSE A.NOR_TEL3 END 
	--			, A.RES_EMAIL = CASE WHEN  ISNULL(A.RES_EMAIL,'') = '' AND ISNULL(B.EMAIL,'') <> ''  THEN  B.EMAIL ELSE A.RES_EMAIL END 
	--			, A.CUS_NO = @NEW_CUS_NO 
	--		FROM RES_MASTER_DAMO A 
	--			INNER JOIN CUS_CUSTOMER_DAMO B
	--				ON B.CUS_NO = @NEW_CUS_NO 
	--		WHERE A.RES_CODE = @RES_CODE
	--	END 
	--	ELSE  -- 출발자 
	--	BEGIN
	--		-- 현재 테이블에 없고,
	--		-- 새로운 CUS_NO 로 부터 새로운 정보가 있을경우 갱신 (고객정보->출발자)
	--		UPDATE A 
	--			SET A.GENDER = CASE WHEN ISNULL(A.GENDER,'') = '' AND ISNULL(B.GENDER,'') <> ''  THEN  B.GENDER ELSE A.GENDER END 
	--			, A.BIRTH_DATE = CASE WHEN A.BIRTH_DATE IS NULL AND B.BIRTH_DATE IS NOT NULL  THEN  B.BIRTH_DATE ELSE A.BIRTH_DATE END 
	--			, A.NOR_TEL1 = CASE WHEN  ISNULL(A.NOR_TEL1,'') = '' AND ISNULL(B.NOR_TEL1,'') <> ''  THEN  B.NOR_TEL1 ELSE A.NOR_TEL1 END 
	--			, A.NOR_TEL2 = CASE WHEN  ISNULL(A.NOR_TEL2,'') = '' AND ISNULL(B.NOR_TEL2,'') <> ''  THEN  B.NOR_TEL2 ELSE A.NOR_TEL2 END 
	--			, A.NOR_TEL3 = CASE WHEN  ISNULL(A.NOR_TEL3,'') = '' AND ISNULL(B.NOR_TEL3,'') <> ''  THEN  B.NOR_TEL3 ELSE A.NOR_TEL3 END 
	--			, A.EMAIL = CASE WHEN  ISNULL(A.EMAIL,'') = '' AND ISNULL(B.EMAIL,'') <> ''  THEN  B.EMAIL ELSE A.EMAIL END 
	--			, A.CUS_NO = @NEW_CUS_NO 

	--			, A.LAST_NAME = CASE WHEN  ISNULL(A.LAST_NAME,'') = '' AND ISNULL(B.LAST_NAME,'') <> ''  THEN  B.LAST_NAME ELSE A.LAST_NAME END 
	--			, A.FIRST_NAME = CASE WHEN  ISNULL(A.FIRST_NAME,'') = '' AND ISNULL(B.FIRST_NAME,'') <> ''  THEN  B.FIRST_NAME ELSE A.FIRST_NAME END 

	--		FROM RES_CUSTOMER_DAMO A 
	--			INNER JOIN CUS_CUSTOMER_DAMO B
	--				ON B.CUS_NO = @NEW_CUS_NO 
	--		WHERE A.RES_CODE = @RES_CODE
	--		AND  A.SEQ_NO = @SEQ_NO 
	--	END 
	--END 
	

	-- 상태 업데이트 
	UPDATE CUS_CLEAR_TARGET 
	SET  
		STATUS =@STATUS
		,NEW_CUS_NO = @NEW_CUS_NO 
		,EXEC_CODE = @EMP_CODE 
		,EXEC_DATE = GETDATE() 

		,MERGE_INFO  =@MERGE_INFO
		,COMP_YN  =@COMP_YN
		,REMARK =@REMARK
		
	WHERE RES_CODE = @RES_CODE
	AND SEQ_NO = @SEQ_NO 
	

END 

GO
