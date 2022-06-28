USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: FN_SET_GET_RES_BRANCH_PRICE
■ DESCRIPTION				: 해당 예약의 지점수수료를 구한다
■ INPUT PARAMETER			: 
	@RES_CODE				: 예약코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	SELECT DBO.FN_SET_GET_RES_BRANCH_PRICE('RP1810225781')

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-01-13		김성호			최초생성
================================================================================================================*/ 
CREATE FUNCTION [dbo].[FN_SET_GET_RES_BRANCH_PRICE]
(
	@RES_CODE VARCHAR(20)
)
RETURNS MONEY
AS
BEGIN

	DECLARE @BRANCH_PRICE DECIMAL = 0;

	WITH LIST AS (

		SELECT SUM(C.SALE_PRICE) AS [TOT_SALE_PRICE], SUM(C.DC_PRICE) AS [TOT_DC_PRICE], MAX(ISNULL(B.BRANCH_RATE, 0)) AS [BRANCH_RATE]
		FROM RES_MASTER_damo A WITH(NOLOCK)
		INNER JOIN RES_PKG_DETAIL B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		INNER JOIN RES_CUSTOMER_DAMO C WITH(NOLOCK) ON A.RES_CODE = C.RES_CODE
		WHERE A.RES_CODE = @RES_CODE AND A.RES_STATE <= 7 AND C.RES_STATE IN (0, 3, 4)
	)
	SELECT @BRANCH_PRICE = ISNULL((SELECT TOP 1 (A.TOT_SALE_PRICE * A.BRANCH_RATE * 0.01 - A.TOT_DC_PRICE) FROM LIST A), 0)

	RETURN @BRANCH_PRICE
	
END
GO
