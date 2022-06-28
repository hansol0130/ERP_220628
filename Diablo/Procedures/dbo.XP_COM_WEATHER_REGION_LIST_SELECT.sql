USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_WEATHER_REGION_LIST_SELECT
■ DESCRIPTION				: BTMS 날씨정보 지역리스트
■ INPUT PARAMETER			: NONE
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-26		백경훈			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_WEATHER_REGION_LIST_SELECT]
	
AS 
BEGIN
	-- 검색_날씨정보_지역리스트 --
	SELECT W_REGION_KOR_NAME, W_REGION_ENG_NAME
	FROM WEATHERI_CAST A
	LEFT JOIN WEATHERI_CITY_MAP B ON A.W_CITY_CODE = B.W_CITY_CODE
	WHERE  W_REGION_KOR_NAME != '' OR W_REGION_KOR_NAME != NULL
	GROUP BY W_REGION_KOR_NAME, W_REGION_ENG_NAME
	ORDER BY COUNT(*) DESC

END 

GO
