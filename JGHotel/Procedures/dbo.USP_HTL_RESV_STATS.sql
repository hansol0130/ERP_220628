USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HTL_RESV_STATS]      
 @TYPE VARCHAR(1),      
 @FROM_DATE VARCHAR(10),      
 @TO_DATE VARCHAR(10),   
 @PARTNER_SHIP VARCHAR(10) = ''   
       
 /*      
 EXEC USP_HTL_RESV_STATS 'C', '2014-12-01', '2014-12-31'
 */      
       
 AS      
       
 DECLARE @T_DATE VARCHAR(20)      
       
  IF (@TYPE = 'C')      
        
   SET @T_DATE = 'CREATE_DATE'      
         
  ELSE      
        
   SET @T_DATE = 'CHECK_IN_DATE'      
        
 DECLARE @SQL VARCHAR(MAX)      
       
 SET @SQL = ''      
       
SET @SQL = @SQL + ' SELECT ' + CHAR(13)      
SET @SQL = @SQL + '  CONVERT(VARCHAR(10), ' + @T_DATE + ', 121) AS T_DATE, ' + CHAR(13)      
SET @SQL = @SQL + '  COUNT(CREATE_DATE) AS ALL_CNT, ' + CHAR(13)      
SET @SQL = @SQL + '  SUM(CASE WHEN LAST_STATUS = ''RMQQ'' THEN 1 ELSE 0 END) AS RMQQ, ' + CHAR(13)      
SET @SQL = @SQL + '  SUM(CASE WHEN LAST_STATUS = ''RMPQ'' THEN 1 ELSE 0 END) AS RMPQ, ' + CHAR(13)      
SET @SQL = @SQL + '  SUM(CASE WHEN LAST_STATUS = ''RMTK'' THEN 1 ELSE 0 END) AS RMTK, ' + CHAR(13)      
SET @SQL = @SQL + '  SUM(CASE WHEN LAST_STATUS = ''RMXX'' OR LAST_STATUS = ''RMXQ'' THEN 1 ELSE 0 END) AS RMXX, ' + CHAR(13)      
SET @SQL = @SQL + '  SUM(CASE WHEN LAST_STATUS = ''RMTK'' THEN (CASE WHEN SUPP_CODE = ''EX'' AND MCPN_CODE NOT IN (''VG0000'') THEN FLOOR(PAY_AMT * EX_RATE) ELSE PAY_AMT END) ELSE 0 END) AS PAY_AMT, ' + CHAR(13)      
SET @SQL = @SQL + '  SUM( ' + CHAR(13)      
SET @SQL = @SQL + '   (CASE WHEN LAST_STATUS = ''RMTK'' THEN SUPP_NET ELSE 0 END) + ' + CHAR(13)      
SET @SQL = @SQL + '   (CASE WHEN LAST_STATUS = ''RMXX'' THEN CANCEL_NET ELSE 0 END) ' + CHAR(13)      
SET @SQL = @SQL + '   ) AS SUPP_NET, ' + CHAR(13)
SET @SQL = @SQL + '  SUM( ' + CHAR(13)      
SET @SQL = @SQL + '   (CASE WHEN LAST_STATUS = ''RMTK'' THEN CARD_COST + COM_AMT ELSE 0 END) + ' + CHAR(13)      
SET @SQL = @SQL + '   (CASE WHEN LAST_STATUS = ''RMXX'' AND (CANCEL_NET > 0 OR CANCEL_AMT > 0) THEN COM_AMT ELSE 0 END) ' + CHAR(13)      
SET @SQL = @SQL + '   ) AS PROFIT_AMT, ' + CHAR(13)
SET @SQL = @SQL + '  SUM( ' + CHAR(13)      
SET @SQL = @SQL + '   (CASE WHEN LAST_STATUS = ''RMTK'' THEN CARD_COST ELSE 0 END) + ' + CHAR(13)      
SET @SQL = @SQL + '   (CASE WHEN LAST_STATUS = ''RMXX'' AND (CANCEL_NET > 0 OR CANCEL_AMT > 0) THEN COM_AMT ELSE 0 END) ' + CHAR(13)      
SET @SQL = @SQL + '   ) AS CARD_COST, ' + CHAR(13)          
SET @SQL = @SQL + '  SUM( ' + CHAR(13)      
SET @SQL = @SQL + '   (CASE WHEN LAST_STATUS = ''RMTK'' THEN COM_AMT ELSE 0 END) + ' + CHAR(13)      
SET @SQL = @SQL + '   (CASE WHEN LAST_STATUS = ''RMXX'' AND (CANCEL_NET > 0 OR CANCEL_AMT > 0) THEN COM_AMT ELSE 0 END) ' + CHAR(13)      
SET @SQL = @SQL + '   ) AS COM_AMT ' + CHAR(13)      
SET @SQL = @SQL + '  FROM HTL_RESV_MAST A ' + CHAR(13)      
SET @SQL = @SQL + '  LEFT JOIN( ' + CHAR(13)      
SET @SQL = @SQL + '  SELECT RESV_NO, SUM(CARD_AMOUNT + CASH_AMOUNT) AS PAY_AMT ' + CHAR(13)      
SET @SQL = @SQL + '  FROM HTL_RESV_PAY ' + CHAR(13)      
SET @SQL = @SQL + '  WHERE USE_YN = ''Y'' ' + CHAR(13)      
SET @SQL = @SQL + '  GROUP BY RESV_NO ' + CHAR(13)      
SET @SQL = @SQL + '  ) AS B ON A.RESV_NO = B.RESV_NO ' + CHAR(13)      
SET @SQL = @SQL + '  WHERE ' + @T_DATE + ' >= ''' + @FROM_DATE + ''' AND ' + @T_DATE + ' < CONVERT(DATETIME, ''' + @TO_DATE + ''') + 1 ' + CHAR(13)  

IF(@PARTNER_SHIP <> '')
SET @SQL = @SQL + ' AND A.MCPN_CODE = ''' + @PARTNER_SHIP + ''' ' + CHAR(13) 
    
SET @SQL = @SQL + '  AND A.HOTEL_CODE NOT LIKE ''OF%'' ' + CHAR(13)    
SET @SQL = @SQL + '  GROUP BY CONVERT(VARCHAR(10), ' + @T_DATE + ', 121) ' + CHAR(13)      
SET @SQL = @SQL + '  ORDER BY CONVERT(VARCHAR(10), ' + @T_DATE + ', 121) DESC ' + CHAR(13)      
      
PRINT(@SQL)          
EXEC(@SQL) 


GO
