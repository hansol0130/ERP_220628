USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_PRO_DETAIL_SALE_PRICE_CUTTING
■ Description				: 행사 성인 판매가 검색
■ Input Parameter			:                  
		@PRO_CODE			: 행사코드
		@PRICE_SEQ			: 가격순번
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.XN_PRO_DETAIL_SALE_PRICE_CUTTING('XXX121-140619', 0)
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2014-06-19		김성호			최초생성
	2014-06-25		김성호			가격순번 입력 (0이면 최저가 리턴)
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_PRO_DETAIL_SALE_PRICE_CUTTING]
(
	@PRO_CODE VARCHAR(20),
	@PRICE_SEQ	INT
)
RETURNS INT
AS
BEGIN
	RETURN (
		SELECT TOP 1 DBO.XN_PRO_SALE_PRICE_CUTTING(A.ADT_PRICE + A.ADT_TAX + (CASE A.QCHARGE_TYPE WHEN 0 THEN 0 WHEN 1 THEN B.ADT_QCHARGE ELSE A.ADT_QCHARGE END)) AS [ADT_SALE_PRICE]
		FROM PKG_DETAIL_PRICE A WITH(NOLOCK)
		LEFT JOIN XN_PKG_DETAIL_SYSTEM_QCHARGE(@PRO_CODE) B ON A.PRO_CODE = B.PRO_CODE
		WHERE A.PRO_CODE = @PRO_CODE AND A.PRICE_SEQ = CASE WHEN @PRICE_SEQ = 0 THEN A.PRICE_SEQ ELSE @PRICE_SEQ END
		ORDER BY ISNULL(A.ADT_PRICE, 0)
	)
END
GO
