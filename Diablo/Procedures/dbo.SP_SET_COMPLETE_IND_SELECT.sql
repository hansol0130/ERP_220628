USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_SET_COMPLETE_IND_SELECT
■ DESCRIPTION				: 정산 회계 감사용 
정산요약_행사_개인별_(회계감사용)

매월 회계팀에서 요청하는 행사의 정산을 개인별로 나눈 통계 자료 

■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	SP_SET_COMPLETE_IND_SELECT '2020-02-01' ,'2020-02-29' 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2020-03-10		박형만					
================================================================================================================*/ 
CREATE  PROC [dbo].[SP_SET_COMPLETE_IND_SELECT]
	@START_DATE DATETIME,
	@END_DATE DATETIME
AS  
BEGIN

	--SELECT TOP 100 * FROM #TMP_SET_COMP
	/* 2015-03-18 정산서 기준식


	알선수익 : 판매금액(SALE_PRICE) - 총지출금 + 기타경비
	총지출금 : 항공비용(AIR_PRICE) + 지상비(LAND_PRICE) + 개인경비(PERSON_PRICE) + 공동경비(GROUP_PRICE) + 항공수익(AIR_PROFIT) + 기타경비 + 항공예외비용(AIR_ETC_PRICE)
	기타경비 : 개인기타경비(PERSON_ETC_PRICE) + 대리점수수료(AGENT_COM_PRICE) + 입금수수료(PAY_COM_PRICE)
	항공수익 : AIR_PROFIT + AIR_ETC_COM_PROFIT + AIR_ETC_COM_PRICE
	기타수익 : 개인수익(PERSON_PROFIT) + 항공수익(AIR_ETC_PROFIT)
	기타경비 : 개인기타경비(PERSON_ETC_PRICE) + 대리점수수료(AGENT_COM_PRICE) + 결제수수료(PAY_COM_PRICE)
	*/
	--DROP TABLE #TMP_SET_COMP
	------------------------------------------------------------------------------------------------------------
	-- A 정산미스터 데이터 생성 
	
	WITH LIST AS
	(
		SELECT 
			A.PRO_CODE AS [행사코드],
			A.DEP_DATE,
			B.ARR_DATE, 
			A.SALE_PRICE AS [총판매액], 
			A.LAND_PRICE AS [지상비], 
			CONVERT(DECIMAL,A.AIR_PRICE) AS [항공비], 
			CONVERT(DECIMAL,A.GROUP_PRICE) AS [공동경비], 
			CONVERT(DECIMAL,A.PERSON_PRICE) AS [개인경비], 
			(A.AGENT_COM_PRICE + A.PAY_COM_PRICE) AS [수수료], 
			(A.SALE_PRICE - (CONVERT(DECIMAL,AIR_PRICE) + LAND_PRICE + CONVERT(DECIMAL,PERSON_PRICE) + CONVERT(DECIMAL,GROUP_PRICE) + CONVERT(DECIMAL,AIR_PROFIT) + CONVERT(DECIMAL,AIR_ETC_PRICE))) AS [알선수익],
			(ISNULL(CONVERT(DECIMAL,A.AIR_PROFIT), 0.0) + ISNULL(CONVERT(DECIMAL,A.AIR_ETC_COM_PROFIT), 0.0) + ISNULL(CONVERT(DECIMAL,A.AIR_ETC_COM_PRICE), 0.0)) AS [항공수익],
			(CONVERT(DECIMAL,A.PERSON_PROFIT) + CONVERT(DECIMAL,A.AIR_ETC_PROFIT)) AS [기타수익],
			(CONVERT(DECIMAL,A.PERSON_ETC_PRICE) + A.AGENT_COM_PRICE + A.PAY_COM_PRICE) AS [기타경비]
		FROM DBO.VIEW_SET_COMPLETE A WITH(NOLOCK)
			LEFT JOIN DBO.PKG_DETAIL B WITH(NOLOCK)  --도착일 구하기위해 JOIN 
				ON A.PRO_CODE = B.PRO_CODE 
		WHERE A.DEP_DATE >= @START_DATE AND A.DEP_DATE < DATEADD(D,1,@END_DATE)  -- 출발일별 기간 
		AND A.SET_STATE = 2 --마감된거 
		
		--도착일 조건이 있을경우 
		--AND B.ARR_DATE >= '2019-07-01' AND B.ARR_DATE < '2019-08-01' --주석처리:6월출발 7월도착이랑개인별 정산요약표
		--AND (A.PRO_CODE NOT LIKE 'KTR0%' AND A.PRO_CODE NOT LIKE '%HH0%')  --온라인국내항공,온라인호텔제외 
	)

	--정산 데이터 넣기 (행사별)
	SELECT * INTO #TMP_SET_COMP
	FROM (
		SELECT
			A.DEP_DATE
			, A.ARR_DATE 
			, A.행사코드, '전체' AS 예약코드, ''고객명
			,''성별,''연령
			, A.총판매액
			, 0 개별판매액, A.지상비, A.항공비, A.공동경비, A.개인경비, A.수수료
			, (A.지상비 + A.항공비 + A.공동경비 + A.개인경비 + A.수수료) AS [소계]
			, A.알선수익
			, (CASE WHEN A.DEP_DATE < '2015-01-01' OR A.알선수익 > 0 THEN (A.알선수익 / 1.1) ELSE A.알선수익 END) AS [알선수수료]
			, (CASE WHEN A.DEP_DATE < '2015-01-01' OR A.알선수익 > 0 THEN ((A.알선수익 / 1.1) * 0.1) ELSE (A.알선수익 * 0.1) END) AS [부가가치세]
			, A.항공수익, A.기타수익, A.기타경비
			, ((CASE WHEN A.DEP_DATE < '2015-01-01' OR A.알선수익 > 0 THEN (A.알선수익 / 1.1) ELSE A.알선수익 END) + A.항공수익 + A.기타수익 - A.기타경비) AS [총수익]
			, 0 인원수 
			, '' 비고 
			, 0 SEQ_NO 
		FROM LIST A	
		--00ORDER BY A.행사코드 
	)TT
	------------------------------------------------------------------------------------------------------------
	--마감된 행사 
	--34172 
	--마감안된 행사 
	--37461 
	--SELECT COUNT(*) FROM #TMP_SET_COMP

	------------------------------------------------------------------------------------------------------------
	--예약출발자별 판매금액 넣기 
	--DROP TABLE #TMP_SET_COMP_RES
	-- B 출발자별 정산데이터 조회 
	
	SELECT * INTO #TMP_SET_COMP_RES 
	FROM ( 
		-- 패키지 , 항공 
		SELECT  A.DEP_DATE, A.ARR_DATE, B.PRO_CODE AS 행사코드, B.RES_CODE AS 예약코드 , C.CUS_NAME AS 고객명 
			, CASE WHEN C.GENDER = 'M' THEN '남' WHEN C.GENDER = 'F' THEN '여' ELSE '-' END AS 성별  
			, CASE WHEN C.AGE_TYPE = '0' THEN '성인' WHEN C.AGE_TYPE = '1' THEN '아동' WHEN C.AGE_TYPE = '2' THEN '유아' ELSE '성인' END AS 연령 
			, 0 총판매액 
			, DBO.FN_RES_GET_TOTAL_PRICE_ONE(B.RES_CODE,C.SEQ_NO) AS 개별판매액, 0 지상비, 0 항공비, 0 공동경비, 0 개인경비, 0 수수료
			, 0 소계 , 0 알선수익
			, 0 AS [알선수수료]
			, 0 AS [부가가치세]
			, 0 항공수익, 0 기타수익, 0 기타경비
			, 0 [총수익] 
			, CASE WHEN  (SELECT COUNT(*) FROM RES_MASTER_damo AA WITH(NOLOCK)  INNER JOIN RES_CUSTOMER_damo BB WITH(NOLOCK) ON AA.RES_CODE = BB.RES_CODE 
				WHERE AA.RES_STATE NOT IN ( 8,9 ) AND  AA.PRO_TYPE IN (1,2) AND   BB.RES_STATE IN (0,3) AND AA.PRO_CODE = A.PRO_CODE   ) = 0 
				 THEN ((SELECT COUNT(*) FROM RES_MASTER_damo AA WITH(NOLOCK)  INNER JOIN RES_CUSTOMER_damo BB WITH(NOLOCK) ON AA.RES_CODE = BB.RES_CODE 
				WHERE AA.RES_STATE NOT IN ( 8,9 ) AND  AA.PRO_TYPE IN (1,2) AND   BB.RES_STATE IN (0,3,4) AND AA.PRO_CODE = A.PRO_CODE   )) ELSE 
					 (SELECT COUNT(*) FROM RES_MASTER_damo AA WITH(NOLOCK)  INNER JOIN RES_CUSTOMER_damo BB WITH(NOLOCK) ON AA.RES_CODE = BB.RES_CODE 
					WHERE AA.RES_STATE NOT IN ( 8,9 ) AND  AA.PRO_TYPE IN (1,2) AND   BB.RES_STATE IN (0,3) AND AA.PRO_CODE = A.PRO_CODE   )
				END  인원수 
			, CASE WHEN C.RES_STATE =4 THEN '패널티'  WHEN C.RES_STATE =3 THEN '환불' ELSE '' END AS 비고 
			, C.SEQ_NO 
		FROM DBO.SET_MASTER A  WITH(NOLOCK)
			inner JOIN DBO.PKG_DETAIL P WITH(NOLOCK)  --도착일 구하기위해 JOIN 
				ON A.PRO_CODE = P.PRO_CODE 
			INNER JOIN DBO.RES_MASTER_damo B  WITH(NOLOCK)
				ON  A.PRO_CODE =  B.PRO_CODE 
				AND B.RES_STATE NOT IN ( 8,9 ) 
				AND B.PRO_TYPE IN (1,2)  --패키지,항공
			INNER JOIN DBO.RES_CUSTOMER_damo C WITH(NOLOCK)
				ON  B.RES_CODE =  C.RES_CODE 
				AND C.RES_STATE IN (0,3,4) 
		WHERE  A.DEP_DATE >= @START_DATE AND A.DEP_DATE < DATEADD(D,1,@END_DATE)  -- 출발일별 기간: 2019.1.1 ~ 2019.10.31
		--WHERE A.DEP_DATE >= '2019-06-01' AND A.DEP_DATE < '2019-07-01'  -- 출발일별 기간: 2019.6.1 ~ 2019.06.30
		AND A.SET_STATE = 2 --마감된거 
		--AND P.ARR_DATE >= '2019-07-01' AND P.ARR_DATE < '2019-08-01' --6월출발 7월도착이 개인별 정산요약표
		--AND P.ARR_DATE >= '2015-12-01' AND P.ARR_DATE < '2016-01-01' --2015년 12월출발 ~ 2015년12월 도착건의 개인별 정산요약표

		--도착조건이 있는경우에 
		--AND (A.PRO_CODE NOT LIKE 'KTR0%' AND A.PRO_CODE NOT LIKE '%HH0%')  --온라인국내항공,온라인호텔제외 

		-- 도착일이 없는경우 
		UNION ALL  
		--온라인 호텔 도 포함 
		SELECT DEP_DATE ,ARR_DATE , 행사코드 ,예약코드 , 고객명 , 성별 ,
			연령 , 총판매액 , 
			CASE WHEN 인원수 > 0 THEN 예약판매액 / 인원수 ELSE 예약판매액 END AS 개별판매액
			, 0 지상비, 0 항공비, 0 공동경비, 0 개인경비, 0 수수료
			, 0 소계 , 0 알선수익
			, 0 AS [알선수수료]
			, 0 AS [부가가치세]
			, 0 항공수익, 0 기타수익, 0 기타경비
			, 0 [총수익]
			, 인원수
			, 비고
			, SEQ_NO 
		FROM 
		(
			SELECT   A.DEP_DATE, B.ARR_DATE, B.PRO_CODE AS 행사코드, B.RES_CODE AS 예약코드 , C.CUS_NAME AS 고객명 
				, CASE WHEN C.GENDER = 'M' THEN '남' WHEN C.GENDER = 'F' THEN '여' ELSE '-' END AS 성별  
				, CASE WHEN C.AGE_TYPE = '0' THEN '성인' WHEN C.AGE_TYPE = '1' THEN '아동' WHEN C.AGE_TYPE = '2' THEN '유아' ELSE '성인' END AS 연령 
				, 0 총판매액 
				, DBO.FN_RES_GET_TOTAL_PRICE(B.RES_CODE) 예약판매액
				, CASE 
					WHEN  B.RES_STATE = 7 THEN 
						(SELECT COUNT(*) FROM RES_MASTER_damo AA WITH(NOLOCK)  INNER JOIN RES_CUSTOMER_damo BB WITH(NOLOCK) ON AA.RES_CODE = BB.RES_CODE 
					 WHERE AA.RES_STATE NOT IN ( 8,9 ) AND  AA.PRO_TYPE IN (3) AND   BB.RES_STATE IN (0,1,3,4) AND AA.res_code = b.res_code   ) 
					WHEN  (SELECT COUNT(*) FROM RES_MASTER_damo AA WITH(NOLOCK)  INNER JOIN RES_CUSTOMER_damo BB WITH(NOLOCK) ON AA.RES_CODE = BB.RES_CODE 
					 WHERE AA.RES_STATE NOT IN ( 8,9 ) AND  AA.PRO_TYPE IN (3) AND   BB.RES_STATE IN (0,3) AND AA.res_code = b.res_code   ) = 0 
					THEN ((SELECT COUNT(*) FROM RES_MASTER_damo AA WITH(NOLOCK)  INNER JOIN RES_CUSTOMER_damo BB WITH(NOLOCK) ON AA.RES_CODE = BB.RES_CODE 
					 WHERE AA.RES_STATE NOT IN ( 8,9 ) AND  AA.PRO_TYPE IN (3) AND   BB.RES_STATE IN (0,3,4) AND AA.res_code = b.res_code   )) 
					ELSE  (SELECT COUNT(*) FROM RES_MASTER_damo AA WITH(NOLOCK)  INNER JOIN RES_CUSTOMER_damo BB WITH(NOLOCK) ON AA.RES_CODE = BB.RES_CODE 
					WHERE AA.RES_STATE NOT IN ( 8,9 ) AND  AA.PRO_TYPE IN (3) AND   BB.RES_STATE IN (0,3) AND AA.res_code = b.res_code   )
					 END  인원수 
				, CASE WHEN C.RES_STATE = 4 THEN '패널티'  WHEN C.RES_STATE = 3 THEN '환불' ELSE '' END AS 비고 
				, C.SEQ_NO  ,C.RES_STATE
			FROM DBO.SET_MASTER A  WITH(NOLOCK)
				INNER JOIN DBO.RES_MASTER_damo B  WITH(NOLOCK)
					ON  A.PRO_CODE =  B.PRO_CODE 
					AND B.RES_STATE NOT IN ( 8,9 ) 
					AND B.PRO_TYPE IN (3)  --호텔 
				LEFT JOIN DBO.RES_CUSTOMER_damo C WITH(NOLOCK)
					ON  B.RES_CODE =  C.RES_CODE 
					AND C.RES_STATE IN (0,3,4) 
					OR (
						B.RES_CODE =  C.RES_CODE AND B.RES_STATE = 7 AND C.RES_STATE IN (1,3,4)  
					)
			WHERE  A.DEP_DATE >= @START_DATE AND A.DEP_DATE < DATEADD(D,1,@END_DATE)    -- 출발일별 기간: 2019.1.1 ~ 2019.06.30
			AND A.SET_STATE = 2 --마감된거 
			--AND A.PRO_CODE = 'KHH0JG-150320'
		)TT
	) BB
	WHERE 개별판매액 > 0 
	------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------
	-- 정산현황_개인별추가
	-- (최종 조회  A + B )
	SELECT 
	행사코드,CONVERT(VARCHAR(10),DEP_DATE,121) AS 출발일, CONVERT(VARCHAR(10),ARR_DATE,121) AS 도착일,  
	예약코드, 고객명,성별,연령 , 총판매액 ,개별판매액 , 
	CASE WHEN 예약코드<> '전체' AND 비고 NOT IN ('패널티','환불') AND 인원수 > 0 THEN (SELECT 지상비 FROM #TMP_SET_COMP WHERE 행사코드 = TT.행사코드) / 인원수 ELSE 지상비 END 지상비 , 
	CASE WHEN 예약코드<> '전체' AND 비고 NOT IN ('패널티','환불') AND 인원수 > 0 THEN (SELECT 항공비 FROM #TMP_SET_COMP WHERE 행사코드 = TT.행사코드) / 인원수 ELSE 항공비 END 항공비, 
	CASE WHEN 예약코드<> '전체' AND 비고 NOT IN ('패널티','환불') AND 인원수 > 0 THEN (SELECT 공동경비 FROM #TMP_SET_COMP WHERE 행사코드 = TT.행사코드) / 인원수 ELSE 공동경비 END 공동경비, 
	CASE WHEN 예약코드<> '전체' AND 비고 NOT IN ('패널티','환불') AND 인원수 > 0 THEN (SELECT 개인경비 FROM #TMP_SET_COMP WHERE 행사코드 = TT.행사코드) / 인원수 ELSE 개인경비 END 개인경비, 
	CASE WHEN 예약코드<> '전체' AND 비고 NOT IN ('패널티','환불') AND 인원수 > 0 THEN (SELECT 수수료 FROM #TMP_SET_COMP WHERE 행사코드 = TT.행사코드) / 인원수 ELSE 수수료 END 수수료, 
	CASE WHEN 예약코드<> '전체' AND 비고 NOT IN ('패널티','환불') AND 인원수 > 0 THEN (SELECT 소계 FROM #TMP_SET_COMP WHERE 행사코드 = TT.행사코드) / 인원수 ELSE 소계 END 소계, 
	CASE WHEN 예약코드<> '전체' AND 비고 NOT IN ('패널티','환불') AND 인원수 > 0 THEN (SELECT 알선수익 FROM #TMP_SET_COMP WHERE 행사코드 = TT.행사코드) / 인원수 ELSE 알선수익 END 알선수익, 
	CASE WHEN 예약코드<> '전체' AND 비고 NOT IN ('패널티','환불') AND 인원수 > 0 THEN (SELECT 알선수수료 FROM #TMP_SET_COMP WHERE 행사코드 = TT.행사코드) / 인원수 ELSE 알선수수료 END 알선수수료, 
	CASE WHEN 예약코드<> '전체' AND 비고 NOT IN ('패널티','환불') AND 인원수 > 0 THEN (SELECT 부가가치세 FROM #TMP_SET_COMP WHERE 행사코드 = TT.행사코드) / 인원수 ELSE 부가가치세 END 부가가치세, 
	CASE WHEN 예약코드<> '전체' AND 비고 NOT IN ('패널티','환불') AND 인원수 > 0 THEN (SELECT 항공수익 FROM #TMP_SET_COMP WHERE 행사코드 = TT.행사코드) / 인원수 ELSE 항공수익 END 항공수익, 
	CASE WHEN 예약코드<> '전체' AND 비고 NOT IN ('패널티','환불') AND 인원수 > 0 THEN (SELECT 기타수익 FROM #TMP_SET_COMP WHERE 행사코드 = TT.행사코드) / 인원수 ELSE 기타수익 END 기타수익, 
	CASE WHEN 예약코드<> '전체' AND 비고 NOT IN ('패널티','환불') AND 인원수 > 0 THEN (SELECT 기타경비 FROM #TMP_SET_COMP WHERE 행사코드 = TT.행사코드) / 인원수 ELSE 기타경비 END 기타경비, 
	CASE WHEN 예약코드<> '전체' AND 비고 NOT IN ('패널티','환불') AND 인원수 > 0 THEN (SELECT 총수익 FROM #TMP_SET_COMP WHERE 행사코드 = TT.행사코드) / 인원수 ELSE 총수익 END 총수익, 
	인원수,
	비고 ,
	SEQ_NO 
	FROM 
	(
		SELECT * FROM #TMP_SET_COMP 
		UNION ALL 
		SELECT * FROM #TMP_SET_COMP_RES  
	) TT 
	ORDER BY 행사코드 , 예약코드 , SEQ_NO ASC 
	------------------------------------------------------------------------------------------
	--판매액이 다른경우 검증  보통 1원단위 차이 남 
	-- 금액다른것 탭 
	SELECT A.행사코드, A.총판매액 as 정산판매액, isnull(B.총판매액,0) as 예약판매액 ,  ABS(A.총판매액 - isnull(B.총판매액,0)) AS 차액 
	FROM 
	(
		SELECT 행사코드 ,sum(총판매액) as 총판매액  FROM #TMP_SET_COMP A 
		group by 행사코드 
		--WHERE DEP_DATE < '2015-02-01'
	) A 
	full outer JOIN 
	(
		SELECT 행사코드 , SUM(개별판매액) AS 총판매액
		FROM #TMP_SET_COMP_RES B 
		--WHERE DEP_DATE < '2015-02-01'
		GROUP BY 행사코드
	) B 
		ON A.행사코드 = B.행사코드 

	WHERE A.총판매액 <> B.총판매액
	or (A.총판매액 > 0 and B.총판매액 is null  )
	or (b.총판매액 > 0 and a.총판매액 is null  )

	ORDER BY 차액 DESC 

END



/* 2015-03-18 정산서 기준식

알선수익 : 판매금액(SALE_PRICE) - 총지출금 + 기타경비
총지출금 : 항공비용(AIR_PRICE) + 지상비(LAND_PRICE) + 개인경비(PERSON_PRICE) + 공동경비(GROUP_PRICE) + 항공수익(AIR_PROFIT) + 기타경비 + 항공예외비용(AIR_ETC_PRICE)
기타경비 : 개인기타경비(PERSON_ETC_PRICE) + 대리점수수료(AGENT_COM_PRICE) + 입금수수료(PAY_COM_PRICE)
항공수익 : AIR_PROFIT + AIR_ETC_COM_PROFIT + AIR_ETC_COM_PRICE
기타수익 : 개인수익(PERSON_PROFIT) + 항공수익(AIR_ETC_PROFIT)
기타경비 : 개인기타경비(PERSON_ETC_PRICE) + 대리점수수료(AGENT_COM_PRICE) + 결제수수료(PAY_COM_PRICE)
*/

/*
DECLARE @알선수익 MONEY
DECLARE @항공수익 MONEY
DECLARE @기타수익 MONEY
DECLARE @기타경비 MONEY
DECLARE @총수익 MONEY

SELECT
	@알선수익 = ISNULL(SALE_PRICE,0) - (ISNULL(AIR_PRICE,0) + ISNULL(LAND_PRICE,0) + ISNULL(PERSON_PRICE,0) + ISNULL(GROUP_PRICE,0) + ISNULL(AIR_PROFIT,0) + ISNULL(AIR_ETC_PRICE,0)),
	@항공수익 = ISNULL(AIR_PROFIT,0) + ISNULL(AIR_ETC_COM_PROFIT,0) - ISNULL(AIR_ETC_COM_PRICE,0),
	@기타수익 = ISNULL(PERSON_PROFIT,0) + ISNULL(AIR_ETC_PROFIT,0),
	@기타경비 = ISNULL(PERSON_ETC_PRICE,0) + ISNULL(AGENT_COM_PRICE,0) + ISNULL(PAY_COM_PRICE,0)
	FROM VIEW_SET_COMPLETE  WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE
	*/
--SELECT
--	@알선수익 = ISNULL(SALE_PRICE,0) - (ISNULL(AIR_PRICE,0) + ISNULL(LAND_PRICE,0) + ISNULL(PERSON_PRICE,0) + ISNULL(GROUP_PRICE,0) + ISNULL(AIR_PROFIT,0) + ISNULL(AIR_ETC_PRICE,0) - ISNULL(AIR_ETC_PROFIT,0)),
--	@항공수익 = ISNULL(AIR_PROFIT,0) + ISNULL(AIR_ETC_COM_PROFIT,0) - ISNULL(AIR_ETC_COM_PRICE,0),
--	@기타수익 = ISNULL(PERSON_PROFIT,0),
--	@기타경비 = ISNULL(PERSON_ETC_PRICE,0) + ISNULL(AGENT_COM_PRICE,0) + ISNULL(PAY_COM_PRICE,0)
-- FROM VIEW_SET_COMPLETE  WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE

-- 2015-03-18 주석 처리
--IF (@알선수익 < 11000)
--BEGIN
--	RETURN ISNULL(@알선수익,0) + ISNULL(@항공수익,0) + ISNULL(@기타수익,0) - ISNULL(@기타경비,0)
--END
/*
-- 회계마감 후 5년간 금액 변경이 불가하여 2015년 기준으로 양수에만 부가세 계산
SELECT @총수익 = ((CASE WHEN A.DEP_DATE < '2015-01-01' OR @알선수익 > 0 THEN (@알선수익/1.1) ELSE @알선수익 END) + @항공수익 + @기타수익 - @기타경비)
FROM PKG_DETAIL A WITH(NOLOCK)
WHERE A.PRO_CODE = @PRO_CODE
*/
 ------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------





GO
