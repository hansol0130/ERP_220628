USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_PUB_PRICE_CUTTING
■ Description				: 지정 자리수 절사 (10자리 이하 가능)
■ Input Parameter			:                  
		@PRICE				: 대상금액
		@DIGIT				: 절사자리수
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.XN_PUB_PRICE_CUTTING(123456789, 3)
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2014-07-03		김성호			최초생성
	2020-03-04		김성호			프로세스 개선
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_PUB_PRICE_CUTTING]
(
	@PRICE INT, 
	@DIGIT INT
)
RETURNS INT
AS
BEGIN
	RETURN(
		--SELECT CONVERT(INT, LEFT(@PRICE , ABS(LEN(@PRICE) - @DIGIT))  + REPLICATE('0', @DIGIT))
		
		SELECT FLOOR(@PRICE / POWER(10, @DIGIT)) * POWER(10, @DIGIT)

	)
END


GO
