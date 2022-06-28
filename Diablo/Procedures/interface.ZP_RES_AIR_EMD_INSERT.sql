USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================    
■ USP_NAME				: [interface].[ZP_RES_AIR_EMD_INSERT]    
■ DESCRIPTION			: EMD 예약 연동 
■ INPUT PARAMETER		:     
■ OUTPUT PARAMETER		: 
■ EXEC					:     
■ MEMO					: 오류 발생 시 @RES_CODE = NULL, @MESSAGE = 오류메세지
						 
	EXEC [interface].[ZP_RES_AIR_EMD_INSERT] @ANCILY_SEQNO = 3208

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION               
------------------------------------------------------------------------------------------------------------------
	2021-08-20		김성호			최초생성
	2021-11-30		김성호			SET_MASTER 존재 시 SET_CUSTOMER 등록
================================================================================================================*/
CREATE PROCEDURE [interface].[ZP_RES_AIR_EMD_INSERT]

	@ANCILY_SEQNO	INT,
	@AUTO_YN		CHAR(1) = 'Y'

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
	-- 실행로그
	------------------------------------------------------------------------
	INSERT INTO interface.TB_VGT_MA990 (ANCLY_SEQNO, RSV_STATUS_CD, REG_DATE, IN_DATE)
	SELECT ANCLY_SEQNO, ED100.RSV_STATUS_CD, GETDATE(), GETDATE()
	FROM interface.TB_VGT_ED100 ED100
	WHERE ED100.ANCLY_SEQNO = @ANCILY_SEQNO;
	
	
	-- 리턴 변수
	DECLARE @RES_CODE VARCHAR(20) = NULL, @CUS_NO INT = 0, @RESULT_CODE INT = 1, @MESSAGE NVARCHAR(2048) = NULL, @PNR_SEQNO INT, @RSV_STATUS_CD	VARCHAR(4) = NULL
		, @LINK_NO INT = @@IDENTITY, @TODAY VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112)

	
	BEGIN TRY
		
		BEGIN TRAN
			------------------------------------------------------------------------
			-- 인터페이스 데이터 조회
			------------------------------------------------------------------------
			BEGIN
				DECLARE
					@ANCLY_FLAG_CD VARCHAR(5),
					@MASTER_CODE VARCHAR(10), @PRO_CODE VARCHAR(20), @PRO_NAME VARCHAR(100), @BIT_CODE VARCHAR(4), @PROVIDER VARCHAR(10), @RES_STATE INT,
					@DEP_DATE DATETIME, @ARR_DATE DATETIME, @LAST_PAY_DATE DATETIME, @SYSTEM_TYPE INT, @SALE_COM_CODE VARCHAR(50), @AIR_GDS INT,
					@AIR_PRO_TYPE INT = 0, -- 실시간 = 0, 공동구매, 할인항공, 땡처리항공, 프로모션, 깜짝특가, 오프라인, 전체 = 9
					@CUS_NAME VARCHAR(20), @MEMBER_YN CHAR(1), @EMAIL VARCHAR(50), @RES_TYPE INT,
					@NOR_TEL VARCHAR(20), @NOR_TEL1 VARCHAR(10), @NOR_TEL2 VARCHAR(10), @NOR_TEL3 VARCHAR(10),  
					@DI_FLAG VARCHAR(10), -- 국내/외 구분
					@ROUTING_TYPE INT,
					@PNR_CODE VARCHAR(10), @AIR_RES_CODE VARCHAR(10), @SET_AGT_CODE VARCHAR(10), @SET_SEQ_NO INT, -- 정산순번
					@NEW_CODE VARCHAR(10), @NEW_TEAM_CODE VARCHAR(3), @NEW_TEAM_NAME VARCHAR(50),
					@SALE_EMP_CODE EMP_CODE, @SALE_TEAM_CODE VARCHAR(3), @SALE_TEAM_NAME varchar(50),
					@PROFIT_EMP_CODE EMP_CODE, @PROFIT_TEAM_CODE varchar(3), @PROFIT_TEAM_NAME varchar(50),
					@REG_DTM VARCHAR(8);

				-- 예약코드 검색
				SELECT @RES_CODE = IF_SYS_RSV_NO FROM interface.TB_VGT_MA190 WHERE ANCLY_SEQNO = @ANCILY_SEQNO;
				
				SELECT
					@PNR_SEQNO = RV100.PNR_SEQNO,
					@AIR_RES_CODE = RV100.RSV_NO,
					@PNR_CODE = RV100.ALPHA_PNR_NO,
					@DI_FLAG = RV100.DI_FLAG,	-- D: 국내, I: 해외
					@CUS_NO = CONVERT(INT, RV100.RSV_USR_ID),
					@CUS_NAME = RV100.RSV_USR_NM,
					@MEMBER_YN = (CASE WHEN EXISTS(SELECT 1 FROM DBO.CUS_MEMBER WHERE CUS_NO =  CONVERT(INT, RV100.RSV_USR_ID)) THEN 'Y' ELSE 'N' END),
					@SYSTEM_TYPE = (CASE WHEN RV100.DVICE_TYPE = 'PC' THEN 1 ELSE 3 END),	-- PC: 1, MOBILE: 3
					@RES_TYPE = (CASE WHEN RV100.SALE_FORM_CD = 'BTMS' THEN 2 ELSE 0 END),  -- 0: 일반 , 1: 대리점, 2: 상용, 9: 지점
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
							WHEN RV100.ON_OFF_RSV_FLAG = 'OFF' THEN '1'		-- 직판
							WHEN RV100.BPLC_CD = 'SKY001' THEN '44'			-- 스카이스캐너
							WHEN RV100.BPLC_CD = 'TMO001' THEN '36'			-- 티몬
							WHEN RV100.BPLC_CD = 'WMP001' THEN '42'			-- 위메프
							WHEN RV100.BPLC_CD = 'SKM001' THEN '31'			-- 11번가
							ELSE '5'										-- 인터넷
						END),
					@SALE_COM_CODE = (
						CASE
							WHEN RV100.BPLC_CD = 'SKY001' THEN '18095'
							WHEN RV100.BPLC_CD = 'TMO001' THEN '93024'				-- 티몬
							WHEN RV100.BPLC_CD = 'WMP001' THEN '92768'				-- 위메프
							WHEN RV100.BPLC_CD = 'SKM001' THEN '16084'				-- 11번가
							WHEN RV100.SALE_FORM_CD = 'BTMS' THEN RV100.BCNC_CD		-- BTMS 거래처코드
						END),
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
					
					@ANCLY_FLAG_CD = ED100.ANCLY_FLAG_CD,	-- S:좌석, B:수하물 
					@RSV_STATUS_CD = ED100.RSV_STATUS_CD,
					@REG_DTM = SUBSTRING(ED100.REG_DTM, 1, 8)
				FROM interface.TB_VGT_ED100 ED100
				INNER JOIN interface.TB_VGT_RV100 RV100 ON ED100.PNR_SEQNO = RV100.PNR_SEQNO
				WHERE ED100.ANCLY_SEQNO = @ANCILY_SEQNO;
				
				-- 출국 출발, 귀국 도착 시간 설정
				SELECT
					@DEP_DATE = MIN([interface].[ZN_PUB_STRING_TO_DATETIME](DEP_DATE + DEP_TM)),
					@ARR_DATE = MAX([interface].[ZN_PUB_STRING_TO_DATETIME](ARR_DATE + ARR_TM))
				FROM interface.TB_VGT_ED100 ED100
				
				INNER JOIN INTERFACE.TB_VGT_RV120 RV120 ON ED100.PNR_SEQNO = RV120.PNR_SEQNO
					AND ((ED100.ANCLY_FLAG_CD = 'S' AND ED100.SEG_TATOO_NO = RV120.ITIN_TATOO_NO) OR 
						(ED100.ANCLY_FLAG_CD = 'B' AND ED100.ITIN_TATOO_NO = RV120.ITIN_BUNDLE_UNIT))
				WHERE ED100.ANCLY_SEQNO = @ANCILY_SEQNO;

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

			END

			------------------------------------------------------------------------
			-- RES_MASTER 등록
			------------------------------------------------------------------------
			IF ISNULL(@RES_CODE, '') = ''
			BEGIN

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
    
				-- 행사코드 BIT_CODE 조회
				EXEC dbo.SP_PRO_GET_PRO_CODE 'T', @BIT_CODE OUTPUT;

				-- PRO_CODE 세팅
				SELECT @PRO_CODE = (@MASTER_CODE + '-' + CONVERT(VARCHAR(6), @DEP_DATE, 12) + @BIT_CODE),
					@PRO_NAME = '[EMD:' + (CASE @ANCLY_FLAG_CD WHEN 'S' THEN '좌석' WHEN 'B' THEN '수하물' ELSE '' END) + '] ' + @CUS_NAME + '/출발일' + CONVERT(VARCHAR(10), @DEP_DATE, 120);

				-- 예약생성
				DECLARE @TMP_RES_CODE TABLE (RES_CODE VARCHAR(20));
				INSERT @TMP_RES_CODE
				EXEC DIABLO.DBO.XP_WEB_RES_MASTER_INSERT @RES_AGT_TYPE=0, @PRO_TYPE=2,  @RES_TYPE=@RES_TYPE,  @RES_PRO_TYPE=2, @PROVIDER=@PROVIDER, @RES_STATE=2, @RES_CODE=NULL,
					@MASTER_CODE=@MASTER_CODE, @PRO_CODE=@PRO_CODE, @PRICE_SEQ=1, @PRO_NAME=@PRO_NAME, @DEP_DATE=@DEP_DATE, @ARR_DATE=@ARR_DATE, @LAST_PAY_DATE=@LAST_PAY_DATE, 
					@CUS_NO=@CUS_NO, @RES_NAME=@CUS_NAME, @BIRTH_DATE=NULL, @GENDER=NULL, @IPIN_DUP_INFO=NULL, @RES_EMAIL=@EMAIL, @NOR_TEL1=@NOR_TEL1, @NOR_TEL2=@NOR_TEL2, 
					@NOR_TEL3=@NOR_TEL3, @ETC_TEL1=NULL, @ETC_TEL2=NULL, @ETC_TEL3=NULL, @RES_ADDRESS1=NULL, @RES_ADDRESS2=NULL, @ZIP_CODE=NULL, @MEMBER_YN=@MEMBER_YN, 
					@CUS_REQUEST=NULL, @CUS_RESPONSE=NULL, @COMM_RATE=NULL, @COMM_AMT=NULL, @NEW_CODE=@NEW_CODE, @ETC=NULL, @SYSTEM_TYPE=@SYSTEM_TYPE, @SALE_COM_CODE=@SALE_COM_CODE, 
					@TAX_YN='N';

				SELECT TOP 1 @RES_CODE = RES_CODE FROM @TMP_RES_CODE;
				
				-- 매핑테이블 등록
				INSERT INTO interface.TB_VGT_MA190 (ANCLY_SEQNO, IF_SYS_RSV_NO, REG_USR_ID)
				VALUES (@ANCILY_SEQNO, @RES_CODE, 'SYSTEM');
									
			END
			------------------------------------------------------------------------
			-- RES_MASTER 수정
			------------------------------------------------------------------------
			ELSE IF EXISTS(SELECT 1 FROM Diablo.dbo.RES_MASTER_damo WHERE RES_CODE = @RES_CODE)
			BEGIN
				-- 이벤트 성격에 따라 예약 상태 값 변경
				SET @RES_STATE = (
					CASE @RSV_STATUS_CD
						WHEN 'ERRP' THEN 2	-- 미결제: 확정
						WHEN 'ERCR' THEN 5	-- 미수발권: 발권완료
						WHEN 'ERTK' THEN 5	-- 발권완료: 발권완료
						WHEN 'ERRX' THEN 7	-- 환불: 환불
						WHEN 'ERXX' THEN 9	-- 예약취소: 취소
						WHEN 'ERVX' THEN 9	-- VOID: 취소
						ELSE 2				-- DEFAULT
					END)

				--DECLARE @OLD_MASTER_CODE VARCHAR(10), @OLD_PRO_CODE VARCHAR(20), @OLD_PRO_NAME VARCHAR(100), @OLD_DEP VARCHAR(6)
				
				-- 행사코드 변경 필요 유무 체크(삭제)
				
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
					RES_STATE = @RES_STATE, MASTER_CODE = @MASTER_CODE, PRO_CODE = @PRO_CODE, PRICE_SEQ = 1, PRO_NAME = @PRO_NAME, DEP_DATE = @DEP_DATE, ARR_DATE = @ARR_DATE,
					LAST_PAY_DATE = @LAST_PAY_DATE, RES_EMAIL = @EMAIL, NOR_TEL1 = @NOR_TEL1, NOR_TEL2 = @NOR_TEL2, NOR_TEL3 = @NOR_TEL3,
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
			-- 항공부가정보 없을 경우 등록
			------------------------------------------------------------------------
			--IF @SYNC_TYPE IN ('createBooking', 'updateBooking')
			IF EXISTS(SELECT 1 FROM dbo.RES_AIR_DETAIL WHERE RES_CODE = @RES_CODE)
			BEGIN
				------------------------------------------------------------------------
				-- RES_AIR_DETAIL(항공예약상세)
				------------------------------------------------------------------------
				--DELETE FROM dbo.RES_AIR_DETAIL WHERE RES_CODE = @RES_CODE;
				WITH LIST AS
				(
					SELECT RV120.PNR_SEQNO, RV120.ITIN_BUNDLE_UNIT, MIN(RV120.ITIN_NO) MIN_NO,  MAX(RV120.ITIN_NO) MAX_NO
					FROM interface.TB_VGT_ED100 ED100
					INNER JOIN INTERFACE.TB_VGT_RV120 RV120 ON ED100.PNR_SEQNO = RV120.PNR_SEQNO
						AND ((ED100.ANCLY_FLAG_CD = 'S' AND ED100.SEG_TATOO_NO = RV120.ITIN_TATOO_NO) OR 
							(ED100.ANCLY_FLAG_CD = 'B' AND ED100.ITIN_TATOO_NO = RV120.ITIN_BUNDLE_UNIT))
					WHERE ED100.ANCLY_SEQNO = @ANCILY_SEQNO
					GROUP BY RV120.PNR_SEQNO, RV120.ITIN_BUNDLE_UNIT
				)
				INSERT INTO dbo.RES_AIR_DETAIL (
					RES_CODE,					AIR_PRO_TYPE,		PRO_CODE,		AIR_GDS,		PNR_CODE1,		PNR_CODE2,			AIRLINE_CODE,
					INTER_YN,					ROUTING_TYPE,
					DEP_DEP_AIRPORT_CODE,		DEP_DEP_DATE,		DEP_DEP_TIME,
					DEP_ARR_AIRPORT_CODE,		DEP_ARR_DATE,		DEP_ARR_TIME,
					ARR_DEP_AIRPORT_CODE,		ARR_DEP_DATE,		ARR_DEP_TIME,
					ARR_ARR_AIRPORT_CODE,		ARR_ARR_DATE,		ARR_ARR_TIME)
				SELECT
					@RES_CODE,					@AIR_PRO_TYPE,		@PRO_CODE,		@AIR_GDS,		@PNR_CODE,		@AIR_RES_CODE,		A.AIRLINE_CODE,
					(CASE WHEN @DI_FLAG = 'I' THEN 'Y' ELSE 'N' END),				@ROUTING_TYPE,
					A.DEP_DEP_AIRPORT_CODE,		A.DEP_DEP_DATE,		CONVERT(VARCHAR(5), A.DEP_DEP_DATE, 108),
					A.DEP_ARR_AIRPORT_CODE,		A.DEP_ARR_DATE,		CONVERT(VARCHAR(5), A.DEP_ARR_DATE, 108),
					A.ARR_DEP_AIRPORT_CODE,		A.ARR_DEP_DATE,		CONVERT(VARCHAR(5), A.ARR_DEP_DATE, 108),
					A.ARR_ARR_AIRPORT_CODE,		A.ARR_ARR_DATE,		CONVERT(VARCHAR(5), A.ARR_ARR_DATE, 108)
				FROM (
					SELECT 
						A.PNR_SEQNO,  --MAX(SEG1.AIR_RSV_NO) AS [PNR_CODE],
						MAX(CASE WHEN A.MIN_NO = SEG1.ITIN_NO THEN SUBSTRING(SEG1.FLTNO, 1, 2) ELSE '' END) AS [AIRLINE_CODE],
						MAX(CASE WHEN A.MIN_NO = SEG1.ITIN_NO THEN SEG1.DEP_AIRPORT_CD ELSE '' END) AS [DEP_DEP_AIRPORT_CODE],
						MAX(CASE WHEN A.MIN_NO = SEG1.ITIN_NO THEN [interface].[ZN_PUB_STRING_TO_DATETIME](SEG1.DEP_DATE + SEG1.DEP_TM) ELSE NULL END) AS [DEP_DEP_DATE],
						MAX(CASE WHEN A.MAX_NO = SEG1.ITIN_NO THEN SEG1.ARR_AIRPORT_CD ELSE '' END) AS [DEP_ARR_AIRPORT_CODE],
						MAX(CASE WHEN A.MAX_NO = SEG1.ITIN_NO THEN [interface].[ZN_PUB_STRING_TO_DATETIME](SEG1.ARR_DATE + SEG1.ARR_TM) ELSE NULL END) AS [DEP_ARR_DATE],
						MAX(CASE WHEN A.MIN_NO = SEG2.ITIN_NO THEN SEG2.DEP_AIRPORT_CD ELSE '' END) AS [ARR_DEP_AIRPORT_CODE],
						MAX(CASE WHEN A.MIN_NO = SEG2.ITIN_NO THEN [interface].[ZN_PUB_STRING_TO_DATETIME](SEG2.DEP_DATE + SEG2.DEP_TM) ELSE NULL END) AS [ARR_DEP_DATE],
						MAX(CASE WHEN A.MAX_NO = SEG2.ITIN_NO THEN SEG2.ARR_AIRPORT_CD ELSE '' END) AS [ARR_ARR_AIRPORT_CODE],
						MAX(CASE WHEN A.MAX_NO = SEG2.ITIN_NO THEN [interface].[ZN_PUB_STRING_TO_DATETIME](SEG2.ARR_DATE + SEG2.ARR_TM) ELSE NULL END) AS [ARR_ARR_DATE]
					FROM LIST A
					LEFT JOIN interface.TB_VGT_RV120 SEG1 ON A.PNR_SEQNO = SEG1.PNR_SEQNO AND SEG1.ITIN_BUNDLE_UNIT = 1
					LEFT JOIN interface.TB_VGT_RV120 SEG2 ON A.PNR_SEQNO = SEG2.PNR_SEQNO AND SEG2.ITIN_BUNDLE_UNIT IN (SELECT MAX(ITIN_BUNDLE_UNIT) FROM LIST)
					GROUP BY A.PNR_SEQNO
				) A

				------------------------------------------------------------------------
				-- RES_CUSTOMER(출발자)
				------------------------------------------------------------------------
				--DELETE FROM dbo.RES_CUSTOMER_damo WHERE RES_CODE = @RES_CODE;
				INSERT INTO dbo.RES_CUSTOMER_damo (
					RES_CODE, SEQ_NO, CUS_NO, CUS_NAME, LAST_NAME, FIRST_NAME, AGE_TYPE, BIRTH_DATE, GENDER, SALE_PRICE, TAX_PRICE, CHG_PRICE, DC_PRICE, NEW_CODE, NEW_DATE)
				SELECT
					@RES_CODE, RV110.PAX_NO, 1,
					(RV110.PAX_ENG_FMNM + RV110.PAX_ENG_NM) AS [CUS_NAME],
					RV110.PAX_ENG_FMNM AS [LAST_NAME],
					RV110.PAX_ENG_NM AS [FIRST_NAME],
					(RV110.PAX_AGE_FLAG - 1) AS [AGT_TYPE],
					[interface].[ZN_PUB_STRING_TO_DATETIME]([interface].[ZN_PUB_AIR_DECRYPT](RV110.PAX_BIRTH, RV110.PNR_SEQNO)) AS [BIRTH_DATE],
					(CASE RV110.PAX_SEX WHEN '1' THEN 'M' WHEN '2' THEN 'F' END) AS [GENDER],
					RV110.SALE_NET_AMT AS [SALE_PRICE],
					(RV110.SALE_TAX_AMT + RV110.BAF) AS [TAX_PRICE],
					RV110.TASF AS [CHG_PRICE],
					(RV110.SALE_DSCNT_AMT - RV110.SALE_NET_AMT) AS [DC_PRICE], @NEW_CODE, GETDATE()
				FROM interface.TB_VGT_ED100 ED100
				INNER JOIN interface.TB_VGT_RV110 RV110 ON ED100.PNR_SEQNO = RV110.PNR_SEQNO AND ED100.PAX_TATOO_NO = RV110.PAX_TATOO_NO
				WHERE ED100.ANCLY_SEQNO = @ANCILY_SEQNO;
				
				------------------------------------------------------------------------
				-- RES_SEGMENT(운항여정)
				------------------------------------------------------------------------
				--DELETE FROM dbo.RES_SEGMENT WHERE RES_CODE = @RES_CODE;
				--INSERT INTO dbo.RES_SEGMENT (
				--	RES_CODE, SEQ_NO, DEP_AIRPORT_CODE, ARR_AIRPORT_CODE, DEP_CITY_CODE, ARR_CITY_CODE, AIRLINE_CODE, FLIGHT, 
				--	[START_DATE], END_DATE, 
				--	FLYING_TIME, AIRLINE_PNR, BKG_CLASS, SEAT_STATUS, DIRECTION, NEW_CODE, NEW_DATE)
				--SELECT
				--	@RES_CODE, RV120.ITIN_NO, RV120.DEP_AIRPORT_CD, RV120.ARR_AIRPORT_CD, RV120.DEP_CITY_CD, RV120.ARR_CITY_CD, SUBSTRING(RV120.FLTNO, 1, 2), SUBSTRING(RV120.FLTNO, 3, 4),
				--	[interface].[ZN_PUB_STRING_TO_DATETIME](RV120.DEP_DATE + RV120.DEP_TM), [interface].[ZN_PUB_STRING_TO_DATETIME](RV120.ARR_DATE + RV120.ARR_TM), 
				--	'00:00', RV120.AIR_RSV_NO, RV120.CABIN_SEAT_GRAD, 'HK', (CONVERT(INT, RV120.ITIN_BUNDLE_UNIT) - 1), 
				--	@NEW_CODE, GETDATE()
				--FROM interface.TB_VGT_RV120 RV120
				--WHERE RV120.PNR_SEQNO = @ANCILY_SEQNO;
			END
			
			------------------------------------------------------------------------
			-- ERCR: 미수발권, ERTK: 발권완료, ERVX: VOID, ERRX: 환불
			------------------------------------------------------------------------
			IF @RSV_STATUS_CD IN ('ERCR', 'ERTK', 'ERVX', 'ERRX')
			BEGIN
				------------------------------------------------------------------------
				-- 정산마스터 미등록 시 등록
				------------------------------------------------------------------------
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
				-- 입금관련 데이터 처리
				------------------------------------------------------------------------
				-- 이전 항목 취소 처리
				IF EXISTS(SELECT 1 FROM DBO.PAY_MATCHING WHERE RES_CODE = @RES_CODE)
				BEGIN
					UPDATE DBO.PAY_MASTER_DAMO SET CXL_YN = 'Y', CXL_DATE = GETDATE(), CXL_CODE = @NEW_CODE WHERE PAY_SEQ IN (
						SELECT PAY_SEQ FROM DBO.PAY_MATCHING WITH(NOLOCK) WHERE RES_CODE = @RES_CODE AND CXL_YN = 'N'
					)
					UPDATE DBO.PAY_MATCHING SET CXL_YN = 'Y', CXL_DATE = GETDATE(), CXL_CODE = @NEW_CODE WHERE RES_CODE = @RES_CODE AND CXL_YN = 'N'	
				END
				------------------------------------------------------------------------
				-- PAY_MASTER 등록
				-- ED130.PAY_MTH_CD IN ('CCCC', 'CCK1') | 코드 참조 interface.TB_VGT_CD111.MASTR_CD = 'C28'
				-- ED130.PAY_STATUS_CD IN ('PAKK', 'PAXX') | 코드 interface.TB_VGT_CD111.MASTR_CD = 'A84'
				-- 호출 시 이전 결제 내용은 취소 처리 하기 때문에 결제요청(PAQK) 상태 제외 등록, 취소/환불에 대한 처리는 아래에
				------------------------------------------------------------------------
				INSERT INTO PAY_MASTER_damo (
					PAY_TYPE,		CUS_NO,			ADMIN_REMARK,
					PAY_SUB_NAME,	PAY_METHOD,		
					PAY_NAME,		PAY_PRICE,		PAY_DATE,	
					INSTALLMENT,	NEW_CODE,		NEW_DATE,
					SEC_PAY_NUM,	
					SEC1_PAY_NUM
				)
				SELECT
					(CASE WHEN ED130.DATA_FLAG = 'EMDRV' THEN 10 ELSE 12 END) AS [PAY_TYPE], @CUS_NO AS [CUS_NO], @RES_CODE AS [ADMIN_REMARK],
					(CASE WHEN ED130.DATA_FLAG = 'EMDRV' THEN 'CCCF' ELSE 'TASF' END) AS [PAY_SUB_NAME], '9' AS [PAY_METHOD],	-- 홈페이지 = 0, EMAIL, 직접방문, 전화, 은행, 수동 = 8, 시스템 = 9
					MIN(ED130.CARD_OWNER_NM) AS [PAY_NAME], SUM(ED130.CARD_PAY_AMT) AS [PAY_PRICE], [interface].[ZN_PUB_STRING_TO_DATETIME](MIN(ED130.PAY_RQ_DTM)) AS [PAY_DATE],
					CONVERT(INT, MIN(ED130.CARD_INSTLMT_CNT)) AS [INSTALLMENT], @NEW_CODE AS [NEW_CODE], GETDATE() AS [NEW_DATE],
					damo.dbo.enc_varchar('DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM', [interface].[ZN_PUB_AIR_DECRYPT](ED130.CARD_NO, ED100.PNR_SEQNO)) AS [SEC_PAY_NUM],
					damo.dbo.pred_meta_plain_v([interface].[ZN_PUB_AIR_DECRYPT](ED130.CARD_NO, ED100.PNR_SEQNO), 'DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM') AS [SEC1_PAY_NUM]
				FROM interface.TB_VGT_ED130 ED130
				INNER JOIN interface.TB_VGT_ED100 ED100 ON ED130.ANCLY_SEQNO = ED100.ANCLY_SEQNO
				WHERE ED130.ANCLY_SEQNO = @ANCILY_SEQNO AND ED130.PAY_MTH_CD IN ('CCCC', 'CCK1') AND ED130.PAY_STATUS_CD IN ('PAKK', 'PAXX') -- PAKK: 결제완료, PAXX: 결제취소
				GROUP BY ED130.DATA_FLAG, ED130.PAY_MTH_CD, [interface].[ZN_PUB_AIR_DECRYPT](ED130.CARD_NO, ED100.PNR_SEQNO)
				------------------------------------------------------------------------
				-- PAY_MATCHING 등록		ED130.PAY_MTH_CD IN ('CCCC', 'CCK1')
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
							@RES_CODE AS [RES_CODE], ROW_NUMBER() OVER (ORDER BY MIN(ED130.PAY_RQ_SEQNO)) AS [ROWNUM],
							(CASE WHEN ED130.DATA_FLAG = 'EMDRV' THEN 10 ELSE 12 END) AS [PAY_TYPE],
							damo.dbo.pred_meta_plain_v([interface].[ZN_PUB_AIR_DECRYPT](ED130.CARD_NO, ED100.PNR_SEQNO), 'DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM') AS [SEC1_PAY_NUM]
						FROM interface.TB_VGT_ED130 ED130
						INNER JOIN interface.TB_VGT_ED100 ED100 ON ED130.ANCLY_SEQNO = ED100.ANCLY_SEQNO
						WHERE ED130.ANCLY_SEQNO = @ANCILY_SEQNO AND ED130.PAY_MTH_CD IN ('CCCC', 'CCK1')
						GROUP BY ED130.DATA_FLAG, ED130.PAY_MTH_CD, [interface].[ZN_PUB_AIR_DECRYPT](ED130.CARD_NO, ED100.PNR_SEQNO)
					) A
					INNER JOIN PAY_MASTER_damo PM
						ON A.SEC1_PAY_NUM = PM.sec1_PAY_NUM AND A.RES_CODE = PM.ADMIN_REMARK AND A.PAY_TYPE = PM.PAY_TYPE AND PM.NEW_DATE >= CONVERT(DATE, GETDATE() - 1)
							AND PM.CXL_YN = 'N'
					INNER JOIN RES_MASTER_damo RM ON A.RES_CODE = RM.RES_CODE
				) A;
					
				------------------------------------------------------------------------
				-- 상품가가 달라질 수 있으므로 이전 항목 삭제 후 재 등록
				------------------------------------------------------------------------
				IF NOT EXISTS(SELECT 1 FROM SET_LAND_AGENT WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE AND PAY_PRICE < 0)
				BEGIN
					DELETE FROM SET_LAND_CUSTOMER WHERE PRO_CODE = @PRO_CODE;
					DELETE FROM SET_LAND_AGENT WHERE PRO_CODE = @PRO_CODE;
				END
					
				-- SET_LAND_AGENT	
				SELECT @SET_SEQ_NO = (ISNULL((SELECT MAX(LAND_SEQ_NO) FROM SET_LAND_AGENT WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE), 0) + 1)
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
				WHERE A.RES_CODE = @RES_CODE AND A.RES_STATE IN (0, 3, 4)
				
				------------------------------------------------------------------------
				-- ERVX: VOID, ERRX: 환불
				------------------------------------------------------------------------
				IF @RSV_STATUS_CD IN ('ERVX', 'ERRX')
				BEGIN
					------------------------------------------------------------------------
					-- 입금데이터 환불 처리 
					------------------------------------------------------------------------
					IF (SELECT SUM(PART_PRICE) FROM PAY_MATCHING WITH(NOLOCK) WHERE RES_CODE = @RES_CODE AND CXL_YN = 'N') > 0
					BEGIN
						------------------------------------------------------------------------
						-- PAY_MASTER 취소등록	ED130.PAY_MTH_CD IN ('CCCC', 'CCK1') | 코드 참조 SELECT * FROM interface.TB_VGT_CD111 WHERE MASTR_CD = 'C28'
						------------------------------------------------------------------------
						INSERT INTO PAY_MASTER_damo (
							PAY_TYPE,		CUS_NO,				ADMIN_REMARK,		PAY_SUB_NAME,	PAY_METHOD,		
							PAY_NAME,		PAY_PRICE,			PAY_DATE,			INSTALLMENT,	
							NEW_CODE,		NEW_DATE,			SEC_PAY_NUM,		SEC1_PAY_NUM
						)
						SELECT
							PAY_TYPE,		CUS_NO,				PM.ADMIN_REMARK,	PAY_SUB_NAME,	PM.PAY_METHOD, 
							PAY_NAME,		(PAY_PRICE * -1),	GETDATE(),			0 AS [INSTALLMENT],
							@NEW_CODE,		GETDATE(),			SEC_PAY_NUM,		SEC1_PAY_NUM  
						FROM PAY_MASTER_damo PM
						WHERE PM.PAY_SEQ IN (SELECT PMA.PAY_SEQ FROM PAY_MATCHING PMA WHERE PMA.RES_CODE = @RES_CODE AND PMA.CXL_YN = 'N') 
							--AND PM.PAY_TYPE = 'CCCF' AND PM.CXL_YN = 'N' AND PM.PAY_PRICE > 0;
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
						-- VOID도 TASF 환불 x
						------------------------------------------------------------------------
						--IF @REG_DTM = @TODAY
						--BEGIN
						--	------------------------------------------------------------------------
						--	-- PAY_MASTER 취소등록
						--	------------------------------------------------------------------------
						--	INSERT INTO PAY_MASTER_damo (
						--		PAY_TYPE,		CUS_NO,				ADMIN_REMARK,		PAY_SUB_NAME,	PAY_METHOD,		
						--		PAY_NAME,		PAY_PRICE,			PAY_DATE,			INSTALLMENT,	
						--		NEW_CODE,		NEW_DATE,			SEC_PAY_NUM,		SEC1_PAY_NUM
						--	)
						--	SELECT
						--		PAY_TYPE,		CUS_NO,				PM.ADMIN_REMARK,	PAY_SUB_NAME,	PM.PAY_METHOD, 
						--		PAY_NAME,		(PAY_PRICE * -1),	GETDATE(),			0 AS [INSTALLMENT],
						--		@NEW_CODE,		GETDATE(),			SEC_PAY_NUM,		SEC1_PAY_NUM  
						--	FROM PAY_MASTER_damo PM
						--	WHERE PM.PAY_SEQ IN (SELECT PMA.PAY_SEQ FROM PAY_MATCHING PMA WHERE PMA.RES_CODE = @RES_CODE AND PMA.CXL_YN = 'N') 
						--		AND PM.PAY_SUB_NAME = 'TASF' AND PM.CXL_YN = 'N' AND PM.PAY_PRICE > 0;
						
						--	------------------------------------------------------------------------
						--	-- PAY_MATCHING 등록	
						--	------------------------------------------------------------------------
						--	SET @PAY_SEQ = @@IDENTITY;
						
						--	INSERT INTO PAY_MATCHING
						--	(
						--		PAY_SEQ,		MCH_SEQ,		MCH_TYPE,	-- 매칭타입(0 : 결제, 1 : 기타)	
						--		RES_CODE,		PRO_CODE,		PART_PRICE,			CXL_YN,		NEW_CODE,		NEW_DATE
						--	)
						--	SELECT
						--		@PAY_SEQ,		PMA.MCH_SEQ,	PMA.MCH_TYPE,
						--		PMA.RES_CODE,	PMA.PRO_CODE,	(PART_PRICE * -1),	PMA.CXL_YN,	@NEW_CODE,		GETDATE() 
						--	FROM PAY_MATCHING PMA
						--	INNER JOIN PAY_MASTER_damo PM ON PM.PAY_SEQ = PMA.PAY_SEQ
						--	WHERE PMA.RES_CODE = @RES_CODE AND PMA.CXL_YN = 'N' AND PM.PAY_SUB_NAME = 'TASF' AND PM.CXL_YN = 'N' AND PM.PAY_PRICE > 0;
						--END
					END
					
					------------------------------------------------------------------------
					-- 정산데이터 처리
					------------------------------------------------------------------------
					IF EXISTS(SELECT 1 FROM SET_MASTER WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
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
					
					------------------------------------------------------------------------
					-- 환불 시 TASF(항공수수료) 정산 기타수익에 등록
					-- ERVX: VOID, ERRX: 환불
					-- 정책상 VOID도 TASF 환불 없음 (21.08.25)
					------------------------------------------------------------------------
					IF @RSV_STATUS_CD IN ('ERVX', 'ERRX')
					BEGIN
						IF EXISTS(SELECT 1 FROM SET_MASTER WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
						BEGIN
							--UPDATE A SET A.ETC_PROFIT = ISNULL(A.ETC_PROFIT, 0) + ISNULL(B.CHG_PRICE, 0), EDT_CODE = @NEW_CODE, EDT_DATE = GETDATE()
							UPDATE A SET A.ETC_PROFIT = ISNULL(B.CHG_PRICE, 0), EDT_CODE = @NEW_CODE, EDT_DATE = GETDATE()
							FROM dbo.SET_CUSTOMER A
							INNER JOIN dbo.RES_CUSTOMER_damo B ON A.RES_CODE = B.RES_CODE AND A.RES_SEQ_NO = B.SEQ_NO
							WHERE A.RES_CODE = @RES_CODE;
						
							INSERT INTO SET_CUSTOMER (PRO_CODE, RES_CODE, RES_SEQ_NO, ETC_PROFIT, NEW_CODE, NEW_DATE)
							SELECT @PRO_CODE, A.RES_CODE, A.SEQ_NO, ISNULL(A.CHG_PRICE, 0), A.NEW_CODE, GETDATE()
							FROM dbo.RES_CUSTOMER_damo A
							LEFT JOIN dbo.SET_CUSTOMER B ON A.RES_CODE = B.RES_CODE AND A.SEQ_NO = B.RES_SEQ_NO 
							WHERE A.RES_CODE = @RES_CODE AND B.RES_CODE IS NULL;
						END
					END
					
					------------------------------------------------------------------------	
					-- 출발자 판매금 0 setting
					------------------------------------------------------------------------
					UPDATE RES_CUSTOMER_damo SET RES_STATE = 4,	-- 환불 
						SALE_PRICE = 0, TAX_PRICE = 0, CHG_PRICE = 0, DC_PRICE = 0, EDT_CODE = @NEW_CODE, EDT_DATE = GETDATE()
					WHERE RES_CODE = @RES_CODE
					
				END
				
			END
			
			------------------------------------------------------------------------
			-- ERXX: 예약취소
			------------------------------------------------------------------------
			IF @RSV_STATUS_CD IN ('ERXX')
			BEGIN
				------------------------------------------------------------------------	
				-- 출발자 판매금 0 setting
				------------------------------------------------------------------------
				UPDATE RES_CUSTOMER_damo SET RES_STATE = 1,	-- 취소 
					SALE_PRICE = 0, TAX_PRICE = 0, CHG_PRICE = 0, DC_PRICE = 0, EDT_CODE = @NEW_CODE, EDT_DATE = GETDATE()
				WHERE RES_CODE = @RES_CODE
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
	UPDATE interface.TB_VGT_MA990 SET OUT_DATE = GETDATE() WHERE LINK_NO = @LINK_NO;
	
	-- 결과리턴
	SELECT @RESULT_CODE AS [CODE], @MESSAGE AS [MESSAGE], @RES_CODE AS [RES_CODE]
	
    ------------------------------------------------------------------------
	-- 대칭키 CLOSE
	------------------------------------------------------------------------
	IF EXISTS (SELECT * FROM SYS.OPENKEYS  WHERE KEY_NAME = 'SYM_TOPAS_AIR')
	BEGIN
		CLOSE SYMMETRIC KEY SYM_TOPAS_AIR
	END
	       
END
GO
