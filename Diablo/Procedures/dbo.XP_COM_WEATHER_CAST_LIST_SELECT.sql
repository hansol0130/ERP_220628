USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*================================================================================================================  
■ USP_NAME     : XP_COM_WEATHER_CAST_LIST_SELECT  
■ DESCRIPTION    : BTMS 날씨정보 도시별날씨  
■ INPUT PARAMETER   :   
  @W_CITY_CODE  VARCHAR(10) : 도시코드   
■ OUTPUT PARAMETER   :   
■ EXEC      :   
■ MEMO      :   
------------------------------------------------------------------------------------------------------------------  
■ CHANGE HISTORY  
------------------------------------------------------------------------------------------------------------------  
   DATE    AUTHOR   DESCRIPTION             
------------------------------------------------------------------------------------------------------------------  
   2016-01-26  백경훈   최초생성  
   2016-05-30  박형만	날짜 주석제거 
   2016-09-12  정지용	LEFT JOIN => INNER 로 변경
================================================================================================================*/   
CREATE PROC [dbo].[XP_COM_WEATHER_CAST_LIST_SELECT]  
(  
 @W_CITY_CODE  VARCHAR(10)  
)  
   
AS   
BEGIN  
 -- 검색_날씨정보_도시별날씨 --  
 SELECT TOP 5  
 A.W_CITY_CODE,  
 A.CAST_DATE,  
 A.WEATHER_CODE,  
 A.WEATHER_TEXT,  
 A.MIN_TEMPER,  
 A.MAX_TEMPER,  
 A.NEW_DATE,  
 B.W_NATION_KOR_NAME,  
 B.W_NATION_CODE,  
 B.W_CITY_KOR_NAME,  
 B.CITY_CODE,  
 B.W_REGION_KOR_NAME  
 FROM WEATHERI_CAST A  
 INNER JOIN WEATHERI_CITY_MAP B ON A.W_CITY_CODE = B.W_CITY_CODE  
 WHERE A.W_CITY_CODE = @W_CITY_CODE AND A.CAST_DATE >= CONVERT(CHAR(8), GETDATE(), 112)  
  
END   
GO
