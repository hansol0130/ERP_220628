USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_DISPLAY_SCREEN_WEATHER_LIST
■ DESCRIPTION				: ERP 전광판 날씨 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
		EXEC SP_DISPLAY_SCREEN_WEATHER_LIST 'SEL,SYD,BJS,BER,BUE,VCE,FUK,OSA,GUM,BTR,PDX,CAN,PRG,MUC,JRS,FLR,KOJ,HIJ'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-09-17		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_DISPLAY_SCREEN_WEATHER_LIST]
	@CITY_CODE_STRINGS VARCHAR(300)
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	SELECT
		CITY_CODE, CITY_NAME, CAST_DATE, MIN(WEATHER_CODE) AS WEATHER_CODE, MIN(WEATHER_TEXT) AS WEATHER_TEXT, MIN(MIN_TEMPER) AS MIN_TEMPER, MIN(MAX_TEMPER) AS MAX_TEMPER
	FROM (
		SELECT 
			ROW_NUMBER() OVER (PARTITION BY WC.W_CITY_CODE ORDER BY MAX(WC.CAST_DATE) DESC) AS [ROW_NUMBER],
			WCM.CITY_CODE,
			PC.KOR_NAME AS CITY_NAME,
			WC.CAST_DATE,
			WC.WEATHER_CODE,
			WC.WEATHER_TEXT,
			WC.MIN_TEMPER,
			WC.MAX_TEMPER,
			WC.NEW_DATE
		FROM WEATHERI_CAST AS WC WITH(NOLOCK)
		INNER JOIN  WEATHERI_CITY_MAP AS WCM WITH(NOLOCK)
			ON WC.W_CITY_CODE = WCM.W_CITY_CODE 
		LEFT JOIN PUB_CITY AS PC WITH(NOLOCK)
			ON WCM.CITY_CODE = PC.CITY_CODE
		WHERE  
		WCM.CITY_CODE IN ( SELECT Data FROM DBO.FN_SPLIT(@CITY_CODE_STRINGS, ',') )
		AND WC.CAST_DATE < CONVERT(VARCHAR(8),DATEADD(DD,1,GETDATE()),112)  
		GROUP BY WC.W_CITY_CODE, WCM.CITY_CODE, PC.KOR_NAME, WC.CAST_DATE, WC.WEATHER_CODE, WC.WEATHER_TEXT, WC.MIN_TEMPER, WC.MAX_TEMPER, WC.NEW_DATE
	) A WHERE A.[ROW_NUMBER] = 1
	GROUP BY CITY_CODE, CITY_NAME, CAST_DATE

END
GO
