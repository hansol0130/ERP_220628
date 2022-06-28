USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김성호
-- Create date: 2009.04.16
-- Description:	주명을 리턴
-- =============================================
CREATE FUNCTION [dbo].[FN_PUB_GET_STATE_NAME]
(
	@NATION_CODE	VARCHAR(4),
	@STATE_CODE		VARCHAR(4)
)
RETURNS VARCHAR(80)
AS
BEGIN
	DECLARE @STATE_NAME VARCHAR(80)

	SELECT @STATE_NAME = KOR_NAME FROM PUB_STATE WITH(NOLOCK)  WHERE NATION_CODE = @NATION_CODE AND STATE_CODE = @STATE_CODE

	RETURN (@STATE_NAME)

END
GO
