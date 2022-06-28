USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*================================================================================================================
■ USP_NAME					: SP_EVT_ROULETTE_SELECT_LIST
■ DESCRIPTION				: 회원의 룰렛이벤트 적립 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
SP_EVT_ROULETTE_SELECT_LIST 4797216
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-05-22		정지용
   2014-09-02		정지용			호텔적립 추가
================================================================================================================*/ 
CREATE PROC [dbo].[SP_EVT_ROULETTE_SELECT_LIST]
	@CUS_NO INT
AS 
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH LIST AS
	(
		SELECT 
			CASE WHEN D.RES_CODE IS NULL THEN 'N' ELSE 'Y' END AS COUPON_YN, 
			RM.RES_STATE,
			RM.RES_CODE, 
			RC.SEQ_NO, 
			PD.PRO_CODE,
			PD.PRO_NAME,
			PD.DEP_DATE,
			PD.ARR_DATE,
			--((ISNULL(RC.SALE_PRICE, 0) + ISNULL(RC.CHG_PRICE, 0) + ISNULL(RC.TAX_PRICE, 0)) - ISNULL(RC.DC_PRICE, 0)) AS TOTAL_PRICE
			DBO.FN_RES_GET_TOTAL_PRICE_ONE(RM.RES_CODE, RC.SEQ_NO) AS TOTAL_PRICE
		FROM PKG_DETAIL AS PD WITH(NOLOCK)
		INNER JOIN RES_MASTER_damo AS RM WITH(NOLOCK) ON PD.PRO_CODE = RM.PRO_CODE 
		INNER JOIN RES_CUSTOMER_damo AS RC WITH(NOLOCK) ON RM.RES_CODE = RC.RES_CODE 
		INNER JOIN CUS_MEMBER AS CC WITH(NOLOCK) ON RC.CUS_NO = CC.CUS_NO
		LEFT JOIN (
			SELECT RES_CODE, CUS_CODE FROM EVT_ROULETTE WITH(NOLOCK) GROUP BY RES_CODE, CUS_CODE
		) D ON RM.RES_CODE = D.RES_CODE AND CC.CUS_NO = D.CUS_CODE
		WHERE --PD.ARR_DATE BETWEEN @START_DATE AND @END_DATE  --도착후 7일 
		RM.RES_STATE IN(3,4,5,6) -- 예약상태 결제중,결제완료,출발완료,해피콜 - 2010.07.12 결제중도 적립
		AND RC.RES_STATE IN (0) -- 출발고객상태 예약인것만
		AND PD.DEP_DATE >= '2014-06-01 00:00:00' -- 6월 1일 출발일인 사람부터
		--AND PD.DEP_DATE > CONVERT(DATETIME,DATEADD(M,-1,CONVERT(DATETIME,'2014-06-01 00:00:00')) ) -- 6월 1일 출발일인 사람부터
		AND CC.CUS_NO = @CUS_NO

		UNION ALL

		SELECT 
			CASE WHEN D.RES_CODE IS NULL THEN 'N' ELSE 'Y' END AS COUPON_YN, 
			HRM.RES_STATE,
			HRM.RES_CODE, 
			0 AS SEQ_NO, 
			HRM.PRO_CODE,
			HRM.PRO_NAME,
			HRM.DEP_DATE,
			HRM.ARR_DATE,
			DBO.FN_RES_HTL_GET_TOTAL_PRICE(HRM.RES_CODE) AS TOTAL_PRICE
		FROM RES_MASTER AS HRM WITH(NOLOCK)
		INNER JOIN CUS_MEMBER AS CC WITH(NOLOCK) ON HRM.CUS_NO = CC.CUS_NO
		LEFT JOIN (
			SELECT RES_CODE, CUS_CODE FROM EVT_ROULETTE WITH(NOLOCK) GROUP BY RES_CODE, CUS_CODE
		) D ON HRM.RES_CODE = D.RES_CODE AND CC.CUS_NO = D.CUS_CODE
		WHERE 
		HRM.PRO_TYPE = 3
		AND HRM.RES_STATE IN(3,4,5,6) -- 예약상태 결제중,결제완료,출발완료,해피콜 - 2010.07.12 결제중도 적립
		AND HRM.DEP_DATE >= '2014-06-01 00:00:00' -- 6월 1일 출발일인 사람부터
		AND CC.CUS_NO = @CUS_NO
	)
	SELECT 
		COUPON_YN, RES_STATE, RES_CODE, SEQ_NO, PRO_CODE, PRO_NAME, DEP_DATE, ARR_DATE, TOTAL_PRICE,
		CASE 
			WHEN TOTAL_PRICE >= 10000 AND TOTAL_PRICE < 1000000 THEN '1' 	  
			WHEN TOTAL_PRICE >= 1000000 AND TOTAL_PRICE < 2000000 THEN '2' 
			WHEN TOTAL_PRICE >= 2000000 AND TOTAL_PRICE < 3000000 THEN '3' 
			WHEN TOTAL_PRICE >= 3000000 AND TOTAL_PRICE < 9000000 THEN '4' 
			WHEN TOTAL_PRICE >= 9000000 THEN '10' 
		END AS COUPON_CNT
	FROM LIST Z
	ORDER BY DEP_DATE DESC

END 


GO
