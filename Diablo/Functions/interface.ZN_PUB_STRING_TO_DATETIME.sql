USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: [interface].[ZN_PUB_STRING_TO_DATETIME]
■ Description				: 항공 데이터 문자열 datetime 형변환 
■ Input Parameter			: 

	@DATESTRING	VARCHAR(20)	: 변환할 문자열 (YYYYMMDDhhmmss)

■ Output Parameter			:      
■ Output Value				:                 
■ Exec						: 

	SELECT [interface].[ZN_PUB_STRING_TO_DATETIME]('20210120')
	
	SELECT [interface].[ZN_PUB_STRING_TO_DATETIME]('202101201709')
	
	SELECT [interface].[ZN_PUB_STRING_TO_DATETIME]('2021')

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2021-01-12		김성호			최초생성
	2022-03-18		김성호			2400 DATETIME 형변환 오류 예외처리 추가
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [interface].[ZN_PUB_STRING_TO_DATETIME]
(
	@DATESTRING	VARCHAR(14)
)
RETURNS DATETIME
AS
BEGIN
	
	DECLARE @CON_DATE DATETIME
	
	-- 2400 형변환오류로 입력값 수정
	IF LEN(@DATESTRING) >= 12 AND @DATESTRING LIKE '________2400%'
	BEGIN
		SELECT @DATESTRING = CONVERT(VARCHAR(8), DATEADD(DD, 1, CONVERT(DATE, SUBSTRING(@DATESTRING, 1, 8))), 112) + '0000' + SUBSTRING(@DATESTRING, 13, 2) 
	END
	
	-- 형 변환 오류에 따른 예외처리
	SELECT @CON_DATE =
		CASE LEN(@DATESTRING)
			WHEN 8 THEN CONVERT(DATETIME, @DATESTRING)
			WHEN 12 THEN CONVERT(DATETIME, (SUBSTRING(@DATESTRING, 1, 8) + ' ' + SUBSTRING(@DATESTRING, 9, 2) + ':' + SUBSTRING(@DATESTRING, 11, 2)))
			WHEN 14 THEN CONVERT(DATETIME, (SUBSTRING(@DATESTRING, 1, 8) + ' ' + SUBSTRING(@DATESTRING, 9, 2) + ':' + SUBSTRING(@DATESTRING, 11, 2) + ':' + SUBSTRING(@DATESTRING, 13, 2)))
			ELSE NULL
		END
	
	RETURN(@CON_DATE)
	
END

GO
