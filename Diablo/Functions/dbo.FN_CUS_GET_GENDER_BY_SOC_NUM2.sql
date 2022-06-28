USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_CUS_GET_GENDER_BY_SOC_NUM2
■ Description				: 주민번호뒷자리로 성별구하기
■ Input Parameter			:                  
	@SOC_NUM2				: 주민번호 뒷자리 
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	select dbo.FN_CUS_GET_GENDER_BY_SOC_NUM2('1')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-07-03		박형만			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_CUS_GET_GENDER_BY_SOC_NUM2]
(
	@SOC_NUM2  VARCHAR(7)	  -- 주민번호 뒷자리 
)
RETURNS CHAR(1)
AS
BEGIN
--DECLARE @SOC_NUM2  VARCHAR(7)	  -- 주민번호 뒷자리 
--SELECT  @SOC_NUM2 = '' 

	DECLARE @GENDER CHAR(1)

	IF LEN(ISNULL(@SOC_NUM2, '')) > 0  
		AND ISNUMERIC(@SOC_NUM2) = 1 
	BEGIN
		DECLARE @YEAR_DIV CHAR(1) 
		SET @YEAR_DIV  = SUBSTRING( @SOC_NUM2  , 1 , 1 ) 
		
		--남자
		IF( @YEAR_DIV IN ('1','3','5','7','9'))
		BEGIN
			SET @GENDER = 'M'
		END
		ELSE 
		BEGIN
			SET @GENDER = 'F'
		END 
	END
	
--SELECT @GENDER 
	RETURN (@GENDER);
END
GO
