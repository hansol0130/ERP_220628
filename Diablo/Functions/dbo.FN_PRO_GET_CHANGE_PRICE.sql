USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_PRO_GET_CHANGE_PRICE
■ Description				: 행사 총 변동금액(서비스수수료) 리턴
■ Input Parameter			:                  
		@PRO_CODE			: 행사코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

	SELECT DBO.FN_PRO_GET_CHANGE_PRICE('JHH29064-1306071605')

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2016-04-19		김성호			BTMS 서비스 수수료 항목 변동금액 컬럼 사용으로 해당 항목만 가져오는 함수 필요
-------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[FN_PRO_GET_CHANGE_PRICE]
(
	@PRO_CODE VARCHAR(20)
)

RETURNS DECIMAL

AS

BEGIN
	DECLARE @CHANGE_PRICE DECIMAL

	-- CHANGE_PRICE는 변동금액

	--국내온라인항공
	IF( @PRO_CODE LIKE 'KTR0%' )
	BEGIN
		
		SELECT @CHANGE_PRICE = ISNULL(SUM(CAST(CHG_PRICE AS DECIMAL)), 0.0)
		FROM RES_CUSTOMER_DAMO A WITH(NOLOCK)
		WHERE A.RES_CODE IN 
		(
			SELECT RES_CODE FROM PAY_MATCHING WITH(NOLOCK) 
			WHERE PRO_CODE = @PRO_CODE 
		)  --국내항공 전체 상태

	END 
	ELSE 
	BEGIN
	
		SELECT @CHANGE_PRICE = SUM(SUM_CHG_PRICE)
		FROM (
			SELECT ISNULL(SUM(CAST(CHG_PRICE AS DECIMAL)), 0.0) AS [SUM_CHG_PRICE]
			FROM RES_CUSTOMER_DAMO WITH(NOLOCK) 
			WHERE RES_CODE IN (SELECT RES_CODE FROM RES_MASTER_DAMO  WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE AND PRO_TYPE <> 3)
			AND RES_STATE IN (0, 3, 4) -- 예약, 환불, 페널티
			UNION ALL
			-- 호텔
			SELECT ISNULL(SUM(CAST(CHG_PRICE AS DECIMAL)), 0.0) AS [SUM_CHG_PRICE]
			FROM RES_HTL_ROOM_MASTER A WITH(NOLOCK)
			INNER JOIN RES_MASTER_DAMO B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
			WHERE B.PRO_CODE = @PRO_CODE AND B.RES_STATE NOT IN (8, 9)  --이동제외 
		) A
	END 
	
	RETURN (@CHANGE_PRICE)
END
GO
