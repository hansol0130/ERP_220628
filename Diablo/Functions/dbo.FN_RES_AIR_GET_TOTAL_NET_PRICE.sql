USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name			: FN_RES_AIR_GET_TOTAL_NET_PRICE
■ Description				: 예약코드로 항공 총 NET 가격(유류,TAX제외) 불러온다.
■ Input Parameter			:                  
		@RES_CODE			: 
■ Select					: 
■ Author					: 
■ Date						: 2019-09-19

SELECT DBO.FN_RES_AIR_GET_TOTAL_NET_PRICE('RT1909193269')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2019-09-19		박형만			최초생성  
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_RES_AIR_GET_TOTAL_NET_PRICE]
(
	@RES_CODE VARCHAR(20)
)
RETURNS INT
AS
BEGIN
	DECLARE @TOTAL_PRICE INT;
	SET @TOTAL_PRICE = 0 
	IF EXISTS(SELECT 1 FROM RES_AIR_DETAIL  WITH(NOLOCK) WHERE RES_CODE = @RES_CODE)
	BEGIN
		SELECT @TOTAL_PRICE = (ISNULL(B.ADT_PRICE, 0)  * C.ADT_CNT)  + (ISNULL(B.CHD_PRICE, 0)  * C.CHD_CNT) + (ISNULL(B.INF_PRICE, 0)  * C.INF_CNT)  
		FROM RES_MASTER_DAMO A WITH(NOLOCK) 
		INNER JOIN RES_AIR_DETAIL B  WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		INNER JOIN 
		( 
			SELECT RES_CODE , 
			SUM(CASE WHEN AGE_TYPE = 0 THEN 1 ELSE 0 END) AS ADT_CNT , 
			SUM(CASE WHEN AGE_TYPE = 1 THEN 1 ELSE 0 END) AS CHD_CNT , 
			SUM(CASE WHEN AGE_TYPE = 2 THEN 1 ELSE 0 END) AS INF_CNT 
			FROM  RES_CUSTOMER_DAMO   WITH(NOLOCK)
			WHERE RES_CODE = @RES_CODE 
			AND RES_STATE = 0 
			GROUP BY RES_CODE 
		) C 
			ON A.RES_CODE = C.RES_CODE 
		WHERE A.RES_CODE = @RES_CODE;
	END
		
	RETURN @TOTAL_PRICE;
END
GO
