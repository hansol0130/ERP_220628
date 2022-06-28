USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================  
■ USP_NAME     : XP_COM_WEATHER_CAST_CITY_SELECT  
■ DESCRIPTION    : BTMS 날씨정보 도시리스트  
■ INPUT PARAMETER   : NONE  
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
================================================================================================================*/   
CREATE PROC [dbo].[XP_COM_WEATHER_CAST_CITY_SELECT]  
  
AS   
BEGIN  
 -- 검색_날씨정보_도시리스트 --  
 SELECT   
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
 B.CITY_CODE  
 FROM WEATHERI_CAST A  
 LEFT JOIN WEATHERI_CITY_MAP B ON A.W_CITY_CODE = B.W_CITY_CODE  
 WHERE A.CAST_DATE = CONVERT(CHAR(8), GETDATE(), 112) AND  
  --A.CAST_DATE = '20150731' AND  
  B.W_CITY_CODE IN ('01208','00479', '00369',  '00637', '00425',  '00699', '02325', '01065', '00722', '00584', '00940',   
  '91335', '00917', '00239', '00684', '01044', '00253', '01021', '00148', '00832',   
  '01316', '00321', '02232', '01600', '01399', '01956', '01506', '01560', '00781', '00220')  
  
END 
GO
