USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HTL_SALE_MONTH_BY_CITY_DETAIL]
/*
USP_HTL_SALE_MONTH_BY_CITY_DETAIL '', ''
*/

@CITY_CODE VARCHAR(20),
@DATE_FROM VARCHAR(10)

AS

DECLARE @SQL VARCHAR(MAX)

SET @SQL = ''

SET @SQL = @SQL + ' SET ANSI_WARNINGS OFF ' + CHAR(13)
SET @SQL = @SQL + '  SET ARITHIGNORE ON  ' + CHAR(13)
SET @SQL = @SQL + '  SET ARITHABORT OFF  ' + CHAR(13)
SET @SQL = @SQL + '  SELECT  ' + CHAR(13)
SET @SQL = @SQL + '  	CONVERT(VARCHAR(7), A.CREATE_DATE, 121) AS RES_MONTH,  ' + CHAR(13)
SET @SQL = @SQL + '  	B.CITY_CODE,  ' + CHAR(13)
SET @SQL = @SQL + '  	B.CITY_NAME, ' + CHAR(13)
SET @SQL = @SQL + '  	B.HOTEL_CODE, ' + CHAR(13)
SET @SQL = @SQL + '  	B.NAME, ' + CHAR(13)
SET @SQL = @SQL + '  	SUM(CASE WHEN A.LAST_STATUS = ''RMTK'' THEN 1 ELSE 0 END) AS RMTK,  ' + CHAR(13)
SET @SQL = @SQL + '  	SUM(CASE WHEN A.LAST_STATUS = ''RMTK'' THEN A.TOTAL_AMT ELSE 0 END) AS TOTAL_AMT,  ' + CHAR(13)
SET @SQL = @SQL + '  	SUM(CASE WHEN A.LAST_STATUS = ''RMTK'' THEN A.SUPP_NET ELSE 0 END) AS SUPP_NET,  ' + CHAR(13)
SET @SQL = @SQL + '  	SUM(CASE WHEN A.LAST_STATUS = ''RMTK'' THEN (CASE WHEN A.SUPP_CODE = ''EX'' AND MCPN_CODE NOT IN (''VG0000'') THEN FLOOR(C.PAY_AMT * EX_RATE) ELSE C.PAY_AMT END) ELSE 0 END) AS PAY_AMT,  ' + CHAR(13)
SET @SQL = @SQL + '  	SUM(CASE WHEN A.LAST_STATUS = ''RMTK'' THEN A.COM_AMT ELSE 0 END) AS COM_AMT,  ' + CHAR(13)
SET @SQL = @SQL + ' 		ROUND(SUM(CASE WHEN A.LAST_STATUS = ''RMTK'' THEN A.COM_AMT ELSE 0 END) / SUM(CASE WHEN A.LAST_STATUS = ''RMTK'' THEN (CASE WHEN A.SUPP_CODE = ''EX'' THEN FLOOR(C.PAY_AMT * EX_RATE) ELSE C.PAY_AMT END) ELSE 0 END) * 100, 1) AS COM_RATE  ' + CHAR(13)
SET @SQL = @SQL + '  FROM HTL_RESV_MAST A  ' + CHAR(13)
SET @SQL = @SQL + '  LEFT JOIN HTL_INFO_MAST_HOTEL B  ' + CHAR(13)
SET @SQL = @SQL + '  ON A.HOTEL_NAME = B.NAME  ' + CHAR(13)
SET @SQL = @SQL + '  LEFT JOIN(  ' + CHAR(13)
SET @SQL = @SQL + '  	SELECT RESV_NO, SUM(CARD_AMOUNT + CASH_AMOUNT) AS PAY_AMT  ' + CHAR(13)
SET @SQL = @SQL + '  	FROM HTL_RESV_PAY  ' + CHAR(13)
SET @SQL = @SQL + '  	WHERE USE_YN = ''Y''  ' + CHAR(13)
SET @SQL = @SQL + '  	GROUP BY RESV_NO  ' + CHAR(13)
SET @SQL = @SQL + '  ) AS C ON A.RESV_NO = C.RESV_NO  ' + CHAR(13)
SET @SQL = @SQL + '  WHERE CONVERT(VARCHAR(7), A.CREATE_DATE, 121) = ''' + @DATE_FROM + ''' ' + CHAR(13)
SET @SQL = @SQL + '  AND B.CITY_CODE = ''' + @CITY_CODE + ''' ' + CHAR(13)
SET @SQL = @SQL + '  GROUP BY CONVERT(VARCHAR(7), A.CREATE_DATE, 121), B.CITY_CODE, B.CITY_NAME, B.HOTEL_CODE, B.NAME ' + CHAR(13)
SET @SQL = @SQL + '  ORDER BY ''RMTK'' DESC  ' + CHAR(13)

PRINT(@SQL)          
EXEC (@SQL)


GO