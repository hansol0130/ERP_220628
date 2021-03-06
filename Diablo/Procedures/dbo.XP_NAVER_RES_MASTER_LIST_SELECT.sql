USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_NAVER_RES_MASTER_LIST_SELECT
■ DESCRIPTION				: 

네이버 예약의 동기화를 위하여 
현재 예약 내역 조회 

■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: [XP_NAVER_RES_MASTER_LIST_SELECT] '2019-07-03', NULL 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2019-08-21	박형만	결제완료시에 예약확정으로 보내기 (타이드요청) , 과납도 결제 완료로 
2019-09-06	박형만	결제중 과납도 예약확정으로 
2019-10-04	박형만	내선번호 없을때 , 동료번호 , 대표번호 순 
2019-12-13	박형만	네이버 예약 API 변경 도시,국가,마스터코드 필드 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_NAVER_RES_MASTER_LIST_SELECT]
	@START_DATE VARCHAR(10) = null ,
	@END_DATE VARCHAR(10) = null 
AS 
BEGIN 

--DECLARE @START_DATE DATETIME  ,
--@END_DATE VARCHAR(10) 
--SET @START_DATE = '2019-06-10' 


	IF ISNULL(@END_DATE,'') = ''
	BEGIN
		SET @END_DATE  = DATEADD(YY,1, @START_DATE)
	END 

	-- !! 조회 컬럼 추가시 
	-- !! 반드시 XP_NAVER_RES_MASTER_LIST_UPDATE_SELECT 도 고쳐야 함 !!!
	SELECT  
		A.RES_CODE   ,
		A.SYSTEM_TYPE ,
		C.ALT_MEM_NO, 
		C.ALT_PRO_URL AS BOOK_KEY  , 
		RTRIM(A.PRO_CODE) AS PRO_CODE,
		A.PRICE_SEQ,

		A.PRO_NAME,
		A.NEW_DATE ,

		B.DEP_DATE, 
		B.ARR_DATE, 

		CASE WHEN A.RES_STATE IN(7,8,9) THEN 
			DBO.FN_NAVER_RES_GET_TOTAL_PRICE(A.RES_CODE) 
			ELSE DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE ) 
		END 
		 --DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE ) 
		 AS TOTAL_PRICE ,
		CASE WHEN A.RES_STATE IN(7,8,9) THEN 
			CASE WHEN (SELECT COUNT(*) FROM RES_CUSTOMER_DAMO WHERE RES_CODE = A.RES_CODE AND AGE_TYPE =0) =0 THEN 1 
				ELSE (SELECT COUNT(*) FROM RES_CUSTOMER_DAMO WHERE RES_CODE = A.RES_CODE AND AGE_TYPE =0) END 
		ELSE 
			CASE WHEN DBO.FN_RES_GET_RES_ADULT_COUNT(A.RES_CODE) = 0 THEN 1 
				ELSE DBO.FN_RES_GET_RES_ADULT_COUNT(A.RES_CODE) END 
		END AS ADT_COUNT,

		CASE WHEN A.RES_STATE IN(7,8,9) THEN 
			(SELECT COUNT(*) FROM RES_CUSTOMER_DAMO WHERE RES_CODE = A.RES_CODE AND AGE_TYPE =1) 
		ELSE DBO.FN_RES_GET_RES_CHILD_COUNT(A.RES_CODE ) END AS CHD_COUNT,
		CASE WHEN A.RES_STATE IN(7,8,9) THEN 
			(SELECT COUNT(*) FROM RES_CUSTOMER_DAMO WHERE RES_CODE = A.RES_CODE AND AGE_TYPE =2) 
		ELSE DBO.FN_RES_GET_RES_BABY_COUNT(A.RES_CODE ) END AS INF_COUNT,

		A.RES_NAME , 
		A.NOR_TEL1 + '-' + A.NOR_TEL2 + '-' + A.NOR_TEL3 AS RES_TEL ,

		--	예약상태코드 (RSVRC,RSVCF,RSVWA,RSVCN) 
		-- 예약접수(RSVRC), 예약확정(RSVCF), 예약대기(RSVWA), 예약취소(RSVCN)
		CASE --WHEN A.RES_STATE IN (0,1) THEN 'RSVRC' 
			--WHEN A.RES_STATE IN (2,3,4,5,6) THEN 'RSVCF'
			WHEN A.RES_STATE IN (3) AND  DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE ) <=  DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE)  THEN 'RSVCF'  -- 결제중 과납 추가 
			WHEN A.RES_STATE IN (0,1,2,3) THEN 'RSVRC' 
			WHEN A.RES_STATE IN (4,5,6) THEN 'RSVCF'
			WHEN A.RES_STATE IN(7,8,9) THEN 'RSVCN' ELSE 'RSVWA' 
			END AS BOOKING_STATE ,

		--금액미확정(NONE), 미결제(UNPAID), 부분결제(REPAY), 결제완료(DONE), 결제취소완료(CANCEL)
		CASE WHEN A.RES_STATE IN (7) THEN 'CANCEL' 
			WHEN DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE) = 0 THEN  --미결제시 
				CASE WHEN A.RES_STATE IN(0,1) THEN 'NONE' ELSE 'UNPAID' END 
			WHEN DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE) > 0 THEN  -- 결제시 
				CASE WHEN DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE ) <=  DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE) THEN 'DONE' ELSE 'REPAY' END
		
			END AS PAY_STATE  , 

		A.NEW_CODE , 

		D.KOR_NAME AS EMP_NAME , 

		--D.INNER_NUMBER1 +'-'+ D.INNER_NUMBER2  +'-'+ D.INNER_NUMBER3 AS INNER_NUMBER , 
		COALESCE(D.INNER_NUMBER1 +'-'+ D.INNER_NUMBER2  +'-'+ D.INNER_NUMBER3
		,D.MAIN_NUMBER1 +'-'+ D.MAIN_NUMBER2  +'-'+ D.MATE_NUMBER
		,D.MAIN_NUMBER1 +'-'+ D.MAIN_NUMBER2  +'-'+ D.MAIN_NUMBER3  ) AS INNER_NUMBER,

		'/Affiliate/Naver/PackageDetail?ProCode='+ B.PRO_CODE + '&PriceSeq=' + CONVERT(VARCHAR,A.PRICE_SEQ) AS PRO_PC_URL, 
		'/Affiliate/NaverMobile/PackageDetail?ProCode='+ B.PRO_CODE + '&PriceSeq=' + CONVERT(VARCHAR,A.PRICE_SEQ) AS PRO_MOB_URL, 

		'/Affiliate/Naver/ReserveDetail?ResCode='+ A.RES_CODE AS RES_PC_URL, 
		'/Affiliate/NaverMobile/ReserveDetail?ResCode='+ A.RES_CODE  AS RES_MOB_URL, 


		CASE WHEN ISNULL(B.FIRST_MEET,'') <> '' THEN B.FIRST_MEET 
		ELSE 
			CASE WHEN B.MEET_COUNTER = 1 THEN '인천국제공항 제1터미널 3층 1번 출입구 A카운터 1번 테이블'  
				WHEN B.MEET_COUNTER = 2 THEN '인천국제공항 제1터미널 3층 14번 출입구 M카운터 1번 테이블'  
				WHEN B.MEET_COUNTER = 2 THEN '인천국제공항 제1터미널 3층 1,14번 출입구 A,M카운터 1번 테이블'
				WHEN B.MEET_COUNTER = 2 THEN '인천국제공항 제2터미널 3층 8번 출입구 H카운터' 
				END  
		END AS MEET_INFO,
		B.TC_CODE , B.TC_YN ,
		E.HP_NUMBER1 +'-' + E.HP_NUMBER2 +'-'+ E.HP_NUMBER3  AS TC_NUMBER , 
		NRM.LAST_UPD_DATE ,
		CASE WHEN ISNULL(NRM.NATION_CODES,'') <> '' THEN NRM.NATION_CODES ELSE NPD.countryList END AS NATION_CODES, --2019-12-13 추가 
		CASE WHEN ISNULL(NRM.CITY_CODES,'') <> '' THEN NRM.CITY_CODES ELSE NPD.cityList END AS CITY_CODES, --2019-12-13 추가  
		A.MASTER_CODE 
		-- !! 조회 컬럼 추가시 
		-- !! 반드시 XP_NAVER_RES_MASTER_LIST_UPDATE_SELECT 도 고쳐야 함 !!!
	FROM RES_MASTER_DAMO A WITH(NOLOCK)

		INNER JOIN PKG_DETAIL B WITH(NOLOCK) 
			ON A.PRO_CODE = B.PRO_CODE 

		LEFT JOIN RES_ALT_MATCHING C WITH(NOLOCK) 
			ON A.RES_CODE = C.RES_CODE 

		LEFT JOIN EMP_MASTER_DAMO D WITH(NOLOCK) 
			ON A.NEW_CODE = D.EMP_CODE 

		LEFT JOIN AGT_MEMBER E  WITH(NOLOCK) 
			ON B.TC_CODE = E.MEM_CODE 

		LEFT JOIN NAVER_RES_MASTER NRM WITH(NOLOCK)  
			ON A.RES_CODE = NRM.RES_CODE 

		LEFT JOIN NAVER_PKG_DETAIL NPD WITH(NOLOCK) 
			ON A.MASTER_CODE = NPD.mstCode 
			AND A.PRO_CODE + '|' +CONVERT(VARCHAR,A.PRICE_SEQ) = NPD.childCode 

	WHERE A.PROVIDER = 41 
	AND A.DEP_DATE >= @START_DATE
	AND A.DEP_DATE < DATEADD(D,1,@END_DATE)
	
	----AND (A.RES_CODE = @RES_CODE OR ISNULL(@RES_CODE,'') ='')
	----AND A.RES_CODE IN ('RP1906121639','RP1906121634','RP1906121635','RP1906259439','RP1906121615') 

	ORDER BY A.RES_CODE 

END 
GO
