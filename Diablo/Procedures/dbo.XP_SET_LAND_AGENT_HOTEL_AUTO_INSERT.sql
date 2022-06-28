USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_SET_LAND_AGENT_HOTEL_AUTO_INSERT
■ DESCRIPTION				: 호텔 예약 시 정산 지상비 항목 자동 입력
■ INPUT PARAMETER			:
	@PRO_CODE				: 행사코드
	@RES_CODE				: 예약코드
	@AGT_CODE				: 거래처코드
	@TOTAL_NET_PRICE		: 원가 총액
	@COUNT					: 박 수
	@NEW_CODE				: 등록자 사번
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec DBO.XP_SET_LAND_AGENT_HOTEL_AUTO_INSERT 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-03-04		김성호			최초생성
   2015-04-01		김성호			1박당 원가가 아닌 총 원가 입력
   2015-08-26		김성호			DBO.SP_SET_PROFIT_REFRESH 실행
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_SET_LAND_AGENT_HOTEL_AUTO_INSERT]
(
	@PRO_CODE			VARCHAR(20),
	@RES_CODE			VARCHAR(20),
	@AGT_CODE			VARCHAR(10),
	@TOTAL_NET_PRICE	INT,
	@COUNT				INT,
	@NEW_CODE			CHAR(7)
)
AS
BEGIN

	BEGIN TRAN;

	BEGIN TRY

		-- 정산마스터 미등록 시 등록
		IF NOT EXISTS(SELECT 1 FROM SET_MASTER WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
		BEGIN
			INSERT INTO SET_MASTER (PRO_CODE, MASTER_CODE, PRO_TYPE, DEP_DATE, ARR_DATE, NEW_CODE, PROFIT_TEAM_CODE, PROFIT_TEAM_NAME)
			SELECT A.PRO_CODE, A.MASTER_CODE, A.PRO_TYPE, A.DEP_DATE, A.ARR_DATE, @NEW_CODE, C.TEAM_CODE, C.TEAM_NAME
			FROM PKG_DETAIL A WITH(NOLOCK)
			INNER JOIN EMP_MASTER B WITH(NOLOCK) ON A.NEW_CODE = B.EMP_CODE
			INNER JOIN EMP_TEAM C WITH(NOLOCK) ON B.TEAM_CODE = C.TEAM_CODE
			WHERE A.PRO_CODE = @PRO_CODE;
		END

		-- SET_PROFIT 생성
		--EXEC DBO.SP_SET_PROFIT_REFRESH @PRO_CODE, @NEW_CODE

		DECLARE @LAND_SEQ_NO INT
		SELECT @LAND_SEQ_NO = (ISNULL(MAX(LAND_SEQ_NO), 0) + 1) FROM SET_LAND_AGENT WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE

		-- 지상비 마스터
		INSERT INTO SET_LAND_AGENT (PRO_CODE, LAND_SEQ_NO, AGT_CODE, CUR_TYPE, PAY_PRICE, FOREIGN_PRICE, KOREAN_PRICE, EXC_RATE, RES_COUNT, REMARK, NEW_CODE)
		SELECT
			@PRO_CODE,
			@LAND_SEQ_NO,
			@AGT_CODE,
			0,								-- CUR_TYPE 0:원화
			@TOTAL_NET_PRICE,				-- PAY_PRICE = KOREAN_PRICE[FOREIGN_PRICE * EXC_RATE] * RES_COUNT
			(@TOTAL_NET_PRICE / @COUNT),	-- FOREIGN_PRICE 는 원화기준일때 KOREAN_PRICE 가격과 동일
			(@TOTAL_NET_PRICE / @COUNT),	-- 룸/1박 가격
			1.0,							-- 원화기준 환율은 무조건 1.0
			@COUNT,							-- 박수
			'인보이스첨부 -일별정산(체크인기준)',
			@NEW_CODE;

		-- 지상비 인별금액 (호텔은 1인 모든 금액 합산하여 등록)
		INSERT INTO SET_LAND_CUSTOMER (PRO_CODE, LAND_SEQ_NO, RES_CODE, RES_SEQ_NO, CUR_TYPE, PAY_PRICE, FOREIGN_PRICE, KOREAN_PRICE, EXC_RATE, NEW_CODE)
		SELECT
			@PRO_CODE,
			@LAND_SEQ_NO,
			@RES_CODE,
			1,
			0,
			@TOTAL_NET_PRICE,
			@TOTAL_NET_PRICE,
			@TOTAL_NET_PRICE,
			1.0,					-- 원화기준 환율은 무조건 1.0
			@NEW_CODE;

		IF @@TRANCOUNT > 0
			COMMIT TRAN

	END TRY
	BEGIN CATCH 

		IF @@TRANCOUNT > 0
			ROLLBACK TRAN

		-- 에러로그
		INSERT INTO VGLog.dbo.SYS_ERP_LOG(
			LOG_TYPE,
			CATEGORY,
			TITLE, 
			BODY, 
			REQUEST, 
			TRACE)
		VALUES(
			1,				-- LogTypeEnum { None = 0, Error, Warning, Information };
			'MSSQL',
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			(ISNULL(@PRO_CODE, '') + '|' + ISNULL(@RES_CODE, '') + '|' + ISNULL(CONVERT(VARCHAR(20), @AGT_CODE), '') + '|' + CONVERT(VARCHAR(20), @TOTAL_NET_PRICE) + '|' + CONVERT(VARCHAR(10), @COUNT) + '|' + ISNULL(@NEW_CODE, '')),
			ERROR_LINE());

	END CATCH

END 
GO
