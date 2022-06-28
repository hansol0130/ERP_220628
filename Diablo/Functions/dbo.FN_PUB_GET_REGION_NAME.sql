USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김성호
-- Create date: 2009.04.16
-- Description:	지역명을 리턴
-- =============================================
CREATE FUNCTION [dbo].[FN_PUB_GET_REGION_NAME]
(
	@REGION_CODE  VARCHAR(4)
)
RETURNS VARCHAR(80)
AS
BEGIN
	DECLARE @REGION_NAME VARCHAR(80)

	SELECT @REGION_NAME = KOR_NAME FROM PUB_REGION WITH(NOLOCK) WHERE REGION_CODE = @REGION_CODE

	RETURN (@REGION_NAME)

END

GO
