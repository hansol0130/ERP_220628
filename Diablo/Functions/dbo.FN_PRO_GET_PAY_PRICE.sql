USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_PRO_GET_PAY_PRICE
■ Description				: 
■ Input Parameter			:                  
		@PRO_CODE			: 행사코드
■ Select					: 
■ Author					: 
■ Date						:   
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
									최초생성  
-------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[FN_PRO_GET_PAY_PRICE]
(
	@PRO_CODE VARCHAR(20)
)

RETURNS DECIMAL

AS

	BEGIN
		DECLARE @PAY_PRICE DECIMAL
		
		SELECT @PAY_PRICE = ISNULL(SUM(CONVERT(DECIMAL, PART_PRICE)), 0)
		FROM PAY_MATCHING A  WITH(NOLOCK) 
		WHERE A.RES_CODE IN (SELECT RES_CODE FROM RES_MASTER_DAMO  WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
		  AND CXL_YN = 'N'
	--	AND EXISTS(SELECT 1 FROM RES_MASTER_DAMO WHERE RES_CODE = A.RES_CODE AND RES_STATE NOT IN (8, 9))
		-- 예약, 환불, 페널티
		
		RETURN (@PAY_PRICE)
	END
GO
