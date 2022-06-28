USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_NTT_PKG_DETAIL_TARGET_SELECT_LIST
■ DESCRIPTION				: 네이버 트립토파즈 업데이트 상품 정보 조회 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_NTT_PKG_DETAIL_TARGET_LIST_SELECT @MASTER_CODE='APP5006', @BIT_CODE = 'KE'
	
	SELECT * FROM NTT_PKG_DETAIL_UPDATE_TARGET A WITH(NOLOCK)
	
	--UPDATE NTT_PKG_DETAIL_UPDATE_TARGET SET CHK_DATE = NULL
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2021-11-18		김성호			최초생성
	2021-11-22		김성호			[agencyProductId] SEQ_NO 수정 => 결과 리턴 시 완료 처리를 위해 
	2021-11-29		김성호			유류할증료 포함 가격으로 수정
	2022-02-11		김성호			@PKG_DETAIL_PRICE 등록 시 중복 값 GROUP BY 처리 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_NTT_PKG_DETAIL_TARGET_LIST_SELECT]

	@MASTER_CODE VARCHAR(20),		-- 네이버 모상품 코드
	@BIT_CODE VARCHAR(4)			-- 구분 코드
	
AS 
BEGIN

	-- QCHARGE 조회를 위한 행사코드 정의
	DECLARE @PKG_DETAIL_PRICE UDT_PKG_DETAIL_PRICE
	INSERT INTO @PKG_DETAIL_PRICE (PRO_CODE, PRICE_SEQ)
	SELECT NPD.PRO_CODE, NPD.PRICE_SEQ
	FROM NTT_PKG_DETAIL_UPDATE_TARGET NPD WITH(NOLOCK) 
	WHERE NPD.MASTER_CODE = ISNULL(@MASTER_CODE, NPD.MASTER_CODE) AND NPD.BIT_CODE = ISNULL(@BIT_CODE, NPD.BIT_CODE) AND NPD.CHK_DATE IS NULL
	GROUP BY NPD.PRO_CODE, NPD.PRICE_SEQ;
	
	-- 행상정보 조회
	SELECT NPD.SEQ_NO AS [seqNo]
		, (PD.MASTER_CODE + (CASE WHEN NPD.BIT_CODE = '' THEN '' ELSE '|' END) + NPD.BIT_CODE) AS [nttMasterCode]
		, PD.MASTER_CODE AS [masterCode]
		, PD.PRO_CODE AS [agencyProductId]
		, PD.PRO_NAME AS [productName]
		, PDPL.ADT_SALE_PRICE AS [adult]
		, PDPL.CHD_SALE_PRICE AS [child]
		, PDPL.INF_SALE_PRICE AS [infant]
		, (CASE WHEN PD.SALE_TYPE = 3 THEN 'true' ELSE 'false' END) AS [emergency], 1 AS [minBookingAdult]
		, CONVERT(VARCHAR(10), PD.DEP_DATE, 120) AS [beginDate]
		, (CASE
				WHEN PD.RES_ADD_YN = 'N' THEN 'RSVCD'	-- 신규예약불가
				WHEN PD.MAX_COUNT < 0 THEN 'RSVCD'		-- 대기예약
				WHEN PD.SHOW_YN = 'N' THEN 'RSVCD'		-- 보기유무 'N'인 경우
				WHEN PD.DEP_CFM_YN = 'Y' THEN 'LEVDC'	-- 출발확정
				ELSE 'RSVPS'							-- 예약가능
		   END) AS [productStatus]
		, (CASE WHEN PD.MIN_COUNT = 0 THEN 20 ELSE PD.MIN_COUNT END) AS [bookMinSeat]
		, (CASE WHEN PD.MAX_COUNT <= 0 THEN 50 ELSE PD.MAX_COUNT END) AS [bookMaxSeat]
		--, PDP.ADT_PRICE, PDP.CHD_PRICE, PDP.INF_PRICE
	FROM (
		SELECT MIN(NPD.SEQ_NO) SEQ_NO, NPD.PRO_CODE, NPD.PRICE_SEQ, NPD.BIT_CODE 
		FROM NTT_PKG_DETAIL_UPDATE_TARGET NPD WITH(NOLOCK)
		WHERE NPD.MASTER_CODE = ISNULL(@MASTER_CODE, NPD.MASTER_CODE) AND NPD.BIT_CODE = ISNULL(@BIT_CODE, NPD.BIT_CODE) AND NPD.CHK_DATE IS NULL
		GROUP BY NPD.PRO_CODE, NPD.PRICE_SEQ, NPD.BIT_CODE 
	) NPD
	INNER JOIN PKG_DETAIL PD WITH(NOLOCK) ON NPD.PRO_CODE = PD.PRO_CODE
	INNER JOIN PKG_DETAIL_PRICE PDP WITH(NOLOCK) ON NPD.PRO_CODE = PDP.PRO_CODE AND NPD.PRICE_SEQ = PDP.PRICE_SEQ
	INNER JOIN dbo.XN_PKG_DETAIL_PRICE_LIST(@PKG_DETAIL_PRICE) PDPL ON PDP.PRO_CODE = PDPL.PRO_CODE AND PDP.PRICE_SEQ = PDPL.PRICE_SEQ
	WHERE PD.DEP_DATE > GETDATE()
	ORDER BY NPD.PRO_CODE --NPD.SEQ_NO
	
END
GO
