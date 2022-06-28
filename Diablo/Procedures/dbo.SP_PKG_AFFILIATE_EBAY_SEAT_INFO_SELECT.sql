USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_AFFILIATE_EBAY_SEAT_INFO_SELECT
■ DESCRIPTION				: 이베이 옥션,지마켓 상품 잔여 좌석 조회
■ INPUT PARAMETER			: 
	@PRO_CODE VARCHAR(20)	: 행사코드
	@PRICE_SEQ INT			: 가격순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 

 exec SP_PKG_AFFILIATE_EBAY_SEAT_INFO_SELECT 'PPP235-140715TH', 1
 exec SP_PKG_AFFILIATE_EBAY_SEAT_INFO_SELECT 'APA2019-180301LJ3', 1
 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2014-01-24			김성호			신규생성
2014-02-08			박형만			유류할증료추가
2014-02-27			박형만			XN_PRO_GET_QCHARGE_PRICE 파라미터 변경
2014-04-14			박형만			예약여부 추가 
2014-07-03			박형만			유류할증료 함수변경
2014-07-14			박형만			유류할증료 함수변경2
2014-11-07			박형만			FAKE_COUNT 빼기  
2018-02-20			박형만			지마켓 -> 이베이 버젼 신규 생성 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_AFFILIATE_EBAY_SEAT_INFO_SELECT]
	@PRO_CODE VARCHAR(20),
	@PRICE_SEQ INT
AS 
BEGIN
	-- 코드 존재 시
	IF EXISTS(SELECT 1 FROM PKG_DETAIL_PRICE A WITH(NOLOCK) WHERE A.PRO_CODE = @PRO_CODE AND A.PRICE_SEQ = @PRICE_SEQ)
	BEGIN
		WITH LIST AS
		(
			SELECT  A.MASTER_CODE AS PARTNER_GD_NO 
			    , (A.PRO_CODE + '|' + CONVERT(VARCHAR(2), B.PRICE_SEQ)) AS GD_SUB_CD
				, (CASE WHEN A.MAX_COUNT = 0 THEN 99 WHEN A.MAX_COUNT = -1 THEN 0 ELSE A.MAX_COUNT END) AS [RSV_REMAIN_CNT]
				, DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS [RES_COUNT]
				, A.FAKE_COUNT 
				, B.ADT_PRICE AS [ADULT_PRICE], B.CHD_PRICE AS [CHILD_PRICE], B.INF_PRICE AS [BABY_PRICE]
				--, ISNULL(DBO.XN_PRO_DETAIL_SALE_PRICE_CUTTING(A.PRO_CODE,0),0) AS [TAX_PRICE]
				, C.ADT_SALE_QCHARGE , C.CHD_SALE_QCHARGE , C.INF_SALE_QCHARGE 
				, DATEADD(DAY, -2, A.DEP_DATE) AS [CUT_DATE] 
				, A.RES_ADD_YN 
			FROM PKG_DETAIL A WITH(NOLOCK)
			INNER JOIN PKG_DETAIL_PRICE B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE
			INNER JOIN DBO.XN_PKG_DETAIL_PRICE(@PRO_CODE, @PRICE_SEQ) C 
				ON A.PRO_CODE = B.PRO_CODE AND B.PRICE_SEQ = C.PRICE_SEQ 
			WHERE A.PRO_CODE = @PRO_CODE AND B.PRICE_SEQ = @PRICE_SEQ
		)
		SELECT A.PARTNER_GD_NO, A.GD_SUB_CD, (RSV_REMAIN_CNT - (RES_COUNT+FAKE_COUNT)) AS [REMAIN_SEAT_CNT]
			, A.ADULT_PRICE, A.CHILD_PRICE, A.BABY_PRICE
			, A.ADT_SALE_QCHARGE AS TAX_PRICE
			, 0 AS ADULT_TAX_PRICE    
			, 0 AS CHILD_TAX_PRICE    
			, 0 AS BABY_TAX_PRICE  
			, ISNULL(A.ADT_SALE_QCHARGE,0) AS ADULT_FUEL_SURCHARGE   
			, ISNULL(A.CHD_SALE_QCHARGE,0) AS CHILD_FUEL_SURCHARGE    
			, ISNULL(A.INF_SALE_QCHARGE,0) AS BABY_FUEL_SURCHARGE    
			, (
				CASE
					WHEN A.CUT_DATE > GETDATE() AND (RSV_REMAIN_CNT - RES_COUNT)  > 0 AND A.RES_ADD_YN ='Y'  THEN 1
					ELSE 0
				END
			) AS [RSV_STATUS]
		FROM LIST A
	END
	ELSE
	BEGIN
		SELECT (@PRO_CODE + '|' + CONVERT(VARCHAR(2), @PRICE_SEQ)) AS GD_SUB_CD, 0 AS [REMAIN_SEAT_CNT], 0 AS [ADULT_PRICE], 0 AS [CHILD_PRICE], 0 AS [BABY_PRICE], 0 AS [TAX_PRICE], 0 AS [RSV_STATUS]
	END

END


GO
