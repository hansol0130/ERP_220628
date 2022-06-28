USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
/*================================================================================================================    
■ USP_NAME				: [ZP_RES_HOTEL_MASTER_INSERT]    
■ DESCRIPTION			: 예약 등록 및 수정 
■ INPUT PARAMETER		:     
■ OUTPUT PARAMETER		: 
■ EXEC					: RES_HTL_ROOM_MASTER

EXEC [interface].[ZP_RES_HOTEL_MASTER_INSERT] 1, 'updateBooking'


SELECT * FROM Diablo.dbo.RES_HTL_LINK_LOG WHERE resv_no = 

SELECT * FROM Diablo.dbo.RES_HTL_MAPPING WHERE res_code = ''


■ MEMO					: 오류 발생 시 @RES_CODE = NULL, @MESSAGE = 오류메세지
------------------------------------------------------------------------------------------------------------------    
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------    
	DATE			AUTHOR			DESCRIPTION               
------------------------------------------------------------------------------------------------------------------    
	2021-01-26		김성호			최초생성
	2021-05-21		김성호			입금연동 체크값 수정
	2021-05-25		김성호			카드입금 연동 수수료 등 추가
	2021-05-28		김성호			default 담당자변경 (2015082 -> 2021006)
	2021-07-05		김성호			default 담당자변경 (2021006 -> 2019001)
================================================================================================================*/     
CREATE PROCEDURE [interface].[ZP_RES_HOTEL_MASTER_INSERT]

	@RESV_NO	INT,
	@SYNC_TYPE	VARCHAR(20),		-- createBooking, updateBooking, updatePayment, cancelBooking
	@AUTO_YN	CHAR(1) = 'Y'
	
AS     
BEGIN

    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
    ------------------------------------------------------------------------
	-- 트리거 동작 제외
	------------------------------------------------------------------------
	SET CONTEXT_INFO 0x21884680;
	
	------------------------------------------------------------------------
	-- 실행로그
	------------------------------------------------------------------------
	--DECLARE @LINK_NO INT
	--INSERT INTO dbo.RES_HTL_LINK_LOG (RESV_NO, IN_DATE, AUTO_YN) VALUES (@RESV_NO, GETDATE(), @AUTO_YN);
	--SET @LINK_NO = @@IDENTITY;
    
    -- 리턴 변수
    DECLARE @RES_CODE VARCHAR(20) = NULL, @CUS_NO INT = 0, @RESULT_CODE INT = 1, @MESSAGE NVARCHAR(2048) = NULL, @IN_DATE DATETIME = GETDATE(), @NEW_CODE VARCHAR(10);
    
    BEGIN TRY
		
		BEGIN TRAN

			------------------------------------------------------------------------
			-- 예약코드 조회
			------------------------------------------------------------------------
			SELECT @RES_CODE = RHM.RES_CODE, @NEW_CODE = ISNULL(HRM.CHRG_USER, '2019001')	-- 윤수정 계장
			FROM JGHotel.dbo.HTL_RESV_MAST HRM WITH(NOLOCK)
			LEFT JOIN diablo.DBO.RES_HTL_MAPPING RHM WITH(NOLOCK) ON RHM.SUP_RES_CODE = HRM.RESV_NO
			WHERE HRM.RESV_NO = @RESV_NO
			
			------------------------------------------------------------------------
			-- 최초 예약번호 생성
			------------------------------------------------------------------------
			IF @SYNC_TYPE = 'createBooking' AND @RES_CODE IS NULL
			BEGIN
				------------------------------------------------------------------------
				-- 예약코드 생성
				------------------------------------------------------------------------
				EXEC dbo.SP_RES_GET_RES_CODE 'H', @RES_CODE OUTPUT;
				
				------------------------------------------------------------------------
				-- 매핑테이블 가등록
				------------------------------------------------------------------------
				--INSERT INTO DBO.RES_HTL_MAPPING (RES_CODE, SUP_RES_CODE, NEW_DATE)
				--VALUES (@RES_CODE, @RESV_NO, GETDATE());
			END
			ELSE IF @SYNC_TYPE IN ('updateBooking')
			BEGIN
				------------------------------------------------------------------------
				-- 인터페이스 데이터 조회
				------------------------------------------------------------------------
				BEGIN
				
					DECLARE
						@MASTER_CODE VARCHAR(10), @PRO_CODE VARCHAR(20), @PRO_NAME VARCHAR(100), @PROVIDER VARCHAR(10), @RES_STATE INT, 
						@HOTEL_NAME VARCHAR(300), @ROOM_NAME VARCHAR(300), @ROOM_TYPE VARCHAR(20), @ROOM_COUNT INT,
						@DEP_DATE DATETIME, @ARR_DATE DATETIME, @LAST_PAY_DATE DATETIME, @SYSTEM_TYPE INT, @SALE_COM_CODE VARCHAR(50), @SUP_CODE VARCHAR(2),
						--@HOTEL_PRO_TYPE INT = 0, -- 실시간 = 0, 공동구매, 할인항공, 땡처리항공, 프로모션, 깜짝특가, 오프라인, 전체 = 9
						@CUS_NAME VARCHAR(20), @MEMBER_YN CHAR(1), @EMAIL VARCHAR(50), @RES_TYPE INT,
						@NOR_TEL VARCHAR(20), @NOR_TEL1 VARCHAR(10), @NOR_TEL2 VARCHAR(10), @NOR_TEL3 VARCHAR(10),  
						@DI_FLAG VARCHAR(10), @SIGN_CODE VARCHAR(1), -- 국내/외 구분
						@NEW_TEAM_CODE VARCHAR(3), @NEW_TEAM_NAME VARCHAR(50),
						@SALE_EMP_CODE EMP_CODE, @SALE_TEAM_CODE VARCHAR(3), @SALE_TEAM_NAME varchar(50),
						@PROFIT_EMP_CODE EMP_CODE, @PROFIT_TEAM_CODE varchar(3), @PROFIT_TEAM_NAME varchar(50);
						
					SELECT
						@RES_CODE = (CASE WHEN @RES_CODE IS NULL THEN HRM.VGT_CODE ELSE @RES_CODE END),
						@HOTEL_NAME = HRM.HOTEL_NAME,
						@DI_FLAG = (CASE WHEN HCMC.NATION_CODE = 'KR' THEN 'D' ELSE 'I' END),	-- D: 국내, I: 해외
						@SIGN_CODE = ISNULL(PR.SIGN, 'Z'),	-- 없을경우 DEFAULT
						@CUS_NO = HRM.VGT_USER, --CONVERT(INT, HRM.RESV_ID),
						@CUS_NAME = HRM.RESV_NAME,
						@MEMBER_YN = (CASE WHEN EXISTS(SELECT 1 FROM DBO.CUS_MEMBER WHERE CUS_NO = HRM.VGT_USER) THEN 'Y' ELSE 'N' END),
						@SYSTEM_TYPE = (CASE HRM.CHANNEL WHEN 'WEB' THEN 1 WHEN 'MOBILE' THEN 3 END),
						--@SYSTEM_TYPE = 1, -- (CASE WHEN RV100.DVICE_TYPE = 'PC' THEN 1 ELSE 3 END),	-- PC: 1, MOBILE: 3
						@RES_TYPE = 0, --(CASE WHEN RV100.SALE_FORM_CD = 'BTMS' THEN 2 ELSE 0 END),  -- 0: 일반 , 1: 대리점, 2: 상용, 9: 지점
						@SUP_CODE = HRM.SUPP_CODE,	-- 공급사 코드
						@PROVIDER = '5', -- (
							--CASE
							--	WHEN RV100.ON_OFF_RSV_FLAG = 'OFF' THEN '1'	-- 직판
							--	ELSE (
							--		CASE RV100.BPLC_CD
							--			WHEN 'TMO001' THEN '36'				-- 티몬
							--			WHEN 'WMP001' THEN '42'				-- 위메프
							--			WHEN 'SKM001' THEN '31'				-- 11번가
							--			ELSE '5'							-- 인터넷
							--		END)
							--END),
						@SALE_COM_CODE = NULL,-- (
							--CASE RV100.BPLC_CD
							--	WHEN 'TMO001' THEN '93024'					-- 티몬
							--	WHEN 'WMP001' THEN '92768'					-- 위메프
							--	WHEN 'SKM001' THEN '16084'					-- 11번가
							--END),
						@DEP_DATE = HRM.CHECK_IN_DATE,
						@ARR_DATE = HRM.CHECK_OUT_DATE,
						@LAST_PAY_DATE = HRM.DEAD_LINE,
						@NOR_TEL = REPLACE(HRM.RESV_PHONE_MOBILE, '-', ''),
						@EMAIL = HRM.RESV_EMAIL
						--@NEW_CODE = '2021006'	-- 안선진과장
						--@NEW_CODE = HRM.CHRG_USER
					FROM JGHotel.dbo.HTL_RESV_MAST HRM
					LEFT JOIN JGHotel.dbo.HTL_INFO_MAST_HOTEL HIMH ON HRM.HOTEL_CODE = HIMH.HOTEL_CODE
					LEFT JOIN JGHotel.dbo.HTL_CODE_MAST_CITY HCMC ON HIMH.CITY_CODE = HCMC.CITY_CODE
					LEFT JOIN Diablo.DBO.PUB_NATION PN ON HCMC.NATION_CODE = PN.NATION_CODE
					LEFT JOIN Diablo.DBO.PUB_REGION PR ON PN.REGION_CODE = PR.REGION_CODE
					WHERE HRM.RESV_NO = @RESV_NO;
				
					SELECT TOP 1 @ROOM_TYPE = HRR.ROOM_TYPE, @ROOM_NAME = HRR.ROOM_DESC
						, @ROOM_COUNT = (SELECT COUNT(*) FROM [JGHotel].[dbo].[HTL_RESV_ROOM] WHERE RESV_NO = HRR.RESV_NO) 
					FROM JGHotel.dbo.HTL_RESV_ROOM HRR
					WHERE HRR.RESV_NO = @RESV_NO;
					
					-- 전화번호 분리
					IF LEN(@NOR_TEL) >= 10 AND @NOR_TEL LIKE '01%'
					BEGIN 
						SELECT
							@NOR_TEL1 = LEFT(@NOR_TEL, 3),
							@NOR_TEL2 = REPLACE(SUBSTRING(@NOR_TEL, 4, 10), RIGHT(@NOR_TEL, 4), ''),
							@NOR_TEL3 = RIGHT(@NOR_TEL, 4);
					END
					
					-- MASTER_CODE 조회
					-- 저스트고 도시코드로 국가코드 검색 후 국가코드를 통해 vg 지역 검색하여 마스터코드 지정
					-- 국내는 현재 jg로 고정되어 있음
					-- [A]HH0[HB] : [A] 지역코드, [HB] 
					SELECT @MASTER_CODE = (@SIGN_CODE + 'HH0' + @SUP_CODE);	
				
				END
				
				------------------------------------------------------------------------
				-- RES_MASTER 등록
				------------------------------------------------------------------------
				IF NOT EXISTS(SELECT 1 FROM dbo.RES_MASTER_damo WHERE RES_CODE = @RES_CODE)
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
				
					-- PRO_CODE 세팅
					SELECT @PRO_CODE = (@MASTER_CODE + '-' + CONVERT(VARCHAR(6), @DEP_DATE, 12)), @PRO_NAME = @HOTEL_NAME;
				
					-- 예약생성
					EXEC DIABLO.DBO.XP_WEB_RES_MASTER_INSERT @RES_AGT_TYPE=0, @PRO_TYPE=3, @RES_TYPE=@RES_TYPE, @RES_PRO_TYPE=3, @PROVIDER=@PROVIDER, @RES_STATE=2, @RES_CODE=@RES_CODE,
						@MASTER_CODE=@MASTER_CODE, @PRO_CODE=@PRO_CODE, @PRICE_SEQ=1, @PRO_NAME=@PRO_NAME, @DEP_DATE=@DEP_DATE, @ARR_DATE=@ARR_DATE, @LAST_PAY_DATE=@LAST_PAY_DATE, 
						@CUS_NO=@CUS_NO, @RES_NAME=@CUS_NAME, @BIRTH_DATE=NULL, @GENDER=NULL, @IPIN_DUP_INFO=NULL, @RES_EMAIL=@EMAIL, @NOR_TEL1=@NOR_TEL1, @NOR_TEL2=@NOR_TEL2, 
						@NOR_TEL3=@NOR_TEL3, @ETC_TEL1=NULL, @ETC_TEL2=NULL, @ETC_TEL3=NULL, @RES_ADDRESS1=NULL, @RES_ADDRESS2=NULL, @ZIP_CODE=NULL, @MEMBER_YN=@MEMBER_YN, 
						@CUS_REQUEST=NULL, @CUS_RESPONSE=NULL, @COMM_RATE=NULL, @COMM_AMT=NULL, @NEW_CODE=@NEW_CODE, @ETC=NULL, @SYSTEM_TYPE=@SYSTEM_TYPE, @SALE_COM_CODE=@SALE_COM_CODE, 
						@TAX_YN='N';
				
				END
				------------------------------------------------------------------------
				-- RES_MASTER 수정
				------------------------------------------------------------------------
				ELSE
				BEGIN
					---- 이벤트 성격에 따라 예약 상태 값 변경
					--SET @RES_STATE = (
					--	CASE @SYNC_TYPE
					--		WHEN 'cancelBooking' THEN 9		-- 취소
					--		ELSE 3							-- 확정
					--	END)
					
					-- 담당자 변경 시 수정		
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
						--RES_STATE = @RES_STATE, MASTER_CODE = @MASTER_CODE, PRO_CODE = @PRO_CODE, PRICE_SEQ = 1, PRO_NAME = @PRO_NAME, DEP_DATE = @DEP_DATE, ARR_DATE = @ARR_DATE,
						RES_STATE = 2,	-- 확정 
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
				
				------------------------------------------------------------------------
				-- RES_CUSTOMER(출발자)
				------------------------------------------------------------------------
				DELETE FROM dbo.RES_CUSTOMER_damo WHERE RES_CODE = @RES_CODE;
				--IF NOT EXISTS(SELECT 1 FROM dbo.RES_CUSTOMER_damo WHERE RES_CODE = @RES_CODE)
				BEGIN
					INSERT INTO dbo.RES_CUSTOMER_damo (RES_CODE, SEQ_NO, RES_STATE, CUS_NO, CUS_NAME, LAST_NAME, FIRST_NAME, AGE_TYPE, BIRTH_DATE, GENDER, NEW_CODE, NEW_DATE)
					SELECT @RES_CODE AS [RES_CODE], HRP.PAX_NO AS [SEQ_NO], 0 AS [RES_STATE], 1 AS [CUS_NO], (HRP.SUR_NAME + ' ' + HRP.GIVEN_NAME) AS [CUS_NAME], 
						HRP.SUR_NAME AS [LAST_NAME], HRP.GIVEN_NAME AS [FIRST_NAME], 
						(CASE WHEN HRP.PAX_TYPE = 'CHD' THEN 1 ELSE 0 END) AS [AGT_TYPE], HRP.BIRTH AS [BIRTH_DATE], HRP.GENDER, @NEW_CODE AS [NEW_CODE], GETDATE() AS [NEW_DATE]
					FROM JGHotel.dbo.HTL_RESV_PAX HRP
					WHERE HRP.RESV_NO = @RESV_NO;
				END

				------------------------------------------------------------------------
				-- RES_HTL_ROOM_MASTER 등록
				-- HotelReserveStatusEnum { None, 확정, 대기, 취소, 취소대기중, 펜딩, 확인요망, 환불요청중, 환불, 알수없음 }
				------------------------------------------------------------------------
				DELETE FROM DBO.RES_HTL_ROOM_MASTER WHERE RES_CODE = @RES_CODE;
				--IF NOT EXISTS(SELECT 1 FROM dbo.RES_HTL_ROOM_MASTER WHERE RES_CODE = @RES_CODE)
				BEGIN
					INSERT INTO RES_HTL_ROOM_MASTER (
						RES_CODE, MASTER_CODE, RES_STATE, CHECK_IN, CHECK_OUT, CITY_CODE, SUP_CODE, SUP_RES_CODE, 
						LAST_CXL_DATE, VOUCHER_NO, ROOM_YN, SALE_PRICE, NET_PRICE, NEW_CODE, NEW_DATE)
					SELECT
						@RES_CODE, @MASTER_CODE, 1 AS [RES_STATE], HRM.CHECK_IN_DATE, HRM.CHECK_OUT_DATE, HIMH.CITY_CODE, HRM.SUPP_CODE, HRM.SUPP_NO, 
						HRM.DEAD_LINE, HRM.RESV_NO AS [VOUCHER_NO], 'Y' AS [ROOM_YN], HRM.TOTAL_AMT AS [SALE_PRICE], HRM.SUPP_NET AS [NET_PRICE], @NEW_CODE, GETDATE()
					FROM JGHotel.dbo.HTL_RESV_MAST HRM
					LEFT JOIN JGHotel.dbo.HTL_INFO_MAST_HOTEL HIMH ON HRM.HOTEL_CODE = HIMH.HOTEL_CODE
					WHERE HRM.RESV_NO = @RESV_NO;
				END
				
				------------------------------------------------------------------------
				-- RES_HTL_ROOM_DETAIL 등록
				------------------------------------------------------------------------
				DELETE FROM RES_HTL_ROOM_DETAIL WHERE RES_CODE = @RES_CODE;
				--IF NOT EXISTS(SELECT 1 FROM RES_HTL_ROOM_DETAIL WHERE RES_CODE = @RES_CODE)
				BEGIN
					INSERT INTO RES_HTL_ROOM_DETAIL (RES_CODE, ROOM_NO, ROOM_NAME, ROOM_COUNT, BREAKFAST_YN, ROOM_TYPE)
					SELECT @RES_CODE, HRR.ROOM_NO, HRR.ROOM_DESC, 1, 'N', (
						CASE HRR.ROOM_TYPE
							--WHEN 'None' THEN 0
							WHEN 'SGL' THEN 1
							WHEN 'DBL' THEN 2
							WHEN 'TWN' THEN 3
							WHEN 'TRP' THEN 4
							WHEN 'QRD' THEN 5
							WHEN 'BS' THEN 21
							WHEN 'DB' THEN 22
							WHEN 'FT' THEN 23
							WHEN 'OB' THEN 24
							WHEN 'OD' THEN 25
							WHEN 'Q' THEN 26
							WHEN 'SB' THEN 27
							WHEN 'TB' THEN 28
							WHEN 'TR' THEN 29
							WHEN 'TS' THEN 30
							ELSE 0
						END)
					FROM JGHotel.DBO.HTL_RESV_ROOM HRR
					WHERE HRR.RESV_NO = @RESV_NO;
				END
				
				------------------------------------------------------------------------
				-- 매핑테이블 등록
				------------------------------------------------------------------------
				IF NOT EXISTS(SELECT 1 FROM dbo.RES_HTL_MAPPING WHERE SUP_RES_CODE = CONVERT(VARCHAR(20), @RESV_NO)) AND @RESV_NO > 0
				BEGIN
					INSERT INTO DBO.RES_HTL_MAPPING (RES_CODE, SUP_RES_CODE, SUP_CODE, NEW_CODE, NEW_DATE)
					VALUES (@RES_CODE, @RESV_NO, @SUP_CODE, @NEW_CODE, GETDATE());
				END
								
				--IF EXISTS(SELECT 1 FROM dbo.RES_HTL_MAPPING WHERE SUP_RES_CODE = CONVERT(VARCHAR(20), @RESV_NO) AND NEW_CODE IS NULL)
				--BEGIN
				--	UPDATE DBO.RES_HTL_MAPPING SET SUP_CODE = @SUP_CODE, NEW_CODE = @NEW_CODE WHERE SUP_RES_CODE = @RESV_NO
				--END
				
			END
			ELSE IF @SYNC_TYPE IN ('cancelBooking')
			BEGIN
				------------------------------------------------------------------------
				-- RES_MASTER_DAMO 취소
				------------------------------------------------------------------------
				UPDATE RES_MASTER_DAMO SET
					RES_STATE = 9,	-- 취소 
					CXL_CODE = @NEW_CODE,
					CXL_DATE = GETDATE()
				WHERE RES_CODE = @RES_CODE;
				
				------------------------------------------------------------------------
				-- RES_HTL_ROOM_MASTER 등록
				------------------------------------------------------------------------
				UPDATE RES_HTL_ROOM_MASTER SET SALE_PRICE = 0, NET_PRICE = 0 WHERE RES_CODE = @RES_CODE;
			END
			
			------------------------------------------------------------------------
			-- 입금정보 연동
			------------------------------------------------------------------------
			IF @SYNC_TYPE IN ('updateBooking', 'updatePayment', 'cancelBooking')
			BEGIN
				------------------------------------------------------------------------
				-- PAY_MASTER 등록 RES_HTL_PAY_LOG에 등록되지 않은 카드 건만 등록
				
				-- PAY_TYPE		(계좌종류: PG신용카드 = 3)
				-- PAY_METHOD	(입금방법: 시스템 = 9)
				------------------------------------------------------------------------
				DECLARE @COM_RATE DECIMAL(4,2), @PAY_AGT_CODE VARCHAR(10) = '92273'; -- 한국정보통신(KICC) 고정
				SELECT TOP 1 @COM_RATE = PUB_VALUE2 FROM COD_PUBLIC WHERE PUB_TYPE = 'PAY.PGCARD.FEE' AND PUB_CODE = @PAY_AGT_CODE AND USE_YN = 'Y';
				 
				INSERT INTO PAY_MASTER_damo (
					PAY_TYPE,		PAY_METHOD,		PAY_SUB_TYPE,
					PAY_SUB_NAME,
					AGT_CODE,		PAY_NAME,		PAY_DATE,
					PAY_PRICE,		COM_RATE,		COM_PRICE,
					INSTALLMENT,
					ADMIN_REMARK,
					CUS_NO,			NEW_CODE,		NEW_DATE,
					SEC_PAY_NUM,
					SEC1_PAY_NUM
				)
				SELECT
					3 AS [PAY_TYPE], '9' AS [PAY_METHOD], TTP.P_CARD_ISSUER_CODE AS [PAY_SUB_TYPE], 
					ISNULL(TTP.P_CARD_ISSUER_NAME, 'PG신용카드') AS [PAY_SUB_NAME],
					@PAY_AGT_CODE AS [AGT_CODE], HRP.PAY_USER AS [PAY_NAME], HRP.PAY_DATE,
					HRP.PAY_TOTAL_AMOUNT AS [PAY_PRICE], @COM_RATE AS [COM_RATE], (HRP.PAY_TOTAL_AMOUNT / 100 * @COM_RATE) AS [COM_PRICE],
					ISNULL(CONVERT(INT, TTP.P_PRTC_CODE), 0) AS [INSTALLMENT], 
					(@RES_CODE + '/' + CONVERT(VARCHAR(3), HRP.PAY_NO)) AS [ADMIN_REMARK],
					@CUS_NO AS [CUS_NO], @NEW_CODE AS [NEW_CODE], GETDATE() AS [NEW_DATE],
					damo.dbo.enc_varchar('DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM', HRP.CARD_NUM) AS [SEC_PAY_NUM],
					damo.dbo.pred_meta_plain_v(HRP.CARD_NUM, 'DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM') AS [SEC1_PAY_NUM]
				FROM JGHOTEL.DBO.HTL_RESV_PAY HRP
				LEFT JOIN JGHOTEL.DBO.TBL_TRAN_PAY_INI TTP ON HRP.RESV_NO = TTP.RESV_NO AND HRP.TRAN_NO = TTP.P_TID
				LEFT JOIN Diablo.dbo.RES_HTL_PAY_LOG RHP ON HRP.RESV_NO = RHP.RESV_NO AND HRP.PAY_NO = RHP.PAY_NO
				WHERE HRP.RESV_NO = @RESV_NO AND HRP.PAY_TYPE = 'CARD' AND RHP.RESV_NO IS NULL;
				
				------------------------------------------------------------------------
				-- PAY_MATCHING 등록 RES_HTL_PAY_LOG에 등록되지 않은 카드 건만 등록
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
							@RES_CODE AS [RES_CODE], ROW_NUMBER() OVER (ORDER BY HRP.PAY_NO) AS [ROWNUM], 
							3 AS [PAY_TYPE],
							damo.dbo.pred_meta_plain_v(HRP.CARD_NUM, 'DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM') AS [SEC1_PAY_NUM],
							(@RES_CODE + '/' + CONVERT(VARCHAR(3), HRP.PAY_NO)) AS [CHECK_REMARK]
						FROM JGHOTEL.DBO.HTL_RESV_PAY HRP
						LEFT JOIN Diablo.dbo.RES_HTL_PAY_LOG RHP ON HRP.RESV_NO = RHP.RESV_NO AND HRP.PAY_NO = RHP.PAY_NO
						WHERE HRP.RESV_NO = @RESV_NO AND HRP.PAY_TYPE = 'CARD' AND RHP.RESV_NO IS NULL
					) A
					INNER JOIN PAY_MASTER_damo PM
						ON A.SEC1_PAY_NUM = PM.sec1_PAY_NUM AND A.CHECK_REMARK = PM.ADMIN_REMARK AND A.PAY_TYPE = PM.PAY_TYPE AND PM.NEW_DATE >= CONVERT(DATE, GETDATE() - 1)
							AND PM.CXL_YN = 'N'
					INNER JOIN RES_MASTER_damo RM ON A.RES_CODE = RM.RES_CODE
				) A;
				
				------------------------------------------------------------------------
				-- 입금처리 로그 등록
				------------------------------------------------------------------------
				INSERT INTO Diablo.dbo.RES_HTL_PAY_LOG (RESV_NO, PAY_NO, PAY_DATE)
				SELECT HRP.RESV_NO, HRP.PAY_NO, GETDATE()
				FROM JGHOTEL.DBO.HTL_RESV_PAY HRP
				LEFT JOIN Diablo.dbo.RES_HTL_PAY_LOG RHP ON HRP.RESV_NO = RHP.RESV_NO AND HRP.PAY_NO = RHP.PAY_NO
				WHERE HRP.RESV_NO = @RESV_NO AND HRP.PAY_TYPE = 'CARD' AND RHP.RESV_NO IS NULL;
				
				--SELECT * FROM JGHOTEL.DBO.HTL_RESV_PAY HRP WHERE HRP.RESV_NO = 14625
				--SELECT RESV_NO, CONVERT(INT, P_PRTC_CODE), * FROM JGHOTEL.DBO.TBL_TRAN_PAY_INI WHERE P_SEQ = 50760
				
				------------------------------------------------------------------------
				-- 결제 상태에 따라 예약상태 업데이트
				------------------------------------------------------------------------
				DECLARE @PAY_PRICE DECIMAL = DBO.FN_RES_GET_PAY_PRICE(@RES_CODE);
			
				IF (@PAY_PRICE > 0)
				BEGIN
					UPDATE RES_MASTER_damo SET RES_STATE = (CASE WHEN (DBO.FN_RES_GET_TOTAL_PRICE(RES_CODE) - @PAY_PRICE) = 0 THEN 4 ELSE 3 END)
					WHERE RES_CODE = @RES_CODE AND RES_STATE < 5
				END
				
			END
		
		--IF @@TRANCOUNT > 0
			COMMIT TRAN
    
    END TRY
	BEGIN CATCH
	
		SELECT @RESULT_CODE = -1, @MESSAGE = ERROR_MESSAGE(), @RES_CODE = NULL;
	
		--IF @@TRANCOUNT > 0
			ROLLBACK TRAN
		
	END CATCH
	
	------------------------------------------------------------------------
	-- 실행로그 
	------------------------------------------------------------------------
	--IF @RESV_NO > 0
	--BEGIN
		INSERT INTO dbo.RES_HTL_LINK_LOG (RESV_NO, RES_CODE, SYNC_TYPE, IN_DATE, OUT_DATE, AUTO_YN)
		VALUES (@RESV_NO, @RES_CODE, @SYNC_TYPE, @IN_DATE, GETDATE(), @AUTO_YN);
	--END
	--UPDATE dbo.RES_HTL_LINK_LOG SET SYNC_TYPE = @SYNC_TYPE, OUT_DATE = GETDATE() WHERE LINK_NO = @LINK_NO;
	
	------------------------------------------------------------------------
	-- 결과리턴
	------------------------------------------------------------------------
	SELECT @RESULT_CODE AS [CODE], @MESSAGE AS [MESSAGE], @RES_CODE AS [RES_CODE], CONVERT(VARCHAR(50), @CUS_NO) AS [CUS_NO]
	       
END
		   
GO
