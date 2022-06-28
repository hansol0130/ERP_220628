USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_CURRNECY_UPDATE]

@XML VARCHAR(MAX)

AS


DECLARE @XML_DOCUMENT_HANDLE INT;                              
DECLARE @XML_DOCUMENT VARCHAR(MAX);                              
SET @XML_DOCUMENT = '<?xml version="1.0" encoding="euc-kr"?>' + @XML                                 
                            
EXEC SP_XML_PREPAREDOCUMENT @XML_DOCUMENT_HANDLE OUTPUT, @XML_DOCUMENT       

SELECT *
INTO #TMP_TABLE
FROM OPENXML (@XML_DOCUMENT_HANDLE, '/ArrayOfCurrencyRQ/CurrencyRQ',2)                             
WITH (                                                                                                                                            
     CurrencyCode VARCHAR(10) './CurrencyCode',   
	 CurrencyDesc VARCHAR(200) './CurrencyDesc',   
     BuyCash VARCHAR(20) './BuyCash',        
     SellCash VARCHAR(30) './SellCash',        
     SendCash VARCHAR(30) './SendCash',        
     RecvCash VARCHAR(30) './RecvCash',        
     SellCheck VARCHAR(30) './SellCheck',        
     ExchangeRate VARCHAR(20) './ExchangeRate',        
     UsdRate VARCHAR(20) './UsdRate',        
     ConvertRate VARCHAR(30) './ConvertRate'
) A   

DECLARE @CNT INT;
SELECT @CNT = COUNT(*) FROM #TMP_TABLE


IF (@CNT < 20) RETURN;

--환율정보 인서트
INSERT TBL_CODE_CURRENCY 
(CURRENCY_CODE, CURRENCY_DESC, BUY_CASH, SELL_CASH, SEND_CASH, RECV_CASH, SELL_CHECK, EXCHANGE_RATE, USD_RATE, CONVERT_RATE, USE_YN, UPDATE_DATE)
SELECT CurrencyCode, CurrencyDesc, BuyCash, SellCash, SendCash, RecvCash, SellCheck, ExchangeRate, UsdRate, ConvertRate, 'N', GETDATE()
FROM #TMP_TABLE

--환율사용유무 인서트
UPDATE TBL_CODE_CURRENCY SET USE_YN = (CASE WHEN USE_YN='Y' THEN 'N' ELSE 'Y' END)

--환율미사용 삭제
DELETE TBL_CODE_CURRENCY WHERE USE_YN='N'


DROP TABLE #TMP_TABLE


EXEC SP_XML_REMOVEDOCUMENT @XML_DOCUMENT_HANDLE 
GO
