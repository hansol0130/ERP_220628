USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_AIR_PROMOTION_SERVICE_SELECT
■ DESCRIPTION				: 항공 프로모션 서비스 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	SP_AIR_PROMOTION_SERVICE_SELECT 'Verygood', '2017-09-12'
	SP_AIR_PROMOTION_SERVICE_SELECT 'Verygood', '2020-02-29'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2017-02-16			정지용			최초생성
2017-08-25			정지용			프로모션 로직 변경으로 인해 쿼리 리뉴얼
2017-08-30			정지용			LIMITED_DATE 공백일때 기본 NULL값으로
2019-07-23			박형만			최소적용 인원 추가 
2019-09-10			박형만			DEP_dATE  VARCHAR(10) -> DATETIME 으로  (2020-02-29 동작 안하는 현상 해결 ) 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_AIR_PROMOTION_SERVICE_SELECT]	
	@SITE_CODE VARCHAR(30),
	@DEP_DATE DATETIME 
AS 
BEGIN
	WITH PROMOTION_LIST AS
	(
		SELECT
			SEQ_NO, TITLE, AIRLINE_CODE, AIRPORT_CODE, CLASS, SDATE, EDATE, DEP_SDATE, DEP_EDATE,
			SALE_PRICE, SALE_COMM_RATE, SITE_CODE, CASE WHEN LIMITED_DATE = '' THEN NULL ELSE LIMITED_DATE END AS LIMITED_DATE,
			MIN_PAX_COUNT
		FROM AIR_PROMOTION WITH(NOLOCK)
		WHERE CHARINDEX(@SITE_CODE, SITE_CODE) > 0
			AND USE_YN = 'Y' 
			AND SDATE <= GETDATE() AND EDATE >= GETDATE()
			AND DEP_SDATE <= @DEP_DATE AND DEP_EDATE >= @DEP_DATE
	),
	PROMOTION_LIMITED_LIST AS
	(
		SELECT
			A.SEQ_NO,
			LEFT(LIMIT_DATE, CHARINDEX('~', LIMIT_DATE) - 1) AS LIMIT_SDATE,
			RIGHT(LIMIT_DATE, CHARINDEX('~', REVERSE(LIMIT_DATE)) - 1) AS LIMIT_EDATE
		FROM (
			SELECT 
				A.SEQ_NO, CAST(SUBSTRING(A.LIMITED_DATE, B.S, B.E-B.S) AS VARCHAR) AS LIMIT_DATE
			FROM PROMOTION_LIST A
			CROSS APPLY (
				SELECT TOP (2047) NUMBER AS S, CHARINDEX('/', A.LIMITED_DATE + '/', NUMBER + 1) AS E
				FROM MASTER.DBO.SPT_VALUES
				WHERE NUMBER = CHARINDEX('/', '/' + A.LIMITED_DATE, NUMBER) AND TYPE = 'P'
				ORDER BY NUMBER
			) B
			GROUP BY A.SEQ_NO, A.LIMITED_DATE, B.S, B.E
		) A
	)
	SELECT 
		A.* 
	FROM PROMOTION_LIST A
	WHERE SEQ_NO NOT IN (
		SELECT SEQ_NO FROM PROMOTION_LIMITED_LIST WHERE LIMIT_SDATE <= @DEP_DATE AND LIMIT_EDATE >= @DEP_DATE
	);


	/*
	SELECT
		SEQ_NO, TITLE, AIRLINE_CODE, AIRPORT_CODE, CLASS, SDATE, EDATE, DEP_SDATE, DEP_EDATE,
		SALE_PRICE, SALE_COMM_RATE, SITE_CODE
	FROM AIR_PROMOTION WITH(NOLOCK)
	WHERE CHARINDEX(@SITE_CODE, SITE_CODE) > 0
		AND USE_YN = 'Y' 
		AND SDATE <= GETDATE() AND EDATE >= GETDATE()
		AND DEP_SDATE <= @DEP_DATE AND DEP_EDATE >= @DEP_DATE
	*/
END

GO
