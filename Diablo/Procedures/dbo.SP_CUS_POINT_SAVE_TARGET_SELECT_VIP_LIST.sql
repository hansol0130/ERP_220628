USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ USP_Name					: SP_CUS_POINT_SAVE_TARGET_SELECT_VIP_LIST  
■ Description				: 포인트 추가적립 VIP 대상자 
■ Input Parameter			:                  
		@CUS_NO				: 고객 고유번호
		@USE_TYPE			: 사용종류
		@USE_POINT_PRICE	: 사용 포인트
		@RES_CODE			: 예약코드
		@TITLE				: 제목
		@REMARK				: 비고
		@NEW_CODE			: 작성자 코드
■ Output Parameter			:                  
■ Output Value				: EXEC SP_CUS_POINT_SAVE_TARGET_SELECT_LIST  '2019-01-10'     
							  EXEC SP_CUS_POINT_SAVE_TARGET_SELECT_VIP_LIST  '2019-12-31'
■ Exec						: EXEC SP_CUS_POINT_SAVE_TARGET_SELECT_VIP_LIST  '2020-01-01'
EXEC SP_CUS_POINT_SAVE_TARGET_SELECT_VIP_LIST  '2019-02-12'
■ Author					: 박형만  
■ Date						: 2019-01-07
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date				Author			Description           
---------------------------------------------------------------------------------------------------
	2019-01-07		박형만			최초생성  
	2019-05-24		김남훈			LANDY ONLY도 처리하게 추가
	2019-12-30		박형만			블루(4)등급 2.0 -> 1.5  로 변경   ,  현재 등급이 아닌 CUS_VIP_HISTORY 테이블 참고로 변경 
	2020-07-15		김성호			쿼리정리, 고객 포인트 혜택 CUS_VIP_BENEFIT 테이블 생성하여 등록 후 사용으로 수정
	2020-09-18		김성호			VIP_YEAR 형변환 (VARCHAR(4) -> INT)
	2020-11-18		김성호			POINT_RATE 체크 PKG_DETAIL 에서 RES_CUSTOMER로 수정
									상품속성(ATT_CODE) 단품(1) 제외
	2022-02-25		김성호			포인트 적립 검색일자를 7일전 하루에서 10전부터 7일전까지(3일)로 확장 (포인트 미적립 체크)									
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[SP_CUS_POINT_SAVE_TARGET_SELECT_VIP_LIST]
	@EXE_DATE VARCHAR(10)
AS 
SET NOCOUNT ON 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @START_DATE     DATETIME
	       ,@END_DATE       DATETIME
	
	SELECT @START_DATE = DATEADD(DD,-9,CONVERT(DATETIME, @EXE_DATE)) -- 출발일시
	      ,@END_DATE = DATEADD(DD,-6,CONVERT(DATETIME, @EXE_DATE)) -- 도착일시

	--DECLARE @START_DATE DATETIME 
	--SET @START_DATE = DATEADD(DD,-7,CONVERT(DATETIME, @EXE_DATE))  -- 출발일시
	--DECLARE @END_DATE DATETIME 
	--SET @END_DATE = DATEADD(S,-1,DATEADD(DD,1,@START_DATE))  --도착일시 

	--포인트 적립 대상자 조회 2016-09-08  , 
	SELECT
		RC.CUS_NO,
		MEM.CUS_ID,
		MEM.CUS_NAME,
		CVH.CUS_GRADE,
		--DBO.FN_RES_GET_TOTAL_PRICE_ONE(RC.RES_CODE,RC.SEQ_NO)  AS TOTAL_PRICE,
		ISNULL(CVB.BEN_VALUE, 0) AS POINT_RATE,
		((ISNULL(RC.SALE_PRICE, 0) - ISNULL(RC.DC_PRICE, 0) + ISNULL(RC.CHG_PRICE, 0) + ISNULL(RC.TAX_PRICE, 0) + ISNULL(RC.PENALTY_PRICE, 0))
			 * (ISNULL(CVB.BEN_VALUE, 0) / 100)) AS POINT_PRICE, 
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
	
		PM.SIGN_CODE, 
		--PDP.POINT_RATE,
		RC.DC_PRICE 
	FROM PKG_DETAIL AS PD WITH(NOLOCK)
	INNER JOIN PKG_MASTER AS PM WITH(NOLOCK) ON PD.MASTER_CODE = PM.MASTER_CODE 
	INNER JOIN RES_MASTER_damo AS RM WITH(NOLOCK) ON PD.PRO_CODE = RM.PRO_CODE 
	INNER JOIN RES_CUSTOMER_damo AS RC WITH(NOLOCK) ON RM.RES_CODE = RC.RES_CODE 
		AND RC.SEQ_NO = ( SELECT TOP 1 SEQ_NO FROM RES_CUSTOMER_damo WITH(NOLOCK) WHERE RES_CODE = RC.RES_CODE AND CUS_NO = RC.CUS_NO  AND RES_STATE = 0 ORDER BY SEQ_NO ) 
		-- 중복 매핑된 고객 있을경우 한명만 
	--INNER JOIN CUS_CUSTOMER_DAMO AS CC WITH(NOLOCK) ON RC.CUS_NO = CC.CUS_NO 
	INNER JOIN VIEW_MEMBER AS MEM WITH(NOLOCK) ON RC.CUS_NO = MEM.CUS_NO
	INNER JOIN CUS_VIP_HISTORY AS CVH WITH(NOLOCK) ON MEM.CUS_NO = CVH.CUS_NO AND CVH.VIP_YEAR = YEAR(PD.DEP_DATE) -- 출발년도 별 VIP 매핑 
	LEFT JOIN CUS_VIP_BENEFIT AS CVB WITH(NOLOCK) ON CVH.VIP_YEAR = CVB.VIP_YEAR AND CVH.CUS_GRADE = CVB.CUS_GRADE
	LEFT JOIN PKG_DETAIL_PRICE AS PDP WITH(NOLOCK) ON PD.PRO_CODE = PDP.PRO_CODE AND RM.PRICE_SEQ = PDP.PRICE_SEQ 
	-- VIP 적립 중복 체크 목적
	LEFT JOIN CUS_POINT AS CP WITH(NOLOCK) ON CP.RES_CODE = RC.RES_CODE AND CP.CUS_NO = RC.CUS_NO AND CP.POINT_TYPE = 1 AND CP.ACC_USE_TYPE  = 9

	WHERE
		RM.ARR_DATE >= @START_DATE AND RM.ARR_DATE < @END_DATE	-- 도착 후 7일
		AND RM.DEP_DATE > CONVERT(DATETIME ,DATEADD(M ,-1 ,CONVERT(DATETIME ,@START_DATE))) --  실행일 한달전 출발 만
		AND PD.DEP_DATE >= '2019-02-01' -- 2019년2월1일 출발부터 
		AND RM.PRO_TYPE = 1 -- 패키지만
		--AND PTS.ARR_ARR_DATE IS NULL  
		--AND RC.POINT_PRICE > 0 -- 관계 없음 
		--AND (CC.POINT_CONSENT ='Y' OR CMS.POINT_CONSENT ='Y') --포인트 동의
		--AND (RC.DC_PRICE IS NULL OR RC.DC_PRICE = 0)  --DC 적용된 회원은 적립 안함
		AND RM.PROVIDER IN ( 1,5,8,19,20,21,22,23,24,26,32 ) -- 직판,인터넷,모바일앱,다음,네이버,크리테오,와이더,구글, LANDY ONLY

		-- 판매처 없는것 OR 판매처가 있고 DC가 없는것 
		AND (ISNULL(RM.SALE_COM_CODE,'') = ''					--판매처 없는것
			OR ISNULL(RM.SALE_COM_CODE,'') <> '' AND RC.DC_PRICE = 0 ) --  판매처가 있고 DC가 없는것 
		AND RM.RES_STATE IN (3,4,5,6) -- 예약상태 결제중,결제완료,출발완료,해피콜 - 2010.07.12 결제중도 적립
		AND RC.RES_STATE IN (0) -- 출발고객상태 예약인것만
		-- 포인트 적립 기준일 이전에 동의 했을경우만 , 휴면회원 CUS_STATE ='Y' CUS_ID = NULL 일경우에 휴면회원 테이블의 동의날짜 가져옴 가정
		AND CVH.CUS_GRADE BETWEEN 2 AND 6   -- 등급 그린 = 2, 블루 = 4, 퍼플 = 6
		-- 국내 아닌것 OR 국내는 포인트 0 이상인것만 
		AND (PM.SIGN_CODE <> 'K'  OR  (PM.SIGN_CODE = 'K' AND RC.POINT_RATE > 0 ) )
		-- 단품 추가적립 제외
		AND PM.ATT_CODE <> '1'
		AND CP.POINT_NO IS NULL  --  중복적립 방지 
		ORDER BY MEM.CUS_NO ASC

END 
GO
