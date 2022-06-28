USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이규식
-- Create date: 2009-11-25
-- Description:	해당 행사가 수익인지 마이너스 수익인지를 판별한다.
-- =============================================
CREATE FUNCTION [dbo].[FN_SET_IS_PROFIT]
(
	@PRO_CODE VARCHAR(20)
)
RETURNS CHAR(1)
AS
BEGIN
	DECLARE @알선수익 MONEY
	SELECT
		@알선수익 = SALE_PRICE - (AIR_PRICE + LAND_PRICE + PERSON_PRICE + GROUP_PRICE + AIR_PROFIT + 
		AIR_ETC_PRICE - AIR_ETC_PROFIT)
	 FROM VIEW_SET_COMPLETE  WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE

	IF (@알선수익 < 11000) RETURN 'N'
	
	RETURN 'Y'	
END
GO
