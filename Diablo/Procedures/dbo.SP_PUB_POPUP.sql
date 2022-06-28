USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_PUB_POPUP]  
AS  
-- 날짜 시간 무제한 팝업 = 모두 null  
  
SELECT * from pub_popup  WITH(NOLOCK) 
WHERE 1=1   
AND popStartDate is null   
AND popStartTime is null   
AND popEndDate is null  
AND popEndTime is null  
AND popIsPause = 0  

union all   
  
-- 시간 제한  
SELECT * from pub_popup    WITH(NOLOCK) 
WHERE 1=1   
AND Convert(varchar(8), getDate(), 108) BETWEEN popStartTime And popEndTime  
AND popStartDate is null   
AND popEndDate is null  
AND popIsPause = 0  

union all   
  
-- 날짜 시간 제한  
SELECT * from pub_popup    WITH(NOLOCK) 
WHERE 1=1   
AND getDate() BETWEEN CAST(popStartDate + ' ' + popStartTime AS DateTime) And CAST(popEndDate + ' ' + popEndTime AS DateTime)
AND popIsPause = 0  
  
GO
