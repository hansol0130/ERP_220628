USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_PKG_MASTER_PRICE_SCH_COPY_SELECT
- 기 능 : 행사 가격/일정 마스터가격/일정 조회 
====================================================================================
	참고내용
====================================================================================
- 행사(가격,스케쥴) -> 마스터(가격,스케쥴)복사등록

- 예제
 EXEC SP_PKG_MASTER_PRICE_SCH_COPY_SELECT 'EPP500-131110KL' 
====================================================================================
	변경내역
====================================================================================
- 2014-03-17 박형만 최초생성
- 2014-07-01 박형만 상품총액표시
===================================================================================*/
CREATE PROC [dbo].[SP_PKG_MASTER_PRICE_SCH_COPY_SELECT]
	@PRO_CODE PRO_CODE  
AS 
SET NOCOUNT ON 

--DECLARE @PRO_CODE PRO_CODE 
--SET @PRO_CODE = 'EPP500-131110KL' 

DECLARE @MASTER_CODE MASTER_CODE 
SET @MASTER_CODE = SUBSTRING(@PRO_CODE,1,CHARINDEX('-',@PRO_CODE) -1 ) 

--마스터
SELECT * FROM PKG_MASTER WHERE MASTER_CODE = @MASTER_CODE 

--마스터가격
SELECT PRICE_SEQ , PRICE_NAME , 
dbo.XN_PRO_MASTER_SALE_PRICE_CUTTING(MASTER_CODE, PRICE_SEQ) AS ADT_PRICE 
FROM PKG_MASTER_PRICE WHERE MASTER_CODE = @MASTER_CODE 
--마스터일정
SELECT * , 
(SELECT KOR_NAME FROM PUB_CITY WHERE CITY_CODE =
	( SELECT TOP 1  CITY_CODE FROM PKG_MASTER_SCH_CITY AA WITH(NOLOCK)
		INNER JOIN PKG_MASTER_SCH_DAY BB WITH(NOLOCK) 
			ON AA.MASTER_CODE = BB.MASTER_CODE AND AA.SCH_SEQ = BB.SCH_SEQ AND AA.DAY_SEQ = BB.DAY_SEQ 
		WHERE  AA.MASTER_CODE =  A.MASTER_CODE 
		AND AA.SCH_SEQ = A.SCH_SEQ  
		AND AA.CITY_CODE NOT IN ( 'ICN','PUS') 
		AND AA.MAINCITY_YN = 'Y'  
		ORDER BY BB.DAY_NUMBER ASC ,  AA.CITY_SHOW_ORDER  ASC ) ) AS MAIN_CITY_NAME 
FROM PKG_MASTER_SCH_MASTER A WITH(NOLOCK) 
WHERE MASTER_CODE = @MASTER_CODE
--행사가격
SELECT PRICE_SEQ , PRICE_NAME , 
dbo.XN_PRO_DETAIL_SALE_PRICE_CUTTING(PRO_CODE, PRICE_SEQ) AS ADT_PRICE 
FROM PKG_DETAIL_PRICE WHERE PRO_CODE = @PRO_CODE 

--행사일정
SELECT *,
(SELECT KOR_NAME FROM PUB_CITY WHERE CITY_CODE =
	( SELECT TOP 1  CITY_CODE FROM PKG_DETAIL_SCH_CITY AA WITH(NOLOCK)
		INNER JOIN PKG_DETAIL_SCH_DAY BB WITH(NOLOCK) 
			ON AA.PRO_CODE = BB.PRO_CODE AND AA.SCH_SEQ = BB.SCH_SEQ AND AA.DAY_SEQ = BB.DAY_SEQ 
		WHERE AA.PRO_CODE =  A.PRO_CODE 
		AND AA.SCH_SEQ = A.SCH_SEQ 
		AND AA.CITY_CODE NOT IN ( 'ICN','PUS') 
		AND MAINCITY_YN = 'Y'   
		ORDER BY  BB.DAY_NUMBER ASC ,  AA.CITY_SHOW_ORDER  ASC)  ) AS MAIN_CITY_NAME  
FROM PKG_DETAIL_SCH_MASTER A WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE 

GO
