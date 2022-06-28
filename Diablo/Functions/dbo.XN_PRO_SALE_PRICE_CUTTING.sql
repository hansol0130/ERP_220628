USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_GET_SALE_PRICE_CUTTING
■ Description				: 판매금액에 따른 금액 절사
■ Input Parameter			:                  
		@PRICE				: 판매금액
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT XN_GET_SALE_PRICE_CUTTING(12345678)
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2014-06-17		김성호			최초생성
	2014-07-03		김성호			판매가 절사 삭제 차후 함수 자체 제거 예정
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_PRO_SALE_PRICE_CUTTING]
(
	@PRICE INT
)
RETURNS INT
AS
BEGIN

	RETURN(
		@PRICE
		--CASE
		--	WHEN @PRICE >= 10000000 THEN CONVERT(INT, REVERSE(SUBSTRING(REVERSE(@PRICE), 6, 6)) + '00000')
		--	WHEN @PRICE >= 1000000 THEN CONVERT(INT, REVERSE(SUBSTRING(REVERSE(@PRICE), 5, 6)) + '0000')
		--	WHEN @PRICE >= 100000 THEN CONVERT(INT, REVERSE(SUBSTRING(REVERSE(@PRICE), 4, 6)) + '000')
		--	WHEN @PRICE >= 10000 THEN CONVERT(INT, REVERSE(SUBSTRING(REVERSE(@PRICE), 3, 6)) + '00')
		--	ELSE @PRICE
		--END
	)
END
GO
