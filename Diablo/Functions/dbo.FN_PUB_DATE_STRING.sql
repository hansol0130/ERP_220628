USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- AUTHOR:		김 성 호
-- CREATE DATE: 2014-01-07
-- DESCRIPTION:	시간으로 일자 계산
-- =============================================
CREATE FUNCTION [dbo].[FN_PUB_DATE_STRING]
(
	@HOUR INT
)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @DATE_STRING VARCHAR(20), @DAY INT

	SELECT @DAY = @HOUR / 24, @HOUR = @HOUR % 24

	SELECT @DATE_STRING = (CASE WHEN @DAY > 0 THEN (CONVERT(VARCHAR(3), @DAY) + ' 일 ') ELSE '' END) + (CONVERT(VARCHAR(2), @HOUR) + ' 시')
	
	RETURN (@DATE_STRING);
END

GO
