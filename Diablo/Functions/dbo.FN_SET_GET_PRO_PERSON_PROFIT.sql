USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: FN_SET_GET_PRO_PERSON_PROFIT
■ DESCRIPTION				: 해당 행사의 의 1인당 수익을 구한다.
■ INPUT PARAMETER			: 
	@PRO_CODE				: 행사코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	SELECT DBO.FN_SET_GET_PRO_PERSON_PROFIT('ETR100-1508157794')
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2010-02-06		이규식			최초생성
   2015-08-07		김성호			예약인원에서 패널티는 제외 (강우미차장님 문의 후 결정)
================================================================================================================*/ 
CREATE FUNCTION [dbo].[FN_SET_GET_PRO_PERSON_PROFIT]
(
	@PRO_CODE VARCHAR(20)
)
RETURNS MONEY
AS
BEGIN

	--DECLARE @인당수익 MONEY;

	--WITH LIST AS
	--(
	--	SELECT 
	--		A.DEP_DATE, A.RES_COUNT,
	--		(A.SALE_PRICE - (AIR_PRICE + LAND_PRICE + PERSON_PRICE + GROUP_PRICE + AIR_PROFIT + AIR_ETC_PRICE)) AS [알선수익],
	--		(ISNULL(A.AIR_PROFIT, 0) + ISNULL(A.AIR_ETC_COM_PROFIT, 0) + ISNULL(A.AIR_ETC_COM_PRICE, 0)) AS [항공수익],
	--		(A.PERSON_PROFIT + A.AIR_ETC_PROFIT) AS [기타수익],
	--		(A.PERSON_ETC_PRICE + A.AGENT_COM_PRICE + A.PAY_COM_PRICE) AS [기타경비]
	--	FROM VIEW_SET_COMPLETE A WITH(NOLOCK)
	--	WHERE A.PRO_CODE = @PRO_CODE
	--)
	--SELECT @인당수익 = (((CASE WHEN  A.DEP_DATE < '2015-01-01' OR A.알선수익 > 0 THEN (A.알선수익 / 1.1) ELSE A.알선수익 END) + A.항공수익 + A.기타수익 - A.기타경비) / (CASE WHEN A.RES_COUNT = 0 THEN 1 ELSE A.RES_COUNT END))
	--FROM LIST A

	--RETURN @인당수익

	DECLARE @총수익 MONEY
	DECLARE @예약인원 INT

	SELECT @총수익 = DBO.FN_SET_GET_PRO_PROFIT(@PRO_CODE)
	SELECT @예약인원 = ISNULL(DBO.FN_SET_GET_PRO_COUNT(@PRO_CODE), 0)

	IF @예약인원 = 0 SET @예약인원 = 1

	RETURN @총수익 / @예약인원
	
END
GO
