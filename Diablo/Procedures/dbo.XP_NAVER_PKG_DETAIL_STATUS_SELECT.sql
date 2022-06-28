USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_NAVER_PKG_DETAIL_STATUS_SELECT
■ DESCRIPTION				: 네이버 상품 현재 상품상태,가격 조회 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: XP_NAVER_PKG_DETAIL_STATUS_SELECT 'EPP4390-190610|1' 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   
================================================================================================================*/ 
CREATE PROC [dbo].[XP_NAVER_PKG_DETAIL_STATUS_SELECT]
	@CHILDCODE VARCHAR(30) 
AS 
BEGIN 


--DECLARE @PRO_CODE VARCHAR(30) , 
--@PRICE_SEQ INT 

--DECLARE @CHILDCODE VARCHAR(30) 
--SET @CHILDCODE = 'EPP4390-190610|1' 

	--IF ISNULL(@CHILDCODE,'') <> '' AND ISNULL(@PRO_CODE,'') = ''
	--BEGIN
	--	SET @PRO_CODE = SUBSTRING(@CHILDCODE,1,CHARINDEX('|',@CHILDCODE)-1)
	--	SET @PRICe_SEQ = CONVERT(INT, SUBSTRING(@CHILDCODE,CHARINDEX('|',@CHILDCODE)+1,LEN(@CHILDCODE)-CHARINDEX('|',@CHILDCODE)) )
	--END 
	
	-- 자상품 갱신 후에 조회 
	SELECT  
		mstCode,
		priceInfo_adult_basePrice,
		priceInfo_adult_surcharge,
		priceInfo_adult_total,
		priceInfo_adult_localPrice,
		priceInfo_adult_localCurrency,
		priceInfo_child_basePrice,
		priceInfo_child_surcharge,
		priceInfo_child_total,
		priceInfo_child_localPrice,
		priceInfo_child_localCurrency,
		priceInfo_infant_basePrice,
		priceInfo_infant_surcharge,
		priceInfo_infant_total,
		priceInfo_infant_localPrice,
		priceInfo_infant_localCurrency,
		priceInfo_infant_description,
		
		bookingStatus_seatAll,
		bookingStatus_seatMin,
		bookingStatus_seatNow,
		bookingStatus_bookingCode
	FROM NAVER_PKG_DETAIL  WITH(NOLOCK)
	WHERE childCode = @CHILDCODE 

	-- 현재 참좋은 상태 그대로 조회 <- 보류 
	--SELECT  
	--B.MASTER_CODE AS mstCode,
	--B.PRO_CODE + '|' + D.PRICE_SEQ AS 

	---- 상품 가격정보 priceInfo 
	--D.ADT_PRICE as ?priceInfo_adult_basePrice,
	--(SELECT AA.ADT_SALE_QCHARGE FROM DBO.XN_PKG_DETAIL_PRICE(B.PRO_CODE, D.PRICE_SEQ) AA WHERE AA.PRO_CODE = B.PRO_CODE) AS priceInfo_adult_surcharge,
	--(SELECT AA.ADT_SALE_PRICE FROM DBO.XN_PKG_DETAIL_PRICE(B.PRO_CODE, D.PRICE_SEQ) AA WHERE AA.PRO_CODE = B.PRO_CODE) AS priceInfo_adult_total,
	--H.ADT_COST AS?[priceInfo_adult_localPrice],
	--H.CURRENCY AS [priceInfo_adult_localCurrency],

	--D.CHD_PRICE as priceInfo_child_basePrice,
	--(SELECT AA.CHD_SALE_QCHARGE FROM DBO.XN_PKG_DETAIL_PRICE(B.PRO_CODE, D.PRICE_SEQ) AA WHERE AA.PRO_CODE = B.PRO_CODE) AS priceInfo_child_surcharge,
	--(SELECT AA.CHD_SALE_PRICE FROM DBO.XN_PKG_DETAIL_PRICE(B.PRO_CODE, D.PRICE_SEQ) AA WHERE AA.PRO_CODE = B.PRO_CODE) AS priceInfo_child_total,
	--H.CHD_COST AS?[priceInfo_child_localPrice],
	--H.CURRENCY AS [priceInfo_child_localCurrency],

	--D.INF_PRICE AS priceInfo_infant_basePrice,
	--0 AS priceInfo_infant_surcharge,
	--D.INF_PRICE AS priceInfo_infant_total,
		
	--H.INF_COST AS?[priceInfo_infant_localPrice],
	--H.CURRENCY AS [priceInfo_infant_localCurrency],
	--CASE WHEN D.INF_PRICE = 0  THEN '담당자문의' ELSE '' END AS priceInfo_infant_description,


	---- 좌석 및 부킹코드  
	--CASE WHEN B.MAX_COUNT = 0 THEN 99 WHEN B.MAX_COUNT < 0 THEN 2 ELSE B.MAX_COUNT  END AS bookingStatus_seatAll,
	--B.MIN_COUNT AS bookingStatus_seatMin,
	----0 AS bookingStatus_seatNow,
	----RSVPS	예약가능
	----LEVDC	출발확정
	----ARBKG	대기예약
	----RSVCD	예약마감
	--DBO.FN_PRO_GET_RES_COUNT(B.PRO_CODE) AS bookingStatus_seatNow,
	----(CASE WHEN B.RES_ADD_YN = 'N' THEN 'RSVPS' WHEN B.MAX_COUNT < 0 THEN 'ARBKG' WHEN B.DEP_CFM_YN = 'Y' THEN 'LEVDC' ELSE 'RSVPS' END) AS bookingStatus_bookingCode,
	--(CASE WHEN B.RES_ADD_YN = 'N' THEN 'RSVCD' WHEN B.MAX_COUNT < 0 THEN 'ARBKG' WHEN B.DEP_CFM_YN = 'Y' THEN 'LEVDC' ELSE 'RSVPS' END) AS bookingStatus_bookingCode

	--FROM PKG_DETAIL B WITH(NOLOCK) 
	--INNER JOIN PKG_DETAIL_PRICE D WITH(NOLOCK) ON B.PRO_CODE = D.PRO_CODE --AND D.PRICE_SEQ IN (SELECT TOP 1 PRICE_SEQ FROM PKG_DETAIL_PRICE AA WITH(NOLOCK) WHERE AA.PRO_CODE = B.PRO_CODE ORDER BY AA.PRICE_SEQ)
	--INNER JOIN PKG_MASTER C WITH(NOLOCK) ON B.MASTER_CODE = C.MASTER_CODE

	--LEFT JOIN PKG_DETAIL_PRICE_GROUP_COST H WITH(NOLOCK) 
	--	ON D.PRO_CODE = H.PRO_CODE AND D.PRICE_SEQ = H.PRICE_SEQ AND H.COST_SEQ = 1

	--WHERE B.PRO_CODE = @PRO_CODE 
	--AND D.PRICE_SEQ = @PRICe_SEQ 

END 

GO
