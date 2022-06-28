USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name			: XN_PRO_MASTER_DAUMSHOP_GET_PRO_NAME
■ Description				: 다음쇼핑 상품명 만들기 
■ Input Parameter			:                  
	@PRODUCT_NAME VARCHAR(500), --상품명
	@ATT_NAME VARCHAR(500),	--상품타입명
	@CITY_NAME VARCHAR(500),
	@NATION_NAME VARCHAR(500),
	@REGION_NAME VARCHAR(500)
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
<<<pname>>>유럽/스위스/모노폴호텔 조식포함
<<<pname>>>강원도/용평리조트 스탠다드
권역/대표도시/여행종류

여행상품은 권역(유럽,동남아,강원도,제주도 등)이나 대표도시, 
여행종류(패키지,자유,허니문,에어텔,골프,크루즈,섬)을 표기. 
구분자'/'로 구분하여 표기ㄴ상품명에 해당 내용이 있는 경우, 
추가 표기 하지 않음.
ㄴ동일 키워드가 반복되면 어뷰징으로 간주되어 랭킹 불이익 받을 수 있음.

	SELECT DBO.XN_PRO_MASTER_GET_MAINCITY('XXX121')  --  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2015-07-30		박형만			최초생성
	
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_PRO_MASTER_DAUMSHOP_GET_PRO_NAME]
(
	@PRODUCT_NAME VARCHAR(500),
	@ATT_NAME VARCHAR(500),
	@CITY_NAME VARCHAR(500),
	@NATION_NAME VARCHAR(500),
	@REGION_NAME VARCHAR(500)
)
RETURNS VARCHAR(1000)
AS
BEGIN
	DECLARE @PRO_NAME VARCHAR(1000)

	SET @PRO_NAME = @PRODUCT_NAME 
	IF @NATION_NAME = '대한민국' 
	--@CITY_NAME / @ATT_NAME   
	BEGIN
		IF CHARINDEX ( @ATT_NAME ,@PRO_NAME  )  = 0 
		BEGIN
			SET @PRO_NAME = @ATT_NAME +'/' + @PRO_NAME 
		END 
		IF CHARINDEX ( @CITY_NAME ,@PRO_NAME  )  = 0 
		BEGIN
			SET @PRO_NAME = @CITY_NAME +'/' + @PRO_NAME 
		END 
	END
	ELSE 
	--@REGION_NAME / @NATION_NAME / @CITY_NAME / @ATT_NAME  
	BEGIN
		IF CHARINDEX ( @ATT_NAME ,@PRO_NAME  ) = 0 
		BEGIN
			SET @PRO_NAME = @ATT_NAME +'/' + @PRO_NAME 
		END 
		IF CHARINDEX ( @CITY_NAME ,@PRO_NAME  ) = 0 
		BEGIN
			SET @PRO_NAME = @CITY_NAME +'/' + @PRO_NAME 
		END 
		--IF CHARINDEX ( @NATION_NAME ,@PRO_NAME  )  = 0 
		--BEGIN
		--	SET @PRO_NAME = @NATION_NAME +'/' + @PRO_NAME 
		--END 
		IF CHARINDEX ( @REGION_NAME ,@PRO_NAME  )  = 0 
		BEGIN
			SET @PRO_NAME = @REGION_NAME +'/' + @PRO_NAME 
		END 
	END 

	RETURN @PRO_NAME 

END 
GO
