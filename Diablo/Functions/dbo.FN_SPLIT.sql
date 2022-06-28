USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_SPLIT]
(    
    @RowData NVARCHAR(MAX),
    @Delimeter NVARCHAR(100)
)
RETURNS @RtnValue TABLE 
(
    ID INT IDENTITY(1,1),
    Data NVARCHAR(MAX)
) 
AS
BEGIN 
    DECLARE @FoundIndex INT
    SET @FoundIndex = CHARINDEX(@Delimeter,@RowData)

    WHILE (@FoundIndex>0)
    BEGIN
        INSERT INTO @RtnValue (data)
        SELECT 
            Data = LTRIM(RTRIM(SUBSTRING(@RowData, 1, @FoundIndex - 1)))

        SET @RowData = SUBSTRING(@RowData,
                @FoundIndex + DATALENGTH(@Delimeter) / 2,
                LEN(@RowData))

        SET @FoundIndex = CHARINDEX(@Delimeter, @RowData)
    END
    
    INSERT INTO @RtnValue (Data)
    SELECT Data = LTRIM(RTRIM(@RowData))

    RETURN
END
GO
