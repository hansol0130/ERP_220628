USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PKG_EST_SEAT_INFO_SELECT
■ DESCRIPTION				: 11번가 상품 잔여 좌석 조회
■ INPUT PARAMETER			: 
	@PRO_CODE VARCHAR(20)	: 행사코드
	@PRICE_SEQ INT			: 가격순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 
select top 100 * from pkg_detail where pro_code= 'IPP103-180828'
 exec SP_PKG_EST_SEAT_INFO_SELECT 'IPP103', '2018-08-26', '2018-08-26'
 exec SP_PKG_EST_SEAT_INFO_SELECT 'IPP103', '2018-08-27', '2018-08-30'
 exec SP_PKG_EST_SEAT_INFO_SELECT 'IPP103', '2018-09-07', '2018-09-11'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2015-12-07			박형만			추가 
2018-08-21			박형만			대기예약 제외하기 , 11번가에서 좌석없는 대기예약은 노출안함 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_EST_SEAT_INFO_SELECT]
	@MASTER_CODE VARCHAR(20),
	@DEP_DATE VARCHAR(10),
	@ARR_DATE VARCHAR(10)
AS 
BEGIN
	-- 코드 존재 시
	IF EXISTS(SELECT 1 FROM  PKG_DETAIL A  WITH(NOLOCK)
		INNER JOIN PKG_DETAIL_PRICE B WITH(NOLOCK) 
			ON A.PRO_CODE = B.PRO_CODE 
		WHERE A.MASTER_CODE = @MASTER_CODE 
		AND DEP_DATE = CONVERT(DATETIME,@DEP_DATE)
		--AND ARR_DATE = CONVERT(DATETIME,@ARR_DATE)
		)
	BEGIN
		WITH LIST AS
		(
			SELECT 
				(A.PRO_CODE + '|' + CONVERT(VARCHAR(2), B.PRICE_SEQ)) AS [itemNo]
				, (CASE WHEN A.MAX_COUNT = 0 THEN 99 WHEN A.MAX_COUNT = -1 THEN 0 ELSE A.MAX_COUNT END) AS [RSV_REMAIN_CNT]
				, DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS [RES_COUNT]
				, A.FAKE_COUNT 
				, B.ADT_PRICE  , B.CHD_PRICE  , B.INF_PRICE  
				----, ISNULL(DBO.XN_PRO_DETAIL_SALE_PRICE_CUTTING(A.PRO_CODE,0),0) AS [TAX_PRICE]
				--, C.ADT_SALE_QCHARGE , C.CHD_SALE_QCHARGE , C.INF_SALE_QCHARGE 
				, DATEADD(DAY, -2, A.DEP_DATE) AS [CUT_DATE] 
				
				, CASE WHEN A.RES_ADD_YN = 'Y' AND (A.MAX_COUNT = 0 OR (A.MAX_COUNT - DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) > 0)) THEN 'Y' 
					ELSE 'N' END AS RES_ADD_YN  -- 2018-08-21 
				, dbo.XN_PRO_DETAIL_QCHARGE_PRICE_ALL(A.PRO_CODE ,B.PRICE_SEQ)  AS QHCHARGE_ALL
			FROM PKG_DETAIL A WITH(NOLOCK)
			INNER JOIN PKG_DETAIL_PRICE B WITH(NOLOCK)
				ON A.PRO_CODE = B.PRO_CODE
			WHERE A.MASTER_CODE = @MASTER_CODE
			AND A.DEP_DATE = CONVERT(DATETIME,@DEP_DATE)
			--AND A.ARR_DATE = CONVERT(DATETIME,@ARR_DATE)

		)

		SELECT * FROM ( 
		SELECT A.itemNo   
			, A.ADT_PRICE AS selPrc
			, A.ADT_PRICE AS adultSelPrc , '02' AS adultTaxType , (SELECT DATA FROM DBO.FN_SPLIT(QHCHARGE_ALL,'|') WHERE ID=1) AS adultTaxPrc 
			, '02' AS adultBillType , 0 AS  adultBillPrc 
			, A.CHD_PRICE AS childSelPrc , '02' AS childTaxType , (SELECT DATA FROM DBO.FN_SPLIT(QHCHARGE_ALL,'|') WHERE ID=2) AS childTaxPrc 
			, '02' AS childBillType , 0 AS  childBillPrc  
			, A.INF_PRICE AS babySelPrc , '02' AS babyTaxType , (SELECT DATA FROM DBO.FN_SPLIT(QHCHARGE_ALL,'|') WHERE ID=3) AS babyTaxPrc 
			, '02' AS babyBillType , 0 AS  babyBillPrc  

			, (RSV_REMAIN_CNT - (RES_COUNT+FAKE_COUNT)) AS remainQty
			, 0 AS minSelQty

			, CASE WHEN (RSV_REMAIN_CNT - (RES_COUNT+FAKE_COUNT)) > 9 THEN 9 
				ELSE  (RSV_REMAIN_CNT - (RES_COUNT+FAKE_COUNT)) END as Qty
			, (
				CASE
					WHEN A.CUT_DATE > GETDATE() AND (RSV_REMAIN_CNT - RES_COUNT)  > 0 AND A.RES_ADD_YN ='Y'  THEN '01'
					ELSE '03'
				END
			) AS [rsvPossStat] --		rsvStatCd	예약상태	01:출발가능	02:대기예약	03:마감예약		
		FROM LIST A
		) T 
		WHERE remainQty > 0   -- 좌석있고 
		AND rsvPossStat = '01'  -- 출발가능 만 
		order by selPrc asc 
		
	END
	--ELSE
	--BEGIN
	--	--SELECT (@PRO_CODE + '|' + CONVERT(VARCHAR(2), @PRICE_SEQ)) AS [SERIES_NO], 0 AS [RSV_REMAIN_CNT], 0 AS [ADULT_PRICE], 0 AS [CHILD_PRICE], 0 AS [BABY_PRICE], 0 AS [TAX_PRICE], 0 AS [RSV_STATUS]
	--END

END 

GO
