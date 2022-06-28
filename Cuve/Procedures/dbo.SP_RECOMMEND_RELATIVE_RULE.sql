USE [Cuve]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_RECOMMEND_RELATIVE_RULE
- 기 능 : 연관규칙으로 3개 상품 추천 
====================================================================================
	참고내용
====================================================================================
- 예제

EXEC SP_RECOMMEND_RELATIVE_RULE 'jpf9800', 'app013', 'app1888'
EXEC SP_RECOMMEND_RELATIVE_RULE 'app911', 'app911', 'app9495'
====================================================================================
	변경내역
====================================================================================
- 2017-04-28 아이비솔루션 오준욱 최초작성(윤형도계장 작성)
- 2017-05-09 마스터코드 3개 인자로 받는 방식으로 변경
===================================================================================*/
CREATE PROCEDURE [dbo].[SP_RECOMMEND_RELATIVE_RULE]
(
	@MASTER_CODE1	VARCHAR(20),
	@MASTER_CODE2	VARCHAR(20),
	@MASTER_CODE3	VARCHAR(20)
)

AS
BEGIN


	-- 사용하는 테이블


	--TMP_MASTER_CODE_MAIN_CITY   -- 모든 마스터상품의 메인 CITY를 담고 있음
	--TMP_APRIORI_TRAIN_DATA      -- Apriori 룰 규칙 포함
	--Diablo..PKG_MASTER -- 상품테이블


	-- apriori 기반 추천 output 변수

	DECLARE @마스터코드1 VARCHAR(20)
	DECLARE @마스터코드2 VARCHAR(20)
	DECLARE @마스터코드3 VARCHAR(20)
	DECLARE @추천상품1    VARCHAR(20)
	DECLARE @추천상품2    VARCHAR(20)
	DECLARE @추천상품3    VARCHAR(20)

	--INPUT 데이터 

	SET @마스터코드1 = @MASTER_CODE1;  
	SET @마스터코드2 = @MASTER_CODE2;  
	SET @마스터코드3 = @MASTER_CODE3;  

	-- apriori 기반 추천쿼리

	WITH LIST AS 
	
	(		
		SELECT TOP 2 * 
		FROM 
		(
			SELECT *,
				ROW_NUMBER() OVER(PARTITION BY 예약상품 ORDER BY 상품갯수 DESC, 지지도 DESC) AS RANK_NO
			FROM 
				(
					SELECT 	
						SEQ,
						예약상품,
						(SELECT 
							COUNT(*) 
							FROM 
							TMP_APRIORI_TRAIN_DATA Z
							WHERE 
							Z.SEQ = A.SEQ 
							AND (
								마스터코드 = @마스터코드1 OR
								마스터코드 = @마스터코드2 OR
								마스터코드 = @마스터코드3														
								)
						) AS 상품갯수,
						지지도
					FROM 
						TMP_APRIORI_TRAIN_DATA A

					WHERE 
						SEQ IN
							(
							SELECT
								SEQ 
							FROM 
								TMP_APRIORI_TRAIN_DATA
							WHERE 
								마스터코드 = @마스터코드1 OR
								마스터코드 = @마스터코드2 OR
								마스터코드 = @마스터코드3

							GROUP BY SEQ
							)
				) B
		) C
	
		WHERE 
			C.RANK_NO = 1
	)	

	SELECT @추천상품1 = 예약상품 FROM LIST ORDER BY SEQ DESC

	;


	WITH LIST9 AS 
	
	(		
		SELECT TOP 2 * 
		FROM 
		(
			SELECT *,
				ROW_NUMBER() OVER(PARTITION BY 예약상품 ORDER BY 상품갯수 DESC, 지지도 DESC) AS RANK_NO
			FROM 
				(
					SELECT 	
						SEQ,
						예약상품,
						(SELECT 
							COUNT(*) 
							FROM 
							TMP_APRIORI_TRAIN_DATA Z
							WHERE 
							Z.SEQ = A.SEQ 
							AND (
								마스터코드 = @마스터코드1 OR
								마스터코드 = @마스터코드2 OR
								마스터코드 = @마스터코드3														
								)
						) AS 상품갯수,
						지지도
					FROM 
						TMP_APRIORI_TRAIN_DATA A

					WHERE 
						SEQ IN
							(
							SELECT
								SEQ 
							FROM 
								TMP_APRIORI_TRAIN_DATA
							WHERE 
								마스터코드 = @마스터코드1 OR
								마스터코드 = @마스터코드2 OR
								마스터코드 = @마스터코드3

							GROUP BY SEQ
							)
				) B
		) C
	
		WHERE 
			C.RANK_NO = 1
	)	


	SELECT @추천상품2 = 예약상품 FROM LIST9 ORDER BY SEQ ASC


	-- 내용기반(CBF) 추천 쿼리 

	-- 내용기반추천 변수

	DECLARE @CITY_CODE1 VARCHAR(20)
	DECLARE @CITY_CODE2 VARCHAR(20)
	DECLARE @CITY_CODE3 VARCHAR(20)
	DECLARE @CITY_CODE4 VARCHAR(20)
	DECLARE @CITY_CODE5 VARCHAR(20)
	DECLARE @MASTER_CODE VARCHAR(20)
	DECLARE @AVG_PRICE VARCHAR(20)
	DECLARE @AVG_TOUR_DAY INT
	DECLARE @REGION_CODE VARCHAR(20)
	DECLARE @ATT_CODE VARCHAR(20)

	-- 조회한 상품 3개의 평균가격, 평균여행일자, Top 1 지역코드, top 1 상품타입 조회

	SELECT @AVG_PRICE = AVG(LOW_PRICE) FROM Diablo..PKG_MASTER WHERE MASTER_CODE IN (@마스터코드1, @마스터코드2, @마스터코드3)
	SELECT @AVG_TOUR_DAY = AVG(TOUR_DAY) FROM Diablo..PKG_MASTER WHERE MASTER_CODE IN (@마스터코드1, @마스터코드2, @마스터코드3)
	SELECT TOP 1 @REGION_CODE = SIGN_CODE FROM Diablo..PKG_MASTER WHERE MASTER_CODE IN (@마스터코드1, @마스터코드2, @마스터코드3) GROUP BY SIGN_CODE ORDER BY COUNT(*) DESC
	SELECT TOP 1 @ATT_CODE = ATT_CODE FROM Diablo..PKG_MASTER WHERE MASTER_CODE IN (@마스터코드1, @마스터코드2, @마스터코드3) GROUP BY ATT_CODE ORDER BY COUNT(*) DESC
	;


	WITH LIST2 AS 
	( 
		SELECT
			B.MASTER_CODE		AS OPEN_MASTER,
			B.REGION_CODE,
			B.ATT_CODE,
			B.CITY_CODE,
			B.LOW_PRICE,
			B.TOUR_DAY
		FROM 
			TMP_MASTER_CODE_MAIN_CITY B  -- 미리 생성해놓은 테이블로. 살아있는 상품들의 main_city를 별도로 담아놓음
		WHERE 
			MASTER_CODE IN (@마스터코드1, @마스터코드2, @마스터코드3)

		GROUP BY 
			B.MASTER_CODE,
			B.CITY_CODE,
			B.LOW_PRICE,
			B.TOUR_DAY,
			B.REGION_CODE,
			B.ATT_CODE
	)

	, LIST3 AS
	(
	SELECT
		K.RANKING,
		K.CITY_CODE,
		K.CNT,
		@AVG_PRICE AS AVG_PRICE,
		@AVG_TOUR_DAY AS AVG_TOUR_DAT
	FROM
		(
		SELECT 
			ROW_NUMBER() OVER (ORDER BY CNT DESC) AS RANKING,
			CITY_CODE,
			CNT
		FROM
			(
			SELECT 
				CITY_CODE,
				COUNT(*) AS CNT
			FROM 
				LIST2
			GROUP BY
				CITY_CODE
			) T
		) K

	WHERE
		RANKING in (1,2,3,4,5)
	)

	--select * from list3

	SELECT TOP 1 
			--*
			@추천상품3  = MASTER_CODE
	FROM
		(
		SELECT 
			MASTER_CODE,
			REGION_CODE,
			ATT_CODE,
			COUNT(*) AS CNT, -- 대표 도시 매칭 개수
			MAX(LOW_PRICE) AS PRICE, -- 상품가격
			MAX(TOUR_DAY) AS TOUR_DAY -- 여행일정

		fROM 
			TMP_MASTER_CODE_MAIN_CITY
	
		WHERE 
		   (
		   CITY_CODE = (SELECT CITY_CODE FROM LIST3 WHERE RANKING = 1)--'IST'
		OR CITY_CODE = (SELECT CITY_CODE FROM LIST3 WHERE RANKING = 2) --'EFF'
		OR CITY_CODE = (SELECT CITY_CODE FROM LIST3 WHERE RANKING = 3) -- 'PAM'
		OR CITY_CODE = (SELECT CITY_CODE FROM LIST3 WHERE RANKING = 4) -- 'KAP'
		OR CITY_CODE = (SELECT CITY_CODE FROM LIST3 WHERE RANKING = 5) -- 'ASR'
			)
		AND LOW_PRICE IS NOT NULL 
		AND TOUR_DAY IS NOT NULL

		GROUP BY 
			MASTER_CODE,
			ATT_CODE,
			REGION_CODE
		) T
	 
	WHERE 
		REGION_CODE = @REGION_CODE
	AND ATT_CODE = @ATT_CODE
	
	ORDER BY 
			CAST(((ABS(@AVG_PRICE-PRICE) / @AVG_PRICE) * 10) AS INT)+ ABS(@AVG_TOUR_DAY-TOUR_DAY) + ABS(5-CNT) ASC -- 상품 유사도 계산기준


	-- OUTPUT DATA

	SELECT 
		@추천상품1 AS MASTER_CODE1, 
		@추천상품2 AS MASTER_CODE2,
		@추천상품3 AS MASTER_CODE3



END


GO
