USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ FUNCTION_NAME				: FN_SPLIT_NUMBER
■ DESCRIPTION				: 자리 수로 문자열 나누기
■ INPUT PARAMETER			:                  
		@ROWDATA			: 대상문자열
		@DIGIT				: 자리 수
■ OUTPUT PARAMETER			: 
■ OUTPUT VALUE				: 
■ EXEC						: 
---------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
---------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
---------------------------------------------------------------------------------------------------
	2015-10-12		김성호			최초생성 (에어부산으로 인해 / 삭제)
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[FN_SPLIT_NUMBER]
(    
    @ROWDATA NVARCHAR(1000),
	@DIGIT INT
)
RETURNS @RTNVALUE TABLE 
(
    ID INT IDENTITY(1,1),
    DATA NVARCHAR(100)
) 
AS
BEGIN
	DECLARE @TEMPSTRING NVARCHAR(1500)

	SELECT @TEMPSTRING = REPLACE(ISNULL(@ROWDATA, ''), '/', '')

	WHILE (LEN(@TEMPSTRING) > @DIGIT)
	BEGIN
		INSERT INTO @RTNVALUE (DATA)
		SELECT DATA = SUBSTRING(@TEMPSTRING, 1, @DIGIT)
		SELECT @TEMPSTRING = SUBSTRING(@TEMPSTRING, 1+@DIGIT, LEN(@TEMPSTRING))
	END

    INSERT INTO @RTNVALUE (DATA)
    SELECT DATA = @TEMPSTRING

    RETURN
END

GO
