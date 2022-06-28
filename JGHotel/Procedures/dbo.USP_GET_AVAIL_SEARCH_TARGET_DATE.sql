USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GET_AVAIL_SEARCH_TARGET_DATE]    
    
/*    
USP_GET_AVAIL_SEARCH_TARGET_DATE    
*/    
    
@XML VARCHAR(MAX)    
    
AS    
    
    
DECLARE @XML_DOCUMENT_HANDLE INT;                                  
DECLARE @XML_DOCUMENT VARCHAR(MAX);                                  
SET @XML_DOCUMENT = '<?xml version="1.0" encoding="euc-kr"?>' + @XML                                     
  
                        
EXEC SP_XML_PREPAREDOCUMENT @XML_DOCUMENT_HANDLE OUTPUT, @XML_DOCUMENT               
            
                 
SELECT DT            
INTO #TMP_TABLE                        
FROM OPENXML (@XML_DOCUMENT_HANDLE, '/TDateRQ/Day',2)                                 
WITH (                                                                                                                                                
     DT DATETIME './DT'    
) A        
ORDER BY DT    
    
  
SELECT DT  
FROM (  
 SELECT A.DT, RANK() OVER (ORDER BY NEWID()) AS SORT  
 FROM #TMP_TABLE A  
 LEFT JOIN HTL_CODE_HOLIDAY B ON A.DT=B.TARGET_DATE  
 LEFT JOIN HTL_CODE_HOLIDAY C ON A.DT=DATEADD(DAY, -1, C.TARGET_DATE)  
 WHERE B.TARGET_DATE IS NULL  
 AND C.TARGET_DATE IS NULL  
) A  
WHERE SORT < 2  
ORDER BY DT  
    
    
EXEC SP_XML_REMOVEDOCUMENT @XML_DOCUMENT_HANDLE     


GO
