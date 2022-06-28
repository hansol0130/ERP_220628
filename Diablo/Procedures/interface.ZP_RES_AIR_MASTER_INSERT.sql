USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================    
■ USP_NAME				: [ZP_RES_AIR_MASTER_INSERT]    
■ DESCRIPTION			: 예약 등록 및 수정 
■ INPUT PARAMETER		:     
■ OUTPUT PARAMETER		: 
■ EXEC					: 
■ MEMO					: 오류 발생 시 @RES_CODE = NULL, @MESSAGE = 오류메세지
						 
	EXEC [interface].[ZP_RES_AIR_MASTER_INSERT] @PNR_SEQNO = 3208, @AUTO_YN = 'N'

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION
------------------------------------------------------------------------------------------------------------------
	2021-01-20		김성호			최초생성
	2021-03-29		김성호			행사코드 ('-') 수정, 행사 수정 시 행사 생성 로직 추가
	2021-03-30		김성호			TAX_PRICE에 유류할증료(RV110.BAF) 추가
									SET_MASTER 등록 시 가상행사코드 생성 추가
									interface.TB_VGT_MA900 로그 기능 추가
									입금연동 국내 (@DI_FLAG='D'), 카드만 되도록 수정 (RV410.DEPOSIT_FLAG = 'CCCC') 
	2021-04-01		김성호			입금연동 대체항목 추가 (RV410.DEPOSIT_FLAG = 'CCRP')
									수동실행을 위한 로그 OFF 파라메터 추가
	2021-04-01		김성호			0 나누기 예외처리
									지상비 삭제 후 재등록 추가
	2021-04-05		김성호			입금정보 참조 테이블 변경 (RV410 -> RV130)
	2021-04-06		김성호			로그 기록 부분 수정
	2021-04-08		김성호			정산 지상비 등록 시 TASF(CHG_PRICE) 제외 하도록 수정
	2021-04-12		김성호			담당자 변경 시 수익부서 수익부서 변경되도록 수정
	2021-04-15		김성호			수동실행 로그 등록되도록 수정, 담당자변경 시 정산 수익부서 수정되도록 수정
	2021-04-20		김성호			수동 수수료 연동 추가 (TB_VGT_RV310)
	2021-04-23		김성호			수동 수수료 연동 삭제 (TB_VGT_RV310) - 항공판매팀 요청 : 경우의 수가 많아 수동처리 예정
	2021-04-29		김성호			국내 환불 시 입출금 데이터 마이너스 처리, 국내 refundTicketing 호출 예외처리
	2021-05-10		김성호			환불시 조건값 오류 수정
	2021-06-01		김성호			환불시 기타수익 등록 JOIN 오류 수정
									당일 취소 시 TASF도 환불
	2021-09-09		김성호			해외 연동 시 정산 항공비 탭 (항공사, 고객) 정보 등록
	2021-10-13		김성호			일정 변경 시 지역이 다르거나(MASTER_CODE) 변경된 출발일이 금일 이후인 경우만 행사 변경되도록 수정
	2021-10-19		김성호			해외항공 OZ 항공 발권 시 TASF 입금등록 처리, 예약 취소, 환불 시 TASF 개인경비 등록 처리
	2021-11-09		김성호			스카이스캐너, 네이버 거래처 추가
	2021-11-15		김성호			유입처에 따른 행사/예약명 변경
	2021-11-24		김성호			판매가에 RV110.SALE_QUE_AMT 추가
									판매처 수수료 계산 추가 (스카이스캐너 0.02)
	2021-11-30		김성호			해외항공 결제 전 취소 시 수수료 적용 예외처리
	2021-12-07		김성호			판매처 수수료 적용
	2021-12-14		김성호			환불 요청시 최초 1회만 개인경비에 TASF 등록 (부분 최소등은 항공팀 수동 처리)
	2021-12-15		김성호			네이버항공 거래처코드 변경 (네이버항공 0.01)
									취소 금액 지상비 등록 시 기존값 합이 0보다 큰지 확인 후 등록
	2021-12-17		김성호			행사코드 변경 체크 로직 비 활성화
	2021-12-27		김성호			TASF 입금등록 시 수수료 계산하기 추가 (수수료율 2.4%)
	2022-01-04		김성호			행사 정산마감인 경우 실행 취소
	2022-01-05		김성호			마지막 세그먼트의 클래스 정보 세팅 FareSeatTypeEnum { 전체 = 0, 일반석, 프리미엄일반석, 비지니스, 일등석 }
	2022-01-06		김성호			할인금액 계산 식 수정
	2022-02-09		김성호			출발일 세팅 변경 (항공 일정 중 등록 시점 이후 첫 출발일로 세팅)
	2022-02-10		김성호			고객, 예약자, 출발자 테이블 고객명 자리 수 차이로 인한 에러 예외처리 (고객 VARCHAR(20), 예약 VARCHAR(40))
	2022-02-17		김성호			수정 시 RES_MASTER 수수료 금액 수정 되도록 수정 (COMM_AMT)
	2022-02-18		김성호			수정 시 수수료 수정 다시 삭제 (취소 시 수수료 재 업데이트 문제)
	2022-03-17		김성호			취소,환불 국내 처리 시 입금합계가 0보다 큰 조건에 CCCF만 조회하도록 조건 추가
	2022-03-18		김성호			오류 시 진행단계 체크를 위한 진행단계 추가
	2022-03-24		김성호			제휴사 수수료 계산식 유류할증료, 할인금액 제외한 net가 기준으로 변경 (RV110.SALE_NET_AMT + RV110.SALE_QUE_AMT => RV110.SALE_DSCNT_AMT)
	2022-04-25		김성호			RES_AIR_DETAIL의 AIRLINE_CODE 검색 위치 변경 (RV120 -> RV100.STOCK_AIR_CD)
	2022-04-29		김성호			온라인 정산방식 변경으로 행사 출발일 -> 발권일 변경 로직 추가
	2022-05-04		김성호			IF @SYNC_TYPE = 'cancelBooking'	일 경우 @VOID_YN 에 따라 정산 로직 변경
									정산방식 변경 조건 온라인 팀(TEAM_CODE = 560) 으로 변경
	2022-05-12		김성호			해외항공 OZ TASF 등록 시 최초 등록일 유지 하도록 수정
	2022-05-16		김성호			IF @SYNC_TYPE = 'cancelBooking'	일 경우 CANCEL, VOID, REFUND 에 따른 프로세스 변경
	2022-05-17		김성호			OZ 입금연동 TASF 인터페이스 테이블 생성까지 일시 보류
	2022-05-20		김성호			시스템마감 시 연동 안되게 수정
									예약생성 시 행사코드 중복되지 않도록 WHILE 추가
	2022-05-25		김성호			발권일 NULL인 경우 업데이트 안되도록 수정
	2022-06-02		김성호			정산방식 변경 조건 황희웅(2018048)계장 추가
	2022-06-07		김성호			정산방식 체크 시 출발날짜에서 시분초는 제외
================================================================================================================*/
CREATE PROCEDURE [interface].[ZP_RES_AIR_MASTER_INSERT]

	@PNR_SEQNO	INT,
	@AUTO_YN	CHAR(1) = 'Y',
	@SYNC_TYPE	VARCHAR(50) = NULL

AS     
BEGIN

    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    ------------------------------------------------------------------------
	-- 대칭키 OPEN
	------------------------------------------------------------------------
	IF NOT EXISTS (SELECT * FROM SYS.OPENKEYS  WHERE KEY_NAME = 'SYM_TOPAS_AIR')
	BEGIN
		OPEN SYMMETRIC KEY SYM_TOPAS_AIR
			DECRYPTION BY CERTIFICATE CERT_TOPAS_AIR
			WITH PASSWORD = '!verygood20210105'
	END
	
	------------------------------------------------------------------------
	-- 트리거 동작 제외
	------------------------------------------------------------------------
	SET CONTEXT_INFO 0x21884680;
	
	
	------------------------------------------------------------------------
	-- 전역 변수 선언
	------------------------------------------------------------------------
	DECLARE @SUBJECT VARCHAR(300), @CONTENTS NVARCHAR(300), @STEP_STRING VARCHAR(30)
	
	------------------------------------------------------------------------
	-- 정산확인 (기본값이 있어야 마감 조건을 통과)
	------------------------------------------------------------------------
	DECLARE @SET_STATE INT = 0 --, @CLOSE_CODE CHAR(7) = '9999999'
	SELECT @SET_STATE = SM.SET_STATE --, @CLOSE_CODE = SM.CLOSE_CODE
	FROM interface.TB_VGT_MA100 MA100
	INNER JOIN dbo.RES_MASTER_damo RM ON MA100.IF_SYS_RSV_NO = RM.RES_CODE
	INNER JOIN dbo.SET_MASTER SM ON RM.PRO_CODE = SM.PRO_CODE
	WHERE MA100.PNR_SEQNO = @PNR_SEQNO;
	
	------------------------------------------------------------------------
	-- 정산마감 체크 (CLOSE_CODE가  '9999999'는 가정산마감)
	------------------------------------------------------------------------
	IF @SET_STATE <> 2 --OR @CLOSE_CODE = '9999999'
	BEGIN
		
		------------------------------------------------------------------------
		-- 실행로그
		------------------------------------------------------------------------
		INSERT INTO interface.TB_VGT_MA900 (PNR_SEQNO, IN_DATE, AUTO_YN) VALUES (@PNR_SEQNO, GETDATE(), @AUTO_YN);

	
		-- 리턴 변수
		DECLARE @RES_CODE VARCHAR(20) = NULL, @CUS_NO INT = 0, @RESULT_CODE INT = 1, @MESSAGE NVARCHAR(2048) = NULL
			, @LINK_NO INT = @@IDENTITY, @TODAY VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112)
	
		BEGIN TRY
		
			BEGIN TRAN
				------------------------------------------------------------------------
				-- 인터페이스 데이터 조회
				------------------------------------------------------------------------
				BEGIN
					SET @STEP_STRING = '인터페이스 데이터 조회';
					
					DECLARE
						@MASTER_CODE VARCHAR(10), @PRO_CODE VARCHAR(20), @PRO_NAME VARCHAR(100), @BIT_CODE VARCHAR(4), @PROVIDER VARCHAR(10), @RES_STATE INT,
						@DEP_DATE DATETIME, @ARR_DATE DATETIME, @LAST_PAY_DATE DATETIME, @SYSTEM_TYPE INT, @SALE_COM_CODE VARCHAR(50), @AIR_GDS INT, @AIRLINE_CODE VARCHAR(2),
						@AIR_PRO_TYPE INT = 0, -- 실시간 = 0, 공동구매, 할인항공, 땡처리항공, 프로모션, 깜짝특가, 오프라인, 전체 = 9
						@CUS_NAME VARCHAR(20), @BIG_CUS_NAME VARCHAR(40), @MEMBER_YN CHAR(1), @EMAIL VARCHAR(50), @RES_TYPE INT,
						@NOR_TEL VARCHAR(20), @NOR_TEL1 VARCHAR(10), @NOR_TEL2 VARCHAR(10), @NOR_TEL3 VARCHAR(10),  
						@DI_FLAG VARCHAR(10), -- D: 국내, I: 해외
						@ROUTING_TYPE INT, @COMM_AMT INT,
						@PNR_CODE VARCHAR(10), @AIR_RES_CODE VARCHAR(10), @SET_AGT_CODE VARCHAR(10), @SET_SEQ_NO INT, -- 정산순번
						@NEW_CODE VARCHAR(10), @NEW_TEAM_CODE VARCHAR(3), @NEW_TEAM_NAME VARCHAR(50),
						@SALE_EMP_CODE EMP_CODE, @SALE_TEAM_CODE VARCHAR(3), @SALE_TEAM_NAME varchar(50),
						@PROFIT_EMP_CODE EMP_CODE, @PROFIT_TEAM_CODE varchar(3), @PROFIT_TEAM_NAME varchar(50),
						@REG_DTM VARCHAR(8), @BPLC_CD VARCHAR(10), @ISSUE_DATE DATETIME, @VOID_TYPE CHAR(1),
						------------------------------------------------------------------------------------
						@TASF_COMM_RATE DECIMAL(3,2) = 2.45;	-- TASF 카드 결제 시 수수료 2021.12.27 지수계장님 협의
						------------------------------------------------------------------------------------

					-- 정보 검색
					SELECT @RES_CODE = IF_SYS_RSV_NO FROM interface.TB_VGT_MA100 WHERE PNR_SEQNO = @PNR_SEQNO;

					SELECT
						--@RES_CODE = RV100.IF_SYS_RSV_NO,
						@AIR_RES_CODE = RV100.RSV_NO,
						@PNR_CODE = RV100.ALPHA_PNR_NO,
						@DI_FLAG = RV100.DI_FLAG,	-- D: 국내, I: 해외
						@CUS_NO = CONVERT(INT, RV100.RSV_USR_ID),
						@BIG_CUS_NAME = SUBSTRING(RV100.RSV_USR_NM, 1, 40),
						@CUS_NAME = SUBSTRING(RV100.RSV_USR_NM, 1, 20),
						@MEMBER_YN = (CASE WHEN EXISTS(SELECT 1 FROM DBO.CUS_MEMBER WHERE CUS_NO =  CONVERT(INT, RV100.RSV_USR_ID)) THEN 'Y' ELSE 'N' END),
						@SYSTEM_TYPE = (CASE WHEN RV100.DVICE_TYPE = 'PC' THEN 1 ELSE 3 END),	-- PC: 1, MOBILE: 3
						@RES_TYPE = (CASE WHEN RV100.SALE_FORM_CD = 'BTMS' THEN 2 ELSE 0 END),  -- 0: 일반 , 1: 대리점, 2: 상용, 9: 지점
						@AIRLINE_CODE = RV100.STOCK_AIR_CD,
						@AIR_GDS = (	-- 해외, 국내에 따라 GDS 코드 분리 해야 할 필요?
							CASE RV100.GDS_CD
								WHEN 'T' THEN 5			-- 토파스(아마데우스) T
								WHEN 'A' THEN 2			-- Abacus  A
								WHEN 'G' THEN 3			-- Galileo G
								WHEN 'W' THEN 4			-- Worldspan W
								WHEN 'J' THEN 10		-- 진에어 J
								WHEN 'B' THEN 105		-- 에어부산 B
								WHEN 'Z' THEN 108		-- 이스타항공 Z
								WHEN 'Y' THEN 104		-- 티웨이 Y
								WHEN 'U' THEN 106		-- 제주항공 U
								WHEN 'R' THEN 107		-- 에어서울 R
							END),
						@SET_AGT_CODE = (
							CASE RV100.GDS_CD
								WHEN 'T' THEN '93776'	-- 11019: (주)대한항공, 93776: 대한항공(온라인항공)
								WHEN 'A' THEN '93777'	-- Abacus  A
								--WHEN 'G' THEN '11019'	-- Galileo G
								--WHEN 'W' THEN '11019'	-- Worldspan W
								WHEN 'J' THEN '91416'	-- 진에어 J
								WHEN 'B' THEN '91866'	-- 에어부산 B
								WHEN 'Z' THEN '92321'	-- 이스타항공 Z
								WHEN 'Y' THEN '92223'	-- 티웨이 Y
								WHEN 'U' THEN '91329'	-- 제주항공 U
								WHEN 'R' THEN '94122'	-- 에어서울 R
							END),
						@PROVIDER = (
							CASE
								WHEN RV100.ON_OFF_RSV_FLAG = 'OFF' THEN '1'				-- 직판
								WHEN RV100.BPLC_CD = 'SKY001' THEN '44'					-- 스카이스캐너
								WHEN RV100.BPLC_CD = 'N00001' THEN '45'					-- 네이버항공
								WHEN RV100.BPLC_CD = 'TMO001' THEN '36'					-- 티몬
								WHEN RV100.BPLC_CD = 'WMP001' THEN '42'					-- 위메프
								WHEN RV100.BPLC_CD = 'SKM001' THEN '31'					-- 11번가
								ELSE '5'												-- 인터넷
							END),
						@SALE_COM_CODE = (
							CASE
								WHEN RV100.BPLC_CD = 'SKY001' THEN '18095'				-- 스카이스캐너
								WHEN RV100.BPLC_CD = 'N00001' THEN '18098'				-- 네이버항공
								WHEN RV100.BPLC_CD = 'TMO001' THEN '93024'				-- 티몬
								WHEN RV100.BPLC_CD = 'WMP001' THEN '92768'				-- 위메프
								WHEN RV100.BPLC_CD = 'SKM001' THEN '16084'				-- 11번가
								WHEN RV100.SALE_FORM_CD = 'BTMS' THEN RV100.BCNC_CD		-- BTMS 거래처코드
							END),
						@BPLC_CD = RV100.BPLC_CD,
						@ROUTING_TYPE = (
							CASE RV100.TRIP_TYPE_CD
								WHEN 'RT' THEN 0							-- 왕복 
								WHEN 'OW' THEN 1							-- 편도 
								WHEN 'MT' THEN 2							-- 다구간 
							END),
						@LAST_PAY_DATE = [interface].[ZN_PUB_STRING_TO_DATETIME](RV100.PAY_TL),
						@NOR_TEL = [interface].[ZN_PUB_AIR_DECRYPT](RV100.MPHONE_NO, RV100.PNR_SEQNO),
						@EMAIL = [interface].[ZN_PUB_AIR_DECRYPT](RV100.EMAIL, RV100.PNR_SEQNO),
						@NEW_CODE = RV100.CHRG_USR_ID,
						--@SYNC_TYPE = ISNULL(@SYNC_TYPE, RV100.SYNC_TYPE), -- 이벤트 타입
						@SYNC_TYPE = (
							CASE
								WHEN @SYNC_TYPE IS NOT NULL THEN @SYNC_TYPE		-- SYNC_TYPE 지정 시
								-- 국내 구분 (DI_FLAG = 'D'), 싱크타입 (SYNC_TYPE = 'cancelBooking'), 발권상태코드 (ISSUE_STATUS_CD = 'TKKY' 발권완료), 당일 취소는 cancelBooking 처리
								WHEN RV100.DI_FLAG = 'D' AND RV100.SYNC_TYPE = 'cancelBooking' AND RV100.ISSUE_STATUS_CD = 'TKKY'
									AND SUBSTRING(RV100.REG_DTM, 1, 8) <> @TODAY  THEN 'refundTicketing'
								ELSE RV100.SYNC_TYPE
							END),
						@REG_DTM = SUBSTRING(RV100.REG_DTM, 1, 8),
						@ISSUE_DATE = [interface].[ZN_PUB_STRING_TO_DATETIME](RV100.ISSUE_DATE),
						--@VOID_YN = (CASE WHEN RV100.SYNC_TYPE = 'cancelBooking' AND LEN(RV100.ISSUE_DATE) = 8 THEN 'Y' ELSE 'N' END) -- Y: VOID, N: CANCEL
						-- V: VOID, R: REFUND, C: CANCEL, E: 기타
						@VOID_TYPE = (
							CASE
								WHEN RV100.SYNC_TYPE = 'cancelBooking' AND RV100.ISSUE_DATE = '' THEN 'C'
								WHEN RV100.SYNC_TYPE = 'cancelBooking' AND RV100.CANCEL_DTM LIKE(RV100.ISSUE_DATE + '%') THEN 'V'
								WHEN RV100.SYNC_TYPE = 'cancelBooking' AND RV100.CANCEL_DTM NOT LIKE(RV100.ISSUE_DATE + '%') THEN 'R'
								WHEN RV100.SYNC_TYPE = 'refundTicketing' THEN 'R'
								ELSE 'E'
							END)
					FROM interface.TB_VGT_RV100 RV100
					WHERE RV100.PNR_SEQNO = @PNR_SEQNO;
				
					-- 출국 출발, 귀국 도착 시간 설정
					SELECT
						@DEP_DATE = ISNULL(MIN([interface].[ZN_PUB_STRING_TO_DATETIME](DEP_DATE + DEP_TM)), '2999-01-01'),
						@ARR_DATE = ISNULL(MAX([interface].[ZN_PUB_STRING_TO_DATETIME](ARR_DATE + ARR_TM)), '2999-01-02') 
					FROM interface.TB_VGT_RV120 RV120
					WHERE RV120.PNR_SEQNO = @PNR_SEQNO AND RV120.DEP_DATE > GETDATE();

					-- 전화번호 분리
					IF ISNULL(@NOR_TEL, '') <> ''
					BEGIN 
						SELECT
							@NOR_TEL1 = LEFT(@NOR_TEL, CHARINDEX('-', @NOR_TEL) - 1),
							@NOR_TEL2 = SUBSTRING(@NOR_TEL, CHARINDEX('-', @NOR_TEL)+1, LEN(@NOR_TEL)-CHARINDEX('-', @NOR_TEL)-CHARINDEX('-', REVERSE(@NOR_TEL))),
							@NOR_TEL3 = RIGHT(@NOR_TEL,CHARINDEX('-', REVERSE(@NOR_TEL))-1);
					END
					
					-- MASTER_CODE 조회
					SELECT @MASTER_CODE = CP.PUB_VALUE
					FROM dbo.PUB_AIRPORT PA
					INNER JOIN dbo.PUB_CITY PC ON PA.CITY_CODE = PC.CITY_CODE
					INNER JOIN dbo.PUB_NATION PN ON PC.NATION_CODE = PN.NATION_CODE
					INNER JOIN dbo.COD_PUBLIC CP ON CP.PUB_TYPE = 'AIR.MASTER.CODE' AND PN.REGION_CODE =  CP.PUB_CODE
					WHERE PA.AIRPORT_CODE IN (SELECT ARR_AIRPORT_CD FROM interface.TB_VGT_RV120 WHERE PNR_SEQNO = @PNR_SEQNO AND ITIN_NO = 1);

					-- 수수료 계산
					SELECT @COMM_AMT = CEILING(
						SUM(ISNULL(RV110.SALE_DSCNT_AMT,0)) * (	-- SALE_DSCNT_AMT: 네트에서 할인금액이 제외한 금액
						CASE @BPLC_CD
							WHEN 'SKY001' THEN 0.02				-- 스카이스캐너
							WHEN 'N00001' THEN 0.01				-- 네이버항공
							ELSE 0 
						END))
					FROM interface.TB_VGT_RV110 RV110
					WHERE RV110.PNR_SEQNO = @PNR_SEQNO;

				END

				------------------------------------------------------------------------
				-- RES_MASTER 등록
				------------------------------------------------------------------------
				IF ISNULL(@RES_CODE, '') = ''
				BEGIN
					SET @STEP_STRING = 'RES_MASTER 등록'

					-- 고객번호가 1보다 작으면 고객 등록
					IF @CUS_NO <= 1
					BEGIN
						DECLARE @TMP_CUS_NO TABLE (CUS_NO INT);
						INSERT @TMP_CUS_NO
						EXEC dbo.XP_CUS_CUSTOMER_BASE_INSERT @CUS_NAME=@CUS_NAME, @BIRTH_DATE=NULL, @GENDER=NULL, @NOR_TEL1=@NOR_TEL1, @NOR_TEL2=@NOR_TEL2, @NOR_TEL3=@NOR_TEL3,
							@EMAIL=@EMAIL, @HOM_TEL1=NULL, @HOM_TEL2=NULL, @HOM_TEL3=NULL, @ZIP_CODE=NULL, @ADDRESS1=NULL, @ADDRESS2=NULL, @LAST_NAME=NULL, @FIRST_NAME=NULL,
							@PASS_NUM=NULL, @PASS_EXPIRE=NULL, @IPIN_DUP_INFO=NULL, @IPIN_CONN_INFO=NULL, @NEW_CODE=@NEW_CODE;
						SELECT @CUS_NO = CUS_NO FROM @TMP_CUS_NO;
					END

					-- 최대 3번까지만 돌아가도록
					DECLARE @LOOP INT = 3;
					WHILE (@LOOP > 0)
					BEGIN
					    -- 행사코드 BIT_CODE 조회
					    EXEC dbo.SP_PRO_GET_PRO_CODE 'T' ,@BIT_CODE OUTPUT;
					    
					    -- PRO_CODE 세팅
					    SET @PRO_CODE = (@MASTER_CODE + '-' + CONVERT(VARCHAR(6) ,@DEP_DATE ,12) + @BIT_CODE);
					    
					    IF NOT EXISTS(SELECT 1 FROM dbo.PKG_DETAIL WHERE  PRO_CODE = @PRO_CODE)
					        BREAK;
					    ELSE
							SET @LOOP = @LOOP - 1;
					END
					
					-- PRO_NAME 세팅
					SET @PRO_NAME = '[' + (CASE @PROVIDER WHEN '36' THEN '티몬' WHEN '45' THEN '네이버항공' WHEN '44' THEN '스카이스캐너' ELSE '실시간항공' END) + '] '
					       + @CUS_NAME + ' | ' + CONVERT(VARCHAR(10) ,@DEP_DATE ,120);

					-- 예약생성
					DECLARE @TMP_RES_CODE TABLE (RES_CODE VARCHAR(20));
					INSERT @TMP_RES_CODE
					EXEC DIABLO.DBO.XP_WEB_RES_MASTER_INSERT @RES_AGT_TYPE=0, @PRO_TYPE=2,  @RES_TYPE=@RES_TYPE,  @RES_PRO_TYPE=2, @PROVIDER=@PROVIDER, @RES_STATE=2, @RES_CODE=NULL,
						@MASTER_CODE=@MASTER_CODE, @PRO_CODE=@PRO_CODE, @PRICE_SEQ=1, @PRO_NAME=@PRO_NAME, @DEP_DATE=@DEP_DATE, @ARR_DATE=@ARR_DATE, @LAST_PAY_DATE=@LAST_PAY_DATE, 
						@CUS_NO=@CUS_NO, @RES_NAME=@BIG_CUS_NAME, @BIRTH_DATE=NULL, @GENDER=NULL, @IPIN_DUP_INFO=NULL, @RES_EMAIL=@EMAIL, @NOR_TEL1=@NOR_TEL1, @NOR_TEL2=@NOR_TEL2, 
						@NOR_TEL3=@NOR_TEL3, @ETC_TEL1=NULL, @ETC_TEL2=NULL, @ETC_TEL3=NULL, @RES_ADDRESS1=NULL, @RES_ADDRESS2=NULL, @ZIP_CODE=NULL, @MEMBER_YN=@MEMBER_YN, 
						@CUS_REQUEST=NULL, @CUS_RESPONSE=NULL, @COMM_RATE=0.0, @COMM_AMT=@COMM_AMT, @NEW_CODE=@NEW_CODE, @ETC=NULL, @SYSTEM_TYPE=@SYSTEM_TYPE, @SALE_COM_CODE=@SALE_COM_CODE, 
						@TAX_YN='N';

					SELECT TOP 1 @RES_CODE = RES_CODE FROM @TMP_RES_CODE;
				
					-- 매핑테이블 등록
					INSERT INTO interface.TB_VGT_MA100 (PNR_SEQNO, IF_SYS_RSV_NO, REG_USR_ID)
					VALUES (@PNR_SEQNO, @RES_CODE, 'SYSTEM');
									
				END
				------------------------------------------------------------------------
				-- RES_MASTER 수정
				------------------------------------------------------------------------
				ELSE IF EXISTS(SELECT 1 FROM Diablo.dbo.RES_MASTER_damo WHERE RES_CODE = @RES_CODE)
				BEGIN
					SET @STEP_STRING = 'RES_MASTER 수정'
					
					-- 이벤트 성격에 따라 예약 상태 값 변경
					SET @RES_STATE = (
						CASE
							WHEN @SYNC_TYPE = 'updateTicketing' THEN 5						-- 발권완료
							
							WHEN @DI_FLAG = 'D' AND @SYNC_TYPE = 'refundTicketing' THEN 7	-- 환불
							WHEN @DI_FLAG = 'D' AND @SYNC_TYPE = 'cancelBooking' THEN 9		-- 취소
							
							WHEN @DI_FLAG = 'I' AND @SYNC_TYPE = 'cancelBooking' AND @VOID_TYPE = 'V' THEN 7	-- 환불
							WHEN @DI_FLAG = 'I' AND @SYNC_TYPE = 'cancelBooking' AND @VOID_TYPE = 'C' THEN 9	-- 취소
							
							ELSE NULL														-- 현재상태유지 (해외 REFUND는 현행 유지)
						END)
					
					-- 현재 행사 정보 조회
					SELECT @PRO_CODE = RM.PRO_CODE, @PRO_NAME = RM.PRO_NAME
					FROM Diablo.dbo.RES_MASTER_damo RM
					WHERE RM.RES_CODE = @RES_CODE;
				
					-- 수익부서 세팅
					IF NOT EXISTS(SELECT 1 FROM DBO.RES_MASTER_DAMO RM WHERE RM.RES_CODE = @RES_CODE AND RM.NEW_CODE = @NEW_CODE)
					BEGIN
						SELECT
							@NEW_TEAM_CODE = ET.TEAM_CODE,
							@NEW_TEAM_NAME = ET.TEAM_NAME,
							@SALE_EMP_CODE = EM.EMP_CODE,
							@SALE_TEAM_CODE = ET.TEAM_CODE,
							@SALE_TEAM_NAME = ET.TEAM_NAME,
							@PROFIT_EMP_CODE = EM.EMP_CODE,
							@PROFIT_TEAM_CODE = ET.TEAM_CODE,
							@PROFIT_TEAM_NAME = ET.TEAM_NAME
						FROM DBO.EMP_MASTER_DAMO EM
						INNER JOIN DBO.EMP_TEAM ET ON EM.TEAM_CODE = ET.TEAM_CODE
						WHERE EM.EMP_CODE = @NEW_CODE;
					END

					-- 예약정보 수정
					UPDATE RES_MASTER_DAMO SET
						RES_STATE = ISNULL(@RES_STATE, RES_STATE), MASTER_CODE = @MASTER_CODE, PRO_CODE = @PRO_CODE, PRICE_SEQ = 1, PRO_NAME = @PRO_NAME, DEP_DATE = @DEP_DATE, ARR_DATE = @ARR_DATE,
						LAST_PAY_DATE = @LAST_PAY_DATE, RES_EMAIL = @EMAIL, NOR_TEL1 = @NOR_TEL1, NOR_TEL2 = @NOR_TEL2, NOR_TEL3 = @NOR_TEL3,
						--COMM_AMT = @COMM_AMT, 스카이스캐너 수수료 삭제 재 업로드 문제로 제외
						NEW_CODE = @NEW_CODE,
						NEW_TEAM_CODE = ISNULL(@NEW_TEAM_CODE, NEW_TEAM_CODE),
						NEW_TEAM_NAME = ISNULL(@NEW_TEAM_NAME, NEW_TEAM_NAME),
						SALE_EMP_CODE = ISNULL(@SALE_EMP_CODE, SALE_EMP_CODE),
						SALE_TEAM_CODE = ISNULL(@SALE_TEAM_CODE, SALE_TEAM_CODE),
						SALE_TEAM_NAME = ISNULL(@SALE_TEAM_NAME, SALE_TEAM_NAME),
						PROFIT_EMP_CODE = ISNULL(@PROFIT_EMP_CODE, PROFIT_EMP_CODE),
						PROFIT_TEAM_CODE = ISNULL(@PROFIT_TEAM_CODE, PROFIT_TEAM_CODE),
						PROFIT_TEAM_NAME = ISNULL(@PROFIT_TEAM_NAME, PROFIT_TEAM_NAME),
						EDT_CODE = @NEW_CODE, EDT_DATE = GETDATE(), 
						CXL_CODE = (CASE WHEN @RES_STATE = 9 THEN @NEW_CODE ELSE NULL END),
						CXL_DATE = (CASE WHEN @RES_STATE = 9 THEN GETDATE() ELSE NULL END)
					WHERE RES_CODE = @RES_CODE;
				
				END
				ELSE
				BEGIN
					SET @MESSAGE = ('존재하지 않는 예약 코드 [' + @RES_CODE + ']');
				
					THROW 6000, @MESSAGE, 16;
				END

				------------------------------------------------------------------------
				-- createBooking: 신규예약, updateBooking: 예약수정
				------------------------------------------------------------------------
				IF @SYNC_TYPE IN ('createBooking', 'updateBooking')
				BEGIN
					------------------------------------------------------------------------
					-- RES_AIR_DETAIL(항공예약상세)
					------------------------------------------------------------------------
					SET @STEP_STRING = 'RES_AIR_DETAIL(항공예약상세)'
					DELETE FROM dbo.RES_AIR_DETAIL WHERE RES_CODE = @RES_CODE;
					WITH LIST AS
					(
						SELECT RV120.PNR_SEQNO, RV120.ITIN_BUNDLE_UNIT, MIN(ITIN_NO) MIN_NO,  MAX(ITIN_NO) MAX_NO, MIN(RV100.STOCK_AIR_CD) STOCK_AIR_CD
						FROM interface.TB_VGT_RV120 RV120
						INNER JOIN interface.TB_VGT_RV100 RV100 ON RV120.PNR_SEQNO = RV100.PNR_SEQNO
						WHERE RV120.PNR_SEQNO = @PNR_SEQNO
						GROUP BY RV120.PNR_SEQNO, RV120.ITIN_BUNDLE_UNIT
					)
					INSERT INTO dbo.RES_AIR_DETAIL (
						RES_CODE,					AIR_PRO_TYPE,		PRO_CODE,		AIR_GDS,		PNR_CODE1,		PNR_CODE2,			AIRLINE_CODE,
						INTER_YN,					ROUTING_TYPE,
						DEP_DEP_AIRPORT_CODE,		DEP_DEP_DATE,		DEP_DEP_TIME,
						DEP_ARR_AIRPORT_CODE,		DEP_ARR_DATE,		DEP_ARR_TIME,
						ARR_DEP_AIRPORT_CODE,		ARR_DEP_DATE,		ARR_DEP_TIME,
						ARR_ARR_AIRPORT_CODE,		ARR_ARR_DATE,		ARR_ARR_TIME,
						FARE_SEAT_TYPE
					)
					SELECT
						@RES_CODE,					@AIR_PRO_TYPE,		@PRO_CODE,		@AIR_GDS,		@PNR_CODE,		@AIR_RES_CODE,		A.AIRLINE_CODE,
						(CASE WHEN @DI_FLAG = 'I' THEN 'Y' ELSE 'N' END),				@ROUTING_TYPE,
						A.DEP_DEP_AIRPORT_CODE,		A.DEP_DEP_DATE,		CONVERT(VARCHAR(5), A.DEP_DEP_DATE, 108) AS [DEP_DEP_TIME],
						A.DEP_ARR_AIRPORT_CODE,		A.DEP_ARR_DATE,		CONVERT(VARCHAR(5), A.DEP_ARR_DATE, 108) AS [DEP_ARR_TIME],
						A.ARR_DEP_AIRPORT_CODE,		A.ARR_DEP_DATE,		CONVERT(VARCHAR(5), A.ARR_DEP_DATE, 108) AS [ARR_DEP_TIME],
						A.ARR_ARR_AIRPORT_CODE,		A.ARR_ARR_DATE,		CONVERT(VARCHAR(5), A.ARR_ARR_DATE, 108) AS [ARR_ARR_TIME],
						(CASE
							WHEN A.CABIN_SEAT_GRAD = 'W' THEN 2		-- 프리미엄일반석
							WHEN A.CABIN_SEAT_GRAD = 'C' THEN 3		-- 비지니스
							WHEN A.CABIN_SEAT_GRAD = 'F' THEN 4		-- 일등석
							ELSE 1									-- 일반석
						END) AS FARE_SEAT_TYPE
					FROM (
						SELECT 
							A.PNR_SEQNO,  --MAX(SEG1.AIR_RSV_NO) AS [PNR_CODE],
							--MAX(CASE WHEN A.MIN_NO = SEG1.ITIN_NO THEN SUBSTRING(SEG1.FLTNO, 1, 2) ELSE '' END) AS [AIRLINE_CODE],
							MAX(STOCK_AIR_CD) AS [AIRLINE_CODE],
							MAX(CASE WHEN A.MIN_NO = SEG1.ITIN_NO THEN SEG1.DEP_AIRPORT_CD ELSE '' END) AS [DEP_DEP_AIRPORT_CODE],
							MAX(CASE WHEN A.MIN_NO = SEG1.ITIN_NO THEN [interface].[ZN_PUB_STRING_TO_DATETIME](SEG1.DEP_DATE + SEG1.DEP_TM) ELSE NULL END) AS [DEP_DEP_DATE],
							MAX(CASE WHEN A.MAX_NO = SEG1.ITIN_NO THEN SEG1.ARR_AIRPORT_CD ELSE '' END) AS [DEP_ARR_AIRPORT_CODE],
							MAX(CASE WHEN A.MAX_NO = SEG1.ITIN_NO THEN [interface].[ZN_PUB_STRING_TO_DATETIME](SEG1.ARR_DATE + SEG1.ARR_TM) ELSE NULL END) AS [DEP_ARR_DATE],
							MAX(CASE WHEN A.MIN_NO = SEG2.ITIN_NO THEN SEG2.DEP_AIRPORT_CD ELSE '' END) AS [ARR_DEP_AIRPORT_CODE],
							MAX(CASE WHEN A.MIN_NO = SEG2.ITIN_NO THEN [interface].[ZN_PUB_STRING_TO_DATETIME](SEG2.DEP_DATE + SEG2.DEP_TM) ELSE NULL END) AS [ARR_DEP_DATE],
							MAX(CASE WHEN A.MAX_NO = SEG2.ITIN_NO THEN SEG2.ARR_AIRPORT_CD ELSE '' END) AS [ARR_ARR_AIRPORT_CODE],
							MAX(CASE WHEN A.MAX_NO = SEG2.ITIN_NO THEN [interface].[ZN_PUB_STRING_TO_DATETIME](SEG2.ARR_DATE + SEG2.ARR_TM) ELSE NULL END) AS [ARR_ARR_DATE],
							MAX(SEG2.CABIN_SEAT_GRAD) AS [CABIN_SEAT_GRAD]
						FROM LIST A
						LEFT JOIN interface.TB_VGT_RV120 SEG1 ON A.PNR_SEQNO = SEG1.PNR_SEQNO AND SEG1.ITIN_BUNDLE_UNIT = 1
						LEFT JOIN interface.TB_VGT_RV120 SEG2 ON A.PNR_SEQNO = SEG2.PNR_SEQNO AND SEG2.ITIN_BUNDLE_UNIT IN (SELECT MAX(ITIN_BUNDLE_UNIT) FROM LIST)
						GROUP BY A.PNR_SEQNO
					) A

					------------------------------------------------------------------------
					-- RES_CUSTOMER(출발자)
					------------------------------------------------------------------------
					SET @STEP_STRING = 'RES_CUSTOMER(출발자)'
					DELETE FROM dbo.RES_CUSTOMER_damo WHERE RES_CODE = @RES_CODE;
					INSERT INTO dbo.RES_CUSTOMER_damo (
						RES_CODE, SEQ_NO, CUS_NO, CUS_NAME, LAST_NAME, FIRST_NAME, AGE_TYPE, BIRTH_DATE, GENDER, SALE_PRICE, TAX_PRICE, CHG_PRICE, DC_PRICE, NEW_CODE, NEW_DATE)
					SELECT
						@RES_CODE, RV110.PAX_NO, 1,
						SUBSTRING((RV110.PAX_ENG_FMNM + RV110.PAX_ENG_NM), 1, 40) AS [CUS_NAME],
						SUBSTRING(RV110.PAX_ENG_FMNM, 1, 20) AS [LAST_NAME],
						SUBSTRING(RV110.PAX_ENG_NM, 1, 20) AS [FIRST_NAME],
						(RV110.PAX_AGE_FLAG - 1) AS [AGT_TYPE],
						[interface].[ZN_PUB_STRING_TO_DATETIME]([interface].[ZN_PUB_AIR_DECRYPT](RV110.PAX_BIRTH, RV110.PNR_SEQNO)) AS [BIRTH_DATE],
						(CASE RV110.PAX_SEX WHEN '1' THEN 'M' WHEN '2' THEN 'F' END) AS [GENDER],
						(ISNULL(RV110.SALE_NET_AMT,0) + ISNULL(RV110.SALE_QUE_AMT,0)) AS [SALE_PRICE],
						(ISNULL(RV110.SALE_TAX_AMT,0) + ISNULL(RV110.BAF,0)) AS [TAX_PRICE],
						RV110.TASF AS [CHG_PRICE],
						--(ISNULL(RV110.SALE_DSCNT_AMT,0) - ISNULL(RV110.SALE_NET_AMT,0)) AS [DC_PRICE], 
						(ISNULL(RV110.SALE_NET_AMT,0) - ISNULL(RV110.SALE_DSCNT_AMT,0)) AS [DC_PRICE],	-- SALE_NET_AMT: 네트가격, SALE_DSCNT_AMT: 네트에서 할인금액이 제외한 금액
						@NEW_CODE, GETDATE()
					FROM interface.TB_VGT_RV110 RV110
					WHERE RV110.PNR_SEQNO = @PNR_SEQNO;
				
					------------------------------------------------------------------------
					-- RES_SEGMENT(운항여정)
					------------------------------------------------------------------------
					SET @STEP_STRING = 'RES_SEGMENT(운항여정)'
					DELETE FROM dbo.RES_SEGMENT WHERE RES_CODE = @RES_CODE;
					INSERT INTO dbo.RES_SEGMENT (
						RES_CODE, SEQ_NO, DEP_AIRPORT_CODE, ARR_AIRPORT_CODE, DEP_CITY_CODE, ARR_CITY_CODE, AIRLINE_CODE, FLIGHT, 
						[START_DATE], END_DATE, 
						FLYING_TIME, AIRLINE_PNR, BKG_CLASS, SEAT_STATUS, DIRECTION, NEW_CODE, NEW_DATE)
					SELECT
						@RES_CODE, RV120.ITIN_NO, RV120.DEP_AIRPORT_CD, RV120.ARR_AIRPORT_CD, RV120.DEP_CITY_CD, RV120.ARR_CITY_CD, SUBSTRING(RV120.FLTNO, 1, 2), SUBSTRING(RV120.FLTNO, 3, 4),
						[interface].[ZN_PUB_STRING_TO_DATETIME](RV120.DEP_DATE + RV120.DEP_TM), [interface].[ZN_PUB_STRING_TO_DATETIME](RV120.ARR_DATE + RV120.ARR_TM), 
						'00:00', RV120.AIR_RSV_NO, RV120.CABIN_SEAT_GRAD, 'HK', (CONVERT(INT, RV120.ITIN_BUNDLE_UNIT) - 1), 
						@NEW_CODE, GETDATE()
					FROM interface.TB_VGT_RV120 RV120
					WHERE RV120.PNR_SEQNO = @PNR_SEQNO;
				END
				--ELSE IF @SYNC_TYPE IN ('updatePayment', 'updateTicketing', 'refundTicketing')
				--BEGIN
				--	------------------------------------------------------------------------
				--	-- RES_CUSTOMER(출발자)
				--	------------------------------------------------------------------------
				--	DELETE FROM dbo.RES_CUSTOMER_damo WHERE RES_CODE = @RES_CODE;
				--	INSERT INTO dbo.RES_CUSTOMER_damo (
				--		RES_CODE, SEQ_NO, CUS_NO, CUS_NAME, LAST_NAME, FIRST_NAME, AGE_TYPE, BIRTH_DATE, GENDER, SALE_PRICE, TAX_PRICE, CHG_PRICE, DC_PRICE, NEW_CODE, NEW_DATE)
				--	SELECT
				--		@RES_CODE, RV110.PAX_NO, 1,
				--		(RV110.PAX_ENG_FMNM + RV110.PAX_ENG_NM) AS [CUS_NAME],
				--		RV110.PAX_ENG_FMNM AS [LAST_NAME],
				--		RV110.PAX_ENG_NM AS [FIRST_NAME],
				--		(RV110.PAX_AGE_FLAG - 1) AS [AGT_TYPE],
				--		[interface].[ZN_PUB_STRING_TO_DATETIME]([interface].[ZN_PUB_AIR_DECRYPT](RV110.PAX_BIRTH, RV110.PNR_SEQNO)) AS [BIRTH_DATE],
				--		(CASE RV110.PAX_SEX WHEN '1' THEN 'M' WHEN '2' THEN 'F' END) AS [GENDER],
				--		RV110.SALE_NET_AMT AS [SALE_PRICE],
				--		(RV110.SALE_TAX_AMT + RV110.BAF) AS [TAX_PRICE],
				--		RV110.TASF AS [CHG_PRICE],
				--		(RV110.SALE_DSCNT_AMT - RV110.SALE_NET_AMT) AS [DC_PRICE], @NEW_CODE, GETDATE()
				--	FROM interface.TB_VGT_RV110 RV110
				--	WHERE RV110.PNR_SEQNO = @PNR_SEQNO;
				
				--	------------------------------------------------------------------------
				--	-- RES_CUSTOMER(출발자)에 수수료 합산
				--	------------------------------------------------------------------------
				--	UPDATE RC SET RC.CHG_PRICE = (RC.CHG_PRICE +  B.TOTAL_FEE), RC.CHG_REMARK = B.CHG_REMARK
				--	--SELECT (RC.CHG_PRICE +  B.TOTAL_FEE), B.CHG_REMARK
				--	FROM dbo.RES_CUSTOMER_damo RC
				--	INNER JOIN (
				--		SELECT RV310.PNR_SEQNO, MIN(MA100.IF_SYS_RSV_NO) AS [RES_CODE], SUM(FEE) AS [TOTAL_FEE],
				--			STUFF((
				--				SELECT (',' + DETAIL_NM1) AS [text()]
				--				FROM interface.TB_VGT_RV310 IRV310
				--				INNER JOIN interface.TB_VGT_CD111 CD111 ON CD111.MASTR_CD = 'N99' AND CD111.DETAIL_CD = IRV310.DATA_FLAG
				--				WHERE IRV310.PNR_SEQNO = RV310.PNR_SEQNO  
				--				FOR XML PATH('')
				--			), 1, 1, '') AS [CHG_REMARK]
				--		FROM interface.TB_VGT_RV310 RV310
				--		INNER JOIN interface.TB_VGT_MA100 MA100 ON RV310.PNR_SEQNO = MA100.PNR_SEQNO 
				--		WHERE RV310.PNR_SEQNO = @PNR_SEQNO
				--		GROUP BY RV310.PNR_SEQNO
				--	) B ON RC.RES_CODE = B.RES_CODE
				--END
			
				------------------------------------------------------------------------
				-- updatePayment: 입금등록, updateTicketing: 티켓발권
				------------------------------------------------------------------------
				--ELSE IF @SYNC_TYPE IN ('updatePayment', 'updateTicketing')
				IF @SYNC_TYPE IN ('updateTicketing')
				BEGIN
					------------------------------------------------------------------------
					-- 정산 기준일 변경
					------------------------------------------------------------------------
					SET @STEP_STRING = '정산기준일 변경'
					IF EXISTS(
					       SELECT 1
					       FROM   dbo.RES_MASTER_damo RM
					              INNER JOIN dbo.PKG_DETAIL PD
					                   ON  RM.PRO_CODE = PD.PRO_CODE
					                       AND CONVERT(DATE, RM.DEP_DATE) = CONVERT(DATE, PD.DEP_DATE)
					       WHERE  RM.RES_CODE = @RES_CODE
					              ------------------------------------------------------------------------
					              -- 발권일 기준 정산 담당자 변경 시 수정 필요
					              ------------------------------------------------------------------------
					              AND RM.NEW_CODE IN (SELECT EMP_CODE
					                                  FROM   EMP_MASTER_damo EMD
					                                  WHERE  EMD.TEAM_CODE = 560
					                                         AND EMD.WORK_TYPE = 1
					                                 UNION ALL
					                                 SELECT EMP_CODE
					                                 FROM   EMP_MASTER_damo EMD
					                                 WHERE  EMP_CODE = '2018048'
					                                        AND EMD.WORK_TYPE = 1)
					------------------------------------------------------------------------
					) AND @ISSUE_DATE IS NOT NULL
					BEGIN
					    UPDATE PD
					    SET    PD.DEP_DATE = @ISSUE_DATE
					    FROM   dbo.RES_MASTER_damo RM
					           INNER JOIN dbo.PKG_DETAIL PD
					                ON  RM.PRO_CODE = PD.PRO_CODE
					    WHERE  RM.RES_CODE = @RES_CODE
					END
					
					------------------------------------------------------------------------
					-- 정산마스터 미등록 시 등록
					------------------------------------------------------------------------
					SET @STEP_STRING = '정산마스터 등록'
					IF NOT EXISTS(SELECT 1 FROM SET_MASTER WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
					BEGIN
						-- public enum SetStateEnum { 정산진행중, 결제진행중, 정산완료, 재정산, 미정산 = 9 };
						INSERT INTO SET_MASTER (PRO_CODE, MASTER_CODE, PRO_TYPE, DEP_DATE, NEW_CODE, PROFIT_TEAM_CODE, PROFIT_TEAM_NAME, SET_STATE) -- , CLOSE_CODE, CLOSE_DATE
						SELECT A.PRO_CODE, A.MASTER_CODE, A.PRO_TYPE, A.DEP_DATE, A.NEW_CODE, A.PROFIT_TEAM_CODE, A.PROFIT_TEAM_NAME, 0	-- 정산진행중
						FROM RES_MASTER_damo A WITH(NOLOCK)
						WHERE RES_CODE = @RES_CODE;
						
						-- SET_PROFIT 생성
						EXEC DBO.SP_SET_PROFIT_REFRESH @PRO_CODE, @NEW_CODE;
						
						-- 가상행사코드 생성
						EXEC [dbo].[SP_ACC_GET_DUZ_CODE] @RES_CODE;
					END
					-- 담당자 변경 시 수익부서 수정
					ELSE IF EXISTS(SELECT 1 FROM SET_MASTER WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE AND NEW_CODE <> @NEW_CODE)
					BEGIN
						-- 수익부서 조회
						SELECT
							@PROFIT_TEAM_CODE = ET.TEAM_CODE,
							@PROFIT_TEAM_NAME = ET.TEAM_NAME
						FROM DBO.EMP_MASTER_DAMO EM
						INNER JOIN DBO.EMP_TEAM ET ON EM.TEAM_CODE = ET.TEAM_CODE
						WHERE EM.EMP_CODE = @NEW_CODE;
					
						UPDATE DBO.SET_MASTER SET NEW_CODE = @NEW_CODE, PROFIT_TEAM_CODE = @PROFIT_TEAM_CODE, PROFIT_TEAM_NAME = @PROFIT_TEAM_NAME WHERE PRO_CODE = @PRO_CODE
					END
				
					------------------------------------------------------------------------
					-- 국내 입금관련 데이터 처리
					------------------------------------------------------------------------
					IF @DI_FLAG = 'D'
					BEGIN
						SET @STEP_STRING = '국내 입금관련 데이터 처리'
						------------------------------------------------------------------------
						-- 이전 항목 취소 처리
						------------------------------------------------------------------------
						IF EXISTS(SELECT 1 FROM DBO.PAY_MATCHING WHERE RES_CODE = @RES_CODE)
						BEGIN
							UPDATE DBO.PAY_MASTER_DAMO SET CXL_YN = 'Y', CXL_DATE = GETDATE(), CXL_CODE = @NEW_CODE WHERE PAY_SEQ IN (
								SELECT PAY_SEQ FROM DBO.PAY_MATCHING WITH(NOLOCK) WHERE RES_CODE = @RES_CODE AND CXL_YN = 'N'
							)
							UPDATE DBO.PAY_MATCHING SET CXL_YN = 'Y', CXL_DATE = GETDATE(), CXL_CODE = @NEW_CODE WHERE RES_CODE = @RES_CODE AND CXL_YN = 'N'	
						END
					
						------------------------------------------------------------------------
						-- PAY_MASTER 등록	RV130.PAY_MTH_CD IN ('CCCC', 'CCK1') | 코드 참조 SELECT * FROM interface.TB_VGT_CD111 WHERE MASTR_CD = 'C28'
						------------------------------------------------------------------------
						INSERT INTO PAY_MASTER_damo (
							PAY_TYPE,		CUS_NO,			ADMIN_REMARK,
							PAY_SUB_NAME,	PAY_METHOD,		
							PAY_NAME,		PAY_PRICE,		PAY_DATE,	
							INSTALLMENT,	NEW_CODE,		NEW_DATE,
							COM_RATE,
							COM_PRICE,
							SEC_PAY_NUM,	
							SEC1_PAY_NUM
						)
						SELECT
							(CASE WHEN RV130.DATA_FLAG = 'AIRRV' THEN 10 ELSE 12 END) AS [PAY_TYPE], @CUS_NO AS [CUS_NO], @RES_CODE AS [ADMIN_REMARK],
							(CASE WHEN RV130.DATA_FLAG = 'AIRRV' THEN 'CCCF' ELSE 'TASF' END) AS [PAY_SUB_NAME], '9' AS [PAY_METHOD],	-- 홈페이지 = 0, EMAIL, 직접방문, 전화, 은행, 수동 = 8, 시스템 = 9
							MIN(RV130.CARD_OWNER) AS [PAY_NAME], SUM(RV130.PAY_TOT_AMT) AS [PAY_PRICE], [interface].[ZN_PUB_STRING_TO_DATETIME](MIN(RV130.PAY_DTM)) AS [PAY_DATE],
							CONVERT(INT, MIN(RV130.CARD_INSTLMT_CNT)) AS [INSTALLMENT], @NEW_CODE AS [NEW_CODE], GETDATE() AS [NEW_DATE],
							0 AS [COM_RATE],
							(SUM(CASE WHEN RV130.DATA_FLAG = 'AIRTF' THEN ISNULL(RV130.CARD_PAY_AMT, 0) ELSE 0 END) * @TASF_COMM_RATE * 0.01) AS [COM_PRICE], 
							--(SUM(CASE WHEN RV130.DATA_FLAG = 'AIRTF' AND RV130.PAY_MTH_CD = 'CCCC' THEN RV130.CARD_PAY_AMT ELSE 0 END) * @TASF_COMM_RATE * 0.01) AS [COM_PRICE],
							damo.dbo.enc_varchar('DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM', [interface].[ZN_PUB_AIR_DECRYPT](RV130.CARD_NO, RV130.PNR_SEQNO)) AS [SEC_PAY_NUM],
							damo.dbo.pred_meta_plain_v([interface].[ZN_PUB_AIR_DECRYPT](RV130.CARD_NO, RV130.PNR_SEQNO), 'DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM') AS [SEC1_PAY_NUM]
						FROM interface.TB_VGT_RV130 RV130
						WHERE RV130.PNR_SEQNO = @PNR_SEQNO AND RV130.PAY_MTH_CD IN ('CCCC', 'CCK1')
						GROUP BY RV130.DATA_FLAG, RV130.PAY_MTH_CD, [interface].[ZN_PUB_AIR_DECRYPT](RV130.CARD_NO, RV130.PNR_SEQNO)
						
						------------------------------------------------------------------------
						-- PAY_MATCHING 등록		RV130.PAY_MTH_CD IN ('CCCC', 'CCK1')
						------------------------------------------------------------------------
						INSERT INTO PAY_MATCHING
						(
							PAY_SEQ,	MCH_SEQ,	MCH_TYPE,	-- 매칭타입(0 : 결제, 1 : 기타)	
							RES_CODE,	PRO_CODE,	PART_PRICE,		CXL_YN,		NEW_CODE,	NEW_DATE
						)
						SELECT A.PAY_SEQ, (A.MCH_SEQ + A.MIN_SEQ) AS [MCH_SEQ], A.MCH_TYPE, A.RES_CODE, A.PRO_CODE, A.PART_PRICE, A.CXL_YN, A.NEW_CODE, GETDATE()
						FROM (
							SELECT PM.PAY_SEQ, A.ROWNUM AS [MCH_SEQ], 0 AS [MCH_TYPE], A.RES_CODE, RM.PRO_CODE, PM.PAY_PRICE AS [PART_PRICE], 'N' AS [CXL_YN], PM.NEW_CODE,
								ISNULL((SELECT MAX(MCH_SEQ) FROM PAY_MATCHING WHERE PAY_SEQ = PM.PAY_SEQ), 0) AS [MIN_SEQ]
							FROM (
								SELECT
									MIN(MA100.IF_SYS_RSV_NO) AS [RES_CODE], ROW_NUMBER() OVER (ORDER BY MIN(RV130.PAY_RQ_SEQNO)) AS [ROWNUM],
									(CASE WHEN RV130.DATA_FLAG = 'AIRRV' THEN 10 ELSE 12 END) AS [PAY_TYPE],
									damo.dbo.pred_meta_plain_v([interface].[ZN_PUB_AIR_DECRYPT](RV130.CARD_NO, RV130.PNR_SEQNO), 'DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM') AS [SEC1_PAY_NUM]
								FROM interface.TB_VGT_RV130 RV130
								INNER JOIN interface.TB_VGT_MA100 MA100 ON RV130.PNR_SEQNO = MA100.PNR_SEQNO
								WHERE RV130.PNR_SEQNO = @PNR_SEQNO AND RV130.PAY_MTH_CD IN ('CCCC', 'CCK1')
								GROUP BY RV130.DATA_FLAG, RV130.PAY_MTH_CD, [interface].[ZN_PUB_AIR_DECRYPT](RV130.CARD_NO, RV130.PNR_SEQNO)
							) A
							INNER JOIN PAY_MASTER_damo PM
								ON A.SEC1_PAY_NUM = PM.sec1_PAY_NUM AND A.RES_CODE = PM.ADMIN_REMARK AND A.PAY_TYPE = PM.PAY_TYPE AND PM.NEW_DATE >= CONVERT(DATE, GETDATE() - 1)
									AND PM.CXL_YN = 'N'
							INNER JOIN RES_MASTER_damo RM ON A.RES_CODE = RM.RES_CODE
						) A;

						------------------------------------------------------------------------
						-- 입금처리 유무 업데이트 MA200
						------------------------------------------------------------------------
						--INSERT INTO interface.TB_VGT_MA200 (PNR_SEQNO, PAY_RQ_SEQNO, DATA_FLAG, CONFM_USR_ID)
						--SELECT RV410.PNR_SEQNO, RV410.DEPOSIT_REFUND_NO, RV410.DATA_FLAG, 'SYSTEM'  
						--FROM interface.TB_VGT_RV410 RV410
						--LEFT JOIN interface.TB_VGT_MA200 MA200 ON RV410.PNR_SEQNO = MA200.PNR_SEQNO AND RV410.DEPOSIT_REFUND_NO = MA200.PAY_RQ_SEQNO AND RV410.DATA_FLAG = MA200.DATA_FLAG
						--WHERE RV410.PNR_SEQNO = @PNR_SEQNO AND RV410.DEPOSIT_FLAG IN ('CCCC', 'CCRP') AND MA200.PNR_SEQNO IS NULL;
					
						------------------------------------------------------------------------
						-- 국내 정산 등록 (지상비 이용)
						-- 상품가가 달라질 수 있으므로 이전 항목 삭제 후 재 등록
						-- updateTicketing 생각과 달리 2번이상 호출이 됨
						------------------------------------------------------------------------
						SET @STEP_STRING = '국내 정산 등록'
						IF NOT EXISTS(SELECT 1 FROM SET_LAND_AGENT WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE AND PAY_PRICE < 0)
						BEGIN
							DELETE FROM SET_LAND_CUSTOMER WHERE PRO_CODE = @PRO_CODE;
							DELETE FROM SET_LAND_AGENT WHERE PRO_CODE = @PRO_CODE;
						END
					
						-- SET_LAND_AGENT	
						SELECT @SET_SEQ_NO = (ISNULL((SELECT MAX(LAND_SEQ_NO) FROM SET_LAND_AGENT WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE), 0) + 1);
						-- 전자결재 가상번호 입력후 지결 생성 완료처리
						INSERT INTO SET_LAND_AGENT(
							PRO_CODE, LAND_SEQ_NO, AGT_CODE, CUR_TYPE, DOC_YN, EDI_CODE, PAY_PRICE, 
							FOREIGN_PRICE, 
							KOREAN_PRICE, 
							EXC_RATE, RES_COUNT, REMARK, NEW_CODE)
						SELECT A.PRO_CODE, @SET_SEQ_NO AS [LAND_SEQ_NO], @SET_AGT_CODE AS [AGT_CODE], 0 AS [CUR_TYPE], 'Y' AS [DOC_YN], '9999999999' AS [EDI_CODE], B.TOTAL_PRICE, 
							(CASE WHEN B.RES_COUNT = 0 THEN 0 ELSE (B.TOTAL_PRICE / B.RES_COUNT) END) AS [FOREIGN_PRICE],
							(CASE WHEN B.RES_COUNT = 0 THEN 0 ELSE (B.TOTAL_PRICE / B.RES_COUNT) END) AS [KOREAN_PRICE],  
							1.0 AS [EXC_RATE], B.RES_COUNT, A.RES_CODE, A.NEW_CODE
						FROM RES_MASTER_damo A WITH(NOLOCK)
						INNER JOIN (
							SELECT RC.RES_CODE, COUNT(*) AS [RES_COUNT],
								SUM(ISNULL(RC.SALE_PRICE, 0) + ISNULL(RC.TAX_PRICE, 0) + ISNULL(RC.PENALTY_PRICE, 0) - ISNULL(RC.DC_PRICE, 0)) AS [TOTAL_PRICE] 
							FROM RES_CUSTOMER_damo RC WITH(NOLOCK)
							WHERE RC.RES_CODE = @RES_CODE AND RC.RES_STATE IN (0, 3, 4)
							GROUP BY RC.RES_CODE
						) B ON A.RES_CODE = B.RES_CODE;

						-- SET_LAND_CUSTOMER
						INSERT INTO SET_LAND_CUSTOMER (PRO_CODE, LAND_SEQ_NO, RES_CODE, RES_SEQ_NO, CUR_TYPE, EXC_RATE, PAY_PRICE, FOREIGN_PRICE, KOREAN_PRICE, NEW_CODE)
						SELECT
							@PRO_CODE AS [PRO_CODE], 
							@SET_SEQ_NO AS [LAND_SEQ_NO], 
							A.RES_CODE, 
							A.SEQ_NO AS [RES_SEQ_NO], 
							0 AS [CUR_TYPE],		-- 통화타입 (0: KRW)
							1.0,					-- KRW 기준이므로 무조건 1.0 세팅
							(ISNULL(A.SALE_PRICE, 0) + ISNULL(A.TAX_PRICE, 0) + ISNULL(A.PENALTY_PRICE, 0) - ISNULL(A.DC_PRICE, 0)) AS [PAY_PRICE],
							(ISNULL(A.SALE_PRICE, 0) + ISNULL(A.TAX_PRICE, 0) + ISNULL(A.PENALTY_PRICE, 0) - ISNULL(A.DC_PRICE, 0)) AS [FOREIGN_PRICE],
							(ISNULL(A.SALE_PRICE, 0) + ISNULL(A.TAX_PRICE, 0) + ISNULL(A.PENALTY_PRICE, 0) - ISNULL(A.DC_PRICE, 0)) AS [KOREAN_PRICE],
							A.NEW_CODE
						FROM RES_CUSTOMER_damo A WITH(NOLOCK)
						WHERE A.RES_CODE = @RES_CODE AND A.RES_STATE IN (0, 3, 4);
					
					END
					------------------------------------------------------------------------
					-- 해외 정산 등록 (항공비 이용)
					------------------------------------------------------------------------
					ELSE IF @DI_FLAG = 'I'
					BEGIN
						SET @STEP_STRING = '해외 입금관련 데이터 처리'
						------------------------------------------------------------------------
						-- OZ 항공사 TASF 발행 안함 => 발권시 입금 등록
						------------------------------------------------------------------------
						--IF @AIRLINE_CODE IN ('OZ')
						--BEGIN
						--	DECLARE @REG_DATE DATETIME = GETDATE();
						--	------------------------------------------------------------------------
						--	-- 이전 항목 취소 처리
						--	------------------------------------------------------------------------
						--	IF EXISTS(SELECT 1 FROM DBO.PAY_MATCHING WHERE RES_CODE = @RES_CODE)
						--	BEGIN
						--		-- 최초 등록일 수집
						--		SELECT TOP 1 @REG_DATE = PM.NEW_DATE
						--		FROM dbo.PAY_MASTER_damo PM
						--		INNER JOIN dbo.PAY_MATCHING PMA ON PM.PAY_SEQ = PMA.PAY_SEQ
						--		WHERE PMA.RES_CODE = @RES_CODE AND PM.PAY_TYPE = 12
						--		ORDER BY PM.PAY_SEQ
								
						--		UPDATE DBO.PAY_MASTER_DAMO SET CXL_YN = 'Y', CXL_DATE = @REG_DATE, CXL_CODE = @NEW_CODE 
						--		WHERE PAY_SEQ IN (SELECT PAY_SEQ FROM DBO.PAY_MATCHING WITH(NOLOCK) WHERE RES_CODE = @RES_CODE AND CXL_YN = 'N')
						--			AND PAY_TYPE = 12
							
						--		UPDATE A SET A.CXL_YN = 'Y', A.CXL_DATE = @REG_DATE, A.CXL_CODE = @NEW_CODE
						--		FROM DBO.PAY_MATCHING A
						--		INNER JOIN DBO.PAY_MASTER_damo B ON A.PAY_SEQ = B.PAY_SEQ
						--		WHERE A.RES_CODE = @RES_CODE AND A.CXL_YN = 'N' AND B.PAY_TYPE = 12	
						--	END
					
						--	------------------------------------------------------------------------
						--	-- PAY_MASTER 등록	RV130.PAY_MTH_CD IN ('CCCC', 'CCK1') | 코드 참조 SELECT * FROM interface.TB_VGT_CD111 WHERE MASTR_CD = 'C28'
						--	------------------------------------------------------------------------
						--	INSERT INTO PAY_MASTER_damo (
						--		PAY_TYPE,		CUS_NO,			ADMIN_REMARK,
						--		PAY_SUB_NAME,	PAY_METHOD,		
						--		PAY_NAME,		PAY_PRICE,		PAY_DATE,	
						--		INSTALLMENT,	NEW_CODE,		NEW_DATE,
						--		COM_RATE,
						--		COM_PRICE,
						--		SEC_PAY_NUM,	
						--		SEC1_PAY_NUM
						--	)
						--	SELECT
						--		12 AS [PAY_TYPE], @CUS_NO AS [CUS_NO], @RES_CODE AS [ADMIN_REMARK],
						--		'TASF' AS [PAY_SUB_NAME], '9' AS [PAY_METHOD],	-- 홈페이지 = 0, EMAIL, 직접방문, 전화, 은행, 수동 = 8, 시스템 = 9
						--		MIN(RV130.CARD_OWNER) AS [PAY_NAME], SUM(RV130.PAY_TOT_AMT) AS [PAY_PRICE], [interface].[ZN_PUB_STRING_TO_DATETIME](MIN(RV130.PAY_DTM)) AS [PAY_DATE],
						--		CONVERT(INT, MIN(RV130.CARD_INSTLMT_CNT)) AS [INSTALLMENT], @NEW_CODE AS [NEW_CODE], @REG_DATE AS [NEW_DATE],
						--		0 AS [COM_RATE], 
						--		(SUM(CASE WHEN RV130.DATA_FLAG = 'AIRTF' THEN ISNULL(RV130.CARD_PAY_AMT, 0) ELSE 0 END) * @TASF_COMM_RATE * 0.01) AS [COM_PRICE], 
						--		--(SUM(CASE WHEN RV130.DATA_FLAG = 'AIRTF' AND RV130.PAY_MTH_CD = 'CCCC' THEN RV130.CARD_PAY_AMT ELSE 0 END) * @TASF_COMM_RATE * 0.01) AS [COM_PRICE],
						--		damo.dbo.enc_varchar('DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM', [interface].[ZN_PUB_AIR_DECRYPT](RV130.CARD_NO, RV130.PNR_SEQNO)) AS [SEC_PAY_NUM],
						--		damo.dbo.pred_meta_plain_v([interface].[ZN_PUB_AIR_DECRYPT](RV130.CARD_NO, RV130.PNR_SEQNO), 'DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM') AS [SEC1_PAY_NUM]
						--	FROM interface.TB_VGT_RV130 RV130
						--	WHERE RV130.PNR_SEQNO = @PNR_SEQNO AND RV130.PAY_MTH_CD IN ('CCCC', 'CCK1') AND RV130.DATA_FLAG = 'AIRTF'
						--	GROUP BY RV130.DATA_FLAG, RV130.PAY_MTH_CD, [interface].[ZN_PUB_AIR_DECRYPT](RV130.CARD_NO, RV130.PNR_SEQNO)
						
						--	------------------------------------------------------------------------
						--	-- PAY_MATCHING 등록		RV130.PAY_MTH_CD IN ('CCCC', 'CCK1')
						--	------------------------------------------------------------------------
						--	INSERT INTO PAY_MATCHING
						--	(
						--		PAY_SEQ,	MCH_SEQ,	MCH_TYPE,	-- 매칭타입(0 : 결제, 1 : 기타)	
						--		RES_CODE,	PRO_CODE,	PART_PRICE,		CXL_YN,		NEW_CODE,	NEW_DATE
						--	)
						--	SELECT A.PAY_SEQ, (A.MCH_SEQ + A.MIN_SEQ) AS [MCH_SEQ], A.MCH_TYPE, A.RES_CODE, A.PRO_CODE, A.PART_PRICE, A.CXL_YN, A.NEW_CODE, @REG_DATE
						--	FROM (
						--		SELECT PM.PAY_SEQ, A.ROWNUM AS [MCH_SEQ], 0 AS [MCH_TYPE], A.RES_CODE, RM.PRO_CODE, PM.PAY_PRICE AS [PART_PRICE], 'N' AS [CXL_YN], PM.NEW_CODE,
						--			ISNULL((SELECT MAX(MCH_SEQ) FROM PAY_MATCHING WHERE PAY_SEQ = PM.PAY_SEQ), 0) AS [MIN_SEQ]
						--		FROM (
						--			SELECT
						--				MIN(MA100.IF_SYS_RSV_NO) AS [RES_CODE], ROW_NUMBER() OVER (ORDER BY MIN(RV130.PAY_RQ_SEQNO)) AS [ROWNUM], 12 AS [PAY_TYPE],
						--				damo.dbo.pred_meta_plain_v([interface].[ZN_PUB_AIR_DECRYPT](RV130.CARD_NO, RV130.PNR_SEQNO), 'DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM') AS [SEC1_PAY_NUM]
						--			FROM interface.TB_VGT_RV130 RV130
						--			INNER JOIN interface.TB_VGT_MA100 MA100 ON RV130.PNR_SEQNO = MA100.PNR_SEQNO
						--			WHERE RV130.PNR_SEQNO = @PNR_SEQNO AND RV130.PAY_MTH_CD IN ('CCCC', 'CCK1') AND RV130.DATA_FLAG = 'AIRTF'
						--			GROUP BY RV130.DATA_FLAG, RV130.PAY_MTH_CD, [interface].[ZN_PUB_AIR_DECRYPT](RV130.CARD_NO, RV130.PNR_SEQNO)
						--		) A
						--		INNER JOIN PAY_MASTER_damo PM
						--			ON A.SEC1_PAY_NUM = PM.sec1_PAY_NUM AND A.RES_CODE = PM.ADMIN_REMARK AND A.PAY_TYPE = PM.PAY_TYPE --AND PM.NEW_DATE >= CONVERT(DATE, GETDATE() - 1)
						--				AND PM.CXL_YN = 'N'
						--		INNER JOIN RES_MASTER_damo RM ON A.RES_CODE = RM.RES_CODE
						--	) A;
						--END
						
						IF NOT EXISTS(SELECT 1 FROM SET_AIR_AGENT WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
						BEGIN
							SET @STEP_STRING = '해외 정산 항공사 등록'
							-- 정산 항공사 등록
							INSERT SET_AIR_AGENT(PRO_CODE, AIRLINE_CODE, AIR_SEQ_NO, DEP_DATE, ROUTING, CITY_CODE, NEW_CODE, NEW_DATE)
							SELECT PRO_CODE, AIRLINE_CODE, 1, DEP_DEP_DATE, (DEP_DEP_AIRPORT_CODE + '/' + DEP_ARR_AIRPORT_CODE + '/' + ARR_DEP_AIRPORT_CODE + '/' + ARR_ARR_AIRPORT_CODE) ROUTING
								, DEP_ARR_AIRPORT_CODE, @NEW_CODE, GETDATE()
							FROM RES_AIR_DETAIL 
							WHERE PRO_CODE = @PRO_CODE;
						
							-- 정산 출발자 등록
							INSERT INTO SET_AIR_CUSTOMER(PRO_CODE, AIR_SEQ_NO, RES_CODE, RES_SEQ_NO, FARE_TYPE, NEW_CODE)
							SELECT RM.PRO_CODE, 1 AIR_SEQ_NO, RC.RES_CODE, RC.SEQ_NO, (RC.AGE_TYPE + 1) FARE_TYPE, RM.NEW_CODE
							FROM RES_MASTER_damo RM
							INNER JOIN RES_CUSTOMER_damo RC ON RM.RES_CODE = RC.RES_CODE
							WHERE RM.PRO_CODE = @PRO_CODE AND RM.RES_STATE <= 7 AND RC.RES_STATE IN (0, 3, 4);
						
						END
					END
				
				END
				------------------------------------------------------------------------
				-- cancelBooking: 예약취소/VOID, refundTicketing: 티켓환불
				------------------------------------------------------------------------
				ELSE IF @SYNC_TYPE IN ('cancelBooking', 'refundTicketing')
				BEGIN
					------------------------------------------------------------------------
					-- 국내 취소, 환불인 경우 입출금, 정산관련 데이터 처리 (결재 금액만큼 마이너스 등록)
					------------------------------------------------------------------------
					IF @DI_FLAG = 'D'
					BEGIN
						SET @STEP_STRING = '국내 취소/환불 입금처리'
						------------------------------------------------------------------------
						-- 입금데이터 처리 (CCCF 합계 금액이 0원 이상인 경우 처리)
						------------------------------------------------------------------------
						IF (
							   SELECT SUM(PMA.PART_PRICE)
							   FROM   PAY_MATCHING PMA WITH(NOLOCK)
									  INNER JOIN PAY_MASTER_damo PM WITH(NOLOCK)
										   ON  PMA.PAY_SEQ = PM.PAY_SEQ
							   WHERE  PMA.RES_CODE = @RES_CODE
									  AND PMA.CXL_YN = 'N'
									  AND PM.PAY_SUB_NAME = 'CCCF'
						   ) > 0
						BEGIN
							------------------------------------------------------------------------
							-- PAY_MASTER 취소등록	RV130.PAY_MTH_CD IN ('CCCC', 'CCK1') | 코드 참조 SELECT * FROM interface.TB_VGT_CD111 WHERE MASTR_CD = 'C28'
							------------------------------------------------------------------------
							INSERT INTO PAY_MASTER_damo (
								PAY_TYPE,		CUS_NO,				ADMIN_REMARK,		PAY_SUB_NAME,	PAY_METHOD,		
								PAY_NAME,		PAY_PRICE,			PAY_DATE,			INSTALLMENT,
								NEW_CODE,		NEW_DATE,			SEC_PAY_NUM,		SEC1_PAY_NUM,
								COM_RATE,		COM_PRICE
							)
							SELECT
								PAY_TYPE,		CUS_NO,				PM.ADMIN_REMARK,	PAY_SUB_NAME,	PM.PAY_METHOD, 
								PAY_NAME,		(PAY_PRICE * -1),	GETDATE(),			0 AS [INSTALLMENT],
								@NEW_CODE,		GETDATE(),			SEC_PAY_NUM,		SEC1_PAY_NUM,
								0,				(COM_PRICE * -1)
							  
							FROM PAY_MASTER_damo PM
							WHERE PM.PAY_SEQ IN (SELECT PMA.PAY_SEQ FROM PAY_MATCHING PMA WHERE PMA.RES_CODE = @RES_CODE AND PMA.CXL_YN = 'N') 
								AND PM.PAY_SUB_NAME = 'CCCF' AND PM.CXL_YN = 'N' AND PM.PAY_PRICE > 0;
						
							------------------------------------------------------------------------
							-- PAY_MATCHING 등록		RV130.PAY_MTH_CD IN ('CCCC', 'CCK1')
							------------------------------------------------------------------------
							DECLARE @PAY_SEQ INT = @@IDENTITY;
						
							INSERT INTO PAY_MATCHING
							(
								PAY_SEQ,		MCH_SEQ,		MCH_TYPE,	-- 매칭타입(0 : 결제, 1 : 기타)	
								RES_CODE,		PRO_CODE,		PART_PRICE,			CXL_YN,		NEW_CODE,		NEW_DATE
							)
							SELECT
								@PAY_SEQ,		PMA.MCH_SEQ,	PMA.MCH_TYPE,
								PMA.RES_CODE,	PMA.PRO_CODE,	(PART_PRICE * -1),	PMA.CXL_YN,	@NEW_CODE,		GETDATE() 
							FROM PAY_MATCHING PMA
							INNER JOIN PAY_MASTER_damo PM ON PM.PAY_SEQ = PMA.PAY_SEQ
							WHERE PMA.RES_CODE = @RES_CODE AND PMA.CXL_YN = 'N' AND PM.PAY_SUB_NAME = 'CCCF' AND PM.CXL_YN = 'N' AND PM.PAY_PRICE > 0;
						
							------------------------------------------------------------------------
							-- 당일취소 TASF 도 환불
							------------------------------------------------------------------------
							IF @REG_DTM = @TODAY
							BEGIN
								------------------------------------------------------------------------
								-- PAY_MASTER 취소등록
								------------------------------------------------------------------------
								INSERT INTO PAY_MASTER_damo (
									PAY_TYPE,		CUS_NO,				ADMIN_REMARK,		PAY_SUB_NAME,	PAY_METHOD,		
									PAY_NAME,		PAY_PRICE,			PAY_DATE,			INSTALLMENT,	
									NEW_CODE,		NEW_DATE,			SEC_PAY_NUM,		SEC1_PAY_NUM,
									COM_RATE,		COM_PRICE
								)
								SELECT
									PAY_TYPE,		CUS_NO,				PM.ADMIN_REMARK,	PAY_SUB_NAME,	PM.PAY_METHOD, 
									PAY_NAME,		(PAY_PRICE * -1),	GETDATE(),			0 AS [INSTALLMENT],
									@NEW_CODE,		GETDATE(),			SEC_PAY_NUM,		SEC1_PAY_NUM,
									0,				(COM_PRICE * -1)
								FROM PAY_MASTER_damo PM
								WHERE PM.PAY_SEQ IN (SELECT PMA.PAY_SEQ FROM PAY_MATCHING PMA WHERE PMA.RES_CODE = @RES_CODE AND PMA.CXL_YN = 'N') 
									AND PM.PAY_SUB_NAME = 'TASF' AND PM.CXL_YN = 'N' AND PM.PAY_PRICE > 0;
						
								------------------------------------------------------------------------
								-- PAY_MATCHING 등록	
								------------------------------------------------------------------------
								SET @PAY_SEQ = @@IDENTITY;
						
								INSERT INTO PAY_MATCHING
								(
									PAY_SEQ,		MCH_SEQ,		MCH_TYPE,	-- 매칭타입(0 : 결제, 1 : 기타)	
									RES_CODE,		PRO_CODE,		PART_PRICE,			CXL_YN,		NEW_CODE,		NEW_DATE
								)
								SELECT
									@PAY_SEQ,		PMA.MCH_SEQ,	PMA.MCH_TYPE,
									PMA.RES_CODE,	PMA.PRO_CODE,	(PART_PRICE * -1),	PMA.CXL_YN,	@NEW_CODE,		GETDATE() 
								FROM PAY_MATCHING PMA
								INNER JOIN PAY_MASTER_damo PM ON PM.PAY_SEQ = PMA.PAY_SEQ
								WHERE PMA.RES_CODE = @RES_CODE AND PMA.CXL_YN = 'N' AND PM.PAY_SUB_NAME = 'TASF' AND PM.CXL_YN = 'N' AND PM.PAY_PRICE > 0;
							END

						END

						SET @STEP_STRING = '국내 취소/환불 정산처리'
						------------------------------------------------------------------------
						-- 정산데이터 처리 (정산마스터 존재, 기존값이 양수인 경우 취소 등록)
						------------------------------------------------------------------------
						IF EXISTS(SELECT 1 FROM SET_MASTER WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
						BEGIN
							IF (SELECT SUM(PAY_PRICE) FROM SET_LAND_AGENT WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE) > 0
							BEGIN
								-- SET_LAND_AGENT
								SELECT @SET_SEQ_NO = (ISNULL((SELECT MAX(LAND_SEQ_NO) FROM SET_LAND_AGENT WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE), 0) + 1)
								-- 전자결재 가상번호 입력후 지결 생성 완료처리
								INSERT INTO SET_LAND_AGENT(
									PRO_CODE, LAND_SEQ_NO, AGT_CODE, CUR_TYPE, DOC_YN, EDI_CODE, 
									PAY_PRICE, 
									FOREIGN_PRICE, 
									KOREAN_PRICE, 
									EXC_RATE, RES_COUNT, REMARK, NEW_CODE)
								SELECT A.PRO_CODE, @SET_SEQ_NO AS [LAND_SEQ_NO], @SET_AGT_CODE AS [AGT_CODE], 0 AS [CUR_TYPE], 'Y' AS [DOC_YN], '9999999999' AS [EDI_CODE], 
									(B.TOTAL_PRICE * -1) AS [PAY_PRICE],
									(CASE WHEN B.RES_COUNT = 0 THEN 0 ELSE (B.TOTAL_PRICE / B.RES_COUNT * -1) END) AS [FOREIGN_PRICE],
									(CASE WHEN B.RES_COUNT = 0 THEN 0 ELSE (B.TOTAL_PRICE / B.RES_COUNT * -1) END) AS [KOREAN_PRICE],  
									1.0 AS [EXC_RATE], B.RES_COUNT, A.RES_CODE, A.NEW_CODE
								FROM RES_MASTER_damo A WITH(NOLOCK)
								INNER JOIN (
									SELECT RC.RES_CODE, COUNT(*) AS [RES_COUNT],
										SUM(ISNULL(RC.SALE_PRICE, 0) + ISNULL(RC.TAX_PRICE, 0) + ISNULL(RC.PENALTY_PRICE, 0) - ISNULL(RC.DC_PRICE, 0)) AS [TOTAL_PRICE] 
									FROM RES_CUSTOMER_damo RC WITH(NOLOCK)
									WHERE RC.RES_CODE = @RES_CODE AND RC.RES_STATE IN (0, 3, 4)
									GROUP BY RC.RES_CODE
								) B ON A.RES_CODE = B.RES_CODE;
						
								-- SET_LAND_CUSTOMER
								INSERT INTO SET_LAND_CUSTOMER (PRO_CODE, LAND_SEQ_NO, RES_CODE, RES_SEQ_NO, CUR_TYPE, EXC_RATE, PAY_PRICE, FOREIGN_PRICE, KOREAN_PRICE, NEW_CODE)
								SELECT
									@PRO_CODE AS [PRO_CODE], 
									@SET_SEQ_NO AS [LAND_SEQ_NO], 
									A.RES_CODE, 
									A.SEQ_NO AS [RES_SEQ_NO],
									0 AS [CUR_TYPE],		-- 통화타입 (0: KRW)
									1.0,					-- KRW 기준이므로 무조건 1.0 세팅
									((ISNULL(A.SALE_PRICE, 0) + ISNULL(A.TAX_PRICE, 0) + ISNULL(A.PENALTY_PRICE, 0) - ISNULL(A.DC_PRICE, 0)) * -1) AS [PAY_PRICE],
									((ISNULL(A.SALE_PRICE, 0) + ISNULL(A.TAX_PRICE, 0) + ISNULL(A.PENALTY_PRICE, 0) - ISNULL(A.DC_PRICE, 0)) * -1) AS [FOREIGN_PRICE],
									((ISNULL(A.SALE_PRICE, 0) + ISNULL(A.TAX_PRICE, 0) + ISNULL(A.PENALTY_PRICE, 0) - ISNULL(A.DC_PRICE, 0)) * -1) AS [KOREAN_PRICE],
									A.NEW_CODE
								FROM RES_CUSTOMER_damo A WITH(NOLOCK)
								WHERE A.RES_CODE = @RES_CODE AND A.RES_STATE IN (0, 3, 4)
							END
						END
						
						------------------------------------------------------------------------
						-- 환불 시 TASF(항공수수료) 정산 기타수익에 등록
						------------------------------------------------------------------------
						IF @SYNC_TYPE = 'refundTicketing'
						BEGIN
							IF EXISTS(SELECT 1 FROM dbo.SET_MASTER WHERE PRO_CODE = @PRO_CODE)
							BEGIN
								-- 환불 요청시 최초 1회 등록 (부분 최소등은 항공팀 수동 처리)
								IF NOT EXISTS(SELECT 1 FROM SET_CUSTOMER WHERE RES_CODE = @RES_CODE)
								BEGIN
									--UPDATE A SET A.ETC_PROFIT = ISNULL(B.CHG_PRICE, 0), EDT_CODE = @NEW_CODE, EDT_DATE = GETDATE()
									--FROM dbo.SET_CUSTOMER A
									--INNER JOIN dbo.RES_CUSTOMER_damo B ON A.RES_CODE = B.RES_CODE AND A.RES_SEQ_NO = B.SEQ_NO
									--WHERE A.RES_CODE = @RES_CODE;
						
									INSERT INTO SET_CUSTOMER (PRO_CODE, RES_CODE, RES_SEQ_NO, ETC_PROFIT, NEW_CODE, NEW_DATE)
									SELECT @PRO_CODE, A.RES_CODE, A.SEQ_NO, ISNULL(A.CHG_PRICE, 0), A.NEW_CODE, GETDATE()
									FROM dbo.RES_CUSTOMER_damo A
									LEFT JOIN dbo.SET_CUSTOMER B ON A.RES_CODE = B.RES_CODE AND A.SEQ_NO = B.RES_SEQ_NO 
									WHERE A.RES_CODE = @RES_CODE AND B.RES_CODE IS NULL; 
								END
							END
						END
					
						------------------------------------------------------------------------	
						-- 출발자 판매금 0 setting
						------------------------------------------------------------------------
						UPDATE RES_CUSTOMER_damo SET RES_STATE = (CASE WHEN @SYNC_TYPE = 'cancelBooking' THEN 1 ELSE 4 END), 
							SALE_PRICE = 0, TAX_PRICE = 0, CHG_PRICE = 0, DC_PRICE = 0, EDT_CODE = @NEW_CODE, EDT_DATE = GETDATE()
						WHERE RES_CODE = @RES_CODE

					END
					------------------------------------------------------------------------
					-- 해외 취소, 환불인 경우 정산관련 데이터 처리
					------------------------------------------------------------------------
					ELSE IF @DI_FLAG = 'I'
					BEGIN
						SET @STEP_STRING = '해외 취소/환불 정산처리'
						------------------------------------------------------------------------
						-- cancelBooking 이면서 VOID가 아닌 경우 개인경비 등록
						------------------------------------------------------------------------
						--IF @SYNC_TYPE = 'cancelBooking' AND @VOID_YN = 'N'
						--BEGIN
						--	IF EXISTS(SELECT 1 FROM dbo.SET_MASTER WHERE PRO_CODE = @PRO_CODE)
						--	BEGIN
						--		-- 환불 요청시 최초 1회 등록 (부분 최소등은 항공팀 수동 처리)
						--		IF NOT EXISTS(SELECT 1 FROM SET_CUSTOMER WHERE RES_CODE = @RES_CODE)
						--		BEGIN
						--			INSERT INTO SET_CUSTOMER (PRO_CODE, RES_CODE, RES_SEQ_NO, ETC_PROFIT, NEW_CODE, NEW_DATE)
						--			SELECT @PRO_CODE, A.RES_CODE, A.SEQ_NO, ISNULL(A.CHG_PRICE, 0), A.NEW_CODE, GETDATE()
						--			FROM dbo.RES_CUSTOMER_damo A
						--			LEFT JOIN dbo.SET_CUSTOMER B ON A.RES_CODE = B.RES_CODE AND A.SEQ_NO = B.RES_SEQ_NO 
						--			WHERE A.RES_CODE = @RES_CODE AND B.RES_CODE IS NULL;
						--		END
						--	END
						--END
					
						------------------------------------------------------------------------
						-- cancelBooking, refundTicketing 둘 다 TASF 개인경비 항목 등록
						------------------------------------------------------------------------
						IF @SYNC_TYPE = 'cancelBooking' AND @VOID_TYPE IN ('C', 'V')
						BEGIN
							UPDATE RES_CUSTOMER_damo SET RES_STATE = (CASE WHEN @VOID_TYPE = 'V' THEN 4 ELSE 1 END)
								, SALE_PRICE = (CASE WHEN @VOID_TYPE = 'V' THEN ISNULL(CHG_PRICE, 0) ELSE 0 END)
								, TAX_PRICE = 0, CHG_PRICE = 0, DC_PRICE = 0, EDT_CODE = @NEW_CODE, EDT_DATE = GETDATE()
							WHERE RES_CODE = @RES_CODE
						END
						ELSE IF @SYNC_TYPE = 'refundTicketing'
						BEGIN
						
							-- 출발자 취소 처리 (무시 22.05.04)
							--UPDATE RC SET RES_STATE = 4, SALE_PRICE = 0, TAX_PRICE = 0, CHG_PRICE = 0, DC_PRICE = 0, EDT_CODE = @NEW_CODE, EDT_DATE = GETDATE()
							--FROM RES_CUSTOMER_damo RC
							--INNER JOIN interface.TB_VGT_MA100 MA100 ON RC.RES_CODE = MA100.IF_SYS_RSV_NO
							--INNER JOIN interface.TB_VGT_TK110 TK110 ON MA100.PNR_SEQNO = TK110.PNR_SEQNO AND RC.SEQ_NO = TK110.PAX_NO
							--INNER JOIN interface.TB_VGT_TK120 TK120 ON TK110.PNR_SEQNO = TK120.PNR_SEQNO AND TK110.TKT_NO = TK120.TKT_NO
							--WHERE RC.RES_CODE = @RES_CODE AND RC.RES_STATE <> 4;

							-- 정산 항공티켓 0원 처리							
							--UPDATE A SET A.FARE_PRICE = 0, A.NET_PRICE = 0, A.PAY_PRICE = 0, A.TAX_PRICE = 0
							--FROM dbo.SET_AIR_CUSTOMER A
							--INNER JOIN RES_CUSTOMER_damo B ON A.RES_CODE = B.RES_CODE AND A.RES_SEQ_NO = B.SEQ_NO
							--WHERE A.RES_CODE = @RES_CODE AND B.RES_STATE = 4 -- 패널티만
						
							------------------------------------------------------------------------
							-- 환불 티켓번호가 VGT 티켓정보에 없을 경우 담당자에게 사내메일 발송
							------------------------------------------------------------------------
							DECLARE @TICKET_LIST VARCHAR(1000)
							SELECT @TICKET_LIST = STUFF ((
							
								SELECT (', ' + TK120.TKT_NO)
								FROM interface.TB_VGT_TK120 TK120
								INNER JOIN interface.TB_VGT_TK110 TK110 ON TK120.PNR_SEQNO = TK110.PNR_SEQNO AND TK120.TKT_NO = TK110.TKT_NO
								INNER JOIN interface.TB_VGT_MA100 MA100 ON TK120.PNR_SEQNO = MA100.PNR_SEQNO
								INNER JOIN dbo.RES_CUSTOMER_damo RC ON MA100.IF_SYS_RSV_NO = RC.RES_CODE AND RC.SEQ_NO = TK110.PAX_NO
								WHERE TK120.PNR_SEQNO = @PNR_SEQNO AND RC.RES_CODE IS NULL
								FOR XML PATH('')), 1, 2, '');
						
							IF @TICKET_LIST IS NOT NULL
							BEGIN
								SELECT @SUBJECT = ('[환불연동오류] 미 등록 티켓 발생: [' + @PRO_CODE + ' (' + @RES_CODE + ')]'),
									@CONTENTS = '미 등록 티켓번호: ' + @TICKET_LIST;
							
								EXEC dbo.SP_NOTE_INSERT @NEW_CODE, 0, '', '', @CONTENTS, @SUBJECT, '9999999';
							END
						
						END
					END

				END
			
				------------------------------------------------------------------------
				-- 결제 상태에 따라 예약상태 업데이트
				------------------------------------------------------------------------
				DECLARE @PAY_PRICE DECIMAL = DBO.FN_RES_GET_PAY_PRICE(@RES_CODE);
			
				IF (@PAY_PRICE > 0)
				BEGIN
					UPDATE RES_MASTER_damo SET RES_STATE = (CASE WHEN (DBO.FN_RES_GET_TOTAL_PRICE(RES_CODE) - @PAY_PRICE) = 0 THEN 4 ELSE 3 END)
					WHERE RES_CODE = @RES_CODE AND RES_STATE < 5
				END
		
			IF @@TRANCOUNT > 0
				COMMIT TRAN
		
		END TRY
		BEGIN CATCH
	
			IF @AUTO_YN = 'N'
			BEGIN
			SELECT -1 AS [CODE]
				,@STEP_STRING AS Step
				,ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;
			END

			SELECT @RESULT_CODE = -1, @MESSAGE = ('[' + CONVERT(VARCHAR(100), ERROR_LINE()) + '] ' + ERROR_MESSAGE()), @RES_CODE = NULL;
		
			IF @@TRANCOUNT > 0
				ROLLBACK TRAN
		
		END CATCH
	
		------------------------------------------------------------------------
		-- 실행로그 
		------------------------------------------------------------------------
		UPDATE interface.TB_VGT_MA900 SET SYNC_TYPE = @SYNC_TYPE, OUT_DATE = GETDATE() WHERE LINK_NO = @LINK_NO;
	
		------------------------------------------------------------------------
		-- 결과리턴
		------------------------------------------------------------------------
		SELECT @RESULT_CODE AS [CODE], @MESSAGE AS [MESSAGE], @RES_CODE AS [IF_SYS_RSV_NO], CONVERT(VARCHAR(50), @CUS_NO) AS [RSV_USR_ID], @STEP_STRING AS [STEP]
	
	END
	ELSE
	BEGIN
		------------------------------------------------------------------------
		-- 정산마감으로 동기화 실패 시 실행
		------------------------------------------------------------------------
		SELECT
			@SUBJECT = ('[실시간항공] 정산마감으로 동기화 실패 (일련번호: ' + CONVERT(VARCHAR(10), RV100.PNR_SEQNO) + ']'),
			@CONTENTS = ('예약번호: ' + MA100.IF_SYS_RSV_NO + ' / 일련번호: ' + CONVERT(VARCHAR(10), RV100.PNR_SEQNO) + ' / 동기화타입: ' + RV100.SYNC_TYPE),
			@SYNC_TYPE = ('X-' + RV100.SYNC_TYPE),	-- 동기화실패 표시
			@NEW_CODE = RV100.CHRG_USR_ID
		FROM interface.TB_VGT_RV100 RV100
		LEFT JOIN interface.TB_VGT_MA100 MA100 ON RV100.PNR_SEQNO = MA100.PNR_SEQNO
		WHERE RV100.PNR_SEQNO = @PNR_SEQNO;
		
		------------------------------------------------------------------------
		-- 실행로그
		------------------------------------------------------------------------
		INSERT INTO interface.TB_VGT_MA900 (PNR_SEQNO, SYNC_TYPE, IN_DATE, OUT_DATE, AUTO_YN)
		VALUES (@PNR_SEQNO, @SYNC_TYPE, GETDATE(), GETDATE(), @AUTO_YN);
		
		------------------------------------------------------------------------
		-- 담당자 사내메일 발송
		------------------------------------------------------------------------
		EXEC dbo.SP_NOTE_INSERT @NEW_CODE, 0, '', '', @CONTENTS, @SUBJECT, '9999999';
		
		------------------------------------------------------------------------
		-- 결과리턴
		------------------------------------------------------------------------
		SELECT -1 AS [CODE], '정산마감' AS [MESSAGE], '' AS [IF_SYS_RSV_NO], CONVERT(VARCHAR(50), 0) AS [RSV_USR_ID]
		
	END
	
    ------------------------------------------------------------------------
	-- 대칭키 CLOSE
	------------------------------------------------------------------------
	IF EXISTS (SELECT * FROM SYS.OPENKEYS  WHERE KEY_NAME = 'SYM_TOPAS_AIR')
	BEGIN
		CLOSE SYMMETRIC KEY SYM_TOPAS_AIR
	END
	       
END
GO
