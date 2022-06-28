USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김성호
-- Create date: 2009.04.16
-- Description:	국가명을 리턴
-- =============================================
CREATE FUNCTION [dbo].[FN_PUB_GET_NATION_NAME]
(
	@NATION_CODE  VARCHAR(4)
)
RETURNS VARCHAR(80)
AS
BEGIN
	DECLARE @NATION_NAME VARCHAR(80)

	SELECT @NATION_NAME = KOR_NAME FROM PUB_NATION WITH(NOLOCK) WHERE NATION_CODE = @NATION_CODE

	RETURN (@NATION_NAME)

END

GO
