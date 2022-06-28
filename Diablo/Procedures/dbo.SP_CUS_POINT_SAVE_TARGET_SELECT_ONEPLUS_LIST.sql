USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CUS_POINT_SAVE_TARGET_SELECT_ONEPLUS_LIST
■ DESCRIPTION				: 1 + 1 특별포인트 적립 대상자 검색 (refs #381 참고) 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DIABLO.DBO.SP_CUS_POINT_SAVE_TARGET_SELECT_ONEPLUS_LIST '2020-08-05'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2020-07-10		김성호			최초생성 (SP_CUS_POINT_SAVE_TARGET_SELECT_LIST 참고 생성)
   2020-08-04		김성호			검색범위 확장
================================================================================================================*/ 
CREATE PROC [dbo].[SP_CUS_POINT_SAVE_TARGET_SELECT_ONEPLUS_LIST]
	@EXE_DATE VARCHAR(10)
AS  
BEGIN

	SET NOCOUNT ON

	--DECLARE @EXE_DATE VARCHAR(10)
	--SET @EXE_DATE = '2020-07-15'
	
	DECLARE @START_DATE DATETIME, @END_DATE DATETIME
--	SET @START_DATE = DATEADD(DD,-7,CONVERT(DATETIME, @EXE_DATE))	-- 출발일시
--	SET @END_DATE = DATEADD(S,-1,DATEADD(DD,1,@START_DATE))			-- 도착일시 
	SET @START_DATE = DATEADD(DD,-14,@EXE_DATE)
	SET @END_DATE = DATEADD(S,-1,DATEADD(DD,-6,@EXE_DATE))

	--SELECT @START_DATE , @END_DATE 
	
	--포인트 적립 대상자 조회 2016-09-08  , 
	SELECT
		RC.CUS_NO,
		MEM.CUS_ID,
		MEM.CUS_NAME,
		ISNULL(RC.POINT_RATE, 0) AS [POINT_RATE],
		((ISNULL(RC.SALE_PRICE, 0) - ISNULL(RC.DC_PRICE, 0) + ISNULL(RC.CHG_PRICE, 0) + ISNULL(RC.TAX_PRICE, 0) + ISNULL(RC.PENALTY_PRICE, 0))
			 * (ISNULL(RC.POINT_RATE, 0) / 100)) AS POINT_PRICE,
		(SELECT TOP 1 TOTAL_PRICE AS TOTAL_POINT FROM DBO.CUS_POINT WITH(NOLOCK) WHERE CUS_NO = RC.CUS_NO ORDER BY POINT_NO DESC) AS NOW_POINT_PRICE, -- 해당 고객의 현재 총 포인트
		
		PD.DEP_DATE,
		PD.ARR_DATE,
		RM.RES_CODE,
		RM.PRO_CODE,
		RM.PRO_NAME,
		RM.SALE_COM_CODE,
		RM.PROVIDER,
		
		MEM.EMAIL,
		MEM.RCV_EMAIL_YN,
		MEM.BIRTH_DATE,
		MEM.GENDER,
		MEM.NOR_TEL1,
		MEM.NOR_TEL2,
		MEM.NOR_TEL3,
		
		RC.DC_PRICE

	FROM PKG_DETAIL AS PD WITH(NOLOCK) 
	INNER JOIN RES_MASTER_damo AS RM WITH(NOLOCK) ON PD.PRO_CODE = RM.PRO_CODE 
	INNER JOIN RES_CUSTOMER_damo AS RC WITH(NOLOCK) ON RM.RES_CODE = RC.RES_CODE 
		AND RC.SEQ_NO = ( SELECT TOP 1 SEQ_NO FROM RES_CUSTOMER_damo WITH(NOLOCK) WHERE RES_CODE = RC.RES_CODE AND CUS_NO = RC.CUS_NO  AND RES_STATE = 0 ORDER BY SEQ_NO ) 
		-- 중복 매핑된 고객 있을경우 한명만 
	--INNER JOIN CUS_CUSTOMER_DAMO AS CC WITH(NOLOCK) ON RC.CUS_NO = CC.CUS_NO 
	INNER JOIN VIEW_MEMBER AS MEM WITH(NOLOCK) ON RC.CUS_NO = MEM.CUS_NO
	
	-- 이벤트 적립 중복 체크 목적
	LEFT JOIN CUS_POINT AS CP WITH(NOLOCK) ON CP.RES_CODE = RC.RES_CODE AND CP.CUS_NO = RC.CUS_NO AND CP.POINT_TYPE = 1 AND CP.ACC_USE_TYPE  = 5
	WHERE
		-- 1+1 이벤트 조건 (20.07.15)
		PD.MASTER_CODE = 'KPP202'-- 'KPP202' 국내 카톡 특별 적립
		AND PD.DEP_DATE >= '2020-06-20' AND PD.DEP_DATE < '2021-01-01'				-- 행사기간 : 6월20일 ~ 12월31일 출발 한정
		AND RM.NEW_DATE >= '2020-06-15' AND RM.NEW_DATE < '2020-07-01'				-- 예약기간 : 6월15일 ~ 6월30일 내 예약한 고객
				
		AND PD.ARR_DATE BETWEEN @START_DATE AND @END_DATE  --도착후 7일 
		AND PD.DEP_DATE > CONVERT(DATETIME,DATEADD(M,-3,CONVERT(DATETIME,@EXE_DATE)) ) --  실행일 한달전 출발 만
		AND RM.ARR_DATE BETWEEN DATEADD(D,-1,@START_DATE) AND DATEADD(D,1,@END_DATE) --[20160908추가] 예약테이블의 도착일은 +- 1일 오차 있음 
		AND RM.DEP_DATE > CONVERT(DATETIME,DATEADD(M,-3,CONVERT(DATETIME,@EXE_DATE)) ) -- [20160908추가] 실행일 한달전 출발 만
		AND RC.POINT_PRICE > 0
		AND MEM.POINT_CONSENT ='Y'
		AND (RC.DC_PRICE IS NULL OR RC.DC_PRICE = 0)  --DC 적용된 회원은 적립 안함
--		AND RM.RES_STATE IN (3,4,5,6) -- 예약상태 결제중,결제완료,출발완료,해피콜 - 2010.07.12 결제중도 적립
--		AND RC.RES_STATE IN (0) -- 출발고객상태 예약인것만
		AND (
			MEM.POINT_CONSENT_DATE <  CONVERT(DATETIME,DATEADD(DD,7,CONVERT(DATETIME,  PD.ARR_DATE )) ) 
		)
		-- 포인트 적립 기준일 이전에 동의 했을경우만 , 휴면회원 CUS_STATE ='Y' CUS_ID = NULL 일경우에 휴면회원 테이블의 동의날짜 가져옴 가정
		AND ISNULL(CP.POINT_PRICE,0) = 0 --   이벤트 적립되지 않은것만  


END 

GO
