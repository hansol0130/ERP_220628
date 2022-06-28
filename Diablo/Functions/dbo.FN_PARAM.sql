USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_PARAM]
(    
    @RowData NVARCHAR(MAX),
	@KeyName NVARCHAR(100)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    DECLARE @FoundIndex INT
	DECLARE @FoundIndex2 INT
    SET @FoundIndex = CHARINDEX(@KeyName + '=',@RowData)

	-- 비슷한 이름의 키값에 잘못된 바인딩 수정
	IF @FoundIndex = 1 OR (@FoundIndex > 0 AND SUBSTRING(@RowData, @FoundIndex - 1, 1) = '&')
	BEGIN
		SET @FoundIndex2 = CHARINDEX('&', @RowData, @FoundIndex)

		IF @FoundIndex2 > 0 
		BEGIN
			RETURN SUBSTRING(@RowData, @FoundIndex + LEN(@KeyName) + 1, @FoundIndex2 - @FoundIndex - LEN(@KeyName) - 1)
		END
		ELSE
		BEGIN
			RETURN SUBSTRING(@RowData, @FoundIndex + LEN(@KeyName) + 1, 99999999)
		END
	END

	RETURN ''

END
GO
