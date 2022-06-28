USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_RES_GET_TOTAL_PRICE
■ Description				: 예약 총 판매금액 리턴
■ Input Parameter			:                  
		@RES_CODE			: 예약코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

	SELECT DBO.FN_RES_GET_TOTAL_PRICE('RP1805186997')

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2009-03-29		김성호			최초생성
	2011-06-30		김성호			호텔일경우 금액 합산 분기
	2015-09-02		박형만			국내온라인 항공 마스터 코드 일경우 'KTR0%' , 입금된 예약번호의 판매금액만 다 더함
	2016-01-27		김성호			불필요조인 해제
	2019-01-10		김성호			소스 간소화
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_RES_GET_TOTAL_PRICE]
(
	@RES_CODE VARCHAR(20)
)
RETURNS DECIMAL
AS
BEGIN
	DECLARE @TOT_PRICE DECIMAL

	SELECT @TOT_PRICE = ISNULL((A.SUM_SALE_PRICE - A.SUM_DC_PRICE + A.SUM_TAX_PRICE + A.SUM_CHG_PRICE + A.SUM_PENALTY_PRICE), 0)
	FROM (
		SELECT A.RES_CODE,
			SUM(ISNULL(A.SALE_PRICE, 0)) AS [SUM_SALE_PRICE],
			SUM(ISNULL(A.CHG_PRICE, 0)) AS [SUM_CHG_PRICE],
			SUM(ISNULL(A.DC_PRICE, 0)) AS [SUM_DC_PRICE],
			SUM(ISNULL(A.TAX_PRICE, 0)) AS [SUM_TAX_PRICE],
			SUM(ISNULL(A.PENALTY_PRICE, 0)) AS [SUM_PENALTY_PRICE]
		FROM RES_HTL_ROOM_MASTER A WITH(NOLOCK)
		INNER JOIN RES_MASTER_DAMO B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		WHERE A.RES_CODE = @RES_CODE AND A.RES_CODE LIKE 'RH%' AND B.RES_STATE <= 7
		GROUP BY A.RES_CODE
		UNION ALL
		SELECT A.RES_CODE,
			SUM(ISNULL(A.SALE_PRICE, 0)) AS [SUM_SALE_PRICE],
			SUM(ISNULL(A.CHG_PRICE, 0)) AS [SUM_CHG_PRICE],
			SUM(ISNULL(A.DC_PRICE, 0)) AS [SUM_DC_PRICE],
			SUM(ISNULL(A.TAX_PRICE, 0)) AS [SUM_TAX_PRICE],
			SUM(ISNULL(A.PENALTY_PRICE, 0)) AS [SUM_PENALTY_PRICE]
		FROM RES_CUSTOMER_DAMO A WITH(NOLOCK)
		INNER JOIN RES_MASTER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		WHERE A.RES_CODE = @RES_CODE AND A.RES_CODE LIKE 'R[P,T]%' AND (B.PRO_CODE LIKE 'KTR0%' OR A.RES_STATE IN (0, 3, 4))
		GROUP BY A.RES_CODE
	) A

	-- TOT_PRICE는 판매액
	-- PAY_PRICE는 입금액

	--IF ( SUBSTRING(@RES_CODE,1,2) = 'RH') --호텔
	--BEGIN
	--	SELECT @TOT_PRICE = SUM((ISNULL(SALE_PRICE, 0) - ISNULL(DC_PRICE, 0) + ISNULL(TAX_PRICE, 0) + ISNULL(CHG_PRICE, 0) + ISNULL(PENALTY_PRICE, 0)))
	--	FROM RES_HTL_ROOM_MASTER A WITH(NOLOCK)
	--		INNER JOIN RES_MASTER_DAMO B  WITH(NOLOCK)
	--			ON A.RES_CODE = B.RES_CODE
	--	WHERE A.RES_CODE = @RES_CODE AND B.RES_STATE NOT IN (8, 9)
	--END 
	--ELSE IF ( SUBSTRING(@RES_CODE,1,2) = 'RT') --항공 
	--BEGIN
	--	-- 국내 온라인 항공 
	--	IF (SELECT TOP 1 PRO_CODE FROM RES_MASTER_damo WITH(NOLOCK) WHERE RES_CODE = @RES_CODE) LIKE 'KTR0%' 
	--	BEGIN
	--		SELECT @TOT_PRICE = (SUM_SALE_PRICE - SUM_DC_PRICE + SUM_CHG_PRICE + SUM_TAX_PRICE + SUM_PENALTY_PRICE)
	--		FROM (
	--			SELECT
	--				--국내온라인항공일땐 전체 상태 , 그외는 예약상태가 0,3,4 인경우만 
	--				SUM(ISNULL(SALE_PRICE, 0)) AS [SUM_SALE_PRICE],
	--				SUM(ISNULL(CHG_PRICE, 0)) AS [SUM_CHG_PRICE],
	--				SUM(ISNULL(DC_PRICE, 0)) AS [SUM_DC_PRICE],
	--				SUM(ISNULL(TAX_PRICE, 0)) AS [SUM_TAX_PRICE],
	--				SUM(ISNULL(PENALTY_PRICE, 0)) AS [SUM_PENALTY_PRICE]
	--			FROM RES_CUSTOMER_DAMO A WITH(NOLOCK)
	--			--INNER JOIN PAY_MATCHING B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE (2016.01.27)
	--			WHERE A.RES_CODE = @RES_CODE
	--			--AND RES_STATE IN (0, 3, 4) -- 예약, 환불, 페널티
	--		) A
	--	END 
	--	ELSE  -- 그외 항공 
	--	BEGIN
	--		SELECT @TOT_PRICE = (SUM_SALE_PRICE - SUM_DC_PRICE + SUM_CHG_PRICE + SUM_TAX_PRICE + SUM_PENALTY_PRICE)
	--		FROM (
	--			SELECT
	--				SUM(ISNULL(SALE_PRICE, 0)) AS [SUM_SALE_PRICE],
	--				SUM(ISNULL(CHG_PRICE, 0)) AS [SUM_CHG_PRICE],
	--				SUM(ISNULL(DC_PRICE, 0)) AS [SUM_DC_PRICE],
	--				SUM(ISNULL(TAX_PRICE, 0)) AS [SUM_TAX_PRICE],
	--				SUM(ISNULL(PENALTY_PRICE, 0)) AS [SUM_PENALTY_PRICE]
	--			FROM RES_CUSTOMER_DAMO WITH(NOLOCK)
	--			WHERE RES_CODE = @RES_CODE
	--			AND RES_STATE IN (0, 3, 4) -- 예약, 환불, 페널티
	--		) A
	--	END 
	--END 
	--ELSE 
	--BEGIN
	--	SELECT @TOT_PRICE = (SUM_SALE_PRICE - SUM_DC_PRICE + SUM_CHG_PRICE + SUM_TAX_PRICE + SUM_PENALTY_PRICE)
	--	FROM (
	--		SELECT
	--			SUM(ISNULL(SALE_PRICE, 0)) AS [SUM_SALE_PRICE],
	--			SUM(ISNULL(CHG_PRICE, 0)) AS [SUM_CHG_PRICE],
	--			SUM(ISNULL(DC_PRICE, 0)) AS [SUM_DC_PRICE],
	--			SUM(ISNULL(TAX_PRICE, 0)) AS [SUM_TAX_PRICE],
	--			SUM(ISNULL(PENALTY_PRICE, 0)) AS [SUM_PENALTY_PRICE]
	--		FROM RES_CUSTOMER_DAMO WITH(NOLOCK)
	--		WHERE RES_CODE = @RES_CODE
	--		AND RES_STATE IN (0, 3, 4) -- 예약, 환불, 페널티
	--	) A
	--END 

	-- 취소건 NULL 방지 ISNULL 처리
	RETURN ISNULL(@TOT_PRICE, 0)

END
GO
