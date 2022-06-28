USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[XP_HOLIDAY_INSERT]
	@XML XML
AS 
BEGIN
	INSERT INTO PUB_HOLIDAY (HOLIDAY, HOLIDAY_NAME, IS_HOLIDAY, NEW_CODE, NEW_DATE)
	SELECT
		t1.col.value('./DayString[1]', 'varchar(12)'),
		t1.col.value('./Name[1]', 'varchar(20)'),
		t1.col.value('./IsHoliday[1]', 'char(1)'),
		'9999999',
		GETDATE()
	FROM @xml.nodes('/DocumentElement/DayList/DayInfo') as t1(col)
END
GO
