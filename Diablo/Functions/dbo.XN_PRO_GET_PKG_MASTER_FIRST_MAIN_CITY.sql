USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ FUNCTION_NAME					: XP_WEB_PKG_FIRST_MAIN_CITY_SELECT
■ DESCRIPTION				: 마스터의 첫번째 메인 도시 검색
■ INPUT PARAMETER			: 
	@MASTER_CODE
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	SELECT  DBO.XN_PRO_GET_PKG_MASTER_FIRST_MAIN_CITY('KPP303')
	SELECT  DBO.XN_PRO_GET_PKG_MASTER_FIRST_MAIN_CITY('IRP003')

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-08-02		박형만			최초생성
================================================================================================================*/ 
CREATE FUNCTION [dbo].[XN_PRO_GET_PKG_MASTER_FIRST_MAIN_CITY]
(
	@MASTER_CODE VARCHAR(20) 
)
RETURNS VARCHAR(3)  
AS 
BEGIN
--DECLARE @MASTER_CODE VARCHAR(20)
--SET @MASTER_CODE = 'KPP303' 

	DECLARE @SIGN_CODE VARCHAR(1)
	SET @SIGN_CODE = SUBSTRING(@MASTER_CODE,1,1)
		
	DECLARE @MAIN_CITY_CODE VARCHAR(10) 
	SELECT TOP 1 @MAIN_CITY_CODE = C.CITY_CODE 
	--SELECT * 
	FROM PKG_MASTER_SCH_DAY A WITH(NOLOCK) 
	INNER JOIN PKG_MASTER_SCH_CITY B  WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE AND A.SCH_SEQ = B.SCH_SEQ AND A.DAY_SEQ = B.DAY_SEQ
	INNER JOIN PUB_CITY C WITH(NOLOCK) ON B.CITY_CODE = C.CITY_CODE
	WHERE A.MASTER_CODE = @MASTER_CODE
		AND A.SCH_SEQ IN (SELECT SCH_SEQ FROM PKG_MASTER_PRICE  WITH(NOLOCK) WHERE MASTER_CODE = @MASTER_CODE)
		AND ( B.DAY_SEQ > 1 )
		--AND B.MAINCITY_YN = 'Y' AND C.NATION_CODE <> 'KR'
	ORDER BY B.MAINCITY_YN  DESC , A.DAY_NUMBER, B.CITY_SHOW_ORDER;

	RETURN @MAIN_CITY_CODE 
END
GO
