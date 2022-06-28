USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_RES_AIR_GET_TOTAL_PRICE
■ Description				: 그룹코드로 항공 총 판매가격을 불러온다.
■ Input Parameter			:                  
		@GRP_RES_CODE		: 그룹코드
■ Select					: 
■ Author					: 문태중
■ Date						: 2008-02-03  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2008-02-03		문태중			최초생성  
-------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[FN_RES_AIR_GET_TOTAL_PRICE]
(
	@GRP_RES_CODE VARCHAR(20)
)

RETURNS INT

AS

	BEGIN
		DECLARE @TOTAL_PRICE INT;

		IF EXISTS(SELECT 1 FROM RES_MASTER_DAMO  WITH(NOLOCK) WHERE GRP_RES_CODE = @GRP_RES_CODE)
		BEGIN
			SELECT @TOTAL_PRICE = SUM(ISNULL(B.ADT_PRICE,0) + ISNULL(B.CHD_PRICE,0) + ISNULL(B.INF_PRICE,0)
					 + ISNULL(B.ADT_TAX,0) + ISNULL(B.CHD_TAX,0) + ISNULL(B.INF_TAX,0))
			FROM RES_MASTER_DAMO A WITH(NOLOCK) 
			INNER JOIN RES_AIR_DETAIL B  WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
			WHERE A.GRP_RES_CODE = @GRP_RES_CODE;
		END
		ELSE
		BEGIN
			SET @TOTAL_PRICE = 0;
		END
		
		RETURN @TOTAL_PRICE;
	END
GO
