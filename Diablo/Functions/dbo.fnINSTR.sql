USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fnINSTR] 
( 
@Start INTEGER = 1 --시작
, @String1 nvarchar(4000) --문자열1
, @String2 nvarchar(4000) --문자열2
)
RETURNS INTEGER
AS
BEGIN
WHILE LEN(@String1) - @Start > = 0
BEGIN 
	IF SUBSTRING(@String1, @Start, LEN(@String2)) = @String2 
		BREAK
	
	SET @Start = @Start + 1 
END
IF @Start > LEN(@String1) 
	SELECT @Start = 0

RETURN @Start
END
GO
