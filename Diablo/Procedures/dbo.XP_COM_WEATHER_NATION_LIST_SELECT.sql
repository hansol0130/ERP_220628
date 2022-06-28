USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_WEATHER_NATION_LIST_SELECT
■ DESCRIPTION				: BTMS 날씨정보 국가리스트
■ INPUT PARAMETER			: 
   @W_REGION_KOR_NAME  VARCHAR(300) : 지역한글명
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
CREATE PROC [dbo].[XP_COM_WEATHER_NATION_LIST_SELECT]
(
	@W_REGION_KOR_NAME		VARCHAR(300)
)
	
AS 
BEGIN
	-- 검색_날씨정보_국가리스트 --
	SELECT B.W_NATION_CODE,  B.W_NATION_KOR_NAME
	FROM WEATHERI_CAST A
	LEFT JOIN WEATHERI_CITY_MAP B ON A.W_CITY_CODE = B.W_CITY_CODE
	WHERE B.W_REGION_KOR_NAME = @W_REGION_KOR_NAME 
	GROUP BY B.W_NATION_CODE,  B.W_NATION_KOR_NAME
	ORDER BY B.W_NATION_KOR_NAME

END 

GO
