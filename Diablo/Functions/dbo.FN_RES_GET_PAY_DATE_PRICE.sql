USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name			: FN_RES_GET_PAY_DATE_PRICE
■ Description				: 예약 결제월별 입금금액 리턴
■ Input Parameter			:                  
		@RES_CODE			: 예약코드
		@PAY_DATE			: 결제월 
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.FN_RES_GET_PAY_DATE_PRICE('RP1606178021', '2016-06')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2016-09-07		이유라			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_RES_GET_PAY_DATE_PRICE]
(
	@RES_CODE VARCHAR(20), 
	@PAY_DATE VARCHAR(10)
)
RETURNS DECIMAL
AS
BEGIN
	--FN_RES_GET_PAY_PRICE 참고 // 예약건, 결제월별 입금금액

	DECLARE @PAY_PRICE DECIMAL, @START_DATE VARCHAR(10), @END_DATE VARCHAR(10);

	SET @PAY_DATE = @PAY_DATE + '-01'; 
	SET @START_DATE = CONVERT(VARCHAR(10),@PAY_DATE, 121);
	SET @END_DATE = CONVERT(VARCHAR(10), DATEADD(MONTH, 1, @PAY_DATE), 121);

	SELECT @PAY_PRICE = ISNULL(SUM(A.PART_PRICE), 0)
	FROM PAY_MATCHING A WITH(NOLOCK) 
	JOIN PAY_MASTER_damo B WITH(NOLOCK) ON A.PAY_SEQ = B.PAY_SEQ
	WHERE A.RES_CODE = @RES_CODE AND A.CXL_YN = 'N' AND B.PAY_DATE >= @START_DATE AND B.PAY_DATE < @END_DATE;
	-- 0 접수에서 7 환불까지
	
	RETURN (@PAY_PRICE)

END

GO
