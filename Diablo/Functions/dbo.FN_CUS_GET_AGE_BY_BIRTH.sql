USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- AUTHOR:		박형만
-- CREATE DATE: 2014.04.11
-- DESCRIPTION:	생년월일과 출발일로 만 나이(보험나이) 계산
-- ISDATE 추가 (2014-10-13)
-- SELECT DBO.FN_CUS_GET_AGE_BY_BIRTH('2013-04-12','2014-04-11')
-- =============================================
CREATE FUNCTION [dbo].[FN_CUS_GET_AGE_BY_BIRTH]
(
	@BIRTH_DATE DATETIME,	  -- 생년월일 2010-01-01
	@DEP_DATE DATETIME        -- 출발날짜 2014-04-15
)
RETURNS INT
AS
BEGIN
	DECLARE @INS_AGE INT

	IF @BIRTH_DATE IS NOT NULL AND ISDATE(@BIRTH_DATE) = 1
	BEGIN
		SELECT @INS_AGE = DATEDIFF("dd",@BIRTH_DATE, @DEP_DATE) / 365
	END
	ELSE
	BEGIN
		SELECT @INS_AGE = -1
	END
	
	RETURN (@INS_AGE);
END
GO
