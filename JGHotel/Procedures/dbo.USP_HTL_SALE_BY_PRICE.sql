USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HTL_SALE_BY_PRICE]   
    
/*    
USP_HTL_SALE_BY_PRICE '2014-01-01', '2014-09-30'
*/    
         
@DATE_FROM VARCHAR(10),      
@DATE_TO VARCHAR(10),
@PARTNER_SHIP VARCHAR(10) = ''   
    
AS    
    
DECLARE @SQL VARCHAR(MAX)      
      
SET @SQL = ''    
    
SET @SQL = @SQL + ' SET ANSI_WARNINGS OFF ' + CHAR(13)
SET @SQL = @SQL + ' SET ARITHIGNORE ON ' + CHAR(13)
SET @SQL = @SQL + ' SET ARITHABORT OFF ' + CHAR(13)  
    
SET @SQL = @SQL + ' SELECT ' + CHAR(13)
SET @SQL = @SQL + '  (CEILING(CONVERT(DECIMAL,A.TOTAL_AMT) / 100000) * 10)-10 AS RANGE_FROM, ' + CHAR(13) 
SET @SQL = @SQL + '  (CEILING(CONVERT(DECIMAL,A.TOTAL_AMT) / 100000) * 10) AS RANGE_TO, ' + CHAR(13)
SET @SQL = @SQL + '  COUNT(CREATE_DATE) AS ALL_CNT, ' + CHAR(13)    
SET @SQL = @SQL + '  SUM(CASE WHEN A.LAST_STATUS = ''RMTK'' THEN 1 ELSE 0 END) AS RMTK, ' + CHAR(13)    
SET @SQL = @SQL + '  SUM(CASE WHEN A.LAST_STATUS = ''RMTK'' THEN A.TOTAL_AMT ELSE 0 END) AS TOTAL_AMT, ' + CHAR(13)    
SET @SQL = @SQL + '  SUM(CASE WHEN A.LAST_STATUS = ''RMTK'' THEN A.SUPP_NET ELSE 0 END) AS SUPP_NET, ' + CHAR(13)    
SET @SQL = @SQL + '  SUM(CASE WHEN A.LAST_STATUS = ''RMTK'' THEN (CASE WHEN A.SUPP_CODE = ''EX'' AND MCPN_CODE NOT IN (''VG0000'') THEN FLOOR(B.PAY_AMT * EX_RATE) ELSE B.PAY_AMT END) ELSE 0 END) AS PAY_AMT, ' + CHAR(13)    
SET @SQL = @SQL + '  SUM(CASE WHEN A.LAST_STATUS = ''RMTK'' THEN A.COM_AMT ELSE 0 END) AS COM_AMT, ' + CHAR(13)    
SET @SQL = @SQL + '  ROUND(SUM(CASE WHEN A.LAST_STATUS = ''RMTK'' THEN A.COM_AMT ELSE 0 END) / SUM(CASE WHEN A.LAST_STATUS = ''RMTK'' THEN (CASE WHEN A.SUPP_CODE = ''EX'' THEN FLOOR(B.PAY_AMT * A.EX_RATE) ELSE B.PAY_AMT END) ELSE 0 END) * 100, 1) AS COM_RATE ' + CHAR(13)    
SET @SQL = @SQL + ' FROM HTL_RESV_MAST A ' + CHAR(13)    
SET @SQL = @SQL + ' LEFT JOIN ' + CHAR(13)    
SET @SQL = @SQL + ' ( ' + CHAR(13)    
SET @SQL = @SQL + '  SELECT  ' + CHAR(13)    
SET @SQL = @SQL + '   RESV_NO, ' + CHAR(13)    
SET @SQL = @SQL + '   SUM(PAY_TOTAL_AMOUNT) AS PAY_AMT ' + CHAR(13)    
SET @SQL = @SQL + '  FROM HTL_RESV_PAY ' + CHAR(13)    
SET @SQL = @SQL + '  WHERE USE_YN = ''Y''  ' + CHAR(13)    
SET @SQL = @SQL + '  GROUP BY RESV_NO, PAY_STATUS ' + CHAR(13)    
SET @SQL = @SQL + ' ) AS B ON A.RESV_NO = B.RESV_NO ' + CHAR(13)    
SET @SQL = @SQL + ' WHERE ' + CHAR(13)
SET @SQL = @SQL + ' CONVERT(VARCHAR(10), A.CREATE_DATE, 121) >= '''+@DATE_FROM+''' AND CONVERT(VARCHAR(10), A.CREATE_DATE, 121) < CONVERT(DATETIME, '''+@DATE_TO+''') + 1 ' + CHAR(13)    
IF(@PARTNER_SHIP <> '') SET @SQL = @SQL + ' AND A.MCPN_CODE = ''' + @PARTNER_SHIP + ''' ' + CHAR(13) 
SET @SQL = @SQL + ' AND A.HOTEL_CODE NOT LIKE ''OF%'' ' + CHAR(13)
SET @SQL = @SQL + ' GROUP BY (CEILING(CONVERT(DECIMAL,A.TOTAL_AMT) / 100000) * 10)-10, (CEILING(CONVERT(DECIMAL,A.TOTAL_AMT) / 100000) * 10) ' + CHAR(13)    
SET @SQL = @SQL + ' ORDER BY RANGE_FROM ' + CHAR(13)
    
PRINT(@SQL)    
EXEC(@SQL)



GO
