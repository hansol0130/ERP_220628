USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_GET_THREE_PART_PHONE_NUMBER
■ Description				: 전화번호를 지역번호, 국번호, 개별번호로 분리
							: 11자리 이하의 국내 전화번호만 처리 가능, 15자리 보다 큰 수는 제외
■ Input Parameter			:                  
		@PHONE_NUMBERS		: 전화번호 묶음
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT * fROM DBO.XN_GET_THREE_PART_PHONE_NUMBER('01036865331,01033922419,07089932463,0222993416,01026731971,0315581997,029821322,01036865331999', ',')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2015-01-13		김성호			최초생성
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_GET_THREE_PART_PHONE_NUMBER]
(	
	@PHONE_NUMBERS	VARCHAR(1000),
	@DELIMETER		 VARCHAR(1)
)
RETURNS @RTNVALUE TABLE 
(
	ID			INT,
	DATA		VARCHAR(15),
	TEL1		VARCHAR(4),
	TEL2		VARCHAR(4),
	TEL3		VARCHAR(4)
) 
AS
BEGIN

	INSERT INTO @RTNVALUE (ID, DATA, TEL1, TEL2, TEL3)
	SELECT A.*,
		(CASE
			WHEN LEN(DATA) = 9 THEN SUBSTRING(DATA, 1,2)
			WHEN LEN(DATA) = 10 AND SUBSTRING(DATA, 1,2) = '02' THEN SUBSTRING(DATA, 1,2)
			WHEN LEN(DATA) = 10 AND SUBSTRING(DATA, 1,2) <> '02' THEN SUBSTRING(DATA, 1,3)
			WHEN LEN(DATA) = 11 THEN SUBSTRING(DATA, 1,3)
		END) AS TEL1, 
		(CASE
			WHEN LEN(DATA) = 9 THEN SUBSTRING(DATA, 3,3)
			WHEN LEN(DATA) = 10 AND SUBSTRING(DATA, 1,2) = '02' THEN SUBSTRING(DATA, 3,4)
			WHEN LEN(DATA) = 10 AND SUBSTRING(DATA, 1,2) <> '02' THEN SUBSTRING(DATA, 4,3)
			WHEN LEN(DATA) = 11 THEN SUBSTRING(DATA, 4,4)
		END) AS TEL2,
		(CASE
			WHEN LEN(DATA) = 9 THEN SUBSTRING(DATA, 6,4)
			WHEN LEN(DATA) = 10 THEN SUBSTRING(DATA, 7,4)
			WHEN LEN(DATA) = 11 THEN SUBSTRING(DATA, 8,4)
		END) AS TEL3
	FROM DIABLO.DBO.FN_SPLIT(@PHONE_NUMBERS, @DELIMETER) A
	WHERE LEN(DATA) <= 15

	RETURN
	 
END




GO
