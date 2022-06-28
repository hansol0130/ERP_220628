USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_RES_PAY_COUPON_ACC_INSERT
■ DESCRIPTION				: 업체 쿠폰 입금및 DC(수수료) 처리  ( DC 는 첫번째 출발자의 DC_PRICE 에 넣기 ) 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec XP_RES_PAY_COUPON_ACC_INSERT 'RT1704255204'  , '2013007' , 2482677
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-04-21		박형만			최초생성
================================================================================================================*/ 
create PROC [dbo].[XP_RES_PAY_COUPON_ACC_INSERT]
	@RES_CODE	RES_CODE ,
	@CPN_SEQ	INT , 
	@NEW_CODE	EMP_CODE ,
	@PAY_SEQ	INT   --기존입금내역 
AS 
BEGIN

	--DECLARE @RES_CODE	RES_CODE 
	--	,@NEW_CODE EMP_CODE 
	--	,@PAY_SEQ INT 
	--SET @RES_CODE ='RT1704285207'  
	--SET @NEW_CODE = '2013007' 
	--SET @PAY_SEQ = 2482677 

DECLARE @STATUS INT 
SET @STATUS = 0 
DECLARE CSR_RES_PAY_COUPON_ACCOUNT CURSOR
READ_ONLY
FOR 
SELECT 
(SELECT TOP 1 PRO_CODE FROM RES_MASTER_DAMO WHERE RES_CODE = A.RES_CODE) AS PRO_CODE , 
AGT_CODE,CPN_NO, CPN_SEQ, CPN_TITLE,CPN_TYPE, PAY_TARGET_PRICE , DC_RATE , DC_PRICE , COMM_RATE , COMM_PRICE 
FROM PAY_COUPON A
WHERE RES_CODE = @RES_CODE 
AND CPN_SEQ = @CPN_SEQ 
--AND CXL_YN = 'N' 

--변수선언 
DECLARE @PRO_CODE VARCHAR(50),
@AGT_CODE	VARCHAR(10), --	제휴 업체 코드	제휴 업체 코드
--MEM_NO	VARCHAR(200)	, --	암호화된 쿠폰번호(복호화 할필요 없음)	암호화된 쿠폰번호(복호화 할필요 없음)
@CPN_NO	VARCHAR(200)	, --	암호화된 쿠폰번호(복호화 할필요 없음)	암호화된 쿠폰번호(복호화 할필요 없음)
--@CPN_SEQ	INT,
@CPN_TITLE	VARCHAR(200)	, --	쿠폰제목	
@CPN_TYPE	CHAR(1)	, --	쿠폰종류	즉시할인 : I, 다운쿠폰 : B
@PAY_TARGET_PRICE	INT	, --	할인상한금액	0 이면 제한없음
@DC_RATE		DECIMAL(4,2)	, --	할인율	0 이상이면 할인률 우선
@DC_PRICE	DECIMAL(12,2)	, --	할인금액	0 이상이면 할인금액 우선 
@COMM_RATE	DECIMAL(4,2)	, --	여행사 부담율	0 이상이면 부담률 우선
@COMM_PRICE	DECIMAL(12,2)	 --	여행사 부담액	0 이상이면 부담액 우선

OPEN CSR_RES_PAY_COUPON_ACCOUNT

FETCH NEXT FROM CSR_RES_PAY_COUPON_ACCOUNT INTO @PRO_CODE,@AGT_CODE,@CPN_NO,@CPN_TITLE,@CPN_TYPE,@PAY_TARGET_PRICE,@DC_RATE,@DC_PRICE,@COMM_RATE,@COMM_PRICE
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN

		----------------------------------------------------------------------------------------
		-- 쿠폰 입금처리 

		--계좌순번 임시 불러들임
		DECLARE @ACC_SEQ INT 
		DECLARE @TMP_PAY_SEQ INT;
		SET @ACC_SEQ = ISNULL((SELECT MIN(ACC_SEQ) FROM AGT_ACCOUNT WHERE AGT_CODE = @AGT_CODE), 1);
		--업체로 부터 받을 쿠폰 입금대상액 
		DECLARE @DC_PRICE_AGENT INT 
		IF( @DC_RATE > 0)  --할인률 다시계산
		BEGIN
			SET @DC_PRICE  = CONVERT(DECIMAL,@PAY_TARGET_PRICE) * (@DC_RATE * 0.01)  
		END 
		IF( @COMM_RATE > 0 )  --제휴사 부담액 
		BEGIN
			SET @COMM_PRICE = CONVERT(DECIMAL,@DC_PRICE) * (@COMM_RATE * 0.01)   
		END 
		SET @DC_PRICE_AGENT =  @DC_PRICE - @COMM_PRICE  -- DC 금액 - 참좋은부담액 

		
		--1. 첫번째 출발자 DC 금액중 참좋은여행 부담액(@COMM_PRICE) 처리 
		--SELECT '정상상태인 첫번째출발자 DC 금액 ' , @COMM_PRICE 

		--SELECT TOP 1 * FROM RES_CUSTOMER WHERE RES_CODE = @RES_CODE AND RES_STATE = 0 
		IF( @COMM_PRICE> 0 )
		BEGIN
			UPDATE RES_CUSTOMER_DAMO  
			SET DC_PRICE = @COMM_PRICE 
			WHERE  RES_CODE = @RES_CODE 
			AND SEQ_NO = (SELECT TOP 1 SEQ_NO FROM RES_CUSTOMER_DAMO WHERE RES_CODE = @RES_CODE AND RES_STATE = 0 ORDER BY SEQ_NO ASC) 
		END 
		
		--ORDER BY SEQ_NO ASC  


		-- 2. 쿠폰 입금 매칭 내역 등록  @DC_PRICE_AGENT 
		-- 이미 입금 마스터가 있고 해당 PAY_SEQ 를 매칭 
		IF EXISTS ( SELECT * FROM PAY_MASTER_DAMO WITH(NOLOCK) WHERE PAY_SEQ = @PAY_SEQ ) 
		BEGIN
			--입금매칭 저장
			DECLARE @TMP_MCH_SEQ INT
			SET @TMP_MCH_SEQ = ISNULL((SELECT MAX(MCH_SEQ) FROM PAY_MATCHING WHERE PAY_SEQ = @PAY_SEQ), 0) + 1 ;
			INSERT INTO PAY_MATCHING
			(
				PAY_SEQ,		MCH_SEQ,		MCH_TYPE,		RES_CODE,
				PRO_CODE,		PART_PRICE,		CXL_YN,			NEW_DATE,
				NEW_CODE,		REMARK
			)
			SELECT
			
				@PAY_SEQ,		@TMP_MCH_SEQ,			1 AS MCH_TYPE,		@RES_CODE,
				@PRO_CODE,		@DC_PRICE_AGENT,		'N' CXL_YN,		GETDATE(),
				@NEW_CODE,		@CPN_NO + '_' + ISNULL(@CPN_TITLE,'')

			-- 현재 예약상태가 출발완료 이하 일때만 실행한다.
			IF EXISTS (SELECT 1 FROM DBO.RES_MASTER_DAMO WHERE RES_CODE = @RES_CODE AND RES_STATE < 5)
			BEGIN
				UPDATE RES_MASTER_DAMO
					SET RES_STATE = CASE WHEN (SELECT DBO.FN_RES_GET_TOTAL_PRICE(@RES_CODE) - ISNULL(SUM(PART_PRICE) , 0) FROM PAY_MATCHING WHERE RES_CODE = @RES_CODE AND CXL_YN = 'N') <= 0 THEN 4 ELSE 3 END,
						EDT_CODE = @NEW_CODE,
						EDT_DATE = GETDATE()
				WHERE RES_CODE = @RES_CODE
			END

			--3. 쿠폰에 정상 처리 임을 표시 
			UPDATE PAY_COUPON 
			SET PAY_SEQ = @PAY_SEQ  , MCH_SEQ = @TMP_MCH_SEQ 
			WHERE RES_CODE = @RES_CODE AND CPN_SEQ = @CPN_SEQ 

			SET @STATUS = 1 
		END 
		--ELSE 
		--BEGIN
		--	SELECT '쿠폰입금내역이 있음 어떻게 처리 할지 고민 ' 
		--END 


		

--		PRINT 'add user defined code here'
--		eg.
		--DECLARE @message varchar(100)
		--SELECT @message = 'my name is: ' + @name
		--PRINT @message
	END
	FETCH NEXT FROM CSR_RES_PAY_COUPON_ACCOUNT INTO @PRO_CODE,@AGT_CODE,@CPN_NO,@CPN_TITLE,@CPN_TYPE,@PAY_TARGET_PRICE,@DC_RATE,@DC_PRICE,@COMM_RATE,@COMM_PRICE
END

CLOSE CSR_RES_PAY_COUPON_ACCOUNT
DEALLOCATE CSR_RES_PAY_COUPON_ACCOUNT


SELECT @STATUS 


END 
GO
