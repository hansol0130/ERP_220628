USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이규식
-- Create date: 2010-5-3
-- Description:	고객 주민번호로 연령대 알기
-- =============================================
CREATE FUNCTION [dbo].[FN_GET_AGE_TYPE]
(
	@AGE CHAR(6)
)
RETURNS INT
AS
BEGIN
	DECLARE @BIRTH INT
	DECLARE @YEAR INT

	IF ISNUMERIC(@AGE) = 0 RETURN 0

		SET @YEAR = DATEPART(yyyy, GETDATE())
		SET @BIRTH = SUBSTRING(@AGE, 1, 2)

		IF @BIRTH = 0 SET @BIRTH = 2000
		ELSE SET @BIRTH = 1900 + @BIRTH

		SET @BIRTH = @YEAR - @BIRTH + 1

		
		RETURN 
			CASE 
				WHEN @BIRTH < 20 THEN 10
				WHEN @BIRTH >= 20 AND @BIRTH < 30 THEN 20
				WHEN @BIRTH >= 30 AND @BIRTH < 40 THEN 30
				WHEN @BIRTH >= 40 AND @BIRTH < 50 THEN 40
				WHEN @BIRTH >= 50 AND @BIRTH < 60 THEN 50
				WHEN @BIRTH >= 60 THEN 60
				ELSE 0
			END

END
GO
