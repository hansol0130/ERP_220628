USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_RES_FIT_IS_SEAT]
(
	@GRP_RES_CODE	VARCHAR(20),
	@FLAG			INT
)
RETURNS CHAR(1)
AS
BEGIN

	DECLARE @YN CHAR(1)

	SELECT @YN = MIN(SEAT_YN) FROM RES_CUSTOMER_DAMO WITH(NOLOCK) 
	WHERE RES_CODE IN (SELECT RES_CODE FROM RES_MASTER_DAMO  WITH(NOLOCK) WHERE GRP_RES_CODE = @GRP_RES_CODE
						AND PRO_TYPE = CASE @FLAG WHEN 0 THEN PRO_TYPE ELSE @FLAG END)
		  AND RES_STATE = 0
	GROUP BY RES_CODE

	RETURN (@YN)
END
GO
