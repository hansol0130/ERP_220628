USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_MAPP_CHECK]

/*
USP_MAPP_CHECK
*/

AS


SELECT *
INTO #TMP_MAPP
FROM (
	SELECT C.CITY_CODE, C.CITY_NAME, D.SORT_ORDER,
	SUM(CASE WHEN SUPP_CODE='EX' THEN 1 ELSE 0 END) AS EX_CNT,
	SUM(CASE WHEN SUPP_CODE='RT' THEN 1 ELSE 0 END) AS RT_CNT,
	SUM(CASE WHEN SUPP_CODE='GT' THEN 1 ELSE 0 END) AS GT_CNT
	FROM HTL_MAPP_HOTEL A
	JOIN HTL_INFO_MAST_HOTEL B ON A.HOTEL_CODE=B.HOTEL_CODE
	JOIN HTL_CODE_MAST_CITY C ON B.CITY_CODE=C.CITY_CODE
	JOIN HTL_TMP_CITY D ON C.CITY_CODE=D.CITY_CODE
	WHERE C.NATION_CODE <> 'KR'
	GROUP BY C.CITY_CODE, C.CITY_NAME, D.SORT_ORDER
) A
ORDER BY SORT_ORDER



SELECT *
INTO #TMP_SUB
FROM (
	SELECT A.CITY_CODE, A.CITY_NAME, E.SORT_ORDER,
	SUM(CASE WHEN D.SUPP_CODE='EX' THEN 1 ELSE 0 END) AS EX_CNT,
	SUM(CASE WHEN D.SUPP_CODE='RT' THEN 1 ELSE 0 END) AS RT_CNT,
	SUM(CASE WHEN D.SUPP_CODE='GT' THEN 1 ELSE 0 END) AS GT_CNT
	FROM HTL_CODE_MAST_CITY A
	JOIN HTL_MAPP_CITY B ON A.CITY_CODE=B.CITY_CODE
	JOIN HTL_CODE_SUB_CITY C ON B.SUPP_CODE=C.SUPP_CODE AND B.S_CITY_CODE=C.CITY_CODE
	JOIN HTL_INFO_SUB_HOTEL D ON C.SUPP_CODE=D.SUPP_CODE AND C.CITY_CODE=D.CITY_CODE
	JOIN HTL_TMP_CITY E ON A.CITY_CODE=E.CITY_CODE
	WHERE A.NATION_CODE<>'KR'
	GROUP BY A.CITY_CODE, A.CITY_NAME, E.SORT_ORDER
) A
ORDER BY SORT_ORDER



SELECT A.CITY_CODE, A.CITY_NAME, 
A.EX_CNT, B.EX_CNT AS EX_ORG_CNT, 
A.RT_CNT, B.RT_CNT AS RT_ORG_CNT, 
A.GT_CNT, B.GT_CNT AS GT_ORG_CNT
FROM #TMP_MAPP A
JOIN #TMP_SUB B ON A.CITY_CODE=B.CITY_CODE
ORDER BY A.SORT_ORDER


GO
