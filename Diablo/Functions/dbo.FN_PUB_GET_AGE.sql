USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- AUTHOR:		김성호
-- CREATE DATE: 2009.06.12
-- DESCRIPTION:	주민번호로 나이 리턴
-- =============================================
CREATE FUNCTION [dbo].[FN_PUB_GET_AGE]
(
	@JUMIN  VARCHAR(20),	-- 주민번호
	@FLAG	INT				-- 0 일반나이, 1 만나이
)
RETURNS INT
AS
BEGIN
	DECLARE @TEMP INT, @AGE INT

	-- 오늘의날짜중년도에서주민번호앞2자리를뺀다

	SET @TEMP = YEAR(GETDATE()) - CONVERT(INT, LEFT(@JUMIN, 2)) + 1

	/*	한국나이 : 오늘년도-주민번호앞자리가2000이넘으면2000을빼주고그렇지않으면1900을빼준다.
		만나이 : 한국나이에서생일이지났으면-1 ,안지났으면-2 살을빼준다	*/

	SELECT @AGE = (CASE WHEN @TEMP > 2000 THEN @TEMP - 2000 ELSE @TEMP - 1900 END);
	
	IF @FLAG > 0
	BEGIN
		SELECT @AGE = (
			CASE
				WHEN SUBSTRING(CONVERT(CHAR(10),GETDATE(),112),5,4) <= SUBSTRING(@JUMIN,3,4) THEN @AGE - 2
				ELSE @AGE - 1
			END )
	END

	RETURN (@AGE);

END
GO
