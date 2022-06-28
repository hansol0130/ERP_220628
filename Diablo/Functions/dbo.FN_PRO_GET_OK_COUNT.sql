USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_PRO_GET_OK_COUNT
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

CREATE FUNCTION [dbo].[FN_PRO_GET_OK_COUNT]
(
	@PRO_CODE VARCHAR(20)
)

RETURNS INT

AS

	BEGIN

		DECLARE @COUNT INT

		SELECT @COUNT = COUNT(*) FROM RES_CUSTOMER_DAMO WITH(NOLOCK) 
		WHERE RES_CODE IN (
			SELECT RES_CODE FROM RES_MASTER_DAMO  WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE
		) AND RES_STATE = 0 AND SEAT_YN = 'Y'

		RETURN (@COUNT)
	END
GO
