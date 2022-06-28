USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name			: FN_NAVER_RES_GET_TOTAL_PRICE
■ Description				: 네이버 예약 총 판매금액 리턴
■ Input Parameter			:                  
		@RES_CODE			: 예약코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

	SELECT DBO.FN_NAVER_RES_GET_TOTAL_PRICE('RP1906237786')

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	
	2019-07-09		박형만			네이버 용 총금액 구하기 . 취소 되어도 0원이 아닌 원래 금액 달라고함,, 막무가내

-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_NAVER_RES_GET_TOTAL_PRICE]
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
		FROM RES_CUSTOMER_DAMO A WITH(NOLOCK)
		INNER JOIN RES_MASTER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		WHERE A.RES_CODE = @RES_CODE
		GROUP BY A.RES_CODE
	) A

	--금액이 없는 경우 처음 에서 구하기 
	IF ISNULL(@TOT_PRICE,0)  = 0 
	BEGIN
		SELECT @TOT_PRICE = ISNULL((A.SUM_SALE_PRICE - A.SUM_DC_PRICE + A.SUM_TAX_PRICE + A.SUM_CHG_PRICE + A.SUM_PENALTY_PRICE), 0)
		FROM (
			SELECT 
				B.RES_CODE,
				SUM(ISNULL(B.SALE_PRICE, 0)) AS [SUM_SALE_PRICE],
				SUM(ISNULL(B.CHG_PRICE, 0)) AS [SUM_CHG_PRICE],
				SUM(ISNULL(B.DC_PRICE, 0)) AS [SUM_DC_PRICE],
				SUM(ISNULL(B.TAX_PRICE, 0)) AS [SUM_TAX_PRICE],
				SUM(ISNULL(B.PENALTY_PRICE, 0)) AS [SUM_PENALTY_PRICE]
			FROM RES_CUSTOMER_DAMO A WITH(NOLOCK) 
				INNER JOIN RES_CUSTOMER_HISTORY B WITH(NOLOCK)  
					ON A.RES_CODE = B.RES_CODE 
					AND A.SEQ_NO = B.SEQ_NO 
					AND B.HIS_SEQ = (SELECT MIN(HIS_SEQ) FROM RES_CUSTOMER_HISTORY WITH(NOLOCK)   
									WHERE RES_CODE = B.RES_CODE 
									AND SEq_NO = B.SEq_NO ) 
			WHERE A.RES_CODE = @RES_CODE
			GROUP BY B.RES_CODE
		) A 
	END 

	--그래도 없는 경우 상품가격 가져오기 
	IF ISNULL(@TOT_PRICE,0)  = 0 
	BEGIN
		DECLARE @PRO_CODE VARCHAR(20)
		DECLARE @PRICE_SEQ INT 
		SELECT @PRO_CODE = PRO_CODE , @PRICE_SEQ = PRICE_SEQ 
		FROM RES_MASTER_DAMO WITH(NOLOCK) 
		WHERE RES_CODE = @RES_CODE
	
		SELECT @TOT_PRICE = ISNULL(SALE_PRICE, 0)
		FROM (
			SELECT A.RES_CODE,
				SUM(CASE WHEN A.AGE_TYPE = 0 THEN ADT_SALE_PRICE 
					WHEN A.AGE_TYPE = 1 THEN CHD_SALE_PRICE 
					WHEN A.AGE_TYPE = 2 THEN INF_SALE_PRICE  END) AS SALE_PRICE 
			FROM RES_CUSTOMER_DAMO A WITH(NOLOCK)
			INNER JOIN RES_MASTER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
			INNER JOIN DBO.XN_PKG_DETAIL_PRICE(@PRO_CODE, @PRICE_SEQ) C 
				ON	B.PRO_CODE = C.PRO_CODE 
				AND B.PRICE_SEQ = C.PRICE_SEQ 
			WHERE A.RES_CODE = @RES_CODE 
			GROUP BY A.RES_CODE
		) A 
	END 

	-- 취소건 NULL 방지 ISNULL 처리
	RETURN ISNULL(@TOT_PRICE, 0)

END
GO
