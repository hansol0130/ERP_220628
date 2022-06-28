USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [schedule].[SP_STS_PKG_RES_COUNT]
■ DESCRIPTION				: 패키지 연령별 구매비율
■ INPUT PARAMETER			: 

	@TODAY					: 기준일

■ EXEC						: 

	EXEC schedule.SP_STS_PKG_RES_COUNT @TODAY=null

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2009-03-22		김성호			최초생성 (dbo.SP_STS_PKG_RES_COUNT)
   2022-06-15		김성호			출발일 조건 PKG_DETAIL 에서 RES_MASTER 로 변경, 출발일 범위 조건으로 수정
================================================================================================================*/ 
CREATE PROCEDURE [schedule].[SP_STS_PKG_RES_COUNT]
	@TODAY			VARCHAR(10)	-- 행사출발일
AS
BEGIN

	SET ANSI_WARNINGS OFF
	SET NOCOUNT ON;
/*
	DECLARE @TODAY VARCHAR(10), @PRO_TYPE INT
	SET @TODAY = '2009-03-20'
	SET @PRO_TYPE = 1
*/
	-- 임시테이블 선언
	CREATE TABLE #AGE_TEMP (
		[MASTER_CODE] VARCHAR(10), [TOTAL] INT, [TWO] INT, [THREE] INT, [FOUR] INT, [FIVE] INT
	)

	DECLARE @START_DATE DATETIME, @END_DATE DATETIME
	
	-- 날짜 세팅
	IF @TODAY IS NULL
		SELECT @START_DATE = CONVERT(DATE, GETDATE()), @END_DATE = CONVERT(DATE, DATEADD(DD, 1, GETDATE())) 
	ELSE
		SELECT @START_DATE = @TODAY, @END_DATE = DATEADD(DD, 1, CONVERT(DATETIME, @TODAY))

	-- 연령별 예약정보 임시 저장
	INSERT INTO #AGE_TEMP
	SELECT A.MASTER_CODE, COUNT(*)
		, COUNT(CASE WHEN A.AGE_NUM < 30 THEN 1 END)
		, COUNT(CASE WHEN A.AGE_NUM >= 30 AND A.AGE_NUM < 40 THEN 1 END)
		, COUNT(CASE WHEN A.AGE_NUM >= 40 AND A.AGE_NUM < 50 THEN 1 END)
		, COUNT(CASE WHEN A.AGE_NUM >= 50 THEN 1 END)
	FROM (
		SELECT C.MASTER_CODE--, A.RES_CODE, A.CUS_NAME
			, RIGHT((109 - CONVERT(INT, SUBSTRING(A.SOC_NUM1, 1, 2))), 2) AS [AGE_NUM]
		FROM RES_CUSTOMER A
		INNER JOIN RES_MASTER B ON A.RES_CODE = B.RES_CODE
		INNER JOIN PKG_DETAIL C ON B.PRO_CODE = C.PRO_CODE
		WHERE B.DEP_DATE >= @START_DATE AND B.DEP_DATE < @END_DATE AND B.RES_STATE < 7 AND A.RES_STATE IN (0, 3, 4)
			AND A.SOC_NUM1 IS NOT NULL
	) A
	GROUP BY A.MASTER_CODE

	-- 신규 예약정보 업데이트
	UPDATE A SET ALL_COUNT = (ALL_COUNT + B.TOTAL)
		, TWO_COUNT = (TWO_COUNT + B.TWO), THREE_COUNT = (THREE_COUNT + B.THREE)
		, FOUR_COUNT = (FOUR_COUNT + B.FOUR), FIVE_COUNT = (FIVE_COUNT + B.FIVE)
		, UPDATE_DATE = GETDATE()
	FROM STS_PKG_RES_COUNT A
	INNER JOIN #AGE_TEMP B ON A.MASTER_CODE = B.MASTER_CODE
	WHERE B.MASTER_CODE IN (SELECT MASTER_CODE FROM STS_PKG_RES_COUNT) --AND A.UPDATE_DATE < @DEP_DATE

	-- 신규 예약정보 인서트
	INSERT INTO STS_PKG_RES_COUNT (MASTER_CODE, ALL_COUNT, TWO_COUNT, THREE_COUNT, FOUR_COUNT, FIVE_COUNT, UPDATE_DATE)
	SELECT *, GETDATE() FROM #AGE_TEMP A
	WHERE A.MASTER_CODE NOT IN (SELECT MASTER_CODE FROM STS_PKG_RES_COUNT)

	-- 비율 업데이트
	UPDATE STS_PKG_RES_COUNT SET
		TWO_PERCENT = 100 * TWO_COUNT / ALL_COUNT
		, THREE_PERCENT = 100 * THREE_COUNT / ALL_COUNT
		, FOUR_PERCENT = 100 * FOUR_COUNT / ALL_COUNT
		, FIVE_PERCENT = 100 * FIVE_COUNT / ALL_COUNT
	WHERE UPDATE_DATE > @START_DATE AND ALL_COUNT > 0

	--SELECT * FROM #AGE_TEMP
	DROP TABLE #AGE_TEMP

END

--EXEC SP_STS_PKG_RES_COUNT '2009-03-20', 1

--SELECT * FROM STS_PKG_RES_COUNT
--DELETE FROM STS_PKG_RES_COUNT
GO
