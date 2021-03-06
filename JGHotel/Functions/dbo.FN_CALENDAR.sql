USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_CALENDAR](@FROM_DATE DATETIME, @TO_DATE DATETIME)
RETURNS @RETURN_TABLE TABLE (T_DATE DATETIME)
AS
BEGIN
    DECLARE @D DATETIME
    SET @D = @FROM_DATE

    DECLARE @DAYS VARCHAR(MAX)
    SET @DAYS =  ''

    WHILE (@D <= @TO_DATE)
    BEGIN
        SET @DAYS = @DAYS + ',' + CONVERT(VARCHAR(10), @D, 121)
        SET @D = DATEADD(DAY, 1, @D);
    END

    INSERT @RETURN_TABLE
    SELECT VALUE AS T_DATE FROM fn_Split(RIGHT(@DAYS, LEN(@DAYS) - 1), ',')

    RETURN
END
GO
