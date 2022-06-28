USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name			: XN_PRO_MASTER_SALE_PRICE_CUTTING
■ Description				: 마스터의 메인도시 조회 
■ Input Parameter			:                  
		@MASTER_CODE		: 마스터코드
		@PRICE_SEQ			: 가격순번
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.XN_PRO_MASTER_GET_MAINCITY('XXX121')  --  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2015-07-30		박형만			최초생성
	
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_PRO_MASTER_GET_MAINCITY_CODE]
(
	@MASTER_CODE VARCHAR(20)
)
RETURNS VARCHAR(3)
AS
BEGIN

DECLARE @MAIN_CITY_CODE VARCHAR(3)  
IF LEFT(@MASTER_CODE,1) = 'K'
BEGIN
	
	SELECT 
		TOP 1 @MAIN_CITY_CODE = CITY_CODE  
	FROM 
		PKG_MASTER_SCH_CITY A  -- 
	WHERE A.MASTER_CODE = @MASTER_CODE 
	AND A.CITY_CODE NOT IN('ICN','GMP')  -- 메인도시 한국 출발 도시 제외 
	ORDER BY (CASE WHEN MAINCITY_YN = 'Y' THEN 0 ELSE 1 END)
	, (CASE WHEN DAY_SEQ = 1 THEN 99 ELSE 1 END)
	, DAY_SEQ ,CITY_SHOW_ORDER
	
END 
ELSE 
BEGIN
	SELECT 
		TOP 1 @MAIN_CITY_CODE = CITY_CODE  
	FROM 
		PKG_MASTER_SCH_CITY A  -- 
		--LEFT JOIN PKG_MASTER_PRICE B --가격표에서 사용중인 스케쥴만 
		--	ON A.MASTER_CODE = B.MASTER_CODE 
		--	AND A.SCH_SEQ = B.SCH_SEQ  
		--AND A.DAY_SEQ > 1 
	WHERE A.MASTER_CODE = @MASTER_CODE 
	AND A.CITY_CODE NOT IN('ICN','PUS','GMP','SEL')  -- 메인도시 한국 출발 도시 제외 
	ORDER BY (CASE WHEN MAINCITY_YN = 'Y' THEN 0 ELSE 1 END)
	, (CASE WHEN DAY_SEQ = 1 THEN 99 ELSE 1 END)
	, DAY_SEQ ,CITY_SHOW_ORDER
END 

RETURN @MAIN_CITY_CODE 

END 
GO
