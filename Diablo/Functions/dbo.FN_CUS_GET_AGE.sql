USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_CUS_GET_AGE
■ Description				: 주민번호로 나이 계산
■ Input Parameter			: 
	@BIRTH_DATE				: 생년월일
	@DEP_DATE				: 기준일자       
■ Exec						: 


	SELECT dbo.FN_CUS_GET_AGE('1977-09-12', '2017-10-04')

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2010-09-14		김성호			최초생성
	2014-01-14		박형만			주민번호 뒷자리 1자리 일때도 계산되도록
	2015-03-03		김성호			주민번호 삭제, 생년월일 추가
	2016-09-08		김성호			만나이 계산법 수정
	2017-01-04		김성호			오류 수정
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_CUS_GET_AGE]
(
	@BIRTH_DATE	DATETIME,
	@DEP_DATE	DATETIME        -- 출발날짜 2010-04-15
)
RETURNS INT
AS
BEGIN
	DECLARE @INS_AGE INT

	IF @BIRTH_DATE IS NOT NULL AND ISDATE(@BIRTH_DATE) = 1
	BEGIN

		SELECT @INS_AGE = (
			YEAR(@DEP_DATE) - YEAR(@BIRTH_DATE) -
			-- 생일이 지나지 않으면 한살을 더 뺀다
			--CASE WHEN DATEDIFF("DD", @DEP_DATE, STUFF(CONVERT(CHAR(10), @BIRTH_DATE, 120), 1, 4, YEAR(@DEP_DATE))) < 0 THEN 1 ELSE 0 END
			--CASE WHEN DATEDIFF("DD", @BIRTH_DATE, STUFF(CONVERT(CHAR(10), @DEP_DATE, 120), 1, 4, YEAR(@BIRTH_DATE))) < 0 THEN 1 ELSE 0 END
			CASE
				WHEN SUBSTRING(CONVERT(VARCHAR(10), @BIRTH_DATE, 112), 5, 4) > SUBSTRING(CONVERT(VARCHAR(10), @DEP_DATE, 112), 5, 4) THEN 1
				ELSE 0
			END
		)

		--SELECT @INS_AGE = DATEDIFF("dd",@BIRTH_DATE, @DEP_DATE) / 365
	END
	ELSE
	BEGIN
		SELECT @INS_AGE = -1
	END
	
	RETURN (@INS_AGE);




	--DECLARE @INS_AGE INT, @TEMP_DATE DATETIME

	--/* 오늘의날짜중 년도에서주민번호앞2자리를뺀다 */
	
	--IF LEN(ISNULL(@SOC_NUM1, '')) = 6  AND LEN(ISNULL(@SOC_NUM2, '')) > 0 AND ISDATE(@SOC_NUM1) = 1
	--BEGIN
		
	--	DECLARE @YEAR_DIV INT 
	--	SET @YEAR_DIV  = CONVERT(INT,SUBSTRING( @SOC_NUM2  , 1 , 1 ))
		
	--	--2000년 이후 출생
	--	IF( @YEAR_DIV IN (3,4))
	--	BEGIN
	--		SET @TEMP_DATE = CONVERT(DATETIME, ('20' + @SOC_NUM1))
	--	END
	--	ELSE  -- 1,2 등 기타  
	--	BEGIN
	--		SET @TEMP_DATE = CONVERT(DATETIME, ('19' + @SOC_NUM1))
	--	END 
		
	--	SELECT @INS_AGE = DATEDIFF("dd",@TEMP_DATE, @DEP_DATE) / 365
		
	--END
	--ELSE
	--	BEGIN
	--		SELECT @INS_AGE = -1
	--	END

	
END

GO
