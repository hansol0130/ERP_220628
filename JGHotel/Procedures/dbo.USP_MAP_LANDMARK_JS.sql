USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_MAP_LANDMARK_JS]

/*
USP_MAP_LANDMARK_JS '179900'
*/

@CITY_CODE VARCHAR(30)

AS


SELECT MARK_CODE, MARK_NAME, MARK_ENAME, LATITUDE, LONGITUDE, CITY_CODE, ZOOM_LEVEL
FROM HTL_CODE_MARK 
WHERE CITY_CODE=@CITY_CODE AND USE_YN='Y'
ORDER BY ZOOM_LEVEL

GO
