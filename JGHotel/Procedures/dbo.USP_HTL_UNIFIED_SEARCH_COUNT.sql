USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HTL_UNIFIED_SEARCH_COUNT]

/*
USP_HTL_UNIFIED_SEARCH_COUNT '토'
*/

@KEYWORD VARCHAR(100)=''

AS

SET @KEYWORD = REPLACE(@KEYWORD, ' ', '')

--총카운트
SELECT INT_DOM, COUNT(*) AS CNT
FROM HTL_IDX_SEARCH WITH (NOLOCK)
WHERE USE_YN='Y'
AND INDEX_NAME LIKE '%'+@KEYWORD+'%'
GROUP BY INT_DOM
ORDER BY INT_DOM DESC


SELECT INT_DOM, CITY_CODE, CITY_NAME, COUNT(*) AS CNT
FROM HTL_IDX_SEARCH WITH (NOLOCK)
WHERE USE_YN='Y'
AND INDEX_NAME LIKE '%'+@KEYWORD+'%'
GROUP BY INT_DOM, CITY_CODE, CITY_NAME
ORDER BY INT_DOM DESC, MIN(SORT_ORDER) ASC


GO