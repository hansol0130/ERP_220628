USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_PAY_GET_PAYMENT_TYPE]
(
	@PAY_TYPE INT
)
RETURNS VARCHAR(20)
AS
BEGIN

	-- return 은행 = 0, 일반계좌 = 1, OFF신용카드 = 2, PG신용카드 = 3, 상품권 = 4, 현금 = 5, 미수대체 = 6, 포인트 = 7, 기타 = 8, 세금계산서 = 9, CCCF = 10, IND_TKT = 11, TASF =12
	
	DECLARE @PAY_NAME VARCHAR(20)
	
	SELECT @PAY_NAME = (
		CASE @PAY_TYPE
			WHEN 0 THEN '은행'
			WHEN 1 THEN '일반계좌'
			WHEN 2 THEN 'OFF신용카드'
			WHEN 3 THEN 'PG신용카드'
			WHEN 4 THEN '상품권'
			WHEN 5 THEN '현금'
			WHEN 6 THEN '미수대체'
			WHEN 7 THEN '포인트'
			WHEN 8 THEN '기타'
			WHEN 9 THEN '세금계산서'
			WHEN 10 THEN 'CCCF'
			WHEN 11 THEN 'IND_TKT'
			WHEN 12 THEN 'TASF'
		END
	)

	RETURN (@PAY_NAME)

END

GO
