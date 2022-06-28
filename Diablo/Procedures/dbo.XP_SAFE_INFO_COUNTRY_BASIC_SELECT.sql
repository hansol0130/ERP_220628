USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_SAFE_INFO_COUNTRY_BASIC_SELECT
■ DESCRIPTION				: 안전정보 여행금지제도 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
	EXEC XP_SAFE_INFO_COUNTRY_BASIC_SELECT ''
	EXEC XP_SAFE_INFO_COUNTRY_BASIC_SELECT 'HUN,ICN,TPE, FJG, HEK'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-22		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_SAFE_INFO_COUNTRY_BASIC_SELECT]
	@CITYCODE_STRING VARCHAR(100)
AS 
BEGIN
	DECLARE @NATION_CODE_STRING VARCHAR(100);

	SELECT 
		@NATION_CODE_STRING = STUFF((      
			SELECT DISTINCT
				',' + NATION_CODE 
			FROM PUB_CITY A WITH(NOLOCK) WHERE CITY_CODE IN ( SELECT Data FROM DBO.FN_XML_SPLIT(@CITYCODE_STRING, ',') )             
			FOR XML PATH('')
		), 1, 1, '');	

	SELECT 
		ID, CONTINENT, COUNTRY_NAME, COUNTRY_EN_NAME, BASIC_INFO, IMG_URL, WRT_DT
	FROM SAFE_INFO_COUNTRY_BASIC A WITH(NOLOCK)
	WHERE COUNTRY_EN_NAME IN (
		SELECT 
			SAFE_ENG_NAME 
		FROM SAFE_INFO_NATION_CATEGORY_MAP A WITH(NOLOCK) 
			WHERE (@CITYCODE_STRING = '')  OR (@CITYCODE_STRING != '' AND NATION_CODE IN (SELECT Data FROM dbo.FN_XML_SPLIT(@NATION_CODE_STRING, ',')))
	);
END
GO
