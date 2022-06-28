USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_EMPLOYEE_BIZTRIP_LIST_SELECT
■ DESCRIPTION				: BTMS 거래처 직원 예약현황 리스트
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처 코드
	@EMP_CODE				: 직원 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC XP_COM_EMPLOYEE_BIZTRIP_LIST_SELECT '93881', '104';
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-07-18		이유라			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_EMPLOYEE_BIZTRIP_LIST_SELECT]
	@AGT_CODE		VARCHAR(10),
	@EMP_CODE		INT
AS 
BEGIN
	
	DECLARE @CUS_NO INT;
	SET @CUS_NO = (SELECT TOP 1 CUS_NO FROM COM_EMPLOYEE_MATCHING WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ = @EMP_CODE );

	SELECT 
		A.RES_STATE, --진행상태  ReserveStateEnum
		(CASE
			WHEN A.PRO_TYPE = 2 THEN '항공'
			WHEN A.PRO_TYPE = 3 THEN '호텔'
			WHEN A.PRO_TYPE = 1 AND B.PRO_DETAIL_TYPE = 4 THEN '렌트카'
			WHEN A.PRO_TYPE = 1 AND B.PRO_DETAIL_TYPE = 5 THEN '비자'
			WHEN A.PRO_TYPE = 1 AND B.PRO_DETAIL_TYPE = 9 THEN '기타' END) AS [PRO_TYPE_NAME],
		A.RES_CODE, --예약코드
		C.BT_CODE, --BT코드
		A.NEW_DATE, --예약일
		A.PRO_NAME, --상품명
		A.LAST_PAY_DATE, --입금마감일
		A.DEP_DATE, --출발일
		DBO.FN_RES_GET_RES_COUNT(A.RES_CODE) AS RES_COUNT, --예약인원
		DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) AS TOTAL_PRICE, --결제할금액
		DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE) AS PAY_PRICE --결제한금액
	FROM RES_MASTER_damo A WITH(NOLOCK)
	INNER JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
	INNER JOIN COM_BIZTRIP_MASTER C WITH(NOLOCK) ON B.AGT_CODE = C.AGT_CODE AND B.BT_CODE = C.BT_CODE
	WHERE A.CUS_NO = @CUS_NO
	ORDER BY A.NEW_DATE DESC

	SELECT 
		A.RES_STATE, --진행상태  ReserveStateEnum
		(CASE
			WHEN A.PRO_TYPE = 2 THEN '항공'
			WHEN A.PRO_TYPE = 3 THEN '호텔'
			WHEN A.PRO_TYPE = 1 AND B.PRO_DETAIL_TYPE = 4 THEN '렌트카'
			WHEN A.PRO_TYPE = 1 AND B.PRO_DETAIL_TYPE = 5 THEN '비자'
			WHEN A.PRO_TYPE = 1 AND B.PRO_DETAIL_TYPE = 9 THEN '기타' END) AS [PRO_TYPE_NAME],
		A.RES_CODE, --예약코드
		C.BT_CODE, --BT코드
		A.NEW_DATE, --예약일
		A.PRO_NAME, --상품명
		A.LAST_PAY_DATE, --입금마감일
		A.DEP_DATE, --출발일
		DBO.FN_RES_GET_RES_COUNT(A.RES_CODE) AS RES_COUNT, --예약인원
		DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) AS TOTAL_PRICE, --결제할금액
		DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE) AS PAY_PRICE --결제한금액
	FROM RES_MASTER_damo A WITH(NOLOCK)
	INNER JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
	INNER JOIN COM_BIZTRIP_MASTER C WITH(NOLOCK) ON B.AGT_CODE = C.AGT_CODE AND B.BT_CODE = C.BT_CODE
	INNER JOIN RES_CUSTOMER_damo D WITH(NOLOCK) ON D.RES_CODE = A.RES_CODE
	WHERE D.CUS_NO = @CUS_NO 
	ORDER BY A.NEW_DATE DESC

END 

GO
