USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GET_MARKUP_RATE3]    
    
/*    
USP_GET_MARKUP_RATE3 'OD', '1751'    
*/    
    
    
@SUPP_CODE VARCHAR(2),    
@CITY_CODE VARCHAR(50),    
@HOTEL_CODE VARCHAR(20)='0',    
@CLASS VARCHAR(10)='CLASS_E'    
    
AS    
    
DECLARE @SQL VARCHAR(MAX);    
SET @SQL = '';    
    
SET @SQL = @SQL + 'SELECT A.HOTEL_CODE, A.SUPP_CODE, A.S_HOTEL_CODE, A.S_HOTEL_NAME, D.CITY_CODE AS S_CITY_CODE, E.ADD_INFO1, ' + CHAR(13)    
SET @SQL = @SQL + '(' + CHAR(13)    
SET @SQL = @SQL + ' SELECT TOP 1 ' + CHAR(13)    
SET @SQL = @SQL + ' ISNULL((CASE ''' + @CLASS + ''' WHEN ''CLASS_A'' THEN CLASS_A' + CHAR(13)    
SET @SQL = @SQL + ' WHEN ''CLASS_B'' THEN CLASS_B' + CHAR(13)    
SET @SQL = @SQL + ' WHEN ''CLASS_C'' THEN CLASS_C' + CHAR(13)    
SET @SQL = @SQL + ' WHEN ''CLASS_D'' THEN CLASS_D' + CHAR(13)    
SET @SQL = @SQL + ' WHEN ''CLASS_E'' THEN CLASS_E END),10.00) AS RATE' + CHAR(13)    
SET @SQL = @SQL + ' FROM HTL_CODE_RATE    ' + CHAR(13)    
SET @SQL = @SQL + ' WHERE (SUPP_CODE=A.SUPP_CODE OR SUPP_CODE='''')    ' + CHAR(13)    
SET @SQL = @SQL + ' AND (NATION_CODE=C.NATION_CODE OR NATION_CODE='''')    ' + CHAR(13)    
SET @SQL = @SQL + ' AND (CITY_CODE=C.CITY_CODE OR CITY_CODE='''')    ' + CHAR(13)    
SET @SQL = @SQL + ' AND (HOTEL_CODE=A.HOTEL_CODE OR HOTEL_CODE=0)    ' + CHAR(13)    
SET @SQL = @SQL + ' ORDER BY HOTEL_CODE DESC, CITY_CODE DESC, NATION_CODE DESC, SUPP_CODE DESC ' + CHAR(13)    
SET @SQL = @SQL + ') AS COM_RATE' + CHAR(13)    
SET @SQL = @SQL + 'FROM HTL_MAPP_HOTEL A' + CHAR(13)    
SET @SQL = @SQL + 'JOIN HTL_INFO_MAST_HOTEL B ON A.HOTEL_CODE=B.HOTEL_CODE' + CHAR(13)    
SET @SQL = @SQL + 'JOIN HTL_CODE_MAST_CITY C ON B.CITY_CODE=C.CITY_CODE' + CHAR(13)    
SET @SQL = @SQL + 'JOIN HTL_INFO_SUB_HOTEL D ON A.S_HOTEL_CODE=D.HOTEL_CODE AND A.SUPP_CODE=D.SUPP_CODE' + CHAR(13)    
SET @SQL = @SQL + 'LEFT JOIN HTL_INFO_SUB_ADD E ON D.HOTEL_CODE=E.HOTEL_CODE AND D.SUPP_CODE=E.SUPP_CODE' + CHAR(13)    
SET @SQL = @SQL + 'WHERE A.USE_YN=''Y''' + CHAR(13)    
    
IF (@SUPP_CODE <> '')    
SET @SQL = @SQL + 'AND A.SUPP_CODE=''' + @SUPP_CODE + ''' ' + CHAR(13)    
    
IF (@CITY_CODE <> '')    
SET @SQL = @SQL + 'AND B.CITY_CODE=''' + @CITY_CODE + ''' ' + CHAR(13)    
    
IF (@HOTEL_CODE NOT IN ('', '0'))    
SET @SQL = @SQL + 'AND A.HOTEL_CODE=''' + @HOTEL_CODE + ''' '    
    
PRINT(@SQL)    
EXEC(@SQL)    
GO
