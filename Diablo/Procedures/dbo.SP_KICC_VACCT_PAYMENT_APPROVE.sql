USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	SQL.함수_가상계좌_결제승인완료
====================================================================================
- SP 명 : SP_KICC_VACCT_PAYMENT_APPROVE
- 기 능 : KICC 가상계좌 승인 통지로 결제완료 정보 입력
====================================================================================
	참고내용
====================================================================================
- 예제



SELECT TOP 100 * FROM KICC_PAY_REQUEST WHERE res_code = 'RP1812247210'
and pay_req_type = 'VACCT'

 
 exec SP_KICC_VACCT_PAYMENT_APPROVE @REQ_CTR_NO=N'00198312062823784858'
 , @RES_CTR_NO=N'20198312062823784858'
 ,@RES_CODE=N'RP1206282671',@RESULT_CODE=N'0000',@RESULT_MSG=N'입금완료'
 ,@PAY_NAME=N'박형만',@BANK_CODE=N'026'
 ,@ACCT_NUM=N'26190178357755'
 ,@CARD_NUM=NULL
 ,@AMOUNT=1000
 ,@INSTALLMENT=0
 ,@COM_RATE=0
 ,@REMARK=NULL
 ,@MALL_ID=''
 ,@PAY_DATE= NULL   -- 결제일 지정시 
 
====================================================================================
	변경내역
====================================================================================
- 2012-05-03 박형만  생성
- 2012-06-28 박형만  입금에 해당하는 예약번호가 이동되었을때 최종 이동된예약을 찾아서 입금매칭 시켜줌 (6/28 16:00 ~ 입금부터적용)
- 2012-08-10 박형만  입금 중복 체크시 NOLOCK 빼기 - LOCK 걸렸을때 중복건수 발생 
- 2012-08-10 박형만  이전가상계좌(05110541) 일 경우 입출금검색 내역 비고에 이전가상계좌 표시  
- 2012-08-20 박형만  입금중복체크 KICC_PAY_RESPONSE 테이블 체크 -> PAY_MASTER_damo 체크로 변경 - 입금 중복건 발생 방지
- 2012-08-20 박형만  입금시 카드번호에 계좌번호 넣기, RAIS ERROR -> THROW 로 교체  
- 2015-03-26 박형만	 PAY_MASTER_DAMO 에 MALL_ID 추가 
- 2016-09-13 박형만	 교착상태 방지 위해 TRAN 위치 조정 (IF NOT EXISTS 다음에 )
- 2018-06-01 박형만	 @PAY_DATE 추가 
- 2019-02-07 박형만  가상계좌 요청정보 찾기 로직 변경 , REQ_SEQ_NO 추가  , 임시 롤백 원상복귀 
- 2019-02-19 박형만  가상계좌 매칭 조회 SP 에서 처리 하여 SEQ_NO 를 가져온다 
- 2019-11-01 박형만  네이버패키지예약. 예약확정이전결제(예약금 결제) 시 예약상태 바꾸지 않음 (예외처리)
===================================================================================*/
CREATE  PROC [dbo].[SP_KICC_VACCT_PAYMENT_APPROVE]
	@REQ_CTR_NO VARCHAR(30),  --요청 승인 번호
	@RES_CTR_NO VARCHAR(20),  --응답 승인 번호
	@RES_CODE RES_CODE,
	@RESULT_CODE char(4),
	@RESULT_MSG varchar(100),
	
	@PAY_NAME VARCHAR(80), -- 입금자명 
	@BANK_CODE	VARCHAR(10)	,--은행코드 
	@ACCT_NUM	VARCHAR(20)	,--계좌 번호 
	@CARD_NUM VARCHAR(20), --카드번호
	
	@AMOUNT INT,
	@INSTALLMENT INT , -- 할부개월
	@COM_RATE DECIMAL(4,2),
	@REMARK varchar(500),	--	비고 
	@MALL_ID VARCHAR(8) = NULL ,
	@PAY_DATE DATETIME = NULL ,

	@SEQ_NO INT = NULL 

AS 
SET NOCOUNT ON 
BEGIN
	
	DECLARE @CUS_TEL VARCHAR(80)
	DECLARE @REQ_BANK_CODE VARCHAR(10)
	DECLARE @REQ_ACCT_NUM VARCHAR(20)
	DECLARE @REQ_CUS_NAME VARCHAR(40)
	DECLARE @KICC_ID VARCHAR(15)
	
	DECLARE @REQ_AMOUNT INT
	
	--출력메시지
	DECLARE @RET_MSG VARCHAR(1000)
	SET @RET_MSG = ''

	--최초 응답 CONTROL NUMBER 중복체크 . 중복입금 방지 
	IF EXISTS (SELECT * FROM PAY_MASTER_damo WITH(NOLOCK)
			WHERE PG_APP_NO = @RES_CTR_NO ) 
	BEGIN
		RETURN 
	END 


	---- 2019-01-21 신규 요청정보 찾기 
	--DECLARE @SEQ_NO INT -- 결제 요청 순번 
	DECLARE @ORDER_NUM INT 
	IF EXISTS ( SELECT * FROM KICC_PAY_REQUEST  WITH(NOLOCK)
		WHERE REQ_CTR_NO = @REQ_CTR_NO )
	BEGIN

		
		-- 확실한 SEQ_NO 가 있을때 
		-- 2019-02-19 신규 
		IF( ISNULL(@SEQ_NO,0) > 0 )
		BEGIN
			
			SELECT TOP 1 --@SEQ_NO = SEQ_NO,
			@CUS_TEL = CUS_TEL,
			@REQ_BANK_CODE = BANK_CODE,
			@REQ_ACCT_NUM = ACCT_NUM,
			@KICC_ID = KICC_ID,
			@ORDER_NUM = ORDER_NUM,
			@REQ_CUS_NAME = CUS_NAME ,
			@REQ_AMOUNT =  REQ_AMOUNT 
			FROM ( 
				SELECT 
					SEQ_NO , CUS_TEL , BANK_CODE , ACCT_NUM , KICC_ID  , CUS_NAME , REQ_AMOUNT ,
					--!! 정렬 우선 순위 
					-- 계좌번호,금액,이름,예약번호
					CASE WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CUS_NAME = @PAY_NAME AND RES_CODE = @RES_CODE  THEN 10 
					 WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CHARINDEX(CUS_NAME , @PAY_NAME)  > 0 AND RES_CODE = @RES_CODE  THEN 11
					-- 계좌번호,금액,이름,기존예약번호
					WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CUS_NAME = @PAY_NAME AND ORG_RES_CODE = @RES_CODE  THEN 12
					WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CHARINDEX(CUS_NAME , @PAY_NAME)  > 0 AND ORG_RES_CODE = @RES_CODE  THEN 13
				
					-- 계좌번호,금액,이름
					 WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CUS_NAME = @PAY_NAME  THEN 20
					 WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CHARINDEX(CUS_NAME , @PAY_NAME)  > 0 THEN 21
					-- 계좌번호,이름
					 WHEN ACCT_NUM = @ACCT_NUM  AND CUS_NAME = @PAY_NAME THEN 30
					 WHEN ACCT_NUM = @ACCT_NUM  AND CHARINDEX(CUS_NAME , @PAY_NAME)  > 0 THEN 31
					-- 계좌번호,금액
					 WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT THEN 40
					-- 계좌번호만 
					 WHEN ACCT_NUM = @ACCT_NUM  THEN 50
					ELSE 999 END AS ORDER_NUM 
				FROM KICC_PAY_REQUEST  WITH(NOLOCK)
				WHERE SEQ_NO = @SEQ_NO 
				--WHERE REQ_CTR_NO = '19011817171510362898'
			
			) T ORDER BY ORDER_NUM ASC , SEQ_NO DESC -- 중복되면 최신꺼 

		END 
		ELSE 
		BEGIN
			-- 2019-02-19 신규 
			-- 기존 ,, 앞으로는 쓰이지 않을예정 
			SELECT TOP 1 @SEQ_NO = SEQ_NO,
			@CUS_TEL = CUS_TEL,
			@REQ_BANK_CODE = BANK_CODE,
			@REQ_ACCT_NUM = ACCT_NUM,
			@KICC_ID = KICC_ID,
			@ORDER_NUM = ORDER_NUM,
			@REQ_CUS_NAME = CUS_NAME ,
			@REQ_AMOUNT =  REQ_AMOUNT 
			FROM ( 
				SELECT 
					SEQ_NO , CUS_TEL , BANK_CODE , ACCT_NUM , KICC_ID  , CUS_NAME , REQ_AMOUNT ,
					--!! 정렬 우선 순위 
					-- 계좌번호,금액,이름,예약번호
					CASE WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CUS_NAME = @PAY_NAME AND RES_CODE = @RES_CODE  THEN 10 
					 WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CHARINDEX(CUS_NAME , @PAY_NAME)  > 0 AND RES_CODE = @RES_CODE  THEN 11
					-- 계좌번호,금액,이름,기존예약번호
					WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CUS_NAME = @PAY_NAME AND ORG_RES_CODE = @RES_CODE  THEN 12
					WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CHARINDEX(CUS_NAME , @PAY_NAME)  > 0 AND ORG_RES_CODE = @RES_CODE  THEN 13
				
					-- 계좌번호,금액,이름
					 WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CUS_NAME = @PAY_NAME  THEN 20
					 WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CHARINDEX(CUS_NAME , @PAY_NAME)  > 0 THEN 21
					-- 계좌번호,이름
					 WHEN ACCT_NUM = @ACCT_NUM  AND CUS_NAME = @PAY_NAME THEN 30
					 WHEN ACCT_NUM = @ACCT_NUM  AND CHARINDEX(CUS_NAME , @PAY_NAME)  > 0 THEN 31
					-- 계좌번호,금액
					 WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT THEN 40
					-- 계좌번호만 
					 WHEN ACCT_NUM = @ACCT_NUM  THEN 50
					ELSE 999 END AS ORDER_NUM 
				FROM KICC_PAY_REQUEST  WITH(NOLOCK)
				WHERE REQ_CTR_NO = @REQ_CTR_NO 
				AND (DEL_YN = 'N'  OR DEL_YN IS NULL)
			
				--WHERE REQ_CTR_NO = '19011817171510362898'
			
			) T ORDER BY ORDER_NUM ASC , SEQ_NO DESC -- 중복되면 최신꺼 

		END 



		--SELECT TOP 100 * FROM KICC_PAY_REQUEST 
		--ORDER BY SEQ_NO DESC 
	END 
	ELSE
	BEGIN
		SET @RET_MSG = '가상계좌 요청정보가 존재하지 않습니다!' 
		
		SET @RET_MSG = @RET_MSG +'요청PG거래번호:' +ISNULL(@REQ_CTR_NO ,'')
		SET @RET_MSG = @RET_MSG +',응답PG거래번호:' +ISNULL(@RES_CTR_NO ,'')
		SET @RET_MSG = @RET_MSG +',예약코드:' +ISNULL(@RES_CODE ,'')
		SET @RET_MSG = @RET_MSG +',은행계좌:(' +ISNULL(@BANK_CODE ,'')+')'+ISNULL(@ACCT_NUM ,'')
		SET @RET_MSG = @RET_MSG +',입금자:' +ISNULL(@PAY_NAME ,'')
		SET @RET_MSG = @RET_MSG +',금액:' +ISNULL( CONVERT(VARCHAR,@AMOUNT) ,'');
		
		THROW 50001,@RET_MSG,1;
		RETURN 
	END 
		
	

		
	
	
		
	----------기존 요청정보 찾기 , ------------------------------------------------------------------------
	----요청정보 조회( 요청정보가 있는지 없는지)
	--IF EXISTS ( SELECT * FROM KICC_PAY_REQUEST  WITH(NOLOCK)
	--	WHERE REQ_CTR_NO = @REQ_CTR_NO 
	--	AND	RES_CODE = @RES_CODE )
	--BEGIN
	
	--	-- 요청 계좌 금액 이 있는지- 잇다면 그것으로 
	--	IF EXISTS ( SELECT * FROM KICC_PAY_REQUEST  WITH(NOLOCK)
	--			WHERE REQ_CTR_NO = @REQ_CTR_NO 
	--			AND	RES_CODE = @RES_CODE
	--			AND ACCT_NUM = @ACCT_NUM 
	--			AND REQ_AMOUNT = @AMOUNT )
	--	BEGIN 
	--		SELECT TOP 1 
	--			@CUS_TEL = CUS_TEL , 
	--			@REQ_BANK_CODE = BANK_CODE , 
	--			@REQ_ACCT_NUM = ACCT_NUM ,
	--			@KICC_ID = KICC_ID
	--		FROM KICC_PAY_REQUEST AS A WITH(NOLOCK)
	--		WHERE REQ_CTR_NO = @REQ_CTR_NO 
	--		AND	RES_CODE = @RES_CODE
	--		AND ACCT_NUM = @ACCT_NUM 
	--		AND REQ_AMOUNT = @AMOUNT
	--		ORDER BY SEQ_NO DESC 
	--	END 
	--	ELSE   -- 요청금액이 없다면 요청 계좌의 가장 최신으로
	--	BEGIN
	--		SELECT TOP 1 
	--			@CUS_TEL = CUS_TEL , 
	--			@REQ_BANK_CODE = BANK_CODE , 
	--			@REQ_ACCT_NUM = ACCT_NUM ,
	--			@KICC_ID = KICC_ID
	--		FROM KICC_PAY_REQUEST AS A WITH(NOLOCK)
	--		WHERE REQ_CTR_NO = @REQ_CTR_NO 
	--		AND	RES_CODE = @RES_CODE
	--		AND ACCT_NUM = @ACCT_NUM 
	--		ORDER BY SEQ_NO DESC 
	--	END 
		
	--	---- 요청정보가 맞는지 조회. 다를경우 에러 
	--	--IF( @REQ_ACCT_NUM <> @ACCT_NUM  )
	--	--BEGIN
	--	--	SET @RET_MSG = '가상계좌 요청정보가 올바르지 않습니다.' 
		
	--	--	SET @RET_MSG = @RET_MSG +'요청PG거래번호:' +ISNULL(@REQ_CTR_NO ,'')
	--	--	SET @RET_MSG = @RET_MSG +',응답PG거래번호:' +ISNULL(@RES_CTR_NO ,'')
	--	--	SET @RET_MSG = @RET_MSG +',예약코드:' +ISNULL(@RES_CODE ,'')
	--	--	SET @RET_MSG = @RET_MSG +',요청은행계좌:(' +ISNULL(@REQ_BANK_CODE ,'')+')'+ISNULL(@REQ_ACCT_NUM ,'')
	--	--	SET @RET_MSG = @RET_MSG +',응답은행계좌:(' +ISNULL(@BANK_CODE ,'')+')'+ISNULL(@ACCT_NUM ,'')
	--	--	SET @RET_MSG = @RET_MSG +',금액:' +ISNULL( CONVERT(VARCHAR,@AMOUNT) ,'')
			
		
	--	--	RETURN 
	--	--END 
		
	--END 
	--ELSE
	--BEGIN
	--	SET @RET_MSG = '가상계좌 요청정보가 존재하지 않습니다!' 
		
	--	SET @RET_MSG = @RET_MSG +'요청PG거래번호:' +ISNULL(@REQ_CTR_NO ,'')
	--	SET @RET_MSG = @RET_MSG +',응답PG거래번호:' +ISNULL(@RES_CTR_NO ,'')
	--	SET @RET_MSG = @RET_MSG +',예약코드:' +ISNULL(@RES_CODE ,'')
	--	SET @RET_MSG = @RET_MSG +',은행계좌:(' +ISNULL(@BANK_CODE ,'')+')'+ISNULL(@ACCT_NUM ,'')
	--	SET @RET_MSG = @RET_MSG +',입금자:' +ISNULL(@PAY_NAME ,'')
	--	SET @RET_MSG = @RET_MSG +',금액:' +ISNULL( CONVERT(VARCHAR,@AMOUNT) ,'');
		
	--	THROW 50001,@RET_MSG,1;
	--	RETURN 
	--END 
	------------------------------------------------------------------------------------



	-------------------------------------------------------	
	--정상요청정보가 있을경우. 이동예약번호 체크  
	DECLARE @RES_STATE INT,
		@MOV_AFTER_CODE RES_CODE,
		@PROVIDER INT  -- 유입처 추가 
	
	--예약의 상태, 이동예약정보 담기 
	SELECT @RES_STATE = RES_STATE, @MOV_AFTER_CODE = MOV_AFTER_CODE , @PROVIDER = PROVIDER   FROM RES_MASTER_DAMO WITH(NOLOCK)
	WHERE RES_CODE = @RES_CODE 
	
	IF( @RES_STATE = 8 )  --이동된 예약일경우 
	BEGIN
		
		DECLARE @LOOP_CNT INT 
		DECLARE @MOV_RES_STATE INT 
		-- 이동된 예약을 찾는다 
		-- 무한루프 방지 20회 이동 까지 체크 
		SET @LOOP_CNT = 1 
		WHILE @LOOP_CNT < 20 
		BEGIN 
			--이동된 예약의 상태 , 그이후의 이동예약정보 담기
			SELECT @RES_STATE = RES_STATE, @RES_CODE = MOV_AFTER_CODE , @PROVIDER = PROVIDER  FROM RES_MASTER_DAMO WITH(NOLOCK)
			WHERE RES_CODE = @MOV_AFTER_CODE
			
			--또이동된 경우 
			IF( @RES_STATE = 8 )
			BEGIN
				-- 새로운 이동예약 찾기 
				SET @MOV_AFTER_CODE = @RES_CODE 
			END 
			ELSE 
			BEGIN  -- 이동된 예약이 이동이 아닐경우 예약번호 넣어줌
				SET @RES_CODE = @MOV_AFTER_CODE 
				BREAK;
			END 
			
			SET @LOOP_CNT = @LOOP_CNT + 1 
			--SELECT @RES_CODE ,@RES_STATE ,  @LOOP_CNT 
		END 
	END 
	--SELECT @RES_CODE  
	-------------------------------------------------------	

	DECLARE @PAY_SEQ INT 
	--PAY_MASTER 에 등록이 안되었을경우에만  실행 
	--중복 호출시 PAY_MASTER_DAMO 가 두건이 되는걸 방지
	--IF NOT EXISTS (SELECT * FROM KICC_PAY_RESPONSE --WITH(NOLOCK)
	--		WHERE REQ_CTR_NO = @REQ_CTR_NO 
	--		AND RES_CTR_NO = @RES_CTR_NO 
	--		AND PAY_SEQ IS NOT NULL )
	--BEGIN 
	--PAY_MASTER_DAMO 에서 PG_APP_NO(PG사승인번호)  로 중복 체크  2012-08-10 
	IF NOT EXISTS (SELECT * FROM PAY_MASTER_damo --WITH(NOLOCK)
			WHERE PG_APP_NO = @RES_CTR_NO ) 
	BEGIN

		------------------------------------
		BEGIN TRAN
		------------------------------------

			IF @PAY_DATE IS NULL 
			BEGIN
				SET @PAY_DATE  = GETDATE() 
			END 
			
			DECLARE @PAY_TYPE INT 
			DECLARE @PAY_SUB_NAME VARCHAR(50) 
			DECLARE @PAY_METHOD INT
			SET @PAY_TYPE = 15  -- 계좌종류 가상계좌:15
			SET @PAY_SUB_NAME = '가상계좌' -- 결제구분명
			SET @PAY_METHOD = 0 -- 입금방법 : 홈페이지0
		
			-- 'PAY_MASTER_DAMO' 테이블에 입력 92273- 한국정보통신
			INSERT PAY_MASTER_DAMO (PAY_TYPE, PAY_SUB_NAME, AGT_CODE,  ACC_SEQ, 
				SEC_PAY_NUM ,SEC1_PAY_NUM , 
				PAY_METHOD, PAY_NAME, PAY_PRICE, COM_RATE, COM_PRICE, 
				PAY_DATE, INSTALLMENT, CLOSED_YN, NEW_CODE, NEW_DATE, CXL_YN ,ADMIN_REMARK , PG_APP_NO , MALL_ID)
			VALUES (@PAY_TYPE, @PAY_SUB_NAME,'92273', 1, 
				damo.dbo.enc_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM',@ACCT_NUM), damo.dbo.pred_meta_plain_v( @ACCT_NUM ,'DIABLO','dbo.PAY_MASTER','PAY_NUM'),
				@PAY_METHOD, @PAY_NAME, @AMOUNT, @COM_RATE, @AMOUNT * (@COM_RATE / 100), 
				@PAY_DATE, @INSTALLMENT, 'N', '9999999', GETDATE(), 'N', @REMARK , @RES_CTR_NO , @MALL_ID  )

			-- 'PAY_MASTER_DAMO'에서 저장된 IDENTITY PAY_SEQ값 가져오기.
			SELECT @PAY_SEQ = @@IDENTITY
			
			-- 'PAY_MATCHING' 테이블에 입력
			--DECLARE @MCH_SEQ INT 
			--SET @MCH_SEQ = ISNULL((SELECT TOP 1 MCH_SEQ FROM PAY_MATCHING WHERE RES_CODE = @RES_CODE),0) + 1 
			INSERT PAY_MATCHING (PAY_SEQ, MCH_SEQ, MCH_TYPE, RES_CODE, PRO_CODE, PART_PRICE, NEW_CODE, NEW_DATE, CXL_YN , REMARK )
			SELECT @PAY_SEQ, 1, 0, @RES_CODE, PRO_CODE, @AMOUNT, '9999999', GETDATE(), 'N' , (CASE WHEN @KICC_ID ='05110541' THEN '이전가상계좌:verygoodtour01' ELSE NULL  END) 
			FROM DBO.RES_MASTER_damo
			WHERE RES_CODE = @RES_CODE	
			
			-- 총판매가, 입금가 체크
			DECLARE @GET_PAY_PRICE DECIMAL, @TOTAL_PRICE DECIMAL
			SELECT @TOTAL_PRICE = DBO.FN_RES_GET_TOTAL_PRICE(@RES_CODE), @GET_PAY_PRICE = DBO.FN_RES_GET_PAY_PRICE(@RES_CODE)


			-- 네이버 이고 예약확정 이전에 입금 되었을때  (예약금결제)
			IF (@PROVIDER = 41 AND @RES_STATE < 2 )
			BEGIN
				UPDATE RES_MASTER_DAMO SET RES_STATE = RES_STATE WHERE RES_CODE = @RES_CODE -- 예약상태 동일하게 
			END 
			ELSE 
			BEGIN
				IF @GET_PAY_PRICE = @TOTAL_PRICE
					UPDATE RES_MASTER_DAMO SET RES_STATE = 4 WHERE RES_CODE = @RES_CODE
				ELSE IF @GET_PAY_PRICE > 0
					UPDATE RES_MASTER_DAMO SET RES_STATE = 3 WHERE RES_CODE = @RES_CODE
			END 
			
			--에러시 롤백
			IF @@ERROR <> 0 
			BEGIN
				THROW 50001,'입금 등록시 오류가 발생하였습니다!',1;
				ROLLBACK TRAN 
				RETURN 
			END 
			 
			-- 결제승인 완료 입력 
			DECLARE @MCH_SEQ INT 
			SET @MCH_SEQ = ISNULL( ( SELECT MAX(MCH_SEQ) FROM KICC_PAY_RESPONSE WHERE REQ_CTR_NO = @REQ_CTR_NO ) , 0 ) + 1 
			
			INSERT INTO KICC_PAY_RESPONSE (
				REQ_CTR_NO,MCH_SEQ,RES_CTR_NO,APPR_YN,PAY_SEQ,
				AMOUNT,CARD_NUM,RESULT_CODE,RESULT_MSG,REMARK,NEW_CODE,NEW_DATE ,REQ_SEQ_NO)
			VALUES
				(
				@REQ_CTR_NO,@MCH_SEQ,@RES_CTR_NO,'Y',@PAY_SEQ,
				@AMOUNT,@ACCT_NUM,@RESULT_CODE,@RESULT_MSG,@REMARK,'9999999',GETDATE(),@SEQ_NO) -- RESPONSE 와 매칭 SEQ  추가  
		
			-- 2019-01-21 기존 요청내역 수정 추가 

			--if( isnull(@SEQ_NO,-1)  is not null )
			--begin
				UPDATE KICC_PAY_REQUEST
				SET COMP_YN = CASE WHEN @REQ_AMOUNT = @AMOUNT THEN 'Y' ELSE COMP_YN  END  -- 금액 같을시 완료로 
				 --, RES_MCH_SEQ = @MCH_SEQ  -- RESPONSE 와 매칭 SEQ  추가 
				 , REQ_REMARK = '입금자:' +ISNULL(@REQ_CUS_NAME ,'')
						 +',금액:' +ISNULL( CONVERT(VARCHAR,@REQ_AMOUNT) ,'')

				 , RES_REMARK = '입금자:' +ISNULL(@PAY_NAME ,'')
						 +',금액:' +ISNULL( CONVERT(VARCHAR,@AMOUNT) ,'')
		
				WHERE SEQ_NO = @SEQ_NO 
			--end 
			

			IF @@ERROR <> 0 
			BEGIN
				ROLLBACK TRAN 
				RETURN 
			END 

		------------------------------------
		COMMIT TRAN 
		------------------------------------
	END 
	--BEGIN 

	--	SET @RET_MSG = '이미 가상계좌 입금이 처리 완료 되었습니다 ' 
		
	--	SET @RET_MSG = @RET_MSG +'요청PG거래번호:' +ISNULL(@REQ_CTR_NO ,'')
	--	SET @RET_MSG = @RET_MSG +',응답PG거래번호:' +ISNULL(@RES_CTR_NO ,'')
	--	SET @RET_MSG = @RET_MSG +',예약코드:' +ISNULL(@RES_CODE ,'')
	--	SET @RET_MSG = @RET_MSG +',은행계좌:(' +ISNULL(@BANK_CODE ,'')+')'+ISNULL(@ACCT_NUM ,'')
	--	SET @RET_MSG = @RET_MSG +',입금자:' +ISNULL(@PAY_NAME ,'')
	--	SET @RET_MSG = @RET_MSG +',금액:' +ISNULL( CONVERT(VARCHAR,@AMOUNT) ,'');
		
	--	THROW 50001,@RET_MSG,1;
	--	RETURN 
	--END 

END 





GO
