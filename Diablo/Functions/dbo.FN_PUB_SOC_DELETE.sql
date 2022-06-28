USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- AUTHOR:		김 성 호
-- CREATE DATE: 2015-08-11
-- DESCRIPTION:	주민번호 제거
-- =============================================
CREATE FUNCTION [dbo].[FN_PUB_SOC_DELETE]
(
	@BEFORE	NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

	DECLARE @AFTER NVARCHAR(MAX)

	SET @AFTER = ''

	WHILE(@BEFORE <> '')
	BEGIN
		IF @BEFORE LIKE '[0-9][0-9][0-1][0-9][0-3][0-9]-[1-4][0-9][0-9][0-9][0-9][0-9][0-9]%'
		BEGIN
			SELECT @BEFORE = SUBSTRING(@BEFORE, 15, LEN(@BEFORE))
		END
		ELSE
		BEGIN
			SELECT @AFTER = @AFTER + SUBSTRING(@BEFORE, 1, 1)
			SELECT @BEFORE = SUBSTRING(@BEFORE, 2, LEN(@BEFORE))
		END
	END

	RETURN (@AFTER)
END
GO
