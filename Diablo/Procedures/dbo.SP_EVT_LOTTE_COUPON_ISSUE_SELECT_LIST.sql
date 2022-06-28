USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_EVT_LOTTE_COUPON_ISSUE_SELECT_LIST
- 기 능 : 함수_롯데면세점_교환권발급_선택조회
====================================================================================
	참고내용
====================================================================================
- 예제 EXEC SP_EVT_LOTTE_COUPON_ISSUE_SELECT_LIST '35,'
====================================================================================
	변경내역
====================================================================================
- 2011-08-19 신규 작성 
- 2012-05-24 유입처 조회 
===================================================================================*/
CREATE PROC [dbo].[SP_EVT_LOTTE_COUPON_ISSUE_SELECT_LIST]
	@STR_REQ_NO VARCHAR(4000)
AS 

BEGIN

--DECLARE @STR_REQ_NO VARCHAR(4000)
--SET @STR_REQ_NO = '1509'
	SELECT TOP 10 
		A.REQ_NO ,
		B.RES_CODE , C.SEQ_NO , C.CUS_NO , 
		B.DEP_DATE , ISSUE_PRICE , 
		--CASE
		--	WHEN CONVERT(DATETIME,'2011-11-01') > B.DEP_DATE THEN
		--		CASE WHEN CONVERT(DATETIME,'2011-09-01') > B.DEP_DATE THEN B.DEP_DATE
		--			WHEN CONVERT(DATETIME,'2011-09-01') > DATEADD(M,-1,B.DEP_DATE) THEN  CONVERT(DATETIME,'2011-09-01') 
		--		ELSE DATEADD(M,-1,B.DEP_DATE) END 
		--	WHEN CONVERT(DATETIME,'2011-11-01') <= B.DEP_DATE THEN 
		--		CASE WHEN CONVERT(DATETIME,'2011-11-01') > B.DEP_DATE THEN B.DEP_DATE
		--			WHEN CONVERT(DATETIME,'2011-11-01') > DATEADD(M,-1,B.DEP_DATE) THEN  CONVERT(DATETIME,'2011-11-01') 
		--		ELSE DATEADD(M,-1,B.DEP_DATE) END 
		--END MIN_USE_DATE ,
		--CASE 
		--	WHEN CONVERT(DATETIME,'2011-11-01') > B.DEP_DATE THEN
		--		CASE WHEN CONVERT(DATETIME,'2011-10-31') < DATEADD(M,1,B.DEP_DATE) THEN CONVERT(DATETIME,'2011-10-31')
		--			 ELSE DATEADD(M,1,B.DEP_DATE) END 
		--	WHEN CONVERT(DATETIME,'2011-11-01') <= B.DEP_DATE THEN  
		--		CASE WHEN CONVERT(DATETIME,'2011-12-31') < DATEADD(M,1,B.DEP_DATE) THEN CONVERT(DATETIME,'2011-12-31')
		--			 ELSE DATEADD(M,1,B.DEP_DATE) END 
		--END MAX_USE_DATE ,
		A.ISSUE_DATE AS MIN_USE_DATE,
		B.DEP_DATE AS MAX_USE_DATE,
		A.ISSUE_DATE , 
		ISNULL(A.PASS_NUM , C.PASS_NUM ) AS PASS_NUM  , 
		C.CUS_NAME , 
		B.PRO_CODE ,
		B.PROVIDER 
	FROM EVT_LOTTE_COUPON AS A WITH(NOLOCK) 
		INNER JOIN  RES_MASTER AS B WITH(NOLOCK) 
			ON A.RES_CODE = B.RES_CODE 
		INNER JOIN  RES_CUSTOMER AS C WITH(NOLOCK)
			ON A.RES_CODE = C.RES_CODE 
			AND A.SEQ_NO = C.SEQ_NO 
		
	WHERE REQ_NO IN ( SELECT CONVERT(INT,DATA) FROM DBO.FN_SPLIT(@STR_REQ_NO,',') ) 

END 
GO
