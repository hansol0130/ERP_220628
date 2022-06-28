USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_WEATHER_CITY_LIST_SELECT
■ DESCRIPTION				: BTMS 날씨정보 도시리스트
■ INPUT PARAMETER			: 
   @W_NATION_CODE  VARCHAR(2) : 국가코드
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
CREATE PROC [dbo].[XP_COM_WEATHER_CITY_LIST_SELECT]
(
	@W_NATION_CODE		VARCHAR(2)
)
	
AS 
BEGIN
	-- 검색_날씨정보_도시리스트 --
	SELECT B.W_CITY_CODE,  B.W_CITY_KOR_NAME
	FROM WEATHERI_CAST A
	LEFT JOIN WEATHERI_CITY_MAP B ON A.W_CITY_CODE = B.W_CITY_CODE
	WHERE B.W_NATION_CODE = @W_NATION_CODE
	GROUP BY B.W_CITY_CODE,  B.W_CITY_KOR_NAME
	ORDER BY B.W_CITY_KOR_NAME

END 

GO
