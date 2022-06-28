USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_STS_DEP_CUSTOMER_PHONE_COUNT_LIST
- 기 능 : 예약자 , 출발자 별 전화번호 입력 조회 
====================================================================================
	참고내용
	지마켓 출발자 실적 
====================================================================================
- 예제
 EXEC SP_STS_DEP_CUSTOMER_PHONE_COUNT_LIST  '2016-08-01' , '2016-08-31' 
====================================================================================
	변경내역
====================================================================================
- 2016-09-01		박형만 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_STS_DEP_CUSTOMER_PHONE_COUNT_LIST]
	@SEARCH_TYPE INT , --0 전체 , 1 스마트케어 대상
	@START_DATE DATETIME,
	@END_DATE DATETIME  -- 
AS 
SET NOCOUNT ON 
;
 --DECLARE  @START_DATE VARCHAR(10), 
	--@END_DATE VARCHAR(10)  -- 
 --SET @START_DATE = '2016-08-01'
--SET @END_DATE = '2016-08-16';

WITH WEEK_DATE_LIST 
AS (
	SELECT CONVERT(VARCHAR(10),MIN(DATE),121) + '~' + CONVERT(VARCHAR(10),MAX(DATE),121) AS WEEK_DATE_TITLE, MIN(DATE) WEEK_START_DATE, MAX(DATE) AS WEEK_END_DATE 
	FROM 
	(
		SELECT 
			CONVERT(VARCHAR(10),CASE WHEN DATEPART(W ,A.DATE) = 1 THEN  DATEPART(WK ,A.DATE) -1 ELSE DATEPART(WK ,A.DATE) END , 121) AS WEEK_OF_YEAR,
			DATE ,WEEK_DAY 
 		FROM PUB_TMP_DATE A		
		WHERE DATE >= @START_DATE  AND DATE < CONVERT(DATETIME,DATEADD(DD,1,@END_DATE ))
	) T 
	WHERE CONVERT(VARCHAR(10),CASE WHEN DATEPART(W ,T.DATE) = 1 THEN  DATEPART(WK ,T.DATE) -1 ELSE DATEPART(WK ,T.DATE) END , 121) = WEEK_OF_YEAR 
	GROUP BY WEEK_OF_YEAR 
) 
, RES_MASTER_LIST 
AS (	
	SELECT  
		A.RES_CODE , CONVERT(VARCHAR(10),A.DEP_DATE,121) AS DEP_DATE, 
		W.WEEK_DATE_TITLE ,
		ISNULL(A.NOR_TEL1,'')  + ISNULL(A.NOR_TEL2,'') + ISNULL(A.NOR_TEL3,'') AS RES_NOR_TEL    
	FROM RES_MASTER_DAMO A WITH(NOLOCK)
		INNER JOIN PKG_DETAIL B WITH(NOLOCK)
			ON A.PRO_CODE = B.PRO_CODE
		INNER JOIN PKG_MASTER C WITH(NOLOCK)
			ON B.MASTER_CODE = C.MASTER_CODE

		INNER JOIN WEEK_DATE_LIST W 
			ON A.DEP_DATE >= W.WEEK_START_DATE 
			AND A.DEP_DATE < DATEADD(D,1,W.WEEK_END_DATE )
	WHERE 1 =1 
	AND 
	(	@SEARCH_TYPE = 0 OR 
		(
		A.PRO_TYPE IN (1,2)  -- [패키지,항공예약] 실시간,오프라인항공
			AND A.PRO_CODE NOT LIKE 'K%'  --[국내해외여부] 해외
			AND B.TRANSFER_TYPE = 1 -- [교통편] 항공편
			AND C.ATT_CODE IN ('P','R','W','G')  --[마스터 대표속성] 패키지,실시간항공,허니문,골프
		)
	)
	AND A.DEP_DATE >= @START_DATE AND A.DEP_DATE < CONVERT(DATETIME,DATEADD(DD,1,@END_DATE ))
	AND A.RES_STATE >= 3  -- [예약상태] 결제중부터
	AND A.RES_STATE < 7  -- [예약상태] 출발완료 까지
	--AND A.RES_STATE IN ( 3,4) -- 결제완료(결제중)포함
) 

SELECT 
* 
FROM (
	SELECT DEP_DATE , 
		WEEK_DATE_TITLE , 
		SUM(1) AS RES_CNT ,
		SUM(CASE WHEN RES_NOR_TEL <> '' AND RES_NOR_TEL <> '010' AND RES_NOR_TEL <> '0101111111'  THEN 1 ELSE 0 END) AS RES_TEL_CNT 
	FROM RES_MASTER_LIST
	GROUP BY DEP_DATE ,WEEK_DATE_TITLE 
) T1 
LEFT JOIN 
(
	SELECT 
		DEP_DATE , 
		SUM(1) AS RES_CUS_CNT ,
		SUM(CASE WHEN CUS_NOR_TEL <> '' AND CUS_NOR_TEL <> '010' AND CUS_NOR_TEL <> '0101111111'  THEN 1 ELSE 0 END) AS RES_CUS_TEL_CNT 
	FROM 
	( 
		SELECT  
		A.RES_CODE , D.SEQ_NO , A.DEP_DATE , 
		ISNULL(D.NOR_TEL1,'')  + ISNULL(D.NOR_TEL2,'') + ISNULL(D.NOR_TEL3,'') AS CUS_NOR_TEL    
		FROM RES_MASTER_LIST A 
			INNER JOIN RES_CUSTOMER_damo D WITH(NOLOCK)
				ON A.RES_CODE = D.RES_CODE
		WHERE D.RES_STATE = 0  -- 정상예약
		--WHERE A.PRO_TYPE IN (1,2)  -- [패키지,항공예약] 실시간,오프라인항공
		--AND A.PRO_CODE NOT LIKE 'K%'  --[국내해외여부] 해외
		--AND B.TRANSFER_TYPE = 1 -- [교통편] 항공편
		--AND C.ATT_CODE IN ('P','R','W','G')  --[마스터 대표속성] 패키지,실시간항공,허니문,골프
		
	) T
	GROUP BY DEP_DATE 
) T2 
	ON T1.DEP_DATE = T2.DEP_DATE 

ORDER BY T1.DEP_DATE 




GO
