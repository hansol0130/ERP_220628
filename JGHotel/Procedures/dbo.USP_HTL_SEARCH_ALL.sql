USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HTL_SEARCH_ALL]
      
/*      
USP_HTL_SEARCH_ALL '도'
*/      
      
@KEYWORD VARCHAR(100)
      
AS      

SELECT *
FROM (
	SELECT *,
	RANK() OVER (PARTITION BY ITEM_TYPE ORDER BY SORT1, SORT2, SORT, HOTEL_CNT DESC, CITY_CODE, AREA_CODE, HOTEL_CODE) AS S_LANK
	FROM (
		SELECT *, 
		(CASE WHEN CHARINDEX(',', REVERSE(LEFT(INDEX_NAME, CHARINDEX(@KEYWORD, INDEX_NAME)))) = 0       
		THEN CHARINDEX(@KEYWORD, INDEX_NAME)      
		ELSE CHARINDEX(',', REVERSE(LEFT(INDEX_NAME, CHARINDEX(@KEYWORD, INDEX_NAME)))) END) AS SORT1,      
		LEN(LEFT(INDEX_NAME, CHARINDEX(@KEYWORD, INDEX_NAME))) AS SORT2
		FROM HTL_IDX_CITY
		WHERE (UPPER(INDEX_NAME) LIKE '%'+UPPER(@KEYWORD)+'%'      
		OR UPPER(INDEX_NAME) LIKE '%'+UPPER(@KEYWORD)+'%'      
		OR UPPER(INDEX_NAME) LIKE '%'+UPPER(@KEYWORD)+'%')
	) A
) B
WHERE B.S_LANK <= 10
ORDER BY (CASE B.ITEM_TYPE WHEN 'C' THEN 0 WHEN 'A' THEN 5 ELSE 9 END), SORT1, SORT2, S_LANK



GO
