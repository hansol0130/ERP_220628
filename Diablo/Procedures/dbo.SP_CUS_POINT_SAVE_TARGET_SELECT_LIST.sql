USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ USP_Name					:	SP_CUS_POINT_SAVE_TARGET_SELECT_LIST  
■ Description				:	포인트 적립 대상자 조회 PointSaveSendMail.exe
■ Input Parameter			:	@EXE_DATE		기준일자
■ Output Parameter			:                  
■ Output Value				:     
■ Exec						:

	EXEC [SP_CUS_POINT_SAVE_TARGET_SELECT_LIST]  '2022-02-25'
	
■ Author					: 박형만  
■ Date						: 2010-05-13
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author		Description           
---------------------------------------------------------------------------------------------------
	2010-05-13		박형만		최초생성  
	2010-06-03		박형만		암호화 적용
	2010-06-07		박형만		6월 1일 출발자 부터 적용되도록 수정
	2010-06-28		박형만		도착일(PD.ARR_DATE)을 한국도착일(ARR_ARR_DATE) 로 변경
	2010-07-12		박형만		결재중일때도 적립,출발자상태 가 예약인것만 적립 되도록 수정
								좌석정보에 도착일이 없을때 상품의 도착일 사용
	2010-08-03		박형만		도착일 WHERE IS NULL 검색에서 UNION ALL 검색으로 수정 
	2010-08-03		박형만		기존적립 포인트 JOIN 버그 수정
	2010-08-11		박형만		첫번째 테이블조건 PRO_TRANS_SEAT 을 INNER JOIN 으로 
					박형만		포인트 적립기준일 이전에 동의 한사람만 적립 되도록 수정
	2010-12-09		김성호		회원테이블 분리
	2011-09-19		박형만		호텔 포인트 추가 

	2012-01-17		박형만		성능 문제로 인하여 좌석의도착일 조회 안함 -- 무조건 상품도착일 기준. 하루 일찍적립될 수 있음 
	2013-06-03		박형만		출발 시간으로도 적용 되도록 수정(국내여행의 ARR_DATE 에 시간이 들어가 있음)
	2013-06-19		박형만		DC_PRICE 조건 OR 조건으로 변경 
	2013-08-19		박형만		CUS_CUSTOMER_DAMO -> CUS_MEMBER 
	2013-10-15		박형만		RES_CUSTOMER.POINT_PRICE -> 출발자 판매가격의 1% 로 수정  , TOTAL_PRICE 판매가 추가 
	2013-12-02		박형만		CUS_ID 추가 
	2014-04-15		박형만		성능문제로 호텔 포인트 부분삭제 ( 호텔 포인트 더이상 적립되지 않음 )
	2015-03-03		김성호		주민번호 삭제, 생년월일 추가
	2016-09-08		박형만		성능개선(RES_MASTER 에 조건 걸기) & 한예약에 중복매핑고객 제외하기 (중복적립방지)
	2016-10-20		박형만		휴면회원일경우에 포인트 자동적립  추가 ( 오운 차장님 동의  )  
	2017-08-30		박형만		9월1일 이후 도착자 는  OK캐쉬백 동의 안함으로 수정 
	2018-09-18		박형만		알림톡 발송을 위한 휴대폰 번호 조회 추가 
	2019-05-13		박형만		중복적립 방지 적용
	2020-07-15		김성호		쿼리정리
	2020-11-18		김성호		포인트 적립조건 POINT_PRICE에서 POINT_RATE로 변경 (실제 사용을 POINT_RATE로 하고 있음)
	2020-12-07		김성호		단품구분을 위한 상품 대표속성 검색 추가
	2022-02-25		김성호		포인트 적립 검색일자를 7일전 하루에서 10전부터 7일전까지(3일)로 확장 (포인트 미적립 체크)
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[SP_CUS_POINT_SAVE_TARGET_SELECT_LIST]
	@EXE_DATE VARCHAR(10)
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @START_DATE     DATETIME
	       ,@END_DATE       DATETIME
	
	SELECT @START_DATE = DATEADD(DD,-9,CONVERT(DATETIME, @EXE_DATE)) -- 출발일시
	      ,@END_DATE = DATEADD(DD,-6,CONVERT(DATETIME, @EXE_DATE)) -- 도착일시
	
	
	SELECT LIST.*
	FROM   (
	           SELECT ROW_NUMBER() OVER(PARTITION BY RC.RES_CODE ,RC.CUS_NO ORDER BY RC.SALE_PRICE DESC) AS ROWNUM
	                 ,RC.CUS_NO
	                 ,VM.CUS_ID
	                 ,((ISNULL(RC.SALE_PRICE ,0) - ISNULL(RC.DC_PRICE ,0) + ISNULL(RC.CHG_PRICE ,0) + ISNULL(RC.TAX_PRICE ,0) + ISNULL(RC.PENALTY_PRICE ,0)) * (ISNULL(RC.POINT_RATE ,0) / 100)) AS POINT_PRICE
	                 ,(
	                      SELECT TOP 1 TOTAL_PRICE AS TOTAL_POINT
	                      FROM   DBO.CUS_POINT WITH(NOLOCK)
	                      WHERE  CUS_NO = RC.CUS_NO
	                      ORDER BY
	                             POINT_NO DESC
	                  ) AS NOW_POINT_PRICE	-- 해당 고객의 현재 총 포인트
	                 ,RM.RES_CODE
	                 ,RM.PRO_NAME
	                 ,VM.CUS_NAME
	                 ,VM.EMAIL
	                 ,VM.RCV_EMAIL_YN
	                 ,PD.ARR_DATE
	                 ,ISNULL(CP.POINT_PRICE ,0) AS SAVE_POINT	--기적립 포인트
	                 ,VM.BIRTH_DATE
	                 ,VM.GENDER
	                 ,VM.NOR_TEL1
	                 ,VM.NOR_TEL2
	                 ,VM.NOR_TEL3
	                 ,PM.ATT_CODE
	           FROM   RES_MASTER_damo RM WITH(NOLOCK)
	                  INNER JOIN RES_CUSTOMER_damo RC WITH(NOLOCK)
	                       ON  RM.RES_CODE = RC.RES_CODE
	                  INNER JOIN PKG_DETAIL PD WITH(NOLOCK)
	                       ON  RM.PRO_CODE = PD.PRO_CODE
	                  INNER JOIN PKG_MASTER PM WITH(NOLOCK)
	                       ON  RM.MASTER_CODE = PM.MASTER_CODE
	                  INNER JOIN VIEW_MEMBER VM WITH(NOLOCK)
	                       ON  RC.CUS_NO = VM.CUS_NO
	                  LEFT JOIN CUS_POINT AS CP WITH(NOLOCK)	-- 고객번호로 조인
	                       ON  CP.RES_CODE = RC.RES_CODE
	                           AND CP.CUS_NO = RC.CUS_NO
	                           AND CP.POINT_TYPE = 1 AND CP.ACC_USE_TYPE <> 9	-- VIP 적립 제외
	           WHERE  RM.ARR_DATE >= @START_DATE
	                  AND RM.ARR_DATE < @END_DATE --도착후 7일
	                  AND RM.DEP_DATE > CONVERT(DATETIME ,DATEADD(M ,-1 ,CONVERT(DATETIME ,@START_DATE))) --  실행일 한달전 출발 만
	                  AND RM.RES_STATE IN (3 ,4 ,5 ,6) -- 예약상태 결제중,결제완료,출발완료,해피콜 - 2010.07.12 결제중도 적립
	                  AND RC.RES_STATE IN (0) -- 출발고객상태 예약인것만
	                  AND RC.POINT_RATE > 0
	                  AND VM.POINT_CONSENT = 'Y' --포인트 동의
	                  AND RC.SALE_PRICE > 0
	                  AND RC.DC_PRICE = 0 --DC 적용된 회원은 적립 안함
	                  AND VM.POINT_CONSENT_DATE < CONVERT(DATETIME ,DATEADD(DD ,7 ,CONVERT(DATETIME ,PD.ARR_DATE)))
	                  AND CP.POINT_NO IS  NULL  --  중복적립 방지.적립안된것만
	       ) LIST
	WHERE  LIST.ROWNUM = 1;
END 
GO
