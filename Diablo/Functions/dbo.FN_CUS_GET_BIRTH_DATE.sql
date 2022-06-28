USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_CUS_GET_BIRTH_DATE
■ Description				: 주민번호로 생년월일계산
■ Input Parameter			:                  
	@SOC_NUM1				: 주민번호 앞자리 790703
	@SOC_NUM2				: 주민번호 뒷자리 
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	select dbo.FN_CUS_GET_BIRTH_DATE('800708','1')
	select dbo.FN_CUS_GET_BIRTH_DATE('140101', NULL)
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2010-12-06		박형만			최초생성
	2013-10-24		박형만			주민번호 앞자리만 입력되어도 생년월일 계산 되도록
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_CUS_GET_BIRTH_DATE]
(
	@SOC_NUM1  VARCHAR(6),	  -- 주민번호 790703
	@SOC_NUM2  VARCHAR(7)	  -- 주민번호 뒷자리 
)
RETURNS DATETIME
AS
BEGIN

--	DECLARE @SOC_NUM1  VARCHAR(6),	  -- 주민번호 790703
--	@SOC_NUM2  VARCHAR(7)	  -- 주민번호 뒷자리 
--	SELECT @SOC_NUM1 = '800708' , @SOC_NUM2 = '1' 

	DECLARE @TEMP_DATE DATETIME
	
	IF LEN(@SOC_NUM1) = 6 
	BEGIN
		DECLARE @TEMP_STRING VARCHAR(10)

		IF LEN(@SOC_NUM2) > 0 
			BEGIN
			IF SUBSTRING(@SOC_NUM2, 1, 1) IN ('3', '4', '7', '8')
			BEGIN
				SET @TEMP_STRING = '20' + @SOC_NUM1
			END
			ELSE IF SUBSTRING(@SOC_NUM2, 1, 1) IN ('0', '9')
			BEGIN
				SET @TEMP_STRING = '18' + @SOC_NUM1
			END
			ELSE  -- 1,2,5,6 등 기타  
			BEGIN
				SET @TEMP_STRING = '19' + @SOC_NUM1
			END

			IF ISDATE(@TEMP_STRING) = 1
				SET @TEMP_DATE = CONVERT(DATETIME, @TEMP_STRING)
		END 
		ELSE  --뒷자리가 입력되지 않은경우 
		BEGIN 
			--2000년 ~ 오늘까지 출생자
			IF @SOC_NUM1 BETWEEN '000101' AND RIGHT(CONVERT(VARCHAR(10),GETDATE(),112),6) 
			BEGIN
				SET @TEMP_STRING = '20' + @SOC_NUM1 --2000년 이후 출생으로 간주
			END 
			ELSE 
			BEGIN
				SET @TEMP_STRING = '19' + @SOC_NUM1
			END 

			IF ISDATE(@TEMP_STRING) = 1
				SET @TEMP_DATE = CONVERT(DATETIME, @TEMP_STRING)
		END 

	END 
	RETURN @TEMP_DATE

END
 

GO
