USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: FN_SET_GET_PRO_PROFIT
■ DESCRIPTION				: 해당 행사의 총수익을 구한다.
■ INPUT PARAMETER			: 
	@PRO_CODE				: 행사코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	SELECT DBO.FN_SET_GET_PRO_PROFIT('KHH0HJ-150221')
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2009-12-03		이규식			최초생성
   2015-03-18		김성호			알선수익 금액과 상관없이 1.1로 나눔
   2015-03-19		김성호			ERP 정산서 기준으로 항공수익(AIR_ETC_PROFIT)을 알선수익에서 기타수익으로 이동
   2015-07-10		김성호			2015년 1월 1일기준 0원 이상만 부가세 계산되도록 수정
================================================================================================================*/ 
CREATE FUNCTION [dbo].[FN_SET_GET_PRO_PROFIT]
(
	@PRO_CODE VARCHAR(20)
)
RETURNS MONEY
AS
BEGIN

	/* 2015-03-18 정산서 기준식

	알선수익 : 판매금액(SALE_PRICE) - 총지출금 + 기타경비
	총지출금 : 항공비용(AIR_PRICE) + 지상비(LAND_PRICE) + 개인경비(PERSON_PRICE) + 공동경비(GROUP_PRICE) + 항공수익(AIR_PROFIT) + 기타경비 + 항공예외비용(AIR_ETC_PRICE)
	기타경비 : 개인기타경비(PERSON_ETC_PRICE) + 대리점수수료(AGENT_COM_PRICE) + 결제수수료(PAY_COM_PRICE)
	항공수익 : AIR_PROFIT + AIR_ETC_COM_PROFIT + AIR_ETC_COM_PRICE
	기타수익 : 개인수익(PERSON_PROFIT) + 항공수익(AIR_ETC_PROFIT)
	*/

	DECLARE @알선수익 MONEY
	DECLARE @항공수익 MONEY
	DECLARE @기타수익 MONEY
	DECLARE @기타경비 MONEY
	DECLARE @총수익 MONEY

	SELECT
		@알선수익 = ISNULL(SALE_PRICE,0) - (ISNULL(AIR_PRICE,0) + ISNULL(LAND_PRICE,0) + ISNULL(PERSON_PRICE,0) + ISNULL(GROUP_PRICE,0) + ISNULL(AIR_PROFIT,0) + ISNULL(AIR_ETC_PRICE,0)),
		@항공수익 = ISNULL(AIR_PROFIT,0) + ISNULL(AIR_ETC_COM_PROFIT,0) - ISNULL(AIR_ETC_COM_PRICE,0),
		@기타수익 = ISNULL(PERSON_PROFIT,0) + ISNULL(AIR_ETC_PROFIT,0),
		@기타경비 = ISNULL(PERSON_ETC_PRICE,0) + ISNULL(AGENT_COM_PRICE,0) + ISNULL(PAY_COM_PRICE,0)
	 FROM VIEW_SET_COMPLETE  WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE

	--SELECT
	--	@알선수익 = ISNULL(SALE_PRICE,0) - (ISNULL(AIR_PRICE,0) + ISNULL(LAND_PRICE,0) + ISNULL(PERSON_PRICE,0) + ISNULL(GROUP_PRICE,0) + ISNULL(AIR_PROFIT,0) + ISNULL(AIR_ETC_PRICE,0) - ISNULL(AIR_ETC_PROFIT,0)),
	--	@항공수익 = ISNULL(AIR_PROFIT,0) + ISNULL(AIR_ETC_COM_PROFIT,0) - ISNULL(AIR_ETC_COM_PRICE,0),
	--	@기타수익 = ISNULL(PERSON_PROFIT,0),
	--	@기타경비 = ISNULL(PERSON_ETC_PRICE,0) + ISNULL(AGENT_COM_PRICE,0) + ISNULL(PAY_COM_PRICE,0)
	-- FROM VIEW_SET_COMPLETE  WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE

	-- 2015-03-18 주석 처리
	--IF (@알선수익 < 11000)
	--BEGIN
	--	RETURN ISNULL(@알선수익,0) + ISNULL(@항공수익,0) + ISNULL(@기타수익,0) - ISNULL(@기타경비,0)
	--END

	-- 회계마감 후 5년간 금액 변경이 불가하여 2015년 기준으로 양수에만 부가세 계산
	SELECT @총수익 = ((CASE WHEN A.DEP_DATE < '2015-01-01' OR @알선수익 > 0 THEN (@알선수익/1.1) ELSE @알선수익 END) + @항공수익 + @기타수익 - @기타경비)
	FROM PKG_DETAIL A WITH(NOLOCK)
	WHERE A.PRO_CODE = @PRO_CODE

	RETURN @총수익

--	RETURN (ISNULL(@알선수익,0)/1.1)+ ISNULL(@항공수익,0) + ISNULL(@기타수익,0) - ISNULL(@기타경비,0)
	
END


GO
