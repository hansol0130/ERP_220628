USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_NAVER_PKG_DETAIL_STATUS_PREV_SELECT
■ DESCRIPTION				: 네이버 상품 현재 참좋은 상품상태,가격 조회 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: XP_NAVER_PKG_DETAIL_STATUS_PREV_SELECT 'EPP4390-190610|1' 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-12-20		    박형만			    최초 생성
   2020-01-03		    박형만				마스터 노출 안함이면 예약마감으로 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_NAVER_PKG_DETAIL_STATUS_PREV_SELECT]
	@CHILDCODE VARCHAR(30) 
AS 
BEGIN 

	SELECT 
		UPPER(C.MASTER_CODE) AS??mstCode,
		UPPER(Z.CHILDCODE) AS??childCode,
		
		-- [상품 가격정보 priceInfo]
		-- 전체 상품 갱신 로직과 같음 , 전체 상품 로직이 갱신 되었을경우 수정해야함 
		D.ADT_PRICE as ?priceInfo_adult_basePrice,
		(SELECT AA.ADT_SALE_QCHARGE FROM DBO.XN_PKG_DETAIL_PRICE(B.PRO_CODE, D.PRICE_SEQ) AA WHERE AA.PRO_CODE = B.PRO_CODE) AS priceInfo_adult_surcharge,
		(SELECT AA.ADT_SALE_PRICE FROM DBO.XN_PKG_DETAIL_PRICE(B.PRO_CODE, D.PRICE_SEQ) AA WHERE AA.PRO_CODE = B.PRO_CODE) AS priceInfo_adult_total,
		H.ADT_COST AS?[priceInfo_adult_localPrice],
		H.CURRENCY AS [priceInfo_adult_localCurrency],

		D.CHD_PRICE as priceInfo_child_basePrice,
		(SELECT AA.CHD_SALE_QCHARGE FROM DBO.XN_PKG_DETAIL_PRICE(B.PRO_CODE, D.PRICE_SEQ) AA WHERE AA.PRO_CODE = B.PRO_CODE) AS priceInfo_child_surcharge,
		(SELECT AA.CHD_SALE_PRICE FROM DBO.XN_PKG_DETAIL_PRICE(B.PRO_CODE, D.PRICE_SEQ) AA WHERE AA.PRO_CODE = B.PRO_CODE) AS priceInfo_child_total,
		H.CHD_COST AS?[priceInfo_child_localPrice],
		H.CURRENCY AS [priceInfo_child_localCurrency],

		D.INF_PRICE AS priceInfo_infant_basePrice,
		0 AS priceInfo_infant_surcharge,
		D.INF_PRICE AS priceInfo_infant_total,
		
		H.INF_COST AS?[priceInfo_infant_localPrice],
		H.CURRENCY AS [priceInfo_infant_localCurrency],
		CASE WHEN D.INF_PRICE = 0  THEN '담당자문의' ELSE '' END AS priceInfo_infant_description,

		-- dynamic 아님 
		--(CASE WHEN D.SGL_PRICE > 0 THEN '싱글룸사용' ELSE '' END) AS [priceInfo_serviceCharge_serviceName],
		--D.SGL_PRICE AS [priceInfo_serviceCharge_price],-- 별도문의 ?? 
		--(CASE WHEN D.SGL_PRICE > 0 THEN 'KRW' END) AS [priceInfo_serviceCharge_currency],-- 별도문의 ?? 

		-- [좌석 및 부킹코드]  대기 예약 일단 2로 넘기기 2019-05-24
		-- 전체 상품 갱신 로직과 같음 , 전체 상품 로직이 갱신 되었을경우 수정해야함 
		CASE WHEN B.MAX_COUNT = 0 THEN 
			--좌석 제한 없을때 
			CASE WHEN LEFT(B.PRO_CODE,1) = 'E' THEN  -- 유럽
				CASE WHEN B.FAKE_COUNT+ DBO.FN_PRO_GET_RES_COUNT(B.PRO_CODE) > 40 THEN  B.FAKE_COUNT+ DBO.FN_PRO_GET_RES_COUNT(B.PRO_CODE) 
					ELSE B.FAKE_COUNT+ DBO.FN_PRO_GET_RES_COUNT(B.PRO_CODE) + 20  END -- 총좌석은 현재좌석 + 20 , 현재좌석 40 넘으면 현재좌석으로  
			ELSE  -- 그외 지역 
				B.FAKE_COUNT+ DBO.FN_PRO_GET_RES_COUNT(B.PRO_CODE) + 20  -- 총좌석은 현재좌석 + 20 , 최대좌석 제한 없음 
			END 
		WHEN B.MAX_COUNT < 0 THEN 2 ELSE B.MAX_COUNT  END AS bookingStatus_seatAll,  -- 대기시 대기 2좌석
		B.MIN_COUNT AS bookingStatus_seatMin,
		B.FAKE_COUNT+ DBO.FN_PRO_GET_RES_COUNT(B.PRO_CODE) AS bookingStatus_seatNow,
		--RSVPS	예약가능,LEVDC출발확정	,ARBKG대기예약,RSVCD예약마감
		(CASE WHEN B.SHOW_YN = 'N' OR C.SHOW_YN = 'N' OR B.RES_ADD_YN = 'N' THEN 'RSVCD' WHEN B.MAX_COUNT < 0 THEN 'ARBKG' WHEN B.DEP_CFM_YN = 'Y' THEN 'LEVDC' ELSE 'RSVPS' END) AS bookingStatus_bookingCode
	
	----------------------------------------------------------------------------------------------------------------
	FROM (SELECT SUBSTRING(CHILDCODE,1,CHARINDEX('|',CHILDCODE)-1) AS PRO_CODE ,
			SUBSTRING(CHILDCODE,CHARINDEX('|',CHILDCODE)+1,LEN(CHILDCODE)) AS PRICE_SEQ , CHILDCODE 
		FROM NAVER_PKG_DETAIL WITH(NOLOCK)  WHERE CHILDCODE = @CHILDCODE )  Z 
	INNER JOIN PKG_DETAIL B WITH(NOLOCK) ON Z.PRO_CODE = B.PRO_CODE
	INNER JOIN PKG_DETAIL_PRICE D WITH(NOLOCK) ON Z.PRO_CODE = D.PRO_CODE --AND D.PRICE_SEQ IN (SELECT TOP 1 PRICE_SEQ FROM PKG_DETAIL_PRICE AA WITH(NOLOCK) WHERE AA.PRO_CODE = B.PRO_CODE ORDER BY AA.PRICE_SEQ)
	AND Z.PRICE_SEQ = D.PRICE_SEQ 
	INNER JOIN PKG_MASTER C WITH(NOLOCK) ON B.MASTER_CODE = C.MASTER_CODE

	LEFT JOIN PKG_DETAIL_SELL_POINT  E WITH(NOLOCK) ON B.PRO_CODE = E.PRO_CODE
	LEFT JOIN PRO_TRANS_SEAT F WITH(NOLOCK) ON B.SEAT_CODE = F.SEAT_CODE
	LEFT JOIN PRO_TRANS_MASTER G1 WITH(NOLOCK) ON F.DEP_TRANS_CODE = G1.TRANS_CODE AND F.DEP_TRANS_NUMBER = G1.TRANS_NUMBER 
		AND F.DEP_DEP_AIRPORT_CODE = G1.DEP_AIRPORT_CODE AND F.DEP_ARR_AIRPORT_CODE = G1.ARR_AIRPORT_CODE  
	LEFT JOIN PRO_TRANS_MASTER G2 WITH(NOLOCK) ON F.ARR_TRANS_CODE = G2.TRANS_CODE AND F.ARR_TRANS_NUMBER = G2.TRANS_NUMBER 
		AND F.ARR_DEP_AIRPORT_CODE = G2.DEP_AIRPORT_CODE AND F.ARR_ARR_AIRPORT_CODE = G2.ARR_AIRPORT_CODE  
	
	LEFT JOIN PKG_DETAIL_PRICE_GROUP_COST H WITH(NOLOCK) ON D.PRO_CODE = H.PRO_CODE AND D.PRICE_SEQ = H.PRICE_SEQ AND H.COST_SEQ = 1

	LEFT JOIN EMP_MASTER_DAMO EMP WITH(NOLOCK) 
		ON B.NEW_CODE = EMP.EMP_CODE 
		 
	
	WHERE 1=1
	--AND F.SEAT_CODE IS NOT NULL 

	
	--AND (ISNULL(E.TRAFFIC_POINT,'') <> ''
	--	OR ISNULL(E.STAY_POINT,'') <> ''
	--	OR ISNULL(E.TOUR_POINT,'') <> ''
	--	OR ISNULL(E.EAT_POINT,'') <> ''
	--	OR ISNULL(E.DISCOUNT_POINT,'') <> ''
	--	OR ISNULL(E.OTHER_POINT,'') <> '')

	--AND E.PRO_CODE IS NOT NULL 
END 
GO
