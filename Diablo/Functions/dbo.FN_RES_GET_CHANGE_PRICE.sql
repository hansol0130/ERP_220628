USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_RES_GET_CHANGE_PRICE
■ Description				: 예약 총 변동금액(서비스수수료) 리턴
■ Input Parameter			:                  
		@RES_CODE			: 예약코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

	SELECT DBO.FN_RES_GET_CHANGE_PRICE('RP1009018256')

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2016-04-26		김성호			BTMS 서비스 수수료 항목 변동금액 컬럼 사용으로 해당 항목만 가져오는 함수 필요
-------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[FN_RES_GET_CHANGE_PRICE]
(
	@RES_CODE VARCHAR(20)
)

RETURNS DECIMAL

AS

BEGIN
	DECLARE @CHANGE_PRICE DECIMAL

	-- CHANGE_PRICE는 변동금액

	SELECT @CHANGE_PRICE = SUM(SUM_CHG_PRICE)
	FROM (
		SELECT ISNULL(SUM(CAST(B.CHG_PRICE AS DECIMAL)), 0.0) AS [SUM_CHG_PRICE]
		FROM RES_MASTER_damo A WITH(NOLOCK)
		INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		WHERE A.RES_CODE = @RES_CODE AND A.PRO_TYPE <> 3 AND B.RES_STATE IN (0, 3, 4)
		UNION ALL
		-- 호텔
		SELECT ISNULL(SUM(CAST(CHG_PRICE AS DECIMAL)), 0.0) AS [SUM_CHG_PRICE]
		FROM RES_HTL_ROOM_MASTER A WITH(NOLOCK)
		INNER JOIN RES_MASTER_DAMO B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		WHERE B.RES_CODE = @RES_CODE AND B.RES_STATE NOT IN (8, 9)  --이동제외 
	) A
	
	RETURN (@CHANGE_PRICE)
END
GO
