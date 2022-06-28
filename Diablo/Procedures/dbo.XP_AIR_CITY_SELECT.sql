USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================

■ USP_NAME					: XP_AIR_CITY_SELECT
■ DESCRIPTION				: 항공 지역 포함 도시 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC XP_AIR_CITY_SELECT 'CITY_CODE', '0', '1'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-05-11		정지용			최초생성
   2018-02-05		박형만			항공 도시 검색 정렬 MAJOR_YN ='Y' 우선, 도시명 가나다순 수정 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_AIR_CITY_SELECT]
	@GRP_CODE VARCHAR(10),
	@IS_USE_HTL CHAR(1),
	@IS_USE_AIR CHAR(1)
AS 
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
--declare @GRP_CODE VARCHAR(10),
--	@IS_USE_HTL CHAR(1),
--	@IS_USE_AIR CHAR(1)
--select @GRP_CODE='CITY_CODE',@IS_USE_HTL='0',@IS_USE_AIR='1'
	SELECT 
		A.REGION_CODE, A.KOR_NAME AS REGION_NAME, B.NATION_CODE, A.NATION_NAME, B.CITY_CODE		
		, B.KOR_NAME + '[' + ISNULL(B.RESULT_WORD, '') + ']' AS CITY_KOR_NAME
		, ENG_NAME + '[' + ISNULL(B.RESULT_WORD, '') + ']' AS CITY_ENG_NAME 
		--,  A.SORT_NUM  , B.MAJOR_YN , B.ORDER_SEQ 
	FROM (
		SELECT A.REGION_CODE, A.KOR_NAME, A.SORT_NUM, B.KOR_NAME AS NATION_NAME, B.NATION_CODE 
		FROM (
			SELECT REGION_CODE, 
				CASE KOR_NAME
					WHEN '북미지역' THEN '미주'
					WHEN '대양주' THEN '남태평양'
					WHEN '사이판/괌' THEN '남태평양'
					ELSE KOR_NAME
				END AS KOR_NAME,
				CASE REGION_CODE 
					WHEN '330' THEN 1	
					WHEN '310' THEN 2
					WHEN '320' THEN 3
					WHEN '210' THEN 4
					WHEN '110' THEN 5
					ELSE 6
				END SORT_NUM
			FROM PUB_REGION 
			WHERE REGION_CODE IN (330, 310, 320, 210, 110, 340, 360) -- 동남아 / 일본 / 중국/ 유럽 / 미주 / 남태평양
		) A 
		INNER JOIN PUB_NATION B ON A.REGION_CODE = B.REGION_CODE
		GROUP BY A.KOR_NAME, A.REGION_CODE, A.SORT_NUM, B.KOR_NAME, B.REGION_CODE, B.IS_USE, B.NATION_CODE
		HAVING B.IS_USE = '1'
	) A 
	INNER JOIN (
		SELECT * FROM
		COD_APPROACH A WITH(NOLOCK)
		INNER JOIN PUB_CITY B WITH(NOLOCK) ON A.RESULT_WORD = B.CITY_CODE
		WHERE A.GRP_CODE = @GRP_CODE 
			  AND (@IS_USE_AIR = '1' AND B.IS_USE_AIR = @IS_USE_AIR ) OR (@IS_USE_HTL = '1' AND B.IS_USE_HTL = @IS_USE_HTL)
			  AND B.KOR_NAME IS NOT NULL

	) B ON A.NATION_CODE = B.NATION_CODE
	
	--GROUP BY REGION_CODE, A.KOR_NAME, A.NATION_NAME, A.SORT_NUM, B.NATION_CODE, B.KOR_NAME, B.ENG_NAME, B.RESULT_WORD, B.CITY_CODE  -- 기존 
	GROUP BY REGION_CODE, A.KOR_NAME, A.NATION_NAME, A.SORT_NUM, B.NATION_CODE, B.KOR_NAME, B.ENG_NAME, B.RESULT_WORD, B.CITY_CODE 
	,  B.MAJOR_YN , B.ORDER_SEQ  
	--ORDER BY A.SORT_NUM, NATION_CODE, REGION_NAME ASC;-- 기존 
	ORDER BY A.SORT_NUM, (CASE WHEN B.MAJOR_YN ='Y' THEN 1 ELSE 0 END) DESC,  /*ORDER_sEQ ASC,*/  CITY_KOR_NAME ASC ,  NATION_CODE, REGION_NAME ASC;

END
GO
