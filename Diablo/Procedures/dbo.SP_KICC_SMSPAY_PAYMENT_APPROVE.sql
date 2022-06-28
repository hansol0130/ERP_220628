USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	SQL.함수_SMS_결제승인완료
====================================================================================
- SP 명 : SP_KICC_SMSPAY_PAYMENT_APPROVE
- 기 능 : KICC SMS 승인 통지전문 SMS 결제완료 정보 입력
====================================================================================
	참고내용
====================================================================================
- 예제
 EXEC SP_KICC_SMSPAY_PAYMENT_APPROVE 'RP1202162105|0427160931351','00000000000000','RP1202162105','0000','승인',1000,'',0,2.6
====================================================================================
	변경내역
====================================================================================
- 2021-06-21 김영민 신규 작성  SP_KICC_ARS_PAYMENT_APPROVE 와같은형식(19smspay )
===================================================================================*/
CREATE   PROC [dbo].[SP_KICC_SMSPAY_PAYMENT_APPROVE]
	@REQ_CTR_NO VARCHAR(30),  --요청 승인 번호
	@RES_CTR_NO VARCHAR(20),  --응답 승인 번호
	@RES_CODE RES_CODE,
	@RESULT_CODE char(4),
	@RESULT_MSG varchar(100),
	
	@CARD_NUM varchar(20),	--	카드번호
	--@APPR_YN char(1)	,
	@AMOUNT INT,
	@INSTALLMENT INT ,
	@COM_RATE DECIMAL(4,2),
	@REMARK varchar(500),	--	비고 
	@MALL_ID VARCHAR(8) = NULL  , 
	@PAY_DATE DATETIME = NULL   

AS 
SET NOCOUNT ON 
BEGIN

	DECLARE @SEQ_NO INT -- 결제 요청 순번 
	DECLARE @PAY_SEQ INT 
	--DECLARE @PAY_DATE DATETIME
	DECLARE @PAY_NAME VARCHAR(80)
	DECLARE @CUS_TEL VARCHAR(20)
	
	DECLARE @REQ_AMT INT  --승인시 비교를 위한 요청결제금액
	
	DECLARE @KICC_ID VARCHAR(15)
	
	--출력메시지
	DECLARE @RET_MSG VARCHAR(1000)
	SET @RET_MSG = ''
	
	--SMS 요청정보 조회
	IF EXISTS ( SELECT * FROM KICC_PAY_REQUEST  WITH(NOLOCK)
		WHERE REQ_CTR_NO = @REQ_CTR_NO 
		AND	RES_CODE = @RES_CODE   )
	BEGIN
		SELECT --@PAY_NAME = CUS_TEL,  -- 기존 
			@SEQ_NO = A.SEQ_NO,  -- 2019-01.23 신규
			@CUS_TEL = A.CUS_TEL,  -- 2019-01.23 신규
			@PAY_NAME = A.CUS_NAME,  -- 2019-01.23 신규
			@PAY_SEQ = B.PAY_SEQ , 
			@REQ_AMT = REQ_AMOUNT ,
			@KICC_ID = KICC_ID
		FROM KICC_PAY_REQUEST AS A WITH(NOLOCK)	
			LEFT JOIN KICC_PAY_RESPONSE AS B WITH(NOLOCK)	
				ON A.REQ_CTR_NO = B.REQ_CTR_NO 
		WHERE A.REQ_CTR_NO = @REQ_CTR_NO 
		AND	A.RES_CODE = @RES_CODE
	END 
	ELSE
	BEGIN
		SET @RET_MSG = 'SMS요청정보가 존재하지 않습니다!' 
		
		SET @RET_MSG = @RET_MSG +'요청PG거래번호:' +ISNULL(@REQ_CTR_NO ,'')
		SET @RET_MSG = @RET_MSG +',응답PG거래번호:' +ISNULL(@RES_CTR_NO ,'')
		SET @RET_MSG = @RET_MSG +',예약코드:' +ISNULL(@RES_CODE ,'')
		SET @RET_MSG = @RET_MSG +',응답코드:' +ISNULL(@RESULT_CODE ,'')
		SET @RET_MSG = @RET_MSG +',응답메시지:' +ISNULL(@RESULT_MSG ,'')
		SET @RET_MSG = @RET_MSG +',금액:' +ISNULL( CONVERT(VARCHAR,@AMOUNT) ,'')
		
		RAISERROR(@RET_MSG,16,1)
		RETURN 
	END 

	------------------------	
	BEGIN TRAN 
	
		IF @PAY_DATE IS NULL 
		BEGIN
			SET @PAY_DATE  = GETDATE() 
		END 

		--PAY_MASTER 에 등록이 안되었을경우에만  실행 
		--중복 호출시 PAY_MASTER_DAMO 가 두건이 되는걸 방지
		IF( @PAY_SEQ IS NULL)
		BEGIN
			--요청 금액 , 승인 금액 비교
			IF @REQ_AMT = @AMOUNT
			BEGIN
				DECLARE @PAY_TYPE INT 
				DECLARE @PAY_SUB_NAME VARCHAR(50) 
					BEGIN
						SET @PAY_TYPE = 19
						SET @PAY_SUB_NAME ='SMSPAY' 
					END 

					
				-- 'PAY_MASTER_DAMO' 테이블에 입력 92273- 한국정보통신
				INSERT PAY_MASTER_DAMO (PAY_TYPE, PAY_SUB_NAME, AGT_CODE,  ACC_SEQ, PAY_METHOD, 
					SEC_PAY_NUM ,SEC1_PAY_NUM,
					PAY_NAME, PAY_PRICE, COM_RATE, COM_PRICE, 
					PAY_DATE, INSTALLMENT, CLOSED_YN, NEW_CODE, NEW_DATE, CXL_YN ,ADMIN_REMARK , PG_APP_NO , MALL_ID)
				VALUES (@PAY_TYPE, @PAY_SUB_NAME,'92273', 1, 3, 
					damo.dbo.enc_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM',@CUS_TEL), damo.dbo.pred_meta_plain_v( @CUS_TEL ,'DIABLO','dbo.PAY_MASTER','PAY_NUM'),
					@PAY_NAME, @AMOUNT, @COM_RATE, @AMOUNT * (@COM_RATE / 100), 
					@PAY_DATE, @INSTALLMENT, 'N', '9999999', GETDATE(), 'N', @REMARK , @RES_CTR_NO , @MALL_ID )

				-- 'PAY_MASTER_DAMO'에서 저장된 IDENTITY PAY_SEQ값 가져오기.
				SELECT @PAY_SEQ = @@IDENTITY

				--예약정보에서 가져오기 19.11.01 
				DECLARE @PRO_CODE VARCHAR(20) , @RES_STATE INT  , @PROVIDER INT 
				SELECT @PRO_CODE = PRO_CODE , @RES_STATE = RES_STATE  , @PROVIDER =  PROVIDER 
				FROM RES_MASTER_DAMO WITH(NOLOCK) 
				WHERE RES_CODE = @RES_CODE
				
				-- 'PAY_MATCHING' 테이블에 입력
				--DECLARE @MCH_SEQ INT 
				--SET @MCH_SEQ = ISNULL((SELECT TOP 1 MCH_SEQ FROM PAY_MATCHING WHERE RES_CODE = @RES_CODE),0) + 1 
				INSERT PAY_MATCHING (PAY_SEQ, MCH_SEQ, MCH_TYPE, RES_CODE, PRO_CODE, PART_PRICE, NEW_CODE, NEW_DATE, CXL_YN)
				SELECT @PAY_SEQ, 1, 0, @RES_CODE, @PRO_CODE, @AMOUNT, '9999999', GETDATE(), 'N'
				
				-- 총판매가, 입금가 체크
				DECLARE @GET_PAY_PRICE DECIMAL, @TOTAL_PRICE DECIMAL
				SELECT @TOTAL_PRICE = DBO.FN_RES_GET_TOTAL_PRICE(@RES_CODE), @GET_PAY_PRICE = DBO.FN_RES_GET_PAY_PRICE(@RES_CODE)

				-- 네이버 이고 예약확정 이전에 입금 되었을때 (예약금결제)
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
					RAISERROR('SMS입금 등록시 오류가 발생하였습니다!',16,1)
					ROLLBACK TRAN 
					RETURN 
				END 
			END	
			ELSE 
			BEGIN
				--금액이 동일하지 않을때
				RAISERROR('SMS요청금액과 승인금액이 동일하지 않습니다.',16,1)
				ROLLBACK TRAN 
				RETURN 
			END 
		END
		
		
		--SMS 결제승인 완료 업데이트 
		DECLARE @APPR_YN CHAR(1)
		SET @APPR_YN = (CASE WHEN @RESULT_CODE = '0000' THEN  'Y' ELSE 'N' END) 
		UPDATE KICC_PAY_REQUEST
			SET COMP_YN = @APPR_YN
			,EDT_CODE ='9999999'
			,EDT_DATE = GETDATE()
		WHERE SEQ_NO = @SEQ_NO 
		 
		-- SMS 결제승인 완료 입력 
		INSERT INTO KICC_PAY_RESPONSE (
			REQ_CTR_NO,MCH_SEQ,RES_CTR_NO,APPR_YN,PAY_SEQ,
			AMOUNT,CARD_NUM,RESULT_CODE,RESULT_MSG,REMARK,NEW_CODE,NEW_DATE,REQ_SEQ_NO )
		VALUES
			(
			@REQ_CTR_NO,1,@RES_CTR_NO,'Y',@PAY_SEQ,
			@AMOUNT,@CARD_NUM,@RESULT_CODE,@RESULT_MSG,@REMARK,'9999999',GETDATE() ,@SEQ_NO	)
		 
		IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN 
			RETURN 
		END 
		
	COMMIT TRAN

END 




GO
