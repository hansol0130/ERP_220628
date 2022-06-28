USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	할인전 금액을 가져온다.
-- =============================================
CREATE FUNCTION [dbo].[FN_AIR_GET_PRICE]
(
	@FARE_CODE	INT,
	@DEP_DATE	DATETIME
)
RETURNS INT
AS
BEGIN
	DECLARE @RESULT INT;

	SELECT
		@RESULT = A.PRICE
	FROM
	(
		SELECT
			(CASE A.ADT_IND WHEN 1 THEN A.ADT_PRICE   --직접 ADT_PRICE에 입력한 경우 
							WHEN 2 THEN (CASE WHEN A.PRICE = 0 THEN 0 ELSE (A.PRICE * A.ADT_PRICE / 100) + A.ADT_OPT_PRICE END)
							WHEN 3 THEN A.PRICE   --판매가 성인가격은 1번과 같음. CHD요금은 성인가격 * FARE_MASTER.CHD_PRICE
							ELSE A.PRICE END) AS PRICE
		FROM
		(
			SELECT
				A.ADT_IND,			A.ADT_OPT_PRICE,			A.ADT_PRICE,
				dbo.FN_AIR_GET_IATA_PRICE_2(A.DEP_CITY_CODE, A.ARR_CITY_CODE, A.BKG_CLASS, A.AIRLINE_CODE, (CASE WHEN @DEP_DATE IS NULL THEN GETDATE() ELSE @DEP_DATE END), A.IATA_BASIS) AS PRICE
			FROM FARE_MASTER A WITH(NOLOCK)
			WHERE FARE_CODE = @FARE_CODE
		) A
	) A

	RETURN @RESULT
END
GO
