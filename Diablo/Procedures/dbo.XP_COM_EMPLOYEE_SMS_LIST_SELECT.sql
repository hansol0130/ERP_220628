USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_EMPLOYEE_SMS_LIST_SELECT
■ DESCRIPTION				: BTMS 거래처 직원 SMS 수신 리스트
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@KEY		VARCHAR(400): 검색 키
	@ORDER_BY	INT			: 정렬 순서
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 항목 수
■ EXEC						: 
	DECLARE @TOTAL INT
	EXEC DBO.XP_COM_EMPLOYEE_SMS_LIST_SELECT 1, 10, @TOTAL OUTPUT, 'AgentCode=93881&EmpSeq=104&', 1
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-22		김성호			최초생성
   2016-04-28		정지용			예약코드 추가 및 추가된 컬럼 추가
   2016-07-19		이유라			SND_EMP_NAME 추가 (ERP용 담당자)
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_EMPLOYEE_SMS_LIST_SELECT]
	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY		VARCHAR(400),
	@ORDER_BY	INT
AS 
BEGIN

	DECLARE @AGT_CODE VARCHAR(10), @EMP_SEQ INT, @RES_CODE CHAR(12), @BT_CODE VARCHAR(20)

	SELECT
		@AGT_CODE = DBO.FN_PARAM(@KEY, 'AgentCode'),
		@EMP_SEQ = DBO.FN_PARAM(@KEY, 'EmpSeq'),
		@RES_CODE = DBO.FN_PARAM(@KEY, 'ResCode'),
		@BT_CODE = DBO.FN_PARAM(@KEY, 'BtCode')


	-- 전체 조회 갯수
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM COM_RECEIVE_SMS A WITH(NOLOCK)
	WHERE A.AGT_CODE = @AGT_CODE
		AND (
			(@EMP_SEQ <> '' AND A.EMP_SEQ = @EMP_SEQ) 
			OR (@RES_CODE <> '' AND A.RES_CODE = @RES_CODE)
			OR (@BT_CODE <> '' AND A.RES_CODE IN ( SELECT RES_CODE FROM COM_BIZTRIP_DETAIL B WHERE B.AGT_CODE = @AGT_CODE AND B.BT_CODE = @BT_CODE ))
		);

	-- 리스트 조회
	SELECT AGT_CODE, SMS_SEQ, RCV_NUMBER, EMP_SEQ, BODY, RCV_STATE, RCV_DATE, SND_NUMBER, SND_EMP_CODE, B.KOR_NAME AS SND_EMP_NAME, RCV_NAME
	FROM COM_RECEIVE_SMS A WITH(NOLOCK)
	LEFT JOIN EMP_MASTER B WITH(NOLOCK) ON A.SND_EMP_CODE = B.EMP_CODE
	WHERE A.AGT_CODE = @AGT_CODE 
		AND (
			(@EMP_SEQ <> '' AND A.EMP_SEQ = @EMP_SEQ) 
			OR (@RES_CODE <> '' AND A.RES_CODE = @RES_CODE)
			OR (@BT_CODE <> '' AND A.RES_CODE IN ( SELECT RES_CODE FROM COM_BIZTRIP_DETAIL B WHERE B.AGT_CODE = @AGT_CODE AND B.BT_CODE = @BT_CODE ))
		)
	ORDER BY A.RCV_DATE DESC
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY
END 
GO
