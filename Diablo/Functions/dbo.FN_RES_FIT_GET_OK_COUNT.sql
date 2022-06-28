USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_RES_FIT_GET_OK_COUNT
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

CREATE FUNCTION [dbo].[FN_RES_FIT_GET_OK_COUNT]
(
	@GRP_RES_CODE	VARCHAR(20),
	@FLAG			INT
)

RETURNS INT

AS

	BEGIN
		DECLARE @COUNT INT

		SELECT @COUNT = COUNT(*)
		FROM RES_CUSTOMER_DAMO WITH(NOLOCK) 
		WHERE RES_CODE IN (SELECT RES_CODE
						   FROM RES_MASTER_DAMO WITH(NOLOCK) 
						   WHERE GRP_RES_CODE = @GRP_RES_CODE
							 AND PRO_TYPE = CASE @FLAG WHEN 0 THEN PRO_TYPE ELSE @FLAG END)
		  AND RES_STATE = 0
		  AND SEAT_YN = 'Y'

		RETURN (@COUNT)
	END
GO
