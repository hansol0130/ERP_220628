USE [Cuve]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PRODUCT_RECOMMEND_BATCH_INSERT
■ DESCRIPTION				: 추천 데이타 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_PRODUCT_RECOMMEND_BATCH_INSERT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2017-06-30		윤병도			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_PRODUCT_RECOMMEND_BATCH_INSERT]	
AS
BEGIN
BEGIN TRAN
	BEGIN TRY
		DROP TABLE TMP_MASTER_CODE_MAIN_CITY;
		DROP TABLE TMP_1YEAR_RES_COMPLETE_TRUE_LOG;
		DROP TABLE TMP_APRIORI_INPUT;
		TRUNCATE TABLE TMP_APRIORI_INSERT_TBL;
		DROP TABLE TMP_APRIORI_FINAL_TRAIN;

		/*############## ※ 1.  살아있는 마스터코드들의 대표도시 테이블 만들기 ##############*/
		SELECT
			 LEFT(A.MASTER_CODE,1) AS REGION_CODE
			,A.ATT_CODE 
			,A.MASTER_CODE
			,A.LOW_PRICE
			,A.TOUR_DAY
			,ROW_NUMBER() OVER (PARTITION BY A.MASTER_CODE ORDER BY CITY_CODE) AS SEQ
			,C.CITY_CODE
		INTO 
			TMP_MASTER_CODE_MAIN_CITY
		FROM 
			Diablo..PKG_MASTER A WITH(NOLOCK)
			INNER JOIN Diablo..PKG_MASTER_SCH_MASTER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
			INNER JOIN Diablo..PKG_MASTER_SCH_CITY C WITH(NOLOCK) ON A.MASTER_CODE = C.MASTER_CODE AND B.SCH_SEQ = C.SCH_SEQ
			--INNER JOIN Diablo..PKG_DETAIL D WITH(NOLOCK) ON A.MASTER_CODE = D.MASTER_CODE
		WHERE 
			A.SHOW_YN = 'Y'
				--AND D.SHOW_YN = 'Y'
				AND C.MAINCITY_YN = 'Y'
				AND C.CITY_CODE <> 'ICN'
		GROUP BY
			 A.MASTER_CODE
			,A.LOW_PRICE
			,A.TOUR_DAY
			,C.CITY_CODE
			,A.ATT_CODE;

		/*############## ※ 2. 완료된 예약 로그만 추출 ##############*/
		SELECT * INTO #1YEAR_RES_COMPLETE FROM TMP_1YEAR_LOG --전체 로그테이블에서 2015년 로그만 별도 분리한 테이블
		WHERE IN_PATH LIKE 'http://www.verygoodtour.com/Reserve/Package/Complete%';

		/*############## ※ 3. 실제 완료된 예약만 추출 ##############*/
		SELECT
			 ROW_NUMBER() OVER(ORDER BY X.IN_DATE ASC) AS RES_LOG_SEQ
			,X.IN_IP
			,X.IN_DATE
			--,CONVERT(VARCHAR(10),X.IN_DATE,120) AS IN_DATE
			,DATEPART(WEEK,IN_DATE) AS RES_WEEK
			,X.RES_CODE
			,B.MASTER_CODE
			--, count(*)
		INTO 
			#1YEAR_RES_COMPLETE_TRUE
		FROM
		(	
			SELECT * FROM
			(
				SELECT 
					ROW_NUMBER() OVER(PARTITION BY RES_CODE ORDER BY IN_DATE ASC) AS SEQ,
					*
				FROM
					(
						SELECT 
							IN_IP, IN_DATE, LEFT(RIGHT(IN_QUERY,LEN(IN_QUERY)-CHARINDEX('=',IN_QUERY)),12) AS RES_CODE
						FROM #1YEAR_RES_COMPLETE A
						WHERE LEFT(RIGHT(IN_QUERY,LEN(IN_QUERY)-CHARINDEX('=',IN_QUERY)),12)	IS NOT NULL
					) T
			) V
			WHERE SEQ = 1  --  로그 테이블에 남아있는 예약완료페이지 로그 중 예약코드별로 IP 무관하고 가장 최초 예약완료 화면 기록을 뽑는다.            
		) x
		LEFT JOIN diablo..RES_MASTER_damo b WITH(NOLOCK) ON X.RES_CODE = b.RES_CODE
		WHERE 
			B.RES_STATE < 7 -- 한 주차에 한 아이피가 여러개의 마스터를 막 예약하는 케이스가 있기 때문에. 실예약한 것으로만 추리기 위해.
			AND IN_IP NOT LIKE '110.11%'; --내부 접속 IP 제거

		/*############## ※ 4. 실 예약건의 예약 이전 한달간의 이용로그 별도 분리 ##############*/
		SELECT 
			B.RES_LOG_SEQ, A.IN_IP, A.IN_DATE AS 접속시간, A.IN_MASTER_CODE, B.RES_CODE, B.IN_DATE AS 예약시간,B.MASTER_CODE
		INTO
			TMP_1YEAR_RES_COMPLETE_TRUE_LOG
		FROM 
			TMP_1YEAR_LOG A WITH(NOLOCK)
			INNER JOIN #1YEAR_RES_COMPLETE_TRUE B WITH(NOLOCK) ON A.IN_IP = B.IN_IP 
		WHERE 
			A.IN_MASTER_CODE IS NOT NULL
			AND A.IN_dATE < B.IN_DATE
			AND DATEDIFF(DAY,A.IN_DATE, B.IN_DATE) < 30

		ORDER BY
			B.RES_LOG_SEQ, A.IN_IP, A.IN_DATE;

		/*############## ※ 5. 웹 사용 로그를 분단위로 그룹화하고 순번 매김. ##############*/
		SELECT 
			예약순번,IP주소,
			ROW_NUMBER() OVER (PARTITION BY 예약순번 ORDER BY 접속시간2) AS SEQ,
			접속시간2,조회상품,예약코드,예약시간,예약상품
		INTO 
			#TEMP1
		FROM
		(
			SELECT 
				예약순번,IP주소,접속시간2,
				조회상품,예약코드,예약시간,예약상품
			FROM
			(
				SELECT
					RES_LOG_SEQ   AS 예약순번,
					IN_IP		  AS IP주소, 
					접속시간		  AS 접속시간,
					(
					STR(DATEPART(YEAR,접속시간),4) + '년 ' +
					STR(DATEPART(MONTH,접속시간),2) + '월 ' +
					STR(DATEPART(DAY,접속시간),2) + '일 ' +
					STR(DATEPART(HOUR,접속시간),2) + '시 ' +
					STR(DATEPART(MINUTE,접속시간),2) + '분'
					) AS 접속시간2 , 
					IN_MASTER_CODE AS 조회상품,
					RES_CODE	   AS 예약코드,
					예약시간		   AS 예약시간,
					MASTER_CODE	   AS 예약상품
				FROM 
					TMP_1YEAR_RES_COMPLETE_TRUE_LOG
			) T
			GROUP BY
				예약순번,IP주소,접속시간2,
				조회상품,예약코드,예약시간,예약상품
		) K 
		ORDER BY 예약순번, 접속시간2;

		/*############## ※ 6. 이상값처리 ##############*/
		SELECT * INTO #TEMP2 FROM #TEMP1 A
		WHERE 예약순번 NOT IN ( SELECT DISTINCT 예약순번 FROM #TEMP1 B WHERE SEQ >= 100 )  -- 100개 이상 마스터본건 이상값으로 간주하고 버린다.
		ORDER BY 예약순번, 접속시간2;

		SELECT * INTO #TEMP3 FROM #TEMP2 WHERE 예약순번 IN (SELECT 예약순번 FROM #TEMP2 GROUP BY 예약순번 HAVING SUM(SEQ) >= 6); -- 상품 3개 이상으로 본것만 사용한다.

		SELECT 
			예약순번, 예약코드, 예약시간, IP주소,예약상품 AS RES_MASTER,
			STUFF((
			SELECT ',' + 조회상품
					FROM #TEMP3 A
					WHERE A.예약순번 = B.예약순번
					group by 조회상품   --   2017-06-13 추가. 동일한 마스터코드는 group by.
					FOR XML PATH('')
					),1,1,'') AS OPEN_MASTER
		INTO #TEMP4 FROM #TEMP3 B
		GROUP BY 예약순번, 예약코드, 예약시간, IP주소,예약상품
		ORDER BY 예약순번;

		SELECT * INTO TMP_APRIORI_INPUT FROM #TEMP4 WHERE OPEN_MASTER LIKE '%,%' ORDER BY 예약순번;

		IF @@TRANCOUNT > 0
		BEGIN
			COMMIT TRAN;
		END		
	END TRY
	BEGIN CATCH	
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN;
		END		
	END CATCH
END

GO
