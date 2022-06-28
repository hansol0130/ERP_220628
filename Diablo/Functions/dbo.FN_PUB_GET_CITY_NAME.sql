USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김성호
-- Create date: 2009.03.18
-- Description:	도시명을 리턴
-- =============================================
CREATE FUNCTION [dbo].[FN_PUB_GET_CITY_NAME]
(
	@CITY_CODE  VARCHAR(3)
)
RETURNS VARCHAR(80)
AS
BEGIN
	DECLARE @CITY_NAME VARCHAR(80)

	SELECT @CITY_NAME = KOR_NAME FROM PUB_CITY WITH(NOLOCK) WHERE CITY_CODE = @CITY_CODE

	RETURN (@CITY_NAME)

END
GO
