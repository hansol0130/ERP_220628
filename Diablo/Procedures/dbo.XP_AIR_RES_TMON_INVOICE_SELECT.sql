USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_RES_MASTER_INFO_SELECT
■ DESCRIPTION				: 세금계산서용 데이터 요청 요청 (국제선:발권일기준 데이터(티켓단위, 신규데이터, 취소분 제외) / 국내선:출발일기준 데이터 (예약단위, 신규 데이터, 취소분 제외) 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: XP_AIR_RES_TMON_INVOICE_SELECT '20170916'
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-04-27		박형만			최초생성 
   2017-07-03		박형만			tktListCnt, fuelSurcharge,finalFare 추가 
   2017-08-08		박형만			DSR 발권일 있는 것만 
   2017-10-10		박형만			국내/해외구분 수정 
   2017-10-20		박형만			CONJ_YN = 'Y' 제외 카운트 
   
================================================================================================================*/ 
CREATE PROC [dbo].[XP_AIR_RES_TMON_INVOICE_SELECT]
	@REQ_DATE VARCHAR(8)
AS 
BEGIN 

	--DECLARE @REQ_DATE VARCHAR(8)
	--SET @REQ_DATE = '20170615' 

	DECLARE @DEP_DATE DATETIME 
	SET @DEP_DATE =  SUBSTRING(@REQ_DATE,1,4) + '-' +  SUBSTRING(@REQ_DATE,5,2) + '-' +  SUBSTRING(@REQ_DATE,7,2) ;
	--SELECT @DEP_DATE ;

	WITH RES_LIST 
	AS (
		SELECT A.RES_CODE , A.SYSTEM_TYPE , A.PRO_CODE ,
		(SELECT TOP 1 ISSUE_DATE FROM DSR_TICKET WHERE RES_CODE = A.RES_CODE)  AS ISSUE_DATE 
		FROM RES_MASTER_DAMO A 
		WHERE  A.PROVIDER = 36 
		AND A.DEP_dATE >= @DEP_DATE 
		AND A.DEP_DATE < CONVERT(dATETIME,DATEADD(DD,1,@DEP_DATE))
		AND A.RES_STATE NOT IN (7,8,9) 
		AND A.PRO_TYPE = 2 
		AND A.NEW_TEAM_CODE = '525' -- 항공판매팀 
	 
	) 
	, PRICE_LIST 
	AS (
		--티몬 스케쥴요금정보 , RES_AIR_DETAIL 의 ADT_TAX 컬럼을 이용함, SALE_PRICE 에서 ADT_TAX 금액 뺀다 . ADT_TAX 변경시 SALE_PRICE 가 틀릴수 있으므로 주의!!!!
		-- dc 금액은 참좋은 쿠폰부담액이므로 계산 하지 않는다 
		SELECT 
			A.RES_CODE, --, AGE_TYPE , 
			--COUNT(RES_CODE) AS [RES_COUNT],
			COUNT(AGE_TYPE) AS RES_COUNT ,
			SUM(SALE_PRICE-(CASE WHEN AGE_TYPE = 1 THEN C.CHD_TAX WHEN AGE_TYPE = 2 THEN C.INF_TAX ELSE C.ADT_TAX END)) AS SALE_SUM_PRICE , --  AIR_DETAIL 의 TAX 빼기 
			SUM(SALE_PRICE-(CASE WHEN AGE_TYPE = 1 THEN C.CHD_TAX WHEN AGE_TYPE = 2 THEN C.INF_TAX ELSE C.ADT_TAX END)) AS BASE_SUM_PRICE ,
			SUM(TAX_PRICE) AS FUEL_SUM_PRICE , -- CUSTOMER 의 TAX는 FUEL 임 
			SUM((CASE WHEN AGE_TYPE = 1 THEN C.CHD_TAX WHEN AGE_TYPE = 2 THEN C.INF_TAX ELSE C.ADT_TAX END)) AS TAX_SUM_PRICE , -- AIR_DETAIL 의 TAX 임 변경시 주의!!
			SUM(CHG_PRICE) AS SVC_SUM_CHARGE ,
			SUM(DC_PRICE) AS DC_SUM_PRICE ,
			SUM(SALE_PRICE + CHG_PRICE + TAX_PRICE + PENALTY_PRICE) AS [TOTAL_SUM_PRICE]
		FROM RES_LIST AA
			INNER JOIN  RES_CUSTOMER_DAMO A WITH(NOLOCK)
				ON AA.RES_CODE = A.RES_CODE 
			INNER JOIN RES_MASTER_DAMO B WITH(NOLOCK)
				ON A.RES_CODE = B.RES_CODE 
			INNER JOIN RES_AIR_DETAIL C WITH(NOLOCK)
				ON A.RES_CODE = C.RES_CODE 
		WHERE  A.RES_STATE IN (0, 3)
		GROUP BY A.RES_CODE--, A.AGE_TYPE
		--ORDER BY A.AGE_TYPE ASC 
	) 
	, CPN_LIST 
	AS (
		SELECT A.RES_CODE,MAX(PAY_TARGET_PRICE) AS PAY_TARGET_PRICE , 
			SUM(CASE WHEN DC_RATE  > 0 THEN  PAY_TARGET_PRICE * (DC_RATE * 0.01) ELSE DC_PRICE END) AS DC_CALC_PRICE ,  --계산된 수수료 
			SUM(CASE WHEN D.COMM_RATE > 0 THEN  
				(CASE WHEN DC_RATE  > 0 THEN  PAY_TARGET_PRICE * (DC_RATE * 0.01) ELSE DC_PRICE END) /*계산된수수료*/ * (D.COMM_RATE * 0.01)   -- 여행사 부담율 
			ELSE D.COMM_PRICE END) AS COMM_CALC_PRICE    --계산된 여행사 부담 수수료 
		FROM RES_LIST A 
			LEFT JOIN  PAY_COUPON D  WITH(NOLOCK)
				ON A.RES_CODE = D.RES_CODE
		GROUP BY A.RES_CODE 
	) 
	-- SELECT TOP 100 * FROM PRICE_LIST
	--SELECT TOP 100 * FROM CPN_LIST 
	 

	--쿠폰 조회 
	SELECT
		'TM' AS siteCd,
		CASE WHEN SYSTEM_TYPE IN (1,2) THEN 'P' 
			WHEN SYSTEM_TYPE IN (3) THEN 'W' ELSE 'P' END AS [platform],
		C.ALT_RES_CODE AS bookingCode,
		A.RES_CODE AS bookingNo ,
		CASE WHEN  SUBSTRING(A.PRO_CODE,1,1) = 'K' AND B.INTER_YN ='N' THEN 'D'  
			ELSE 'I' END AS sectionTp ,
		'R' AS passengerTp,
		CONVERT(VARCHAR(8),B.DEP_DEP_DATE,112) + REPLACE(B.DEP_DEP_TIME,':','')  AS depDt,
		
		CASE WHEN A.ISSUE_DATE IS NOT NULL 
			THEN CONVERT(VARCHAR(8),A.ISSUE_DATE,112) + '0000' END AS issDt,
		C.ALT_MEM_NO AS memberNo,
		ISNULL( (SELECT COUNT(*) FROM DSR_TICKET WHERE RES_CODE = A.RES_CODE AND CONJ_YN <> 'Y'),0) AS tktListCnt,
		D.TOTAL_SUM_PRICE AS totFare,
		D.BASE_SUM_PRICE AS fare,
		D.TAX_SUM_PRICE AS tax ,
		D.FUEL_SUM_PRICE AS fuelSurcharge,
		SVC_SUM_CHARGE AS tktCharge ,
		D.TOTAL_SUM_PRICE - isnull(E.DC_CALC_PRICE,0) AS finalFare ,
		E.DC_CALC_PRICE AS couponFare ,
		E.COMM_CALC_PRICE AS couponAdm 

	FROM RES_LIST A  
		INNER JOIN RES_AIR_DETAIL B WITH(NOLOCK) 
			ON A.RES_CODE = B.RES_CODE 
		INNER JOIN RES_ALT_MATCHING C WITH(NOLOCK)  
			ON A.RES_CODE = C.RES_CODE 

		INNER JOIN PRICE_LIST D 
			ON A.RES_CODE = D.RES_CODE 
		LEFT JOIN  CPN_LIST E  WITH(NOLOCK)
			ON A.RES_CODE = E.RES_CODE 

	WHERE A.ISSUE_DATE IS NOT NULL 

END 
GO
