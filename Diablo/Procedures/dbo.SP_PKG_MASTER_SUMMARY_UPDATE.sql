USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Database					: DIABLO
■ USP_Name					: SP_PKG_MASTER_SUMMARY_UPDATE 
■ Description				: 
■ Input Parameter			:                  
		@MASTER_CODE		: 마스터 코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	-- 전체실행
	EXEC SP_PKG_MASTER_SUMMARY_UPDATE
	-- 1개 마스터 단독 실행
	EXEC SP_PKG_MASTER_SUMMARY_UPDATE 'XPP1112'
	-- 전체실행 로그
	SELECT * FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE MASTER_CODE = 'SYSTEM'

	SELECT * FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE SEARCH_TYPE = 'G'

	-- 구분별 마스터 수
	SELECT A.SEARCH_TYPE, COUNT(*) FROM (SELECT SEARCH_TYPE, MASTER_CODE FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE MASTER_CODE <> 'SYSTEM' GROUP BY SEARCH_TYPE, MASTER_CODE) A GROUP BY A.SEARCH_TYPE

	-- 구분별 항목 수
	SELECT SEARCH_TYPE, COUNT(*) FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE MASTER_CODE <> 'SYSTEM' GROUP BY SEARCH_TYPE

	SELECT * FROM PKG_MASTER_SUMMARY A WITH(NOLOCK) WHERE SEARCH_VALUE IS NULL

■ Author					: 
■ Date						: 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2019-11-05		김성호			최초생성
	2020-02-24		김성호			마스터별 최저,최대일 등록 (SEARCH_TYPE : D.TOURDAY)
	2020-02-25		김성호			PKG_DETAIL테이블 SHOW_YN = 'Y' 조건 추가
	2020-03-12		홍종우			여행기간('D') 최소 3일표시에서 2일로 변경
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[SP_PKG_MASTER_SUMMARY_UPDATE]
(
	@MASTER_CODE VARCHAR(10) = NULL
)

AS

BEGIN
	SET NOCOUNT ON;

	DECLARE @MASTER_LIST TABLE (MASTER_CODE MASTER_CODE PRIMARY KEY)
	DECLARE @MASTER_SUMMARY_LIST TABLE (MASTER_CODE MASTER_CODE, SEARCH_TYPE VARCHAR(10), SEARCH_VALUE INT)

	DECLARE @STATUS VARCHAR(10) = 'SUCCESS'

	-- 대상 선정
	IF LEN(@MASTER_CODE) > 0
	BEGIN
		
		INSERT INTO @MASTER_LIST VALUES (@MASTER_CODE)

	END
	ELSE
	BEGIN

		-- 1년치 수집
		INSERT INTO @MASTER_LIST
		SELECT A.MASTER_CODE
		FROM PKG_MASTER A WITH(NOLOCK)
		INNER JOIN PKG_DETAIL B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
		WHERE A.SHOW_YN = 'Y' AND A.SECTION_YN = 'N' AND B.DEP_DATE >= GETDATE() AND B.DEP_DATE < DATEADD(YEAR, 1, GETDATE()) AND B.SHOW_YN = 'Y' --AND A.MASTER_CODE IN ('IPT001', 'IPT700')
		GROUP BY A.MASTER_CODE 
		ORDER BY A.MASTER_CODE;


		-- 전체등록시 일자갱신
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT * FROM (
			SELECT 'SYSTEM' [MASTER_CODE], '1.SDATE' [SEARCH_TYPE], CONVERT(VARCHAR(8), GETDATE(), 112) [SEARCH_VALUE]
			UNION
			SELECT 'SYSTEM' [MASTER_CODE], '2.STIME' [SEARCH_TYPE], REPLACE(CONVERT(VARCHAR(8), GETDATE(), 114), ':', '') [SEARCH_VALUE]
			UNION
			SELECT 'SYSTEM', '4.COUNT', COUNT(*)
			FROM @MASTER_LIST
		) A
	END

	BEGIN TRY

		-- 출발요일
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT A.MASTER_CODE, 'W', DATEPART(DW, A.DEP_DATE)
		FROM PKG_DETAIL A WITH(NOLOCK)
		WHERE A.MASTER_CODE IN (SELECT MASTER_CODE FROM @MASTER_LIST) AND A.DEP_DATE >= GETDATE() AND A.SHOW_YN = 'Y'
		GROUP BY A.MASTER_CODE, DATEPART(DW, A.DEP_DATE);

		-- 임시로그 ↓
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT 'SYSTEM' [MASTER_CODE], 'A.WEEK' [SEARCH_TYPE], REPLACE(CONVERT(VARCHAR(8), GETDATE(), 114), ':', '') [SEARCH_VALUE]
		-- 임시로그 ↑
	
		-- 상품속성
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT A.MASTER_CODE, 'T', (CASE WHEN A.ATT_CODE IN ('P', 'G', 'O', 'J', 'W', 'C', 'X', 'Y', 'E', 'S', 'K') THEN 1 ELSE 2 END)
		FROM PKG_MASTER A WITH(NOLOCK)
		WHERE A.MASTER_CODE IN (SELECT MASTER_CODE FROM @MASTER_LIST)
		UNION
		SELECT A.MASTER_CODE, 'T', 3 -- 라르고
		FROM PKG_MASTER A WITH(NOLOCK)
		WHERE A.MASTER_CODE IN (SELECT MASTER_CODE FROM @MASTER_LIST) AND A.BRAND_TYPE IS NOT NULL;

		-- 임시로그 ↓
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT 'SYSTEM' [MASTER_CODE], 'B.TYPE' [SEARCH_TYPE], REPLACE(CONVERT(VARCHAR(8), GETDATE(), 114), ':', '') [SEARCH_VALUE]
		-- 임시로그 ↑

		-- 여행기간
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT A.MASTER_CODE, 'D', (CASE WHEN A.TOUR_DAY < 2 THEN 2 WHEN A.TOUR_DAY > 12 THEN 12 ELSE A.TOUR_DAY END)
		FROM PKG_DETAIL A WITH(NOLOCK)
		WHERE A.MASTER_CODE IN (SELECT MASTER_CODE FROM @MASTER_LIST) AND A.DEP_DATE >= GETDATE() AND A.SHOW_YN = 'Y'
		GROUP BY A.MASTER_CODE, A.TOUR_DAY;

		-- 마스터 최저, 최대 여행일자
		WITH LIST AS (
			SELECT A.MASTER_CODE, MIN(A.TOUR_DAY) AS [MINDAY], MAX(A.TOUR_DAY) AS [MAXDAY]
			FROM PKG_DETAIL A WITH(NOLOCK)
			WHERE A.MASTER_CODE IN (SELECT MASTER_CODE FROM @MASTER_LIST) AND A.DEP_DATE >= GETDATE() AND A.SHOW_YN = 'Y'
			GROUP BY A.MASTER_CODE
		)
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT A.MASTER_CODE, 'D.TOURDAY' AS [SEARCH_TYPE], A.MINDAY AS [SEARCH_VALUE]
		FROM LIST A
		UNION
		SELECT A.MASTER_CODE, 'D.TOURDAY', A.MAXDAY
		FROM LIST A
		ORDER BY A.MASTER_CODE, SEARCH_VALUE;

		-- 임시로그 ↓
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT 'SYSTEM' [MASTER_CODE], 'C.DAY' [SEARCH_TYPE], REPLACE(CONVERT(VARCHAR(8), GETDATE(), 114), ':', '') [SEARCH_VALUE]
		-- 임시로그 ↑

		-- 상품가격
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT A.MASTER_CODE, 'P', A.PRICE_TYPE
		FROM (
			SELECT A.MASTER_CODE, (
				CASE
					WHEN (B.ADT_PRICE + B.ADT_TAX) < 300000 THEN 1
					WHEN (B.ADT_PRICE + B.ADT_TAX) >= 300000 AND (B.ADT_PRICE + B.ADT_TAX) < 800000 THEN 2
					WHEN (B.ADT_PRICE + B.ADT_TAX) >= 800000 AND (B.ADT_PRICE + B.ADT_TAX) < 1300000 THEN 3
					WHEN (B.ADT_PRICE + B.ADT_TAX) >= 1300000 AND (B.ADT_PRICE + B.ADT_TAX) < 2000000 THEN 4
					WHEN (B.ADT_PRICE + B.ADT_TAX) >= 2000000 AND (B.ADT_PRICE + B.ADT_TAX) < 3000000 THEN 5
					WHEN (B.ADT_PRICE + B.ADT_TAX) >= 3000000 THEN 6
				END) PRICE_TYPE
			FROM PKG_DETAIL A WITH(NOLOCK)
			INNER JOIN PKG_DETAIL_PRICE B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE
			WHERE A.MASTER_CODE IN (SELECT MASTER_CODE FROM @MASTER_LIST) AND A.DEP_DATE >= GETDATE() AND A.SHOW_YN = 'Y'
			GROUP BY A.MASTER_CODE, (
				CASE
					WHEN (B.ADT_PRICE + B.ADT_TAX) < 300000 THEN 1
					WHEN (B.ADT_PRICE + B.ADT_TAX) >= 300000 AND (B.ADT_PRICE + B.ADT_TAX) < 800000 THEN 2
					WHEN (B.ADT_PRICE + B.ADT_TAX) >= 800000 AND (B.ADT_PRICE + B.ADT_TAX) < 1300000 THEN 3
					WHEN (B.ADT_PRICE + B.ADT_TAX) >= 1300000 AND (B.ADT_PRICE + B.ADT_TAX) < 2000000 THEN 4
					WHEN (B.ADT_PRICE + B.ADT_TAX) >= 2000000 AND (B.ADT_PRICE + B.ADT_TAX) < 3000000 THEN 5
					WHEN (B.ADT_PRICE + B.ADT_TAX) >= 3000000 THEN 6
				END)
			) A

		-- 임시로그 ↓
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT 'SYSTEM' [MASTER_CODE], 'D.PRICE' [SEARCH_TYPE], REPLACE(CONVERT(VARCHAR(8), GETDATE(), 114), ':', '') [SEARCH_VALUE]
		-- 임시로그 ↑


		-- 항공편
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT A.MASTER_CODE, 'A', ISNULL(C.AIRLINE_TYPE, 4) AS [AIRLINE_TYPE]
		FROM PKG_DETAIL A WITH(NOLOCK)
		LEFT JOIN PRO_TRANS_SEAT B WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE
		LEFT JOIN PUB_AIRLINE C WITH(NOLOCK) ON B.DEP_TRANS_CODE = C.AIRLINE_CODE
		WHERE A.MASTER_CODE IN (SELECT MASTER_CODE FROM @MASTER_LIST) AND A.DEP_DATE >= GETDATE() AND A.SHOW_YN = 'Y'
		GROUP BY A.MASTER_CODE, C.AIRLINE_TYPE;

		-- 임시로그 ↓
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT 'SYSTEM' [MASTER_CODE], 'E.AIRLINE' [SEARCH_TYPE], REPLACE(CONVERT(VARCHAR(8), GETDATE(), 114), ':', '') [SEARCH_VALUE]
		-- 임시로그 ↑

		-- 호텔
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT A.MASTER_CODE, 'G', SUBSTRING(A.HOTEL_GRADE, B.SEQ, 1)
		FROM PKG_MASTER A WITH(NOLOCK)
		CROSS JOIN PUB_TMP_SEQ B WITH(NOLOCK)
		WHERE A.MASTER_CODE IN (SELECT MASTER_CODE FROM @MASTER_LIST) AND B.SEQ <= 3 AND SUBSTRING(A.HOTEL_GRADE, B.SEQ, 1) <> '0'

		-- 임시로그 ↓
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT 'SYSTEM' [MASTER_CODE], 'F.GRADE' [SEARCH_TYPE], REPLACE(CONVERT(VARCHAR(8), GETDATE(), 114), ':', '') [SEARCH_VALUE]
		-- 임시로그 ↑

		-- 출발지역
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT A.MASTER_CODE, 'S', A.BRANCH_CODE AS [BRANCH_CODE]
		FROM PKG_MASTER A WITH(NOLOCK)
		WHERE A.MASTER_CODE IN (SELECT MASTER_CODE FROM @MASTER_LIST);

		-- 임시로그 ↓
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT 'SYSTEM' [MASTER_CODE], 'G.START' [SEARCH_TYPE], REPLACE(CONVERT(VARCHAR(8), GETDATE(), 114), ':', '') [SEARCH_VALUE]
		-- 임시로그 ↑

		-- 업데이트 종료
		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT 'SYSTEM' [MASTER_CODE], '3.ETIME' [SEARCH_TYPE], REPLACE(CONVERT(VARCHAR(8), GETDATE(), 114), ':', '') [SEARCH_VALUE]


	END TRY
	BEGIN CATCH
		
		-- 에러발생
		SET @STATUS = 'FALSE'

		INSERT INTO @MASTER_SUMMARY_LIST (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT 'SYSTEM' [MASTER_CODE], '5.FALSE' [SEARCH_TYPE], ERROR_LINE() [SEARCH_VALUE]

	END CATCH

	IF @STATUS = 'SUCCESS'
	BEGIN
		
		IF LEN(@MASTER_CODE) > 0
		BEGIN
			DELETE FROM PKG_MASTER_SUMMARY WHERE MASTER_CODE = @MASTER_CODE
		END
		ELSE
		BEGIN
			DELETE FROM PKG_MASTER_SUMMARY
		END

		INSERT PKG_MASTER_SUMMARY (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE FROM @MASTER_SUMMARY_LIST
	END
	ELSE
	BEGIN

		DELETE FROM PKG_MASTER_SUMMARY WHERE MASTER_CODE = '_SYSTEM';

		INSERT PKG_MASTER_SUMMARY (MASTER_CODE, SEARCH_TYPE, SEARCH_VALUE)
		SELECT '_SYSTEM', SEARCH_TYPE, SEARCH_VALUE FROM @MASTER_SUMMARY_LIST
		WHERE MASTER_CODE = 'SYSTEM';

	END
	

END


GO
