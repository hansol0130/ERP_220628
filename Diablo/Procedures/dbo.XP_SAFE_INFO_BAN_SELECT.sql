USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_SAFE_INFO_BAN_SELECT
■ DESCRIPTION				: 안전정보 여행금지제도 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
	EXEC XP_SAFE_INFO_BAN_SELECT ''
	EXEC XP_SAFE_INFO_BAN_SELECT 'HUN,ICN,TPE, FJG, HEK'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-06		정지용			최초생성
   2016-01-14		정지용			전체조회로 수정
================================================================================================================*/ 
CREATE PROC [dbo].[XP_SAFE_INFO_BAN_SELECT]
	@CITYCODE_STRING VARCHAR(100)
AS 
BEGIN
	DECLARE @NATION_CODE_STRING VARCHAR(100);

	--SELECT 
	--	@NATION_CODE_STRING = STUFF((      
	--		SELECT DISTINCT
	--			',' + NATION_CODE 
	--		FROM PUB_CITY A WITH(NOLOCK) WHERE CITY_CODE IN ( SELECT Data FROM DBO.FN_XML_SPLIT(@CITYCODE_STRING, ',') )             
	--		FOR XML PATH('')
	--	), 1, 1, '');	

	SELECT 
		CONTINENT, COUNTRY_NAME, COUNTRY_EN_NAME, BAN, BAN_PARTIAL, BAN_NOTE, IMG_URL1, IMG_URL2, WRT_DT
	FROM SAFE_INFO_TRAVEL_BAN A WITH(NOLOCK)
	--WHERE COUNTRY_EN_NAME IN (
	--	SELECT 
	--		SAFE_ENG_NAME 
	--	FROM SAFE_INFO_NATION_CATEGORY_MAP A WITH(NOLOCK) 
	--		WHERE (@CITYCODE_STRING = '')  OR (@CITYCODE_STRING != '' AND NATION_CODE IN (SELECT Data FROM dbo.FN_XML_SPLIT(@NATION_CODE_STRING, ',')))
	--);
END

GO
