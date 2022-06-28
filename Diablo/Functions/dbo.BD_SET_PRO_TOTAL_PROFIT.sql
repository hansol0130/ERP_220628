USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Function_Name				: BD_SET_PRO_TOTAL_PROFIT
■ Description				: 정산수익공식 
■ Input Parameter			:                  
	@@PRO_CODE				: 주민번호 앞자리 790703
	 
■ Exec						: 
	SELECT dbo.BD_SET_PRO_TOTAL_PROFIT('AFP271-150214KE4' )  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2015-09-02		윤병도			정산수익공식 
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[BD_SET_PRO_TOTAL_PROFIT]
(
	--@SOC_NUM1  VARCHAR(6),	  -- 주민번호 790703
	--@SOC_NUM2  VARCHAR(7),	  -- 주민번호 뒷자리
	
	@PRO_CODE VARCHAR(20)
)
RETURNS MONEY
AS
BEGIN

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

	RETURN (@총수익);
END

GO
