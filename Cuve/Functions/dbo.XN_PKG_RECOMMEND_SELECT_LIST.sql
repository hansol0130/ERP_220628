USE [Cuve]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XN_PKG_RECOMMEND_SELECT_LIST
■ DESCRIPTION				: 추천 상품 리스트 테이블 반환 함수
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	SELECT * FROM [dbo].[XN_PKG_RECOMMEND_SELECT_LIST]('upp171, upp623, upp170',NULL) 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2017-07-04		윤병도			최초생성
	2017-10-13		김성호			결과물 순번 적용 수정
	2017-10-13		김성호			TMP_MASTER_CODE_MAIN_CITY 프로시저 기반 테이블 반환 함수 생성
	2018-12-05      여승은           기존에 관심출발월 13월로 나오는 경우가 있어서 IF구문으로 1월로 나오게 수정
================================================================================================================*/ 
CREATE FUNCTION [dbo].[XN_PKG_RECOMMEND_SELECT_LIST]
(
	@MASTER_CODE_LIST VARCHAR(100),
	@PRO_CODE VARCHAR(30) = NULL
)
RETURNS @RECOMMEND_LIST TABLE 
(
	SEQ INT,
	MASTER_CODE VARCHAR(10),
	MASTER_NAME NVARCHAR(200),
	LOW_PRICE INT
)
AS
BEGIN
	DECLARE @관심출발월 INT;			-- 관심출발월
	DECLARE @추천상품_패턴기반 VARCHAR(50); -- 추천상품 패턴기반
	DECLARE @추천상품_내용기반 VARCHAR(50); -- 추천상품 내용기반


	--# 상품코드 기준 관심 출발월 구하기 ( 상품코드 없을 시 현재 월 +1 )
	SET @관심출발월 =  
		CASE 
			WHEN @PRO_CODE IS NOT NULL THEN (SELECT DATEPART(MM,DEP_DATE) FROM Diablo..PKG_DETAIL WHERE PRO_CODE = @PRO_CODE) 
			ELSE DATEPART(MM,GETDATE())+1 END;

	IF(@관심출발월 = 13) -- 13월로 나오는 경우 1월로 셋팅
	BEGIN
	 SET @관심출발월 = 1;
	END
	;
	--# 연관규칙(APRIORI) 기반 추천쿼리
	WITH LIST AS
	(
		SELECT * FROM (
			SELECT 
				*, ROW_NUMBER() OVER(PARTITION BY 예약상품 ORDER BY 상품갯수 DESC, 지지도 DESC) AS RANK_NO
			FROM (
				SELECT 	
					SEQ,
					마스터코드,
					예약상품,
					(
						SELECT COUNT(*) AS CNT FROM TMP_APRIORI_FINAL_TRAIN Z 
						WHERE Z.SEQ = A.SEQ AND 마스터코드 IN ( SELECT Data FROM diablo..FN_XML_SPLIT(@MASTER_CODE_LIST, ',') )		
					) AS 상품갯수,
					지지도
				FROM TMP_APRIORI_FINAL_TRAIN A
				WHERE SEQ IN ( SELECT SEQ FROM TMP_APRIORI_FINAL_TRAIN WHERE 마스터코드 IN ( SELECT Data FROM diablo..FN_XML_SPLIT(@MASTER_CODE_LIST, ',') ) GROUP BY SEQ )
			) B
		) C
		WHERE C.RANK_NO = 1
	)
	SELECT 
		@추천상품_패턴기반 = 예약상품
	FROM (
		SELECT TOP 5
			STUFF( (SELECT TOP 5 ',' + 예약상품 FROM LIST GROUP BY 예약상품,상품갯수,지지도 ORDER BY 상품갯수 DESC, 지지도 DESC FOR XML PATH('')), 1, 1, '') AS 예약상품
		FROM LIST
	) T GROUP BY 예약상품
--	PRINT @추천상품_패턴기반;


	--# 내용기반(CBF) 추천 쿼리
	DECLARE @CITY_CODE1 VARCHAR(20);
	DECLARE @CITY_CODE2 VARCHAR(20);
	DECLARE @CITY_CODE3 VARCHAR(20);
	DECLARE @CITY_CODE4 VARCHAR(20);
	DECLARE @CITY_CODE5 VARCHAR(20);
	DECLARE @MASTER_CODE VARCHAR(20);
	DECLARE @AVG_PRICE INT;
	DECLARE @AVG_TOUR_DAY INT;
	DECLARE @REGION_CODE VARCHAR(20);
	DECLARE @ATT_CODE VARCHAR(20);

	WITH LIST AS 
	(
		SELECT LOW_PRICE, TOUR_DAY, SIGN_CODE, ATT_CODE FROM Diablo..PKG_MASTER WITH(NOLOCK) WHERE MASTER_CODE IN ( SELECT Data FROM diablo..FN_XML_SPLIT(@MASTER_CODE_LIST, ',') )
	)
	SELECT 
		@AVG_PRICE = AVG(LOW_PRICE), 
		@AVG_TOUR_DAY = AVG(TOUR_DAY),
		@REGION_CODE = ( SELECT TOP 1 SIGN_CODE FROM LIST GROUP BY SIGN_CODE ORDER BY COUNT(1) DESC ),
		@ATT_CODE = ( SELECT TOP 1 ATT_CODE FROM LIST GROUP BY ATT_CODE ORDER BY COUNT(1) DESC )
	FROM LIST;
--	PRINT CONVERT(VARCHAR, @AVG_PRICE) + ' ,' + CONVERT(VARCHAR, @AVG_TOUR_DAY) + ' ,' + @REGION_CODE + ' ,' + @ATT_CODE;


	WITH LIST_1 AS 
	( 
		SELECT
			B.MASTER_CODE AS OPEN_MASTER,
			B.REGION_CODE,
			B.ATT_CODE,
			B.CITY_CODE,
			B.LOW_PRICE,
			B.TOUR_DAY
		FROM TMP_MASTER_CODE_MAIN_CITY B  -- 미리 생성해놓은 테이블로. 살아있는 상품들의 main_city를 별도로 담아놓음
		WHERE 
			MASTER_CODE IN ( SELECT Data FROM diablo..FN_XML_SPLIT(@MASTER_CODE_LIST, ',') )
		GROUP BY 
			B.MASTER_CODE,
			B.CITY_CODE,
			B.LOW_PRICE,
			B.TOUR_DAY,
			B.REGION_CODE,
			B.ATT_CODE
	),
	LIST_2 AS
	(
		SELECT TOP 5
			K.RANKING,
			K.CITY_CODE,
			K.CNT,
			@AVG_PRICE AS AVG_PRICE,
			@AVG_TOUR_DAY AS AVG_TOUR_DAT
		FROM (
			SELECT 
				ROW_NUMBER() OVER (ORDER BY CNT DESC) AS RANKING, CITY_CODE, CNT
			FROM ( SELECT CITY_CODE, COUNT(*) AS CNT FROM LIST_1 GROUP BY CITY_CODE ) T
		) K
	)	
	SELECT @추천상품_내용기반 = 예약상품
	FROM (
		SELECT 
			STUFF((
				SELECT TOP 5 ',' + MASTER_CODE 
				FROM (
						SELECT 
							MASTER_CODE,
							REGION_CODE,
							ATT_CODE,
							COUNT(*) AS CNT, -- 대표 도시 매칭 개수
							MAX(LOW_PRICE) AS PRICE, -- 상품가격
							MAX(TOUR_DAY) AS TOUR_DAY -- 여행일정
						FROM TMP_MASTER_CODE_MAIN_CITY	
						WHERE 
							CITY_CODE IN ( SELECT CITY_CODE FROM LIST_2 ) AND LOW_PRICE IS NOT NULL AND TOUR_DAY IS NOT NULL
						GROUP BY 
							MASTER_CODE,ATT_CODE, REGION_CODE
					) T	 
				WHERE 
					REGION_CODE = @REGION_CODE AND ATT_CODE = @ATT_CODE	
				ORDER BY 
					ABS(5 - CNT) ASC, ABS(@AVG_PRICE - PRICE) ASC, ABS(@AVG_TOUR_DAY - TOUR_DAY) ASC
				FOR XML PATH('')), 1, 1, '') AS 예약상품
		FROM LIST_2
	) KK;

	--PRINT @추천상품_내용기반;

	INSERT INTO @RECOMMEND_LIST (SEQ, MASTER_CODE, MASTER_NAME, LOW_PRICE)
	SELECT 
		--MAX(ID) AS SEQ
		ROW_NUMBER() OVER (ORDER BY ITEM, K.MASTER_NAME, K.LOW_PRICE) AS [SEQ]
		, UPPER(ITEM) AS MASTER_CODE, K.MASTER_NAME, K.LOW_PRICE
	FROM (
			SELECT ID, Data as ITEM FROM diablo..FN_XML_SPLIT(@추천상품_패턴기반,',')
			UNION
			SELECT ID, Data as ITEM FROM diablo..FN_XML_SPLIT(@추천상품_내용기반,',')
	) T
	INNER JOIN Diablo..PKG_MASTER K WITH(NOLOCK)
	ON T.ITEM = K.MASTER_CODE
	WHERE EXISTS (
		SELECT TOP 1 * FROM Diablo..PKG_MASTER B
		INNER JOIN Diablo..PKG_DETAIL C ON B.MASTER_CODE = C.MASTER_CODE
		WHERE 
			T.ITEM = B.MASTER_CODE 
				AND B.SHOW_YN = 'Y'
				AND C.SHOW_YN = 'Y'
				AND DATEPART(MM,C.DEP_DATE) = @관심출발월	
	)
	GROUP BY ITEM, K.MASTER_NAME, K.LOW_PRICE
	ORDER BY SEQ
	
	RETURN 


END
GO
