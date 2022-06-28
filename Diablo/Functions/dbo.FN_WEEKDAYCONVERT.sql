USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		이규식
-- Create date: 2009-11-26
-- Description:	1234567 -> 1111111
-- Description:	4567 -> 100111
-- Description:	1->월요일, 7->일요일 형식을 일월화수목금토(1111111) 형식으로 변경한다.
-- =============================================
CREATE FUNCTION [dbo].[FN_WEEKDAYCONVERT]
(
	@WEEKDAY	VARCHAR(7)
)
RETURNS VARCHAR(7)
AS
BEGIN
	DECLARE @RESULT VARCHAR(7)

	IF ISNULL(@WEEKDAY, '') = ''
	BEGIN
		RETURN '1111111'
	END
	ELSE 
	BEGIN
		SET @RESULT = ''

		-- 일요일		
		IF CHARINDEX('7', @WEEKDAY) = 0 SET @RESULT = '0'
		ELSE SET @RESULT = '1'

		-- 월요일
		IF CHARINDEX('1', @WEEKDAY) = 0 SET @RESULT = @RESULT + '0'
		ELSE SET @RESULT = @RESULT + '1'

		-- 화요일
		IF CHARINDEX('2', @WEEKDAY) = 0 SET @RESULT = @RESULT + '0'
		ELSE SET @RESULT = @RESULT + '1'

		-- 수요일
		IF CHARINDEX('3', @WEEKDAY) = 0 SET @RESULT = @RESULT + '0'
		ELSE SET @RESULT = @RESULT + '1'

		-- 목요일
		IF CHARINDEX('4', @WEEKDAY) = 0 SET @RESULT = @RESULT + '0'
		ELSE SET @RESULT = @RESULT + '1'

		-- 금요일
		IF CHARINDEX('5', @WEEKDAY) = 0 SET @RESULT = @RESULT + '0'
		ELSE SET @RESULT = @RESULT + '1'

		-- 토요일
		IF CHARINDEX('6', @WEEKDAY) = 0 SET @RESULT = @RESULT + '0'
		ELSE SET @RESULT = @RESULT + '1'

	END

	RETURN @RESULT;
END

GO
