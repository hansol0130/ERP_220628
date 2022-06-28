USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ARG_CUSTOMER_LIST_SELECT
■ DESCRIPTION				: 수배현황 출발자 리스트 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	/Land/LandCommonHandler.ashx?type=argcust&argCode=A140325-0006&grpSeqNo=1&argStatus=-1&orderBy=1
	EXEC DBO.XP_ARG_CUSTOMER_LIST_SELECT 'A140403-0044','', 0 , 0, 0 

	/Land/ArrangementDetail.aspx?proCode=XXX101-140422
	/Land/LandCommonHandler.ashx?type=argcustpro&proCode=XXX101-140422&argCode=A140326-0001&grpSeqNo=1&argStatus=-1&orderBy=1
	EXEC DBO.XP_ARG_CUSTOMER_LIST_SELECT 'CPP1020-131217', '93002','', 1 , 0 , 0 
		   XP_ARG_CUSTOMER_LIST_SELECT @PRO_CODE='CPP1020-131217',@AGT_CODE='',@ARG_CODE='',@GRP_SEQ_NO=0,@ARG_STATUS=0,@ORDER_BY=0


		   select * from arg_customer where arg_code in (
'A140327-0007',
'A140327-0008')
		   SELECT * FROM ARG_MASTER WHERE PRO_CODE = 'CPP1020-131217'
	exec XP_ARG_CUSTOMER_LIST_SELECT @ARG_CODE='A141204-0110',@AGT_CODE='',@GRP_SEQ_NO=0,@ARG_STATUS=0,@ORDER_BY=0
	■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-03-25		박형만			최초생성
   2014-12-03		정지용			수배취소상태 제외하고 조회 (수배취소상태 조회시에만 수배취소조회)
   2014-12-05		정지용			관련 취소 상태 모두 제외 검색시에만 취소상태 값 조회 가능하게
   2015-03-03		김성호			주민번호 삭제, 생년월일 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_CUSTOMER_LIST_SELECT]
	@ARG_CODE VARCHAR(12) ,  --수배코드 
	@AGT_CODE VARCHAR(20) , -- 랜드사코드 ( 전체 NULL ) 
	@GRP_SEQ_NO INT ,-- 그룹별 조회 (전체 0)
	@ARG_STATUS INT , -- 상태별 조회 (전체 0)
	@ORDER_BY	INT  -- 정렬방식 -- 상태 1,예약코드2,작성일3
AS 
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
--declare @ARG_CODE VARCHAR(12) ,  --수배코드 
--	@AGT_CODE VARCHAR(20) , -- 랜드사코드 ( 전체 NULL ) 
--	@GRP_SEQ_NO INT ,-- 그룹별 조회 (전체 -1)
--	@ARG_STATUS INT , -- 상태별 조회 (전체 -1)
--	@ORDER_BY	INT  -- 정렬방식 -- 상태 1,예약코드2,작성일3
--select @ARG_CODE = 'A140403-0044', @AGT_CODE = '' ,@GRP_SEQ_NO = 0 , @ARG_STATUS = 0 , @ORDER_BY= 0 

	--출발자 명단 카운트
	SELECT 
		SUM(CASE WHEN A.ARG_STATUS IN (1) THEN 1 ELSE 0 END ) AS ARG_CUS_CNT_1 ,
		SUM(CASE WHEN A.ARG_STATUS IN (2) THEN 1 ELSE 0 END ) AS ARG_CUS_CNT_2 ,
		SUM(CASE WHEN A.ARG_STATUS IN (3,4) THEN 1 ELSE 0 END ) AS ARG_CUS_CNT_3 
	FROM ARG_CUSTOMER A 
	INNER JOIN ARG_DETAIL B
		ON A.ARG_CODE = B.ARG_CODE 
	INNER JOIN ARG_CONNECT C
		ON A.ARG_CODE = C.ARG_CODE 
		AND A.CUS_SEQ_NO = C.CUS_SEQ_NO
		AND B.GRP_SEQ_NO = C.GRP_SEQ_NO 
		--AND C.GRP_SEQ_NO = ( SELECT MAX(GRP_SEQ_NO) FROM ARG_CONNECT WHERE ARG_CODE = C.ARG_CODE  AND CUS_SEQ_NO = C.CUS_SEQ_NO ) 
		AND C.GRP_SEQ_NO = ( 
			SELECT MAX(AA.GRP_SEQ_NO) FROM ARG_CONNECT AA
				INNER JOIN ARG_DETAIL BB	ON AA.ARG_CODE = BB.ARG_CODE AND AA.GRP_SEQ_NO = BB.GRP_SEQ_NO 
			WHERE AA.ARG_CODE = C.ARG_CODE  AND AA.CUS_SEQ_NO = C.CUS_SEQ_NO AND BB.ARG_STATUS NOT IN ( 4, 7 , 8 )  )   -- 수배확정취소,인보이스취소,인보이스확정취소 제외 최근 GRP_SEQ_NO
	INNER JOIN ARG_MASTER D 
			ON A.ARG_CODE = D.ARG_CODE
	WHERE A.ARG_CODE = @ARG_CODE
	AND (B.GRP_SEQ_NO = @GRP_SEQ_NO OR @GRP_SEQ_NO = 0 )
	AND (D.AGT_CODE = @AGT_CODE OR ISNULL(@AGT_CODE,'') ='' )
	--AND B.ARG_TYPE IN (1,2)  --수배요청서,확정서
		

	--출발자 명단 
	SELECT
		CASE  WHEN @ORDER_BY = 1 THEN ROW_NUMBER() OVER( ORDER BY A.ARG_STATUS DESC ) 
					WHEN @ORDER_BY = 2 THEN ROW_NUMBER() OVER( ORDER BY A.RES_CODE DESC ) 
					WHEN @ORDER_BY = 3 THEN ROW_NUMBER() OVER( ORDER BY A.NEW_DATE DESC ) 
					ELSE ROW_NUMBER() OVER( ORDER BY A.NEW_DATE DESC ) 
		END AS ROW_NUM ,
		D.PRO_CODE, D.AGT_CODE , A.ARG_CODE , B.ARG_TYPE, B.GRP_SEQ_NO , 
		A.ARG_CODE,A.CUS_SEQ_NO,A.RES_CODE,A.SEQ_NO,A.ARG_STATUS,
		A.CUS_NAME,A.LAST_NAME,A.FIRST_NAME,A.AGE_TYPE,A.GENDER,A.BIRTH_DATE,A.EMAIL,A.CELLPHONE,A.PASS_NUM,A.PASS_EXPIRE,
		A.ROOMING,A.ETC_REMAKR,A.NEW_CODE,A.NEW_DATE,A.EDT_DATE,A.EDT_CODE ,
		CASE WHEN ISDATE(A.BIRTH_DATE) = 1 THEN  
			dbo.FN_CUS_GET_AGE(CONVERT(DATETIME,A.BIRTH_DATE) ,B.DEP_DATE ) 
		ELSE 0 END AS AGE
	FROM ARG_CUSTOMER A 
	INNER JOIN ARG_DETAIL B
		ON A.ARG_CODE = B.ARG_CODE 
	INNER JOIN ARG_CONNECT C
		ON A.ARG_CODE = C.ARG_CODE 
		AND A.CUS_SEQ_NO = C.CUS_SEQ_NO
		AND B.GRP_SEQ_NO = C.GRP_SEQ_NO 
		AND C.GRP_SEQ_NO = ( 
			SELECT MAX(AA.GRP_SEQ_NO) FROM ARG_CONNECT AA
				INNER JOIN ARG_DETAIL BB	ON AA.ARG_CODE = BB.ARG_CODE AND AA.GRP_SEQ_NO = BB.GRP_SEQ_NO 
			WHERE AA.ARG_CODE = C.ARG_CODE  AND AA.CUS_SEQ_NO = C.CUS_SEQ_NO AND BB.ARG_STATUS NOT IN ( 4, 7 , 8 )  )  -- 수배확정취소,인보이스취소,인보이스확정취소 제외 최근 GRP_SEQ_NO
	INNER JOIN ARG_MASTER D 
			ON A.ARG_CODE = D.ARG_CODE 	
	WHERE A.ARG_CODE = @ARG_CODE
	AND (D.AGT_CODE = @AGT_CODE OR ISNULL(@AGT_CODE,'') ='' )
	AND (B.GRP_SEQ_NO = @GRP_SEQ_NO OR @GRP_SEQ_NO = 0 )
	AND (A.ARG_STATUS = @ARG_STATUS OR (@ARG_STATUS = 0 AND A.ARG_STATUS NOT IN( 3, 4, 7, 8 ))) 
	--AND B.ARG_TYPE IN (1,2)  --수배요청서,확정서

	ORDER BY (CASE  WHEN @ORDER_BY = 1 THEN ROW_NUMBER() OVER( ORDER BY A.ARG_STATUS DESC ) 
					WHEN @ORDER_BY = 2 THEN ROW_NUMBER() OVER( ORDER BY A.RES_CODE DESC ) 
					WHEN @ORDER_BY = 3 THEN ROW_NUMBER() OVER( ORDER BY A.NEW_DATE DESC ) 
					ELSE ROW_NUMBER() OVER( ORDER BY A.NEW_DATE DESC ) 					
					END) ASC  

END 
GO
