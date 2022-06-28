USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME						: ZP_DSR_TASF_INSERT
■ DESCRIPTION					: DSR TASF 등록
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :

■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
	2022-05-13		김성호			최초생성 (Querystring -> SP 변경)
	2022-05-17		김성호			TASF Ticket 기준 등록된 것은 다시 등록되지 않게 수정
	2022-05-19		김성호			환불 TASF 생성 조건 예외처리 (cancelBooking 이면서 발권일과 취소일이 다른경우 (REFUND) 예외 추가
									행사 있을 시 예약코드 조회 추가
	2022-05-22		김성호			TASF 등록 일괄 처리 (입금 포함, 환불 TASF 등록 예외처리 때문)
	2022-05-23		김성호			환불 TASF 중복 등록 방지 TICKET 컬럼 추가 (SET_CUSTOMER, RES_CUSTOMER_damo)
	2022-05-25		김성호			환불 TASF 등록 시 해당 예약 TASF 한 건 이상일 경우만 저장
	2022-05-26		김성호			TASF 입금 등록 시 TASF 이니시스 수수료 등록 (2.45%)
	2022-05-30		김성호			TASF 등록 유무와 상관없이 환불 TASF 및 입금 가능하게 수정
									환불 TASF 등록 용 행사, 예약 생성 시 RES_AIR_DETAIL 테이블 같이 생성하도록 수정 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_DSR_TASF_INSERT]
	@TICKET			VARCHAR(10),
    @AIRLINE_NUM	VARCHAR(3),
    @AIRLINE_CODE	VARCHAR(2),
    @FOP			INT,
    @TOTAL_PRICE	MONEY,
    @CARD_PRICE		MONEY,
    @CASH_PRICE		MONEY,
    @CARD_NUM		VARCHAR(16),
    @EXPIRE_DATE	VARCHAR(4),
    @CARD_AUTH		VARCHAR(8),
    @TICKET_STATUS	INT,			-- TicketStatusEnum { 전체 = 0, Normal = 1, Void, Refund };
    @GDS			INT,
    @COMPANY		INT,
    @CARD_RATE		NUMERIC(5,2),
    @NEW_CODE		NEW_CODE,
    @ISSUE_DATE		DATETIME,
    @PNR			VARCHAR(9),
    @PARENT_TICKET	VARCHAR(10),
    @IATA_FEE		MONEY,
    @CARD_COMM		MONEY
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @RESULT1 CHAR(1) = 'N', @RESULT2 CHAR(1) = 'N', @RESULT3 CHAR(1) = 'N'
	
	--------------------------------------------------------------------------------------
	-- TASF 등록
	--------------------------------------------------------------------------------------
	IF NOT EXISTS(
		SELECT 1 FROM dbo.DSR_TASF WHERE TICKET = @TICKET
	   )
	BEGIN
		INSERT INTO DSR_TASF 
			   (TICKET ,AIRLINE_NUM ,AIRLINE_CODE ,FOP ,TOTAL_PRICE ,CARD_PRICE ,CASH_PRICE ,CARD_NUM ,EXPIRE_DATE ,CARD_AUTH
			   ,TICKET_STATUS ,GDS ,COMPANY ,CARD_RATE ,NEW_CODE ,ISSUE_DATE ,PNR ,PARENT_TICKET ,IATA_FEE ,CARD_COMM)
		VALUES
			   (@TICKET ,@AIRLINE_NUM ,@AIRLINE_CODE ,@FOP ,@TOTAL_PRICE ,@CARD_PRICE ,@CASH_PRICE ,@CARD_NUM ,@EXPIRE_DATE ,@CARD_AUTH
			   ,@TICKET_STATUS ,@GDS ,@COMPANY ,@CARD_RATE ,@NEW_CODE ,@ISSUE_DATE ,@PNR ,@PARENT_TICKET ,@IATA_FEE ,@CARD_COMM)
			   
		SET @RESULT1 = 'Y'
	END

	--------------------------------------------------------------------------------------
	-- 환불 TASF 등록
	--------------------------------------------------------------------------------------
	-- 부모 티켓 정보 조회
	DECLARE @PRO_CODE VARCHAR(20), @RES_CODE VARCHAR(20), @PROFIT_TEAM_CODE VARCHAR(3), @PROFIT_TEAM_NAME VARCHAR(50)
		, @NEW_MASTER_CODE VARCHAR(10) = 'ZTR100', @NEW_PRO_CODE VARCHAR(20), @NEW_RES_CODE VARCHAR(20), @NEW_SEQ_NO INT
		, @DEP_DATE DATETIME, @ARR_DATE DATETIME, @CUS_NO INT, @CUS_NAME VARCHAR(40), @PAX_NAME VARCHAR(50), @REMARK VARCHAR(100), @VOID_TYPE CHAR(1)
	
	-- 고객정보
	SELECT @PRO_CODE = RM.PRO_CODE, @RES_CODE = RC.RES_CODE, @CUS_NO = RC.CUS_NO, @PAX_NAME = DT.PAX_NAME--, @CUS_NAME = RC.CUS_NAME
		, @REMARK = (DT.TICKET + '/' + DTA.CARD_AUTH + '/' + CONVERT(VARCHAR(10), DTA.ISSUE_DATE, 120) + '/' + DTA.TICKET)
		, @NEW_CODE = ISNULL(DT.ISSUE_CODE, @NEW_CODE)
		, @PROFIT_TEAM_CODE = RM.PROFIT_TEAM_CODE, @PROFIT_TEAM_NAME = RM.PROFIT_TEAM_NAME
		, @VOID_TYPE = (CASE WHEN RV100.SYNC_TYPE = 'cancelBooking' AND RV100.CANCEL_DTM NOT LIKE(RV100.ISSUE_DATE + '%') THEN 'R' WHEN RV100.SYNC_TYPE = 'refundTicketing' THEN 'R' ELSE 'E' END)
	FROM dbo.DSR_TASF DTA
	INNER JOIN dbo.DSR_TICKET DT ON DTA.PARENT_TICKET = DT.TICKET
	INNER JOIN dbo.RES_CUSTOMER_damo RC ON DT.RES_CODE = RC.RES_CODE AND DT.RES_SEQ_NO = RC.SEQ_NO
	INNER JOIN dbo.RES_MASTER_damo RM ON RC.RES_CODE = RM.RES_CODE
	INNER JOIN interface.TB_VGT_MA100 MA100 ON MA100.IF_SYS_RSV_NO = RM.RES_CODE
	INNER JOIN interface.TB_VGT_RV100 RV100 ON MA100.PNR_SEQNO = RV100.PNR_SEQNO
	WHERE DTA.TICKET = @TICKET;

	--------------------------------------------------------------------------------------
	-- 환불 TASF 예약생성 - PARENT_TICKET 없을 때는 수동 등록
	--------------------------------------------------------------------------------------
	IF EXISTS(
		SELECT 1
		FROM dbo.RES_MASTER_damo RM
		INNER JOIN interface.TB_VGT_MA100 MA100 ON RM.RES_CODE = MA100.IF_SYS_RSV_NO
		INNER JOIN interface.TB_VGT_RV100 RV100 ON MA100.PNR_SEQNO = RV100.PNR_SEQNO
		WHERE RES_CODE = @RES_CODE AND RV100.DI_FLAG = 'I' AND @VOID_TYPE = 'R') --AND RV100.SYNC_TYPE = 'refundTicketing')
			AND EXISTS(SELECT 1 FROM dbo.PAY_MATCHING PM INNER JOIN dbo.PAY_MASTER_damo PMD ON PM.PAY_SEQ = PMD.PAY_SEQ WHERE PM.RES_CODE = @RES_CODE AND PM.CXL_YN = 'N' AND PMD.PAY_TYPE = 12)
	BEGIN
		-- 행사정보
		SELECT @NEW_PRO_CODE = @NEW_MASTER_CODE + '-' + CONVERT(VARCHAR(4), GETDATE(), 12) + '01TASF'
			, @DEP_DATE = CONVERT(VARCHAR(4), GETDATE(), 12) + '01'
			, @ARR_DATE = CONVERT(VARCHAR(4), GETDATE(), 12) + '02'

		IF NOT EXISTS(SELECT 1 FROM PKG_DETAIL WHERE PRO_CODE = @NEW_PRO_CODE)
		BEGIN
			-- 행사생성
			INSERT INTO PKG_DETAIL
				(PRO_CODE, PRO_NAME, MASTER_CODE, TRANSFER_TYPE, SEAT_CODE, DEP_DATE, ARR_DATE, TOUR_NIGHT, TOUR_DAY, MIN_COUNT, MAX_COUNT,
				LAST_PAY_DATE, SENDING_YN, DEP_CFM_YN, CONFIRM_YN, SHOW_YN, NEW_CODE ,NEW_DATE, PRO_TYPE)
			VALUES
				(@NEW_PRO_CODE, '환불수수료 TASF', 'ZTR100', 3, 0, @DEP_DATE, DATEADD(DD, 1, @DEP_DATE), 1, 2, 0, 0,
				@DEP_DATE, 'N', 'N', 'Y', 'N', @NEW_CODE, GETDATE(), 2)
			
			-- 예약생성
			DECLARE @TMP_RES_CODE TABLE (RES_CODE VARCHAR(20));
			INSERT @TMP_RES_CODE
			EXEC DIABLO.DBO.XP_WEB_RES_MASTER_INSERT @RES_AGT_TYPE=0, @PRO_TYPE=2,  @RES_TYPE=0,  @RES_PRO_TYPE=2, @PROVIDER=1, @RES_STATE=2, @RES_CODE=NULL,
				@MASTER_CODE=@NEW_MASTER_CODE, @PRO_CODE=@NEW_PRO_CODE, @PRICE_SEQ=1, @PRO_NAME='환불수수료 TASF', @DEP_DATE=@DEP_DATE, @ARR_DATE=@ARR_DATE, @LAST_PAY_DATE=@DEP_DATE, 
				@CUS_NO=@CUS_NO, @RES_NAME=@PAX_NAME, @BIRTH_DATE=NULL, @GENDER=NULL, @IPIN_DUP_INFO=NULL, @RES_EMAIL=NULL, @NOR_TEL1=NULL, @NOR_TEL2=NULL, 
				@NOR_TEL3=NULL, @ETC_TEL1=NULL, @ETC_TEL2=NULL, @ETC_TEL3=NULL, @RES_ADDRESS1=NULL, @RES_ADDRESS2=NULL, @ZIP_CODE=NULL, @MEMBER_YN='N', 
				@CUS_REQUEST=NULL, @CUS_RESPONSE=NULL, @COMM_RATE=0.0, @COMM_AMT=0, @NEW_CODE=@NEW_CODE, @ETC=NULL, @SYSTEM_TYPE='1', @SALE_COM_CODE=NULL, 
				@TAX_YN='N';

			SELECT TOP 1 @NEW_RES_CODE = RES_CODE FROM @TMP_RES_CODE;
				
			-- RES_AIR_DETAIL 등록
			INSERT INTO RES_AIR_DETAIL (RES_CODE, PRO_CODE) VALUES (@NEW_RES_CODE, @NEW_PRO_CODE);
			
			-- 정산생성
			-- public enum SetStateEnum { 정산진행중, 결제진행중, 정산완료, 재정산, 미정산 = 9 };
			INSERT INTO SET_MASTER (PRO_CODE, MASTER_CODE, PRO_TYPE, DEP_DATE, NEW_CODE, PROFIT_TEAM_CODE, PROFIT_TEAM_NAME, SET_STATE) -- , CLOSE_CODE, CLOSE_DATE
			VALUES (@NEW_PRO_CODE, @NEW_MASTER_CODE, 2, @DEP_DATE, @NEW_CODE, @PROFIT_TEAM_CODE, @PROFIT_TEAM_NAME, 0)
		END
		ELSE
		BEGIN
			SELECT TOP 1 @NEW_RES_CODE = RES_CODE FROM RES_MASTER_damo WHERE PRO_CODE = @NEW_PRO_CODE
		END
		
		
		-- 예약자 순번
		SELECT @NEW_SEQ_NO = ISNULL((SELECT (MAX(SEQ_NO) + 1) FROM dbo.RES_CUSTOMER_damo RC WHERE RC.RES_CODE = @NEW_RES_CODE), 1)

		-- 티켓번호로 중복 체크
		IF NOT EXISTS(SELECT 1 FROM RES_CUSTOMER_damo RC WHERE RC.RES_CODE = @NEW_RES_CODE AND RC.TICKET = @TICKET)
		BEGIN
			-- 출발자 등록
			INSERT INTO dbo.RES_CUSTOMER_damo (RES_CODE, SEQ_NO, CUS_NO, CUS_NAME, AGE_TYPE, BIRTH_DATE, GENDER, SALE_PRICE, ETC_REMARK, NEW_CODE, NEW_DATE, TICKET)
			VALUES (@NEW_RES_CODE, @NEW_SEQ_NO, @CUS_NO, @CUS_NAME, 1, NULL, NULL, @TOTAL_PRICE, @REMARK, @NEW_CODE, GETDATE(), @TICKET)
		
			-- 개인경비 등록
			INSERT INTO SET_CUSTOMER (PRO_CODE, RES_CODE, RES_SEQ_NO, ETC_PROFIT, REMARK, NEW_CODE, NEW_DATE, TICKET)
			VALUES (@NEW_PRO_CODE, @NEW_RES_CODE, @NEW_SEQ_NO, @TOTAL_PRICE, '여행사 환불 수수료', @NEW_CODE, GETDATE(), @TICKET)
				
			--------------------------------------------------------------------------------------
			-- 행사, 예약코드에 환불 TASF 전용 코드 넣어 줌
			SELECT @RESULT2 = 'Y', @PRO_CODE = @NEW_PRO_CODE, @RES_CODE = @NEW_RES_CODE
			--------------------------------------------------------------------------------------
		END
	END
		
	--------------------------------------------------------------------------------------
	-- 티켓상태 Normal 이고 티켓번호 기준 중복 입금이 없으면
	--------------------------------------------------------------------------------------
	IF @TICKET_STATUS = 1
		AND NOT EXISTS(
		        SELECT 1
		        FROM   dbo.PAY_MASTER_damo PM
		        WHERE  PM.SEC1_PAY_NUM = damo.dbo.pred_meta_plain_v (@TICKET ,'DIABLO' ,'dbo.PAY_MASTER' ,'PAY_NUM')
		                AND PM.PAY_TYPE = 12 -- 12: TASF
		    )
	BEGIN
		    
		DECLARE @TMP_PAY_SEQ INT, @PAY_TYPE INT = 12, @PAY_SUB_NAME VARCHAR(50) = 'TASF', @MCH_TYPE INT = 0
			,@PAY_METHOD INT = 9	-- PaymentMethodEnum { 홈페이지 = 0, EMAIL, 직접방문, 전화, 은행, 수동 = 8, 시스템 = 9 };
		------------------------------------------------------------------------------------
			,@TASF_COMM_RATE DECIMAL(3,2) = 2.45	-- TASF 카드 결제 시 수수료 2021.12.27 지수계장님 협의
		------------------------------------------------------------------------------------
			,@COM_PRICE DECIMAL(12, 2)
			
		SELECT @PAX_NAME = ISNULL(@PAX_NAME, @TICKET) ,@COM_PRICE = (@TOTAL_PRICE * @TASF_COMM_RATE * 0.01)
			
		--입금마스터 저장
		INSERT INTO PAY_MASTER_DAMO
		(
			PAY_TYPE,		PAY_SUB_TYPE,	PAY_SUB_NAME,	AGT_CODE,
			ACC_SEQ,		PAY_METHOD,		PAY_NAME,
			PAY_PRICE,		COM_RATE,		COM_PRICE,		PAY_DATE,
			PAY_REMARK,		ADMIN_REMARK,	CUS_NO,			INSTALLMENT,
			CLOSED_YN,		NEW_CODE,		NEW_DATE,		CXL_YN,
			SEC_PAY_NUM,	SEC1_PAY_NUM
		)
		VALUES
		(
			@PAY_TYPE,		NULL,			@PAY_SUB_NAME,	NULL,
			NULL,			@PAY_METHOD,	@PAX_NAME,
			@TOTAL_PRICE,	NULL,			@CARD_COMM,		@ISSUE_DATE,
			@REMARK,		@REMARK,		NULL,			NULL,
			'N',			@NEW_CODE,		GETDATE(),		'N',
			damo.dbo.enc_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM',@TICKET),
			damo.dbo.pred_meta_plain_v( @TICKET ,'DIABLO','dbo.PAY_MASTER','PAY_NUM')
		)

		--입금매칭 저장
		SET @TMP_PAY_SEQ = @@IDENTITY;

		IF @RES_CODE IS NOT NULL AND @RES_CODE <> ''
		BEGIN
			INSERT INTO PAY_MATCHING
			(
				PAY_SEQ,		MCH_SEQ,		MCH_TYPE,		RES_CODE,
				PRO_CODE,		PART_PRICE,		CXL_YN,			NEW_DATE,
				NEW_CODE
			)
			VALUES
			(
				@TMP_PAY_SEQ,	1,				@MCH_TYPE,		@RES_CODE,
				@PRO_CODE,		@TOTAL_PRICE,	'N',			GETDATE(),
				@NEW_CODE
			);
	
			-- 현재 예약상태가 출발완료 이하 일때만 실행한다.
			IF EXISTS (SELECT 1 FROM DBO.RES_MASTER_DAMO WHERE RES_CODE = @RES_CODE AND RES_STATE < 5)
			BEGIN
				UPDATE RES_MASTER_DAMO
					SET RES_STATE = CASE WHEN (SELECT DBO.FN_RES_GET_TOTAL_PRICE(@RES_CODE) - ISNULL(SUM(PART_PRICE) , 0) FROM PAY_MATCHING WHERE RES_CODE = @RES_CODE AND CXL_YN = 'N') <= 0 THEN 4 ELSE 3 END,
						EDT_CODE = @NEW_CODE,
						EDT_DATE = GETDATE()
				WHERE RES_CODE = @RES_CODE
			END
		END
			
		SET @RESULT3 = 'Y'
			    
	END
	
	SELECT @RESULT1 + @RESULT2 + @RESULT3
	
END
GO
