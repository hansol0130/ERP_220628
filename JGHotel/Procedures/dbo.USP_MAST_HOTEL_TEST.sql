USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_MAST_HOTEL_TEST]      
        
/*        
USP_MAST_HOTEL_TEST '179900', ''        
USP_MAST_HOTEL_TEST '179900', '105822'      
USP_MAST_HOTEL_TEST '179900', '', '신주쿠'      
*/        
        
@CITY_CODE VARCHAR(20),        
@HOTEL_CODE VARCHAR(20),      
@HOTEL_NAME VARCHAR(1000) = ''      
        
AS        
        
DECLARE @SQL VARCHAR(8000);        
SET @SQL = '';        
        
IF (@CITY_CODE = '') RETURN;        
        
SET @SQL = @SQL + 'SELECT A.HOTEL_CODE, NAME, ENG_NAME, CITY_CODE, CITY_NAME, AREA_CODE, AREA_NAME, LOCATION_DESC, ' + CHAR(13)        
SET @SQL = @SQL + 'ADDRESS, STAR_RATING, ROOM_CNT, CHECK_IN_TIME, CHECK_OUT_TIME, LATITUDE, LONGITUDE, ' + CHAR(13)        
SET @SQL = @SQL + 'MAIN_IMG, RV_POINT, RECOM_YN, RECOM_SORT, PHONE, FAX, ISNULL(B.SALE_AMT, 0) AS SALE_AMT, ' + CHAR(13)        
    
SET @SQL = @SQL + '( ' + CHAR(13)      
  
SET @SQL = @SQL + ' SELECT STUFF((SELECT ''@''+S_CODE+''|''+CODE_NAME ' + CHAR(13)   
SET @SQL = @SQL + ' FROM HTL_INFO_MAST_FAC_IDX WHERE HOTEL_CODE=A.HOTEL_CODE ' + CHAR(13)   
SET @SQL = @SQL + ' FOR XML PATH('''')),1,1,'''') ' + CHAR(13)   
  
SET @SQL = @SQL + ') AS FACILITY, ' + CHAR(13)      
SET @SQL = @SQL + '( ' + CHAR(13)      
SET @SQL = @SQL + ' SELECT STUFF((SELECT ''@''+CONVERT(VARCHAR,BL.MARK_CODE)+''|''+MARK_NAME ' + CHAR(13)      
SET @SQL = @SQL + ' FROM HTL_INFO_LANDMARK AL ' + CHAR(13)      
SET @SQL = @SQL + ' JOIN HTL_CODE_LANDMARK BL ON AL.MARK_CODE=BL.MARK_CODE ' + CHAR(13)      
SET @SQL = @SQL + ' WHERE HOTEL_CODE=A.HOTEL_CODE AND BL.SUB_CLASS IN (''CIVIC'',''HISTORIC'',''TREE'',''CASINO'') ' + CHAR(13)      
SET @SQL = @SQL + ' FOR XML PATH('''')),1,1,'''') ' + CHAR(13)      
SET @SQL = @SQL + ') AS LAND_MARK ' + CHAR(13)      
SET @SQL = @SQL + 'FROM HTL_INFO_MAST_HOTEL A WITH (NOLOCK) ' + CHAR(13)      
SET @SQL = @SQL + 'LEFT JOIN HTL_INFO_PRICE B WITH (NOLOCK) ON A.HOTEL_CODE=B.HOTEL_CODE  ' + CHAR(13)      
SET @SQL = @SQL + 'WHERE USE_YN=''Y'' ' + CHAR(13)        
SET @SQL = @SQL + 'AND CITY_CODE=''' + @CITY_CODE + ''' ' + CHAR(13)        
        
IF (@HOTEL_CODE <> '')        
 SET @SQL = @SQL + 'AND A.HOTEL_CODE=''' + @HOTEL_CODE + ''' '        
      
IF (@HOTEL_NAME <> '')        
 SET @SQL = @SQL + 'AND (NAME LIKE ''%' + @HOTEL_NAME + '%'' OR NAME LIKE ''%' + @HOTEL_NAME + '%'') '        
        
PRINT(@SQL)        
EXEC(@SQL) 


GO
