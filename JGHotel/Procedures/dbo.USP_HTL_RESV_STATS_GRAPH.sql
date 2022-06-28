USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HTL_RESV_STATS_GRAPH]      
 @TYPE VARCHAR(1),      
 @FROM_DATE VARCHAR(10),      
 @TO_DATE VARCHAR(10),   
 @PARTNER_SHIP VARCHAR(10) = '',
 @XML VARCHAR(MAX) 
       
 /*      
 EXEC USP_HTL_RESV_STATS_GRAPH 'C', '2015-02-01', '2015-04-27', 'S00000', '<CalendarRS><Date>2015-02-01</Date><Date>2015-02-02</Date><Date>2015-02-03</Date><Date>2015-02-04</Date><Date>2015-02-05</Date><Date>2015-02-06</Date><Date>2015-02-07</Date><Date>2015-02-08</Date><Date>2015-02-09</Date><Date>2015-02-10</Date><Date>2015-02-11</Date><Date>2015-02-12</Date><Date>2015-02-13</Date><Date>2015-02-14</Date><Date>2015-02-15</Date><Date>2015-02-16</Date><Date>2015-02-17</Date><Date>2015-02-18</Date><Date>2015-02-19</Date><Date>2015-02-20</Date><Date>2015-02-21</Date><Date>2015-02-22</Date><Date>2015-02-23</Date><Date>2015-02-24</Date><Date>2015-02-25</Date><Date>2015-02-26</Date><Date>2015-02-27</Date><Date>2015-02-28</Date><Date>2015-03-01</Date><Date>2015-03-02</Date><Date>2015-03-03</Date><Date>2015-03-04</Date><Date>2015-03-05</Date><Date>2015-03-06</Date><Date>2015-03-07</Date><Date>2015-03-08</Date><Date>2015-03-09</Date><Date>2015-03-10</Date><Date>2015-03-11</Date><Date>2015-03-12</Date><Date>2015-03-13</Date><Date>2015-03-14</Date><Date>2015-03-15</Date><Date>2015-03-16</Date><Date>2015-03-17</Date><Date>2015-03-18</Date><Date>2015-03-19</Date><Date>2015-03-20</Date><Date>2015-03-21</Date><Date>2015-03-22</Date><Date>2015-03-23</Date><Date>2015-03-24</Date><Date>2015-03-25</Date><Date>2015-03-26</Date><Date>2015-03-27</Date><Date>2015-03-28</Date><Date>2015-03-29</Date><Date>2015-03-30</Date><Date>2015-03-31</Date><Date>2015-04-01</Date><Date>2015-04-02</Date><Date>2015-04-03</Date><Date>2015-04-04</Date><Date>2015-04-05</Date><Date>2015-04-06</Date><Date>2015-04-07</Date><Date>2015-04-08</Date><Date>2015-04-09</Date><Date>2015-04-10</Date><Date>2015-04-11</Date><Date>2015-04-12</Date><Date>2015-04-13</Date><Date>2015-04-14</Date><Date>2015-04-15</Date><Date>2015-04-16</Date><Date>2015-04-17</Date><Date>2015-04-18</Date><Date>2015-04-19</Date><Date>2015-04-20</Date><Date>2015-04-21</Date><Date>2015-04-22</Date><Date>2015-04-23</Date><Date>2015-04-24</Date><Date>2015-04-25</Date><Date>2015-04-26</Date><Date>2015-04-27</Date><Date>2015-04-28</Date><Date>2015-04-29</Date><Date>2015-04-30</Date></CalendarRS>'
 */      
       
AS

DECLARE @T_DATE VARCHAR(20) 
DECLARE @XML_DOCUMENT_HANDLE INT;                            
DECLARE @XML_DOCUMENT VARCHAR(MAX); 
SET @XML_DOCUMENT = '<?xml version="1.0" encoding="euc-kr"?>' + @XML                               
                          
EXEC SP_XML_PREPAREDOCUMENT @XML_DOCUMENT_HANDLE OUTPUT, @XML_DOCUMENT

SELECT *                     
INTO #TMP_TABLE                  
FROM OPENXML (@XML_DOCUMENT_HANDLE, '/CalendarRS/Date',2)                           
WITH (                                                                                                                                          
     TARGET_DATE varchar(10) '.'           
) A
      
IF (@TYPE = 'C')      
       
SET @T_DATE = 'CREATE_DATE'      
        
ELSE      
       
SET @T_DATE = 'CHECK_IN_DATE'      
       
DECLARE @SQL VARCHAR(MAX)      
       
SET @SQL = ''  

SET @SQL = @SQL + ' SELECT * ' + CHAR(13)
SET @SQL = @SQL + ' INTO #TMP_TABLE2 FROM ' + CHAR(13)
SET @SQL = @SQL + ' ( ' + CHAR(13)   
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
SET @SQL = @SQL + ' ) B ' + CHAR(13)
SET @SQL = @SQL + ' SELECT ' + CHAR(13)
SET @SQL = @SQL + ' A.TARGET_DATE, ' + CHAR(13)
SET @SQL = @SQL + ' B.T_DATE, ' + CHAR(13)
SET @SQL = @SQL + ' ISNULL(B.ALL_CNT, 0) AS ALL_CNT, ' + CHAR(13)
SET @SQL = @SQL + ' ISNULL(B.RMQQ, 0) AS RMQQ, ' + CHAR(13)
SET @SQL = @SQL + ' ISNULL(B.RMPQ, 0) AS RMPQ, ' + CHAR(13)
SET @SQL = @SQL + ' ISNULL(B.RMTK, 0) AS RMTK, ' + CHAR(13)
SET @SQL = @SQL + ' ISNULL(B.RMXX, 0) AS RMXX ' + CHAR(13)
SET @SQL = @SQL + ' FROM #TMP_TABLE A ' + CHAR(13)
SET @SQL = @SQL + ' LEFT JOIN #TMP_TABLE2 B ON A.TARGET_DATE = B.T_DATE ' + CHAR(13)
SET @SQL = @SQL + ' ORDER BY TARGET_DATE ASC ' + CHAR(13)
      
PRINT(@SQL)          
EXEC(@SQL)

EXEC SP_XML_REMOVEDOCUMENT @XML_DOCUMENT_HANDLE


GO
