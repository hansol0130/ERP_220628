USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [XP_NAVER_PAY_MASTER_INSERT]
■ DESCRIPTION				: 네이버 페이 승인 요청 성공 결과 등록 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec  XP_NAVER_PAY_MASTER_INSERT 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-05-23		박형만			최초생성
   2019-11-01		박형만			네이버패키지예약. 예약확정이전결제(예약금 결제) 시 예약상태 바꾸지 않음 (예외처리)
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_NAVER_PAY_MASTER_INSERT]
(
	@NPAY_ID	VARCHAR(50)		,
	--@NPAY_HIS_ID	VARCHAR(50)		,
	--@LAST_STATUS	VARCHAR(10)		,
	--@RESULT_CODE	VARCHAR(20)		,
	--@RESULT_MSG	VARCHAR(500)		,
	@RES_CODE	RES_CODE		,
	@CUS_NO	INT,
	@PAY_MEANS	VARCHAR(10)		,
	@TOTAL_PRICE	INT		,
	@PAY_PRICE	INT		,
	@PAY_POINT	INT		,

	@CARD_CODE	VARCHAR(10)		,
	@CARD_NO	VARCHAR(50)		,
	@CARD_AUTH_NO	VARCHAR(30)		,
	@INST_NO	INT		,
	@BANK_CODE	VARCHAR(10)		,
	@BANK_NUM	VARCHAR(50)		,


	--@MALL_ID	VARCHAR(50)	,
	@REMARK		VARCHAR(1000)		,

	@PAY_DATE DATETiME ,
	@PAY_SEQ INT ,
	@PAY_NAME VARCHAR(100),
	@AGT_CODE VARCHAR(10),
	
	@NEW_CODE VARCHAR(7) ,
	@ADMIN_REMARK VARCHAR(1000)
)
AS 
BEGIN

	BEGIN TRAN 
	---- 입금내역이 이미 있으면 거의 없음 혹시 몰라서 
	--IF ISNULL(@PAY_SEQ,0) > 0 
	--BEGIN
	--	-- 입금마스터 업데이트
	--	UPDATE PAY_MASTER_DAMO SET
	--		CXL_YN = 'N', CXL_DATE = NULL , CXL_CODE = NULL 
	--		, PAY_SUB_TYPE = @PAY_SUB_TYPE
	--		, PAY_SUB_NAME = @PAY_SUB_NAME
	--		, INSTALLMENT = @INST_NO
	--		, SEC_PAY_NUM = damo.dbo.enc_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM',@PAY_NUM)
	--		, SEC1_PAY_NUM =damo.dbo.pred_meta_plain_v( @PAY_NUM ,'DIABLO','dbo.PAY_MASTER','PAY_NUM')
	--		, ADMIN_REMARK =  (CASE WHEN ISNULL(@ADMIN_REMARK, '') = '' THEN ADMIN_REMARK ELSE @ADMIN_REMARK END)
	--		, PG_APP_NO = @NPAY_ID  
	--	WHERE PAY_SEQ = @PAY_SEQ
	--END 
	--ELSE 
	--BEGIN
	--END

	--일반결제 
	DECLARE @PAY_TYPE INT 
	DECLARE @PAY_SUB_TYPE VARCHAR(50)
	DECLARE @PAY_SUB_NAME VARCHAR(50)
	DECLARE @PAY_NUM VARCHAR(100)
	DECLARE @COM_RATE DECIMAL (4,2)
	DECLARE @MALL_ID	VARCHAR(50)	

	--포인트결제 
	DECLARE @POINT_PAY_TYPE INT 
	DECLARE @POINT_COM_RATE DECIMAL (4,2)
	DECLARE @POINT_MALL_ID	VARCHAR(50)	


	-- 주결제 수단이 있을경우 
	-- 포인트 전체 결제는 제외
	SET @PAY_SEQ = 0 
	DECLARE @POINT_PAY_SEQ INT 
	SET @POINT_PAY_SEQ = 0 

	IF @PAY_PRICE > 0 
	BEGIN

		SET @PAY_SUB_TYPE =  CASE WHEN @PAY_MEANS = 'CARD' THEN @CARD_CODE ELSE @BANK_CODE END  
		SET @PAY_SUB_NAME =  CASE WHEN @PAY_MEANS = 'CARD' THEN 
			(SELECT PUB_VALUE FROM COD_PUBLIC WHERE PUB_TYPE LIKE 'PAY.CARD.CODE.NPAY' AND PUB_CODE = @CARD_CODE ) 
			ELSE NULL END  
		SET @PAY_NUM = CASE WHEN @PAY_MEANS = 'CARD' THEN @CARD_NO ELSE @BANK_NUM END   
		SET @PAY_TYPE = CASE WHEN @PAY_MEANS = 'CARD' THEN 16 ELSE 17 END 
		SET @COM_RATE = CASE WHEN @PAY_MEANS = 'CARD' THEN 2.5 ELSE 1.5 END   
		SET @MALL_ID = CASE WHEN @PAY_MEANS = 'CARD' THEN (SELECT TOP 1 PUB_CODE FROM COD_PUBLIC WHERE PUB_TYPE = 'PAY.NAVER.CARD' ) 
						ELSE (SELECT TOP 1  PUB_CODE FROM COD_PUBLIC WHERE PUB_TYPE = 'PAY.NAVER.CASH' ) END 

		-- 입금내역이 없으면 바로 등록 
		INSERT INTO PAY_MASTER_DAMO
		(
			PAY_TYPE,		PAY_SUB_TYPE,	PAY_SUB_NAME,	AGT_CODE,
			ACC_SEQ,						PAY_METHOD,		PAY_NAME,
			PAY_PRICE,		COM_RATE,		COM_PRICE,		PAY_DATE,
			PAY_REMARK,		ADMIN_REMARK,	CUS_NO,			INSTALLMENT,
			CLOSED_YN,		NEW_CODE,		NEW_DATE,		CXL_YN,
			SEC_PAY_NUM ,	SEC1_PAY_NUM,	MALL_ID,		PG_APP_NO 
		)
		VALUES
		(
			@PAY_TYPE,		@PAY_SUB_TYPE,	@PAY_SUB_NAME,	@AGT_CODE,
			1,						0,	@PAY_NAME,
			@PAY_PRICE,		@COM_RATE,		CONVERT(INT,(CONVERT(DECIMAL,@PAY_PRICE) /100.0) * @COM_RATE),	@PAY_DATE,
			@REMARK,	@ADMIN_REMARK,	@CUS_NO,		@INST_NO,
			'N',		@NEW_CODE,		GETDATE(),		'N',
			damo.dbo.enc_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM',@PAY_NUM) ,
			damo.dbo.pred_meta_plain_v( @PAY_NUM ,'DIABLO','dbo.PAY_MASTER','PAY_NUM'),
			@MALL_ID ,@NPAY_ID 
		)

		SET @PAY_SEQ = @@IDENTITY 

		-- NPAY 결과 업데이트 
		UPDATE NAVER_PAY_RESULT 
		SET PAY_SEQ = @PAY_SEQ 
		WHERE NPAY_ID = @NPAY_ID 
	END 

 
	
	-- NPAY 포인트 있는경우 
	IF @PAY_POINT > 0 
	BEGIN
	
		SET @POINT_PAY_TYPE = 18  
		SET @POINT_COM_RATE = 2.5 
		SET @POINT_MALL_ID = (SELECT TOP 1 PUB_CODE FROM COD_PUBLIC WHERE PUB_TYPE = 'PAY.NAVER.POINT')

		-- 입금내역이 없으면 등록 
		INSERT INTO PAY_MASTER_DAMO
		(
			PAY_TYPE,		PAY_SUB_TYPE,	PAY_SUB_NAME,	AGT_CODE,
			ACC_SEQ,						PAY_METHOD,		PAY_NAME,
			PAY_PRICE,		COM_RATE,		COM_PRICE,		PAY_DATE,
			PAY_REMARK,		ADMIN_REMARK,	CUS_NO,			INSTALLMENT,
			CLOSED_YN,		NEW_CODE,		NEW_DATE,		CXL_YN,
			SEC_PAY_NUM ,	SEC1_PAY_NUM,	MALL_ID,		PG_APP_NO 
		)
		VALUES
		(
			@POINT_PAY_TYPE ,		NULL,	'NPAY포인트',	@AGT_CODE,
			1,			0 ,	@PAY_NAME,
			@PAY_POINT,	@POINT_COM_RATE,		CONVERT(INT,(CONVERT(DECIMAL,@PAY_POINT) /100.0) * @POINT_COM_RATE),		@PAY_DATE,
			NULL,	'',	@CUS_NO,		0,
			'N',		@NEW_CODE,		GETDATE(),		'N',
			NULL,
			NULL,
			@POINT_MALL_ID , (CASE WHEN @PAY_PRICE > 0 THEN null  ELSE @NPAY_ID END )  -- 일반결제 있으면 NULL , 포인트 전액 결제는 PG_APP_ID 넣기 
		)
		SET @POINT_PAY_SEQ  = @@IDENTITY 
	END 

	--SELECT @PAY_SEQ , @POINT_PAY_SEQ 

	--에러시 롤백
	IF @@ERROR <> 0 
	BEGIN
		RAISERROR('NAVER 입금 마스터 등록시 오류가 발생하였습니다!',16,1)
		ROLLBACK TRAN 
		RETURN 
	END 


	-- 입금매칭
	IF @RES_CODE IS NOT NULL AND @RES_CODE <> ''
	BEGIN
		IF EXISTS(SELECT 1 FROM RES_MASTER_DAMO WITH(NOLOCK) WHERE RES_CODE = @RES_CODE)
		BEGIN

			--예약정보에서 가져오기 19.11.01 
			DECLARE @PRO_CODE VARCHAR(20) , @RES_STATE INT  , @PROVIDER INT 
			SELECT @PRO_CODE = PRO_CODE , @RES_STATE = RES_STATE  , @PROVIDER =  PROVIDER 
			FROM RES_MASTER_DAMO WITH(NOLOCK) 
			WHERE RES_CODE = @RES_CODE

			-- 일반 결제 입금매칭 
			IF @PAY_SEQ > 0 
			BEGIN
				INSERT INTO PAY_MATCHING (PAY_SEQ, MCH_SEQ, MCH_TYPE, RES_CODE, PRO_CODE, PART_PRICE, CXL_YN, NEW_DATE, NEW_CODE)
				SELECT @PAY_SEQ, 1, 0, @RES_CODE, @PRO_CODE, @PAY_PRICE, 'N', GETDATE(), @NEW_CODE

				-- NPAY 결과 업데이트 
				UPDATE NAVER_PAY_RESULT 
				SET PAY_SEQ = @PAY_SEQ 
				WHERE NPAY_ID = @NPAY_ID 
			END 
			

			-- 포인트 입금매칭
			IF @POINT_PAY_SEQ > 0 
			BEGIN
				INSERT INTO PAY_MATCHING (PAY_SEQ, MCH_SEQ, MCH_TYPE, RES_CODE, PRO_CODE, PART_PRICE, CXL_YN, NEW_DATE, NEW_CODE)
				SELECT @POINT_PAY_SEQ, 1, 0, @RES_CODE, @PRO_CODE, @PAY_POINT, 'N', GETDATE(), @NEW_CODE
				
				-- NPAY 포인트 결과 업데이트 
				UPDATE NAVER_PAY_RESULT 
				SET POINT_PAY_SEQ = @POINT_PAY_SEQ 
				WHERE NPAY_ID = @NPAY_ID 

				IF @PAY_SEQ = 0 
				BEGIN
					-- 포인트 전액 결제의 경우 NPAY 결과 업데이트 
					UPDATE NAVER_PAY_RESULT 
					SET PAY_SEQ = @POINT_PAY_SEQ 
					WHERE NPAY_ID = @NPAY_ID 
				END 

			END 

			-- 총판매가, 입금가 체크
			DECLARE @GET_PAY_PRICE DECIMAL, @TOTAL_PRO_PRICE DECIMAL
			SELECT @TOTAL_PRO_PRICE = DBO.FN_RES_GET_TOTAL_PRICE(@RES_CODE), @GET_PAY_PRICE = DBO.FN_RES_GET_PAY_PRICE(@RES_CODE)

			-- 네이버 이고 예약확정 이전에 입금 되었을때 (예약금결제)
			IF (@PROVIDER = 41 AND @RES_STATE < 2 )
			BEGIN 
				UPDATE RES_MASTER_DAMO SET RES_STATE = RES_STATE WHERE RES_CODE = @RES_CODE -- 예약상태 동일하게 
			END 
			ELSE 
			BEGIN
				IF @GET_PAY_PRICE = @TOTAL_PRO_PRICE
					UPDATE RES_MASTER_DAMO SET RES_STATE = 4 WHERE RES_CODE = @RES_CODE
				ELSE IF @GET_PAY_PRICE > 0
					UPDATE RES_MASTER_DAMO SET RES_STATE = 3 WHERE RES_CODE = @RES_CODE
			END 
			
		END
		--ELSE
		--BEGIN
		--	-- 호텔의 경우 예약 전 결제 처리 가능
		--	-- 예약이 없을경우 결제 정보 먼저 입력 RES_CODE , PRO_CODE 먼저 생성 
		--	INSERT INTO PAY_MATCHING (PAY_SEQ, MCH_SEQ, MCH_TYPE, RES_CODE, PRO_CODE , PART_PRICE, CXL_YN, NEW_DATE, NEW_CODE)
		--	SELECT @PAY_SEQ, 1, 0, @RES_CODE, NULL, @PAY_PRICE, 'N', GETDATE(), @NEW_CODE
		--END
	END

	
	----에러시 롤백
	IF @@ERROR <> 0 
	BEGIN
		RAISERROR('NAVER 입금 매칭 등록시 오류가 발생하였습니다!',16,1)
		ROLLBACK TRAN 
		RETURN 
	END 

	 --COMMIT 
	COMMIT TRAN

	IF @PAY_PRICE > 0 
	BEGIN
		SELECT @PAY_SEQ	
	END 
	ELSE
	BEGIN 
		SELECT @POINT_PAY_SEQ	 
	END 

	
	
END 

GO
