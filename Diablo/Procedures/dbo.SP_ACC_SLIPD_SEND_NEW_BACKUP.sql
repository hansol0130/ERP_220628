USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_ACC_SLIPD_SEND_NEW
■ DESCRIPTION				: 입금전표 더존 전송
■ INPUT PARAMETER			: 
	@SLIP_MK_DAY			: 전표일자
	@SLIP_MK_SEQ			: 전표번호
	@DEL_YN					: 전표전송시 N, 전표취소시 Y
	@EMP_NO					: 사번 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2010-06-21		김성호			최초생성
	2012-06-21		김성호			SP 분리 작업
	2015-04-30		김성호			관리항목 한국정보통신계정(M70) 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_ACC_SLIPD_SEND_NEW_BACKUP]
	@SLIP_MK_DAY CHAR(8),		-- 전표일자
	@SLIP_MK_SEQ SMALLINT,		-- 전표번호
	@DEL_YN      CHAR(1),		-- 전표전송시 N, 전표취소시 Y
	@EMP_NO      VARCHAR(10)	-- 사번
AS

BEGIN
	-- FI_ADOCU 테이블 입력 값
	DECLARE	@ROW_ID		nvarchar(40),
			@ROW_NO		nvarchar(40),
			@NO_TAX		nvarchar(20),
			@CD_PC		nvarchar(7),
			@CD_WDEPT	nvarchar(12),
			@NO_DOCU	nvarchar(20),
			@NO_DOLINE	numeric (5,0),
			@CD_COMPANY	nvarchar (7),
			@ID_WRITE	nvarchar (20),
			@CD_DOCU	nvarchar (10),
			@DT_ACCT	nvarchar (8),
			@ST_DOCU	nvarchar (3),
			@TP_DRCR	nvarchar (3),
			@CD_ACCT	nvarchar (20),
			@AMT		numeric (19,4),
			@CD_PARTNER	nvarchar (20),
			@NM_PARTNER	nvarchar (50),
			@TP_JOB		nvarchar (40),
			@CLS_JOB	nvarchar (40),
			@ADS_HD		nvarchar (200),
			@NM_CEO		nvarchar (40),
			@DT_START	nvarchar (8),
			@DT_END		nvarchar (8),
			@AM_TAXSTD	numeric (19,4),
			@AM_ADDTAX	numeric (19,4),
			@TP_TAX		nvarchar (10),
			@NO_COMPANY	nvarchar (20),
			@DTS_INSERT	nvarchar (20),
			@ID_INSERT	nvarchar (20),
			@DTS_UPDATE	nvarchar (20),
			@ID_UPDATE	nvarchar (20),
			@NM_NOTE	nvarchar (100),
			@CD_BIZAREA	nvarchar (12),
			@CD_DEPT	nvarchar (12),
			@CD_CC		nvarchar (12),
			@CD_PJT		nvarchar (20),
			@CD_FUND	nvarchar (20),
			@CD_BUDGET	nvarchar (20),
			@NO_CASH	nvarchar (20),
			@ST_MUTUAL	nvarchar (3),
			@CD_CARD	nvarchar (20),
			@NO_DEPOSIT	nvarchar (20),
			@CD_BANK	nvarchar (20),
			@UCD_MNG1	nvarchar (20),
			@UCD_MNG2	nvarchar (20),
			@UCD_MNG3	nvarchar (20),
			@UCD_MNG4	nvarchar (20),
			@UCD_MNG5	nvarchar (20),
			@CD_EMPLOY	nvarchar (20),
			@CD_MNG		nvarchar (20),
			@NO_BDOCU	nvarchar (20),
			@NO_BDOLINE	numeric (4,0),
			@TP_DOCU	nvarchar (3),
			@NO_ACCT	numeric (5,0),
			@TP_TRADE	nvarchar (10),
			@CD_EXCH	nvarchar (10),
			@RT_EXCH	numeric (10,4),
			@AM_EX		numeric (19,4),
			@NO_TO		nvarchar (20),
			@DT_SHIPPING	varchar (8),
			@TP_GUBUN	nvarchar (3),
			@NO_INVOICE	nvarchar (20),
			@NO_ITEM	nvarchar (20),
			@MD_TAX1	nchar (4),
			@NM_ITEM1	nvarchar (50),
			@NM_SIZE1	nvarchar (20),
			@QT_TAX1	numeric (17,4),
			@AM_PRC1	numeric (19,4),
			@AM_SUPPLY1	numeric (19,4),
			@AM_TAX1	numeric (19,4),
			@NM_NOTE1	nvarchar (20),
			@CD_BIZPLAN	nvarchar (20),
			@CD_BGACCT	nvarchar (10),
			@CD_MNGD1	nvarchar (20),
			@NM_MNGD1	nvarchar (100),
			@CD_MNGD2	nvarchar (20),
			@NM_MNGD2	nvarchar (100),
			@CD_MNGD3	nvarchar (20),
			@NM_MNGD3	nvarchar (100),
			@CD_MNGD4	nvarchar (20),
			@NM_MNGD4	nvarchar (100),
			@CD_MNGD5	nvarchar (20),
			@NM_MNGD5	nvarchar (100),
			@CD_MNGD6	nvarchar (20),
			@NM_MNGD6	nvarchar (100),
			@CD_MNGD7	nvarchar (20),
			@NM_MNGD7	nvarchar (100),
			@CD_MNGD8	nvarchar (20),
			@NM_MNGD8	nvarchar (100),
			@YN_ISS		nchar (1),
			@TP_BILL	nvarchar (1),
			@FINAL_STATUS	varchar (2),
			@NO_BILL	nvarchar (20),
			@TP_RECORD	nvarchar (1),
			@TP_ETCACCT	nchar (1),
			@SELL_DAM_NM	nvarchar (30),
			@SELL_DAM_EMAIL	nvarchar (50),
			@SELL_DAM_MOBIL	nvarchar (20),
			@ST_GWARE	nvarchar(3),
			@NM_PUMM	nvarchar(100),
			@JEONJASEND15_YN	char(1),
			@DT_WRITE	varchar(2)


	/*** DEFAULT 설정 ↓ ***/
	
	SELECT	@ROW_ID = ('AD' + @SLIP_MK_DAY + RIGHT(('0000' + CONVERT(VARCHAR(5), @SLIP_MK_SEQ)), 5)),
			@NO_TAX = '*',						-- 부가세번호 ex) 부가세계정이 아닌경우 '*'
			@CD_PC = '1000',					-- 회계단위 (DZDB.NEOE.NEOE.MA_PC 테이블에 정의)
			@NO_DOCU = ('AD' + @SLIP_MK_DAY + RIGHT(('0000' + CONVERT(VARCHAR(5), @SLIP_MK_SEQ)), 5)),
			@CD_COMPANY = '3000',				-- 회사코드 3000 고정
			@CD_DOCU = '24',					-- 자료원천구분 ex) 24 해외매출
			@DT_ACCT = @SLIP_MK_DAY,			-- 회계일자
			@ST_DOCU = '1',						-- 승인여부 ex) '1' 미결, '2' 승인
			@TP_DOCU = 'N',						-- 전표처리결과 ex) 'N' 미처리, 'Y' 처리
			@CD_BIZAREA = '1000',				-- 귀속사업장
			@NO_ACCT = '0'						-- 회계승인번호 ex) '0'
	
	/*** DEFAULT 설정 ↑ ***/
	
			
	/*** 미결 전표 삭제 ↓ ***/
	
	DECLARE @SLIP_STATE VARCHAR(1),				-- 승인 여부 체크
			@SLIP_CNT INT						-- 전표 세부 항목 수
	
	SELECT	@SLIP_STATE = MAX(TP_DOCU),			-- 전표 상태 'N' 미처리, 'Y' 처리
			@SLIP_CNT = COUNT(*)				-- 존재유무
	FROM	DZDB.NEOE.NEOE.FI_ADOCU
	WHERE	ROW_ID = @ROW_ID					-- 처리일자
			AND CD_COMPANY = @CD_COMPANY

	IF @SLIP_STATE = 'Y'						-- 전표처리가 되면 삭제할 수 없음
		RETURN -9
		
	-- 전송된 전표가 있으면 삭제
	IF @SLIP_CNT > 0           
	BEGIN
		DELETE
		FROM	DZDB.NEOE.NEOE.FI_ADOCU
		WHERE	ROW_ID = @ROW_ID
				AND CD_COMPANY = @CD_COMPANY
	END
	
	-- 더존 전표전송일자 삭제
	UPDATE ACC_SLIPM
	   SET DZ_SEND_DT = NULL
	 WHERE SLIP_MK_DAY = @SLIP_MK_DAY
	   AND SLIP_MK_SEQ = @SLIP_MK_SEQ
	
	-- 전표전송 취소일 경유는 여기에서 리턴
	IF @DEL_YN = 'Y'
		RETURN 0
		
	/*** 미결 전표 삭제 ↑ ***/
	
	-- ***
	DECLARE	@JUNL_FG VARCHAR(2),				-- 분개계정코드	
			@DEB_AMT NUMERIC(12, 0),			-- 차변
			@CRE_AMT NUMERIC(12, 0),			-- 대변
			@SITE_CD VARCHAR(20),				-- 자사 거래처 코드
			@DEPT_CD VARCHAR(10),				-- 자사 부서코드
			@PRO_CODE VARCHAR(20),				-- 행사코드
			@SAVE_ACC_NO VARCHAR(20),			-- 계좌번호
			@INS_DT VARCHAR(8),					-- 입력일
			@REMARK VARCHAR(200),				-- 비고
			@AGT_REGISTER VARCHAR(20),			-- 사업자등록번호
			@FG_NM1 VARCHAR(40),
			@FG_NM2 VARCHAR(40),
			@FG_NM3 VARCHAR(40)

	DECLARE CUR_1 SCROLL CURSOR FOR

		SELECT	A.JUNL_FG,
				A.SLIP_FG,						-- 전표구분(1.입금 2.출금 3.대체)
				B.DC_FG ,
				ISNULL(B.DEB_AMT_W, 0),
				ISNULL(B.CRE_AMT_W, 0),
				CASE B.DC_FG WHEN '1' THEN B.DEB_AMT_W ELSE B.CRE_AMT_W END ,
				B.USE_ACC_CD,					-- 계정과목
				B.SITE_CD,						-- 거래처코드
				B.DEPT_CD,						-- 부서코드
				B.EMP_NO,
				RTRIM(B.PRO_CODE),
				B.SAVE_ACC_NO,
				B.SLIP_DET_SEQ,					-- 같은 전표일자, 전표번호의 각각의 순번
				CONVERT(VARCHAR(8), B.INS_DT, 112),
				B.INS_EMP_NO,
				ISNULL(B.REMARK,''),
				B.FG_NM1,
				B.FG_NM2,
				B.FG_NM3
		FROM	ACC_SLIPM A
	INNER JOIN	ACC_SLIPD B ON A.SLIP_MK_DAY = B.SLIP_MK_DAY AND A.SLIP_MK_SEQ = B.SLIP_MK_SEQ
	INNER JOIN	ACC_ACCOUNT C ON B.USE_ACC_CD = C.USE_ACC_CD
		WHERE	A.SLIP_MK_DAY = @SLIP_MK_DAY AND A.SLIP_MK_SEQ = @SLIP_MK_SEQ
		ORDER BY A.SLIP_MK_DAY,
				A.SLIP_MK_SEQ,
				B.SLIP_DET_SEQ

	OPEN CUR_1

	FETCH NEXT FROM CUR_1 INTO
			@JUNL_FG,							-- 분개계정코드	
			@TP_GUBUN,							-- 전표구분(1.입금 2.출금 3.대체)
			@TP_DRCR,							-- 차대구분
			@DEB_AMT,							-- 차변
			@CRE_AMT,							-- 대변
			@AMT,								-- 금액
			@CD_ACCT,							-- 계정과목
			@SITE_CD,							-- 거래처코드
			@DEPT_CD,							-- 부서코드
			@EMP_NO,							-- 사원코드
			@PRO_CODE,							-- 행사코드
			@SAVE_ACC_NO,						-- 계좌번호       
			@NO_DOLINE,							-- 전표 세부 순번
			@INS_DT,							-- 등록일자
			@ID_WRITE,							-- 작성자코드
			@REMARK,							-- 전표명
			@FG_NM1,
			@FG_NM2,
			@FG_NM3

	-- FETCH 문이 실패했거나 행이 결과 집합의 범위를 벗어나이 않으면..
	WHILE ( @@FETCH_STATUS <> -1 )
	BEGIN
		-- 거래처 등록번호
		SELECT @AGT_REGISTER = AGT_REGISTER FROM AGT_MASTER WHERE AGT_CODE = @SITE_CD
		
		-- ※ @CHECK_CODES와 @CHECK_CODE 주의

		DECLARE @CD_RELATION VARCHAR(3),			-- 연동항목
				@CHECK_CODES VARCHAR(100),			-- 관리항목 묶음
				@SERIAL_NO INT,						-- 관리항목 순서
				@CHECK_CODE VARCHAR(10)				-- 관리항목 코드 EX) 관리항목코드(3자리) + 체크항목(1자리)
		
		-- 계정별 관리항목코드
		SELECT	@CD_RELATION = CD_RELATION,
				@CHECK_CODES = (ISNULL(CD_MNG1, '') + '|' + 
								ISNULL(CD_MNG2, '') + '|' + 
								ISNULL(CD_MNG3, '') + '|' + 
								ISNULL(CD_MNG4, '') + '|' + 
								ISNULL(CD_MNG5, '') + '|' + 
								ISNULL(CD_MNG6, '') + '|' + 
								ISNULL(CD_MNG7, '') + '|' + 
								ISNULL(CD_MNG8, ''))
		FROM DZDB.NEOE.NEOE.FI_ACCTCODE WHERE CD_COMPANY = @CD_COMPANY AND CD_ACCT = @CD_ACCT
		
		-- 타시스템라인번호
		SET @ROW_NO = @NO_DOLINE
		
		-- 부가세번호
		-- '13500' - 선급부가세 (30 부가세대급금), '25500' - 예수부가세 (31 부가세예수금)
		IF (@CD_ACCT = '13500' AND @CD_RELATION = 30) OR (@CD_ACCT = '25500' AND @CD_RELATION = 31)
			SELECT	@NO_TAX = @ROW_ID + @ROW_NO
		ELSE
			SET		@NO_TAX = '*'
			
		-- 작성부서
		SELECT	@CD_WDEPT = ISNULL((
			SELECT	TOP 1 CD_DEPT
			FROM	DZDB.NEOE.NEOE.MA_EMP
			WHERE	CD_COMPANY = @CD_COMPANY
					AND NO_EMP = @ID_WRITE
			ORDER BY NO_EMP DESC
			), '5120')								-- '5120' 재무회계팀
			
		-- 거래처코드
		IF CHARINDEX('A06', @CHECK_CODES) > 0
		BEGIN
			IF @CD_ACCT = '12002'							/* 관광상품권 */
			BEGIN
				SELECT	@CD_PARTNER = '100189',
						@NM_PARTNER = '코리아트래블즈(관광상품권)'
			END
			ELSE IF @CD_ACCT IN ('12300', '27400')				/* 카드미수금, 상품권예수금 */
			BEGIN
				SELECT	@CD_PARTNER = DZ_CODE,		-- 더존	거래처코드
						@NM_PARTNER = DZ_NAME		-- 더존 거래처명
				FROM	ACC_CODE
				WHERE	CD_FG = 'CARD'
						AND CD = @SITE_CD			-- 카드거래처코드
			END
			ELSE IF @CD_ACCT = '25300' AND @JUNL_FG = 'G1'	/* 미지급금(여행) - 일반지결 */
			BEGIN
				SELECT	@CD_PARTNER = '200200',
						@NM_PARTNER = '미확인거래처(회계)'
			END
			ELSE IF @CD_ACCT = '25500'						/* 예수부가세 */
			BEGIN
				SELECT	@CD_PARTNER = '139230',
						@NM_PARTNER = '(정산)예수부가세가상'
			END
			ELSE IF @CD_ACCT = '25900'						/* 선수금 */
			BEGIN
				SELECT	@CD_PARTNER = '100610',
						@NM_PARTNER = '(주)신한은행'
			END
			ELSE IF @CD_ACCT = '27500' AND @JUNL_FG = 'G3'	/* 미지급금(랜드) - 공동경비지결 */
			BEGIN
				SELECT	@CD_PARTNER = '300300',
						@NM_PARTNER = '인솔경비&기타경비'
			END
			ELSE IF @CD_ACCT = '31100' AND CHARINDEX('[예약입금-포인트_구매실적]', @REMARK) > 0	/* 장기선수수익 */
			BEGIN
				SELECT	@CD_PARTNER = '102747',
						@NM_PARTNER = '포인트(구매실적)'
			END
			ELSE
			BEGIN
				SELECT	@CD_PARTNER = CD_PARTNER,		-- 더존 거래처코드
						@NM_PARTNER = LN_PARTNER		-- 더존 거래처명
				FROM	DZDB.NEOE.NEOE.MA_PARTNER
				WHERE	NO_COMPANY = @AGT_REGISTER		-- 사업자등록번호
						AND CD_COMPANY = @CD_COMPANY	-- 회사코드
			END
		END
		ELSE
		BEGIN
			SET @CD_PARTNER = NULL
			SET @NM_PARTNER = NULL
		END

		-- 발생일자
		IF CHARINDEX('B21', @CHECK_CODES) > 0
			SET @DT_START = @SLIP_MK_DAY
		ELSE
			SET @DT_START = NULL
			
		-- 자금예정일자
		--IF CHARINDEX('B22', @CHECK_CODES) > 0 OR CHARINDEX('B23', @CHECK_CODES) > 0
		--	SET @DT_END = NULL
		--ELSE
		--	SET @DT_END = NULL	
			
		-- 과세표준액
		SELECT	@AM_TAXSTD = ISNULL(DEB_AMT_W,0) + ISNULL(CRE_AMT_W,0)
		FROM	ACC_SLIPD              
		WHERE	SLIP_MK_DAY = @SLIP_MK_DAY				-- 전표일자
				AND SLIP_MK_SEQ = @SLIP_MK_SEQ			-- 전표번호
				AND SLIP_DET_SEQ = (@NO_DOLINE - 1 )
				
		-- 세액
		SELECT	@AM_ADDTAX = CASE WHEN @CD_ACCT = '13500' THEN  @DEB_AMT ELSE @CRE_AMT END
		
		-- 세무구분, 사업자등록번호
		SET @NO_COMPANY = NULL
		IF CHARINDEX('C14', @CHECK_CODES) > 0
		BEGIN
			SELECT	@TP_TAX = CASE WHEN @CD_ACCT = '13500' THEN  '21' ELSE '13' END
			
			IF @TP_TAX = '13'
				SET	@NO_COMPANY = '8888888888'
		END
		IF CHARINDEX('C01', @CHECK_CODES) > 0
			SET @NO_COMPANY = @AGT_REGISTER

		-- 귀속사업장
		IF CHARINDEX('A01', @CHECK_CODES) > 0
		BEGIN
			IF @JUNL_FG = 'EV'
			BEGIN
				-- 부산상품이면
				IF EXISTS(
					SELECT 1 
					FROM PKG_DETAIL 
					WHERE PRO_CODE = @PRO_CODE AND NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER_damo WHERE TEAM_CODE = 514))
				BEGIN
					SET	@CD_BIZAREA = '3000'
				END
				ELSE
				BEGIN
					SET	@CD_BIZAREA = '2000'
				END
			END
			ELSE
			BEGIN
				SET	@CD_BIZAREA = '1000'
			END
		END
		
		-- 부서
		IF CHARINDEX('A03', @CHECK_CODES) > 0
		BEGIN
			SELECT	@CD_DEPT = DZ_CODE
			FROM	ACC_CODE
			WHERE	CD_FG = 'DEPI'
					AND CD = @DEPT_CD
		
			--SELECT	TOP 1 @CD_DEPT = CD_DEPT
			--FROM	DZDB.NEOE.NEOE.MA_EMP
			--WHERE	CD_COMPANY = @CD_COMPANY
			--		AND NO_EMP IN (SELECT NEW_CODE FROM PKG_DETAIL WHERE PRO_CODE = @PRO_CODE)
			--ORDER BY NO_EMP DESC
		END
		ELSE
			SET @CD_DEPT = NULL
			
		-- 코스트센터 - 계정코드가 A02 일때 입력
		--IF CHARINDEX('A02', @CHECK_CODES) > 0
		--	SET @CD_CC = '1000'
		--ELSE
		--	SET @CD_CC = NULL
			
		-- 프로젝트코드 - 계정코드가 A05 일때 입력
		IF CHARINDEX('A05', @CHECK_CODES) > 0
		BEGIN
			SELECT	@CD_PJT = DUZ_CODE    
			FROM	ACC_MATCHING    
			WHERE	PRO_CODE = @PRO_CODE 
			
			IF @CD_PJT IS NULL AND CHARINDEX('[선수금환불]', @REMARK) > 0
				SET	@CD_PJT = '200200'
		END
		ELSE
			SET @CD_PJT = NULL

		-- 자금과목코드
		--SET @CD_FUND = ''
		-- 예산단위코드
		--SET CD_BUDGET = ''
		-- 현금영수증번호 - 세무구분이 31, 37 일때 입력
		--SET NO_CASH = ''
		-- 불공제사유 - 세무구분이 22 일때 입력
		--SET ST_MUTUAL = ''
		-- 신용카드번호 - 세무구분이 24, 39 일때 입력, 계정코드가 A08 일때 입력
		--SET CD_CARD = ''
		
		-- 예적금계좌 - 계정코드가 A07 일때 입력
		IF CHARINDEX('A07', @CHECK_CODES) > 0
		BEGIN
			-- 계좌번호를 '-'가 포함된 값으로 변경
			--SELECT	@SAVE_ACC_NO = DZ_NAME
			--FROM	ACC_CODE
			--WHERE	CD_FG = 'BACC'
			--		AND CD = @SAVE_ACC_NO			-- 계좌번호
					
			SELECT	@NO_DEPOSIT = NO_DEPOSIT
			FROM	DZDB.NEOE.NEOE.FI_DEPOSIT
			WHERE	REPLACE(CD_DEPOSIT, '-', '') = @SAVE_ACC_NO		-- 계좌번호
					AND CD_COMPANY = @CD_COMPANY	-- 회사코드
		END
		ELSE
			SET @NO_DEPOSIT = NULL
			
		-- 금융기관
		IF CHARINDEX('A09', @CHECK_CODES) > 0
		BEGIN
			IF @CD_ACCT = '10300'						/* 보통예금 */
			BEGIN
				SELECT	@CD_BANK = '100610'
			END
			ELSE
			BEGIN
				SELECT	@CD_BANK = CD_PARTNER			-- 더존 거래처코드
				FROM	DZDB.NEOE.NEOE.MA_PARTNER
				WHERE	NO_COMPANY = @AGT_REGISTER		-- 사업자등록번호
						AND CD_COMPANY = @CD_COMPANY	-- 회사코드
						AND FG_PARTNER = '002'			-- 금융기관
			END
		END
		ELSE
			SET @CD_BANK = NULL
			
		-- 사용자정의1
		IF CHARINDEX('A21', @CHECK_CODES) > 0
		BEGIN
			IF @CD_ACCT = '83900'					-- 판매수수료
				SET	@UCD_MNG1 = '2901'				-- 판수-여행상품커미션 (FI_MNGD 정의)
			ELSE
				SET @UCD_MNG1 = NULL
		END
		ELSE
			SET @UCD_MNG1 = NULL

		-- 사용자정의3
		IF CHARINDEX('A23', @CHECK_CODES) > 0
		BEGIN
			IF @CD_ACCT = '93000'						-- 잡이익
				SET @UCD_MNG3 = '1'						-- 잡이익-취소수수료
			ELSE
				SET @UCD_MNG3 = NULL
		END
		ELSE
			SET @UCD_MNG3 = NULL

		-- 사원
		IF CHARINDEX('A04', @CHECK_CODES) > 0
			SELECT	TOP 1 @CD_EMPLOY = NO_EMP
			FROM	DZDB.NEOE.NEOE.MA_EMP
			WHERE	CD_COMPANY = @CD_COMPANY
					AND NO_EMP IN (SELECT NEW_CODE FROM SET_MASTER WHERE PRO_CODE = @PRO_CODE)
			ORDER BY NO_EMP DESC
			
		-- 반제처리 & 적요
		IF @CD_ACCT = '27500' AND @JUNL_FG IN ('G3', 'G4')	-- G3:공동비지결, G4:지상비지결
		BEGIN
			SELECT @NO_BDOCU = NULL, @NO_BDOLINE = 0
			-- 더존전송된 전표중에 원인전표를 찾는다.
			SELECT @NO_BDOCU = ('AD' + A.SLIP_MK_DAY + RIGHT(('0000' + CONVERT(VARCHAR(5), A.SLIP_MK_SEQ)), 5)),
				@NO_BDOLINE = B.SLIP_DET_SEQ
			FROM ACC_SLIPM A
			INNER JOIN ACC_SLIPD B ON A.SLIP_MK_DAY = B.SLIP_MK_DAY AND A.SLIP_MK_SEQ = B.SLIP_MK_SEQ
			WHERE A.JUNL_FG = 'EV' AND B.FG_NM1 = @FG_NM1 AND B.FG_NM2 = @FG_NM2 AND B.FG_NM3 = @FG_NM3 AND A.DZ_SEND_DT IS NOT NULL

			-- 실제 처리된 전표인지 체크
			IF EXISTS(SELECT 1 FROM DZDB.NEOE.NEOE.FI_ADOCU WHERE NO_DOCU = @NO_BDOCU AND NO_DOLINE = @NO_BDOLINE AND TP_DOCU = 'Y')
				SELECT @NM_NOTE = NM_NOTE FROM DZDB.NEOE.NEOE.FI_ADOCU WHERE NO_DOCU = @NO_BDOCU AND NO_DOLINE = @NO_BDOLINE
			ELSE
				SELECT @NM_NOTE = @REMARK

			--SELECT @NO_BDOCU = ('AD' + A.SLIP_MK_DAY + RIGHT(('0000' + CONVERT(VARCHAR(5), A.SLIP_MK_SEQ)), 5)),
			--	@NO_BDOLINE = B.SLIP_DET_SEQ
			--FROM ACC_SLIPM A
			--INNER JOIN ACC_SLIPD B ON A.SLIP_MK_DAY = B.SLIP_MK_DAY AND A.SLIP_MK_SEQ = B.SLIP_MK_SEQ
			--WHERE A.JUNL_FG = 'EV' AND B.FG_NM1 = @FG_NM1 AND B.FG_NM2 = @FG_NM2 AND B.FG_NM3 = @FG_NM3
			
			---- 실제 처리된 전표인지 체크
			--IF EXISTS(SELECT 1 FROM DZDB.NEOE.NEOE.FI_ADOCU WHERE NO_DOCU = @NO_BDOCU AND NO_DOLINE = @NO_BDOLINE AND TP_DOCU = 'Y')
			--	SELECT @NM_NOTE = NM_NOTE FROM DZDB.NEOE.NEOE.FI_ADOCU WHERE NO_DOCU = @NO_BDOCU AND NO_DOLINE = @NO_BDOLINE
			--ELSE
			--	SELECT @NO_BDOCU = NULL, @NO_BDOLINE = 0, @NM_NOTE = @REMARK
		END
		ELSE
		BEGIN
			SELECT @NO_BDOCU = NULL, @NO_BDOLINE = 0, @NM_NOTE = @REMARK
		END

		-- 월/일
		SELECT @MD_TAX1 = SUBSTRING(@SLIP_MK_DAY,5,4)
		-- 품명, 규격 은 NULL
		-- 수량
		SET @QT_TAX1 = 1
		-- 단가, 공급가액, 세액
		SELECT	@AM_PRC1 = @AM_TAXSTD,
				@AM_SUPPLY1 = @AM_TAXSTD,
				@AM_TAX1 = @AM_ADDTAX
		
		-- 관리항목 초기화
		SELECT	@CD_MNGD1 = NULL, @NM_MNGD1 = NULL,
				@CD_MNGD2 = NULL, @NM_MNGD2 = NULL,
				@CD_MNGD3 = NULL, @NM_MNGD3 = NULL,
				@CD_MNGD4 = NULL, @NM_MNGD4 = NULL,
				@CD_MNGD5 = NULL, @NM_MNGD5 = NULL,
				@CD_MNGD6 = NULL, @NM_MNGD6 = NULL,
				@CD_MNGD7 = NULL, @NM_MNGD7 = NULL,
				@CD_MNGD8 = NULL, @NM_MNGD8 = NULL
		
		-- 관리항목 체크
		DECLARE CUR_2 SCROLL CURSOR FOR

			SELECT ID, DATA FROM dbo.FN_SPLIT(@CHECK_CODES, '|') WHERE DATA <> ''

		OPEN CUR_2

		FETCH NEXT FROM CUR_2 INTO  @SERIAL_NO, @CHECK_CODE

		WHILE ( @@FETCH_STATUS <> -1 )
		BEGIN
			-- 관리항목 체크
			IF @CHECK_CODE <> ''-- AND (SUBSTRING(@CHECK_CODE, 1, 1)) NOT IN ('A', 'B')
			BEGIN
				IF @SERIAL_NO = 1
				BEGIN
					SELECT	@CD_MNGD1 = CASE YN_CDMNG WHEN 'Y' THEN @CHECK_CODE ELSE NULL END
					FROM	DZDB.NEOE.NEOE.FI_MNG
					WHERE	CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
					SELECT	@NM_MNGD1 = NM_MNG FROM DZDB.NEOE.NEOE.FI_MNG WHERE CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
				END
				ELSE IF @SERIAL_NO = 2
				BEGIN
					SELECT	@CD_MNGD2 = CASE YN_CDMNG WHEN 'Y' THEN @CHECK_CODE ELSE NULL END
					FROM	DZDB.NEOE.NEOE.FI_MNG
					WHERE	CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
					SELECT	@NM_MNGD2 = NM_MNG FROM DZDB.NEOE.NEOE.FI_MNG WHERE CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
				END
				ELSE IF @SERIAL_NO = 3
				BEGIN
					SELECT	@CD_MNGD3 = CASE YN_CDMNG WHEN 'Y' THEN @CHECK_CODE ELSE NULL END
					FROM	DZDB.NEOE.NEOE.FI_MNG
					WHERE	CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
					SELECT	@NM_MNGD3 = NM_MNG FROM DZDB.NEOE.NEOE.FI_MNG WHERE CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
				END
				ELSE IF @SERIAL_NO = 4
				BEGIN
					SELECT	@CD_MNGD4 = CASE YN_CDMNG WHEN 'Y' THEN @CHECK_CODE ELSE NULL END
					FROM	DZDB.NEOE.NEOE.FI_MNG
					WHERE	CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
					SELECT	@NM_MNGD4 = NM_MNG FROM DZDB.NEOE.NEOE.FI_MNG WHERE CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
				END
				ELSE IF @SERIAL_NO = 5
				BEGIN
					SELECT	@CD_MNGD5 = CASE YN_CDMNG WHEN 'Y' THEN @CHECK_CODE ELSE NULL END
					FROM	DZDB.NEOE.NEOE.FI_MNG
					WHERE	CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
					SELECT	@NM_MNGD5 = NM_MNG FROM DZDB.NEOE.NEOE.FI_MNG WHERE CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
				END
				ELSE IF @SERIAL_NO = 6
				BEGIN
					SELECT	@CD_MNGD6 = CASE YN_CDMNG WHEN 'Y' THEN @CHECK_CODE ELSE NULL END
					FROM	DZDB.NEOE.NEOE.FI_MNG
					WHERE	CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
					SELECT	@NM_MNGD6 = NM_MNG FROM DZDB.NEOE.NEOE.FI_MNG WHERE CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
				END
				ELSE IF @SERIAL_NO = 7
				BEGIN
					SELECT	@CD_MNGD7 = CASE YN_CDMNG WHEN 'Y' THEN @CHECK_CODE ELSE NULL END
					FROM	DZDB.NEOE.NEOE.FI_MNG
					WHERE	CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
					SELECT	@NM_MNGD7 = NM_MNG FROM DZDB.NEOE.NEOE.FI_MNG WHERE CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
				END
				ELSE IF @SERIAL_NO = 8
				BEGIN
					SELECT	@CD_MNGD8 = CASE YN_CDMNG WHEN 'Y' THEN @CHECK_CODE ELSE NULL END
					FROM	DZDB.NEOE.NEOE.FI_MNG
					WHERE	CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
					SELECT	@NM_MNGD8 = NM_MNG FROM DZDB.NEOE.NEOE.FI_MNG WHERE CD_COMPANY = '3000' AND CD_MNG = @CHECK_CODE
				END
				
			END
			
			FETCH NEXT FROM CUR_2 INTO  @SERIAL_NO, @CHECK_CODE
		END
		
		CLOSE      CUR_2
		DEALLOCATE CUR_2
		
		
		INSERT INTO	DZDB.NEOE.NEOE.FI_ADOCU
			(	ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT, NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, 
				CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, CD_PARTNER, NM_PARTNER, TP_JOB, 
				CLS_JOB, ADS_HD, NM_CEO, DT_START, DT_END, AM_TAXSTD, AM_ADDTAX, TP_TAX, NO_COMPANY, 
				NM_NOTE, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_FUND, CD_BUDGET, NO_CASH, ST_MUTUAL, 
				CD_CARD, NO_DEPOSIT, CD_BANK, UCD_MNG1, UCD_MNG2, UCD_MNG3, UCD_MNG4, UCD_MNG5, 
				CD_EMPLOY, CD_MNG, NO_BDOCU, NO_BDOLINE, TP_DOCU, NO_ACCT, TP_TRADE, AM_EX, NO_TO, 
				DT_SHIPPING, TP_GUBUN, NO_INVOICE, NO_ITEM, MD_TAX1, NM_ITEM1, NM_SIZE1, QT_TAX1, 
				AM_PRC1, AM_SUPPLY1, AM_TAX1, NM_NOTE1, CD_BIZPLAN, CD_BGACCT, CD_MNGD1, NM_MNGD1, 
				CD_MNGD2, NM_MNGD2, CD_MNGD3, NM_MNGD3, CD_MNGD4, NM_MNGD4, CD_MNGD5, NM_MNGD5, 
				CD_MNGD6, NM_MNGD6, CD_MNGD7, NM_MNGD7, CD_MNGD8, NM_MNGD8, YN_ISS, FINAL_STATUS, 
				NO_BILL, TP_BILL, TP_RECORD, TP_ETCACCT, ST_GWARE, SELL_DAM_NM, SELL_DAM_EMAIL, 
				SELL_DAM_MOBIL, NM_PUMM, JEONJASEND15_YN, DT_WRITE )  
		VALUES
			(	@ROW_ID, @ROW_NO, @NO_TAX, @CD_PC, @CD_WDEPT, @NO_DOCU, @NO_DOLINE, @CD_COMPANY, @ID_WRITE, 
				@CD_DOCU, @DT_ACCT, @ST_DOCU, @TP_DRCR, @CD_ACCT, @AMT, @CD_PARTNER, @NM_PARTNER, @TP_JOB, 
				@CLS_JOB, @ADS_HD, @NM_CEO, @DT_START, @DT_END, @AM_TAXSTD, @AM_ADDTAX, @TP_TAX, @NO_COMPANY, 
				@NM_NOTE, @CD_BIZAREA, @CD_DEPT, @CD_CC, @CD_PJT, @CD_FUND, @CD_BUDGET, @NO_CASH, @ST_MUTUAL, 
				@CD_CARD, @NO_DEPOSIT, @CD_BANK, @UCD_MNG1, @UCD_MNG2, @UCD_MNG3, @UCD_MNG4, @UCD_MNG5, 
				@CD_EMPLOY, @CD_MNG, @NO_BDOCU, @NO_BDOLINE, @TP_DOCU, @NO_ACCT, @TP_TRADE, @AM_EX, @NO_TO, 
				@DT_SHIPPING, @TP_GUBUN, @NO_INVOICE, @NO_ITEM, @MD_TAX1, @NM_ITEM1, @NM_SIZE1, @QT_TAX1, 
				@AM_PRC1, @AM_SUPPLY1, @AM_TAX1, @NM_NOTE1, @CD_BIZPLAN, @CD_BGACCT, @CD_MNGD1, @NM_MNGD1, 
				@CD_MNGD2, @NM_MNGD2, @CD_MNGD3, @NM_MNGD3, @CD_MNGD4, @NM_MNGD4, @CD_MNGD5, @NM_MNGD5, 
				@CD_MNGD6, @NM_MNGD6, @CD_MNGD7, @NM_MNGD7, @CD_MNGD8, @NM_MNGD8, @YN_ISS, @FINAL_STATUS, 
				@NO_BILL, @TP_BILL, @TP_RECORD, @TP_ETCACCT, @ST_GWARE, @SELL_DAM_NM, @SELL_DAM_EMAIL, 
				@SELL_DAM_MOBIL, @NM_PUMM, @JEONJASEND15_YN, @DT_WRITE )
		
		
		FETCH NEXT FROM CUR_1 INTO
				@JUNL_FG,				-- 분개계정코드	
				@TP_GUBUN,				-- 전표구분(1.입금 2.출금 3.대체)
				@TP_DRCR,				-- 차대구분
				@DEB_AMT,				-- 차변
				@CRE_AMT,				-- 대변
				@AMT,					-- 금액
				@CD_ACCT,				-- 계정과목
				@SITE_CD,				-- 거래처코드
				@DEPT_CD,				-- 부서코드
				@EMP_NO,				-- 사원코드
				@PRO_CODE,				-- 행사코드
				@SAVE_ACC_NO,			-- 계좌번호       
				@NO_DOLINE,				-- 전표 세부 순번
				@INS_DT,				-- 등록일자
				@ID_WRITE,				-- 작성자코드
				@REMARK,				-- 전표명
				@FG_NM1,
				@FG_NM2,
				@FG_NM3
	END
		
	CLOSE      CUR_1
	DEALLOCATE CUR_1
	
	-- 전송일자 업데이트
	UPDATE	ACC_SLIPM
	SET		DZ_SEND_DT = GETDATE()
	WHERE	SLIP_MK_DAY = @SLIP_MK_DAY
			AND SLIP_MK_SEQ = @SLIP_MK_SEQ
	
	-- 프로젝트 테이블 업데이트		
	EXEC SP_ACC_SLIPD_SEND1_NEW @SLIP_MK_DAY, @SLIP_MK_SEQ
		
END

/*
SELECT * FROM DZDB.NEOE.NEOE.MA_BIZAREA

SELECT * fROM DZDB.NEOE.NEOE.MA_EMP
*/



/*

select '가나다라마바사아자차카타파하' as [FLAG], '가나다라마바사아자차카타파하' AS [CODE], GETDATE() AS [DATE]
INTO TMP_SLPD

SELECT * FROM TMP_SLPD

DELETE FROM TMP_SLPD

*/
GO
