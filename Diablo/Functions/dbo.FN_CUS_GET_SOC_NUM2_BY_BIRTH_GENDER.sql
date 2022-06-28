USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- AUTHOR:		박 형 만
-- CREATE DATE: 2013-10-21
-- DESCRIPTION:	생년월일,성별로 주민번호 뒷자리 가져오기 
-- select dbo.FN_CUS_GET_SOC_NUM2_BY_BIRTH_GENDER('1980-01-01','M')
-- =============================================
CREATE FUNCTION [dbo].[FN_CUS_GET_SOC_NUM2_BY_BIRTH_GENDER]
(
	@BIRTH_DATE  DATETIME,  -- 생년월일 
	@GENDER CHAR(1) 
)
RETURNS VARCHAR(6)
AS
BEGIN
	DECLARE @SOC_NUM2 VARCHAR(7)
	IF @BIRTH_DATE IS NOT NULL 
		AND ISNULL( @GENDER,'') <> '' 
	BEGIN
	
		SET @SOC_NUM2 = CASE WHEN @BIRTH_DATE BETWEEN '1800-01-01' AND '1899-12-31' THEN 
				CASE WHEN @GENDER ='M' THEN '9' ELSE '0' END 
			 WHEN @BIRTH_DATE BETWEEN '1900-01-01' AND '1999-12-31' THEN 
				CASE WHEN @GENDER ='M' THEN '1' ELSE '2' END 
			 WHEN @BIRTH_DATE BETWEEN '2000-01-01' AND '2999-12-31' THEN 
				CASE WHEN @GENDER ='M' THEN '3' ELSE '4' END 
			END 
	END 
	RETURN @SOC_NUM2
END 
GO