USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- AUTHOR:		박 형 만
-- CREATE DATE: 2013-10-21
-- DESCRIPTION:	생년월일로 주민번호 가져오기 
-- select dbo.FN_CUS_GET_SOC_NUM1_BY_BIRTH('1980-01-01')
-- 2013-10-21 생년월일로 주민번호 채워넣기
-- =============================================
CREATE FUNCTION [dbo].[FN_CUS_GET_SOC_NUM1_BY_BIRTH]
(
	@BIRTH_DATE  DATETIME	  -- 생년월일 
)
RETURNS VARCHAR(6)
AS
BEGIN
	DECLARE @SOC_NUM1 VARCHAR(6)
	IF @BIRTH_DATE IS NOT NULL 
	BEGIN
		SET @SOC_NUM1 = RIGHT(CONVERT(VARCHAR(8),@BIRTH_DATE,112),6)
	END 
	RETURN @SOC_NUM1
END 
GO
