USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_EVT_LOTTE_COUPON_MANAGE_LIST
- 기 능 : 함수_롯데면세점_관리조회

예약상태가 정상 인것들만 조회 
====================================================================================
	참고내용
====================================================================================
- 예제 EXEC SP_EVT_LOTTE_COUPON_MANAGE_LIST 'XXX902-110831' , ''
====================================================================================
	변경내역
====================================================================================
- 2011-08-19 신규 작성 
- 2011-09-08 1994년 1월 1일 이후 출생자는 쿠폰발급 불가능 하도록. 이미 발급된 내역은 그대로 발급완료로,
- 2011-12-13 출발년도별 미성년자 체크추가. 2012 년일때는 1995 년 이후 출생자 불가능 하도록 
- 2011-12-23 패널티인사람도 나오도록
- 2012-03-23 발급금액 30000 -> 10000원 중복 체크로 수정 
- 2012-05-24 PROVIDER 유입처 추가 
- 2012-09-25 이전발급 조회 기능 제거
- 2013-02-25 미성년자 발급제한, 2013 년 출발 상품은 1995년 이후 출생자 불가능 하도록

- 2013-12-24 임시 - ok캐쉬백 발급 제한용으로 사용
- 2013-12-27 OK캐쉬백 제거 , 원상복구 
- 2014-01-03 롯데면세점 1만원권 신규 추가 .생년월일 체크 ,중복발급 체크 추가 
===================================================================================*/
CREATE PROC [dbo].[SP_EVT_LOTTE_COUPON_MANAGE_LIST]
	@PRO_CODE PRO_CODE, --	행사코드
	@STATUS CHAR(1)
AS 

--DECLARE @PRO_CODE PRO_CODE 
--DECLARE @STATUS CHAR(1)
----SET @PRO_CODE = 'CPY111-110920' --'CPP332-110925'
--SET @PRO_CODE = 'XXX101-120605' --'CPP332-110925'
----SET @PRO_CODE = 'CPP332-110925'
----SET @PRO_CODE = 'APP9009-110909KE'
--SET @STATUS = ''

SELECT 
	TBL.*,
	CASE
		WHEN TBL.STATUS =5  THEN 
			--불가능, 이전발급&날짜제한 상태5
			CASE WHEN IS_AGE_LIMIT = 1 THEN 
			'이전발급['+ ISNULL(PREV_RES_CODE,'') + '] ' + CONVERT(VARCHAR(16),PREV_ISSUE_DATE,121)+ ' ' 
			+ ISNULL(( SELECT TEAM_NAME FROM EMP_TEAM WITH(NOLOCK) WHERE TEAM_CODE = (SELECT TEAM_CODE FROM EMP_MASTER_damo WITH(NOLOCK) WHERE EMP_CODE = PREV_ISSUER_CODE) )  , '') + ' ' 
			+ ISNULL(( SELECT KOR_NAME FROM EMP_MASTER_damo WITH(NOLOCK) WHERE EMP_CODE = PREV_ISSUER_CODE ),'')  
			ELSE 
			(CASE CONVERT(VARCHAR(4),DEP_DATE,121) 
				WHEN '2014' THEN '1996' ELSE '1996' END ) + 
			'년 1월 1일 이후 출생자는 쿠폰발급이 불가능 합니다.'
			END 
		WHEN TBL.STATUS =3 THEN 
		
			CASE WHEN EDT_CODE IS NOT NULL THEN 
			'발급취소[' + ISNULL(RES_CODE,'') + '] ' + CONVERT(VARCHAR(16),EDT_DATE,121)+ ' ' 
			+ ISNULL(( SELECT TEAM_NAME FROM EMP_TEAM WITH(NOLOCK) WHERE TEAM_CODE = (SELECT TEAM_CODE FROM EMP_MASTER_damo WITH(NOLOCK) WHERE EMP_CODE = TBL.EDT_CODE) )  , '') + ' ' 
			+ ISNULL(( SELECT KOR_NAME FROM EMP_MASTER_damo WITH(NOLOCK) WHERE EMP_CODE = TBL.EDT_CODE ),'') 
			ELSE 
			--신청완료 상태3
			'신청['+ ISNULL(RES_CODE,'') + '] ' + CONVERT(VARCHAR(16),NEW_DATE,121)+ ' ' 
			+ ISNULL(( SELECT TEAM_NAME FROM EMP_TEAM WITH(NOLOCK) WHERE TEAM_CODE = (SELECT TEAM_CODE FROM EMP_MASTER_damo WITH(NOLOCK) WHERE EMP_CODE = TBL.NEW_CODE) )  , '') + ' ' 
			+ ISNULL(( SELECT KOR_NAME FROM EMP_MASTER_damo WITH(NOLOCK) WHERE EMP_CODE = TBL.NEW_CODE ),'') 
			END 
		WHEN TBL.STATUS =1 THEN 
			CASE WHEN  LEN(ISNULL(SOC_NUM1,''))< 6 OR LEN(ISNULL(SOC_NUM2,'')) < 7 THEN 
			'''주민번호'' 가 제대로 입력되지 않아 쿠폰발급이 불가능합니다.'
			ELSE 
			'''여권번호'' 가 입력이 되지 않아 쿠폰발급이 불가능 합니다'
			END 
		WHEN TBL.STATUS =4 THEN 
			''
		ELSE ''
	END STATUS_REMARK 
	, CASE WHEN TBL.PROVIDER = 16 THEN '[웅진메키아]' ELSE '' END AS TYPE_REMARK
FROM (
	SELECT  
		C.REQ_NO,
		B.SOC_NUM1,
		damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','SOC_NUM2', B.SEC_SOC_NUM2) AS SOC_NUM2,
		--상태
		CASE WHEN P1.REQ_NO IS NOT NULL THEN 5  --기존발급  
			 WHEN LEN(ISNULL(B.SOC_NUM1,''))= 6 AND LEN(ISNULL(damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','SOC_NUM2', B.SEC_SOC_NUM2),''))=7
				AND CONVERT(DATETIME ,(CASE WHEN SUBSTRING(damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','SOC_NUM2', B.SEC_SOC_NUM2),1,1) IN ('3','4') THEN '20' ELSE '19' END )
					+ B.SOC_NUM1) >= (CASE CONVERT(VARCHAR(4),A.DEP_DATE,121)  WHEN  '2014' THEN '1996-01-01' ELSE '1996-01-01' END ) 
					AND B.SOC_NUM1 + damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','SOC_NUM2', B.SEC_SOC_NUM2) <> '0105033082415'  --RP1108140796 길동현 임시 
					 THEN CASE WHEN C.ISSUE_YN ='Y'
					 THEN 4 ELSE 5 END   --날짜제한걸리면 불가능. 현재발급된거면 그냥 발급완료로 
			WHEN C.REQ_NO IS NOT NULL THEN CASE WHEN C.ISSUE_YN ='Y' THEN 4 ELSE 3 END    --현재발급여부
			WHEN LEN(ISNULL(B.SOC_NUM1,''))< 6 OR LEN(ISNULL(damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','SOC_NUM2', B.SEC_SOC_NUM2),'')) < 7 THEN 1    --정보필요
			WHEN damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM', B.SEC_PASS_NUM) IS NULL THEN 1 -- 정보필요 (여권번호없음)
				ELSE 2 --신청가능
		END
		AS STATUS ,	
		CASE WHEN CONVERT(DATETIME , 
			(CASE WHEN SUBSTRING(damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','SOC_NUM2', B.SEC_SOC_NUM2),1,1) IN ('3','4') THEN '20' ELSE '19' END )
			+ B.SOC_NUM1) >= (CASE CONVERT(VARCHAR(4),A.DEP_DATE,121)  WHEN  '2014' THEN '1996-01-01' ELSE '1996-01-01' END ) 
			AND B.SOC_NUM1 + damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','SOC_NUM2', B.SEC_SOC_NUM2) <> '0105033082415' /*CPP103-110910G길동현임시마케팅요청20110909*/ 
			THEN 2 ELSE 1
		END AS IS_AGE_LIMIT ,  -- 생년월일 발급가능 1 : 가능 , 2  불가능 
		
		A.PRO_CODE , B.RES_CODE, B.SEQ_NO, 
		B.CUS_NAME, 
		--ISNULL(damo.dbo.dec_varchar('DIABLO','dbo.EVT_LOTTE_COUPON','PASS_NUM', C.SEC_PASS_NUM) , 
		--	damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM', B.sec_PASS_NUM)
		-- ) AS PASS_NUM  ,
		ISNULL(damo.dbo.dec_varchar('DIABLO','dbo.EVT_LOTTE_COUPON','PASS_NUM', C.SEC_PASS_NUM), damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM', B.SEC_PASS_NUM)) AS PASS_NUM ,
		ISNULL(C.CUS_NO, B.CUS_NO) AS CUS_NO ,
		B.NOR_TEL1, B.NOR_TEL2, B.NOR_TEL3, B.EMAIL, 
		C.ISSUE_PRICE, C.ACC_PRICE, 
		C.ISSUER_CODE , C.ISSUE_DATE , C.ISSUE_TYPE,C.ISSUE_YN,
		(SELECT KOR_NAME FROM EMP_MASTER_damo WITH(NOLOCK) WHERE EMP_CODE = C.ISSUER_CODE )  AS ISSUER_NAME,
		C.NEW_CODE,C.NEW_DATE,
		P1.RES_CODE AS PREV_RES_CODE , 
		P1.ISSUE_DATE AS PREV_ISSUE_DATE , 
		P1.ISSUER_CODE AS PREV_ISSUER_CODE ,
		--NULL AS PREV_RES_CODE , 
		--NULL AS PREV_ISSUE_DATE , 
		--NULL AS PREV_ISSUER_CODE ,
		C.EDT_CODE,C.EDT_DATE , 
		A.DEP_DATE ,
		A.PROVIDER
	FROM RES_MASTER_DAMO AS A WITH(NOLOCK) 
		INNER JOIN RES_CUSTOMER_DAMO AS B WITH(NOLOCK) 
		--INNER JOIN RES_CUSTOMER AS B WITH(NOLOCK)
			ON A.RES_CODE = B.RES_CODE
		LEFT JOIN EVT_LOTTE_COUPON_DAMO AS C WITH(NOLOCK)
			ON A.RES_CODE = C.RES_CODE
			AND B.SEQ_NO = C.SEQ_NO 
			
		-- 2014-01-03 중복체크  
		LEFT JOIN EVT_LOTTE_COUPON_DAMO AS P1 WITH(NOLOCK)
			ON	B.SEC_PASS_NUM = P1.SEC_PASS_NUM 
			--ON	B.CUS_NO = P1.CUS_NO 
			--ON	damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM', B.SEC_PASS_NUM ) = damo.dbo.dec_varchar('DIABLO','dbo.EVT_LOTTE_COUPON','PASS_NUM', P1.SEC_PASS_NUM ) 
			AND B.RES_CODE <> P1.RES_CODE 
			AND damo.dbo.dec_varchar('DIABLO','dbo.RES_CUSTOMER','PASS_NUM', B.SEC_PASS_NUM) IS NOT NULL 
			AND P1.ISSUE_YN = 'Y' 
			AND P1.ISSUE_PRICE = 10000  -- 30000
			AND P1.ISSUE_DATE >= '2014-01-01' 
			AND P1.ISSUE_DATE < '2014-03-01' 

	WHERE A.PRO_CODE = @PRO_CODE
	AND A.RES_STATE NOT IN ( 7,8,9 ) 
	AND B.RES_STATE IN (0,4)
) AS TBL 
WHERE (@STATUS = '' OR TBL.STATUS = @STATUS )
ORDER BY RES_CODE , SEQ_NO 
GO
