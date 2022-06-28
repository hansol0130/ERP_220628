USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_SENDING_DETAIL_SELECT
■ DESCRIPTION				: 샌딩 상품 정보
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_PKG_SENDING_DETAIL_SELECT 'EPP300-160318OZ7';
	EXEC SP_PKG_SENDING_DETAIL_SELECT 'EPP369-160318EY';
	EXEC SP_PKG_SENDING_DETAIL_SELECT 'EPP5018-170521';	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
    2017-04-17		정지용			최초생성
	2017-05-16		정지용			요청에 따른 수정
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_SENDING_DETAIL_SELECT]
	@PRO_CODE VARCHAR(20)
AS 
BEGIN

	SELECT
		A.PRO_CODE, 
		A.PRO_NAME, 
		B.DEP_DEP_DATE AS DEP_DATE, 
		B.DEP_DEP_TIME AS DEP_TIME, 
		B.DEP_TRANS_CODE + B.DEP_TRANS_NUMBER AS TRANS_NAME,
		A.MEET_COUNTER, 
		ISNULL(A.TC_YN, 'N') AS TC_YN,
		A.NEW_CODE AS MANAGER_CODE,
		C.KOR_NAME AS MANAGER_NAME, 
		C.INNER_NUMBER3 AS INNER_NUMBER,
		C.HP_NUMBER1 + C.HP_NUMBER2 + C.HP_NUMBER3 AS EMR_TEL_NUMBER
	FROM PKG_DETAIL A
	LEFT JOIN PRO_TRANS_SEAT B WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE
	LEFT JOIN EMP_MASTER C WITH(NOLOCK) ON A.NEW_CODE = C.EMP_CODE
	WHERE PRO_CODE = @PRO_CODE;

/*
	WITH LIST AS (
		SELECT
			A.PRO_CODE, A.PRO_NAME, 
			B.DEP_DEP_DATE, B.DEP_DEP_TIME, B.DEP_TRANS_CODE + B.DEP_TRANS_NUMBER AS TRANS_NAME,
			A.MEET_COUNTER
		FROM PKG_DETAIL A
		LEFT JOIN PRO_TRANS_SEAT B WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE
		WHERE PRO_CODE = @PRO_CODE
	)
	SELECT
		A.PRO_CODE, A.PRO_NAME,
		A.DEP_DEP_DATE AS DEP_DATE, A.DEP_DEP_TIME AS DEP_TIME, A.TRANS_NAME,
		A.MEET_COUNTER,		
		-- 해당 상품에 예약이 있고 여행자 계약서가 존재 하지 않거나 작성되지 않은 것
		COUNT(CASE WHEN (B.RES_CODE IS NOT NULL AND C.RES_CODE IS NULL) OR C.CFM_YN = 'N' THEN 1 END) AS CONTRACT_CNT,
		ISNULL(SUM(D.RES_CUS_CNT), 0) AS MEET_CNT -- 출발자 인원
	FROM LIST A
	LEFT JOIN RES_MASTER B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE AND B.RES_STATE <= 7
	LEFT JOIN (
		SELECT RES_CODE, CFM_YN, MAX(CONTRACT_NO) AS CONTRACT_NO FROM RES_CONTRACT WITH(NOLOCK) GROUP BY RES_CODE, CFM_YN
	) C ON B.RES_CODE = C.RES_CODE
	LEFT JOIN (
		SELECT RES_CODE, COUNT(1) AS RES_CUS_CNT FROM RES_CUSTOMER WITH(NOLOCK) GROUP BY RES_CODE, RES_STATE HAVING RES_STATE IN (0, 3)
	) D ON B.RES_CODE = D.RES_CODE
	GROUP BY 
		A.PRO_CODE, A.PRO_NAME, A.DEP_DEP_DATE, A.DEP_DEP_TIME, A.TRANS_NAME, A.MEET_COUNTER
*/
END
GO
