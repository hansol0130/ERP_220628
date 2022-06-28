USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_RES_FIT_GET_PAY_PRICE
■ Description				: 
■ Input Parameter			:             
		@GRP_RES_CODE		: 
		@FLAG				:
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

CREATE FUNCTION [dbo].[FN_RES_FIT_GET_PAY_PRICE]
(
	@GRP_RES_CODE	VARCHAR(20),
	@FLAG			INT
)

RETURNS INT

AS

	BEGIN
		DECLARE @PAY_PRICE INT
		
		SELECT @PAY_PRICE = ISNULL(SUM(PART_PRICE), 0)
		FROM PAY_MATCHING A WITH(NOLOCK) 
		WHERE RES_CODE IN (SELECT RES_CODE
						   FROM RES_MASTER_DAMO WITH(NOLOCK) 
						   WHERE GRP_RES_CODE = @GRP_RES_CODE
							 AND RES_STATE IN (0, 3, 4)
							 AND PRO_TYPE = CASE @FLAG WHEN 0 THEN PRO_TYPE ELSE @FLAG END)
		  AND CXL_YN = 'N';
		-- 예약, 환불, 페널티
		
		RETURN (@PAY_PRICE)
	END
GO
