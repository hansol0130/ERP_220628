USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_RES_HOTEL_INFO_SELECT
■ DESCRIPTION				: 예약된 상품 정보 OR 상품정보 보기 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC XP_COM_RES_HOTEL_INFO_SELECT '92756 ','RT1603078823',100

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE					AUTHOR				DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-01		저스트고 - 백경훈		최초생성
   2016-05-26		김성호					BT_STATE 삭제
================================================================================================================*/ 

CREATE PROC [dbo].[XP_COM_RES_HOTEL_INFO_SELECT]
	@AGT_CODE VARCHAR(10),
	@RES_CODE VARCHAR(20),
	@NEW_SEQ INT
AS 
BEGIN
	WITH AGT_BIZTRIP_LIST AS 
	(
		SELECT top 1 A.AGT_CODE,A.BT_CODE, A.BT_START_DATE, A.BT_END_DATE, A.BT_REASON,  B.RES_CODE, 
		A.BT_TIME_LIMIT, A.NEW_DATE, A.NEW_SEQ, C.KOR_NAME AS EMP_NAME,
		D.HOTEL_LIKE_YN, D.HOTEL_DISLIKE_YN,  D.HOTEL_PRICE_LIMIT, D.REASON_SEQ, D.REASON_REMARK
		FROM 
		COM_BIZTRIP_MASTER A
		JOIN COM_BIZTRIP_DETAIL B
		ON A.BT_CODE = B.BT_CODE
		AND A.AGT_CODE = @AGT_CODE
		AND A.NEW_SEQ = @NEW_SEQ
		AND B.RES_CODE = @RES_CODE
		JOIN COM_EMPLOYEE C
		ON A.NEW_SEQ = C.EMP_SEQ
		LEFT JOIN COM_BIZTRIP_RULE_REMARK D
		ON B.RES_CODE = D.RES_CODE
		)
	--호텔예약 정보
	SELECT  ABL.AGT_CODE,ABL.BT_CODE, ABL.BT_START_DATE, ABL.BT_END_DATE, ABL.BT_REASON,ABL.RES_CODE,
        ABL.BT_TIME_LIMIT, ABL.NEW_DATE, ABL.NEW_SEQ, ABL.EMP_NAME,
		ABL.HOTEL_LIKE_YN, ABL.HOTEL_DISLIKE_YN,  ABL.HOTEL_PRICE_LIMIT, ABL.REASON_SEQ, ABL.REASON_REMARK,
		A.PRO_TYPE,A.RES_STATE , B.RES_STATE as ROOM_RES_STATE,
		A.RES_CODE, A.PRO_NAME, A.PRO_CODE,A.PRICE_SEQ , A.NEW_DATE , 
		A.CUS_NO , A.RES_NAME, A.NOR_TEL1 , A.NOR_TEL2 , A.NOR_TEL3 , A.RES_EMAIL , A.BIRTH_DATE, 
		case when A.GENDER ='F' then '女' else '男' end as GENDER,  
		B.CHECK_IN AS DEP_DATE , 
		B.CHECK_OUT AS ARR_DATE ,
		B.SALE_PRICE,
		B.LAST_CXL_DATE,
		B.CXL_REMARK,
	
		dbo.FN_RES_GET_RES_AGE_COUNT(A.RES_CODE, 0) AS ADULT_COUNT,
		dbo.FN_RES_GET_RES_AGE_COUNT(A.RES_CODE, 1) AS CHILD_COUNT,
		dbo.FN_RES_GET_RES_AGE_COUNT(A.RES_CODE, 2) AS INFANT_COUNT,
		DBO.FN_RES_HTL_GET_TOTAL_PRICE(A.RES_CODE)  AS TOTAL_PRICE,
		DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE) AS PAY_PRICE,
		A.LAST_PAY_DATE, A.CUS_REQUEST, A.CUS_RESPONSE,
		C.EMP_CODE, C.KOR_NAME, C.INNER_NUMBER1, C.INNER_NUMBER2, C.INNER_NUMBER3, 
		C.FAX_NUMBER1, C.FAX_NUMBER2, C.FAX_NUMBER3, C.EMAIL AS EMP_EMAIL, C.GREETING , 
		C.TEAM_CODE , DBO.XN_COM_GET_TEAM_NAME(C.EMP_CODE)  AS TEAM_NAME  ,
		( SELECT KEY_NUMBER FROM EMP_TEAM WITH(NOLOCK) WHERE TEAM_CODE = C.TEAM_CODE )  AS KEY_NUMBER  ,
		B.ROOM_YN , DATEDIFF( D, B.CHECK_IN , B.CHECK_OUT ) AS NIGHTS,
		 CASE WHEN D.BREAKFAST_YN ='Y' THEN '조식포함' ELSE '조식불포함'  END  as BREAKFAST
	FROM RES_MASTER_damo A WITH(NOLOCK)	
	INNER JOIN  AGT_BIZTRIP_LIST ABL WITH(NOLOCK)
	ON ABL.RES_CODE = A.RES_CODE
		INNER JOIN RES_HTL_ROOM_MASTER B WITH(NOLOCK) 
			ON A.RES_CODE = B.RES_CODE
		INNER JOIN RES_HTL_ROOM_DETAIL D WITH(NOLOCK)
			ON A.RES_CODE = D.RES_CODE
			AND D.ROOM_NO = 1
		LEFT JOIN EMP_MASTER C WITH(NOLOCK) 
			ON A.NEW_CODE = C.EMP_CODE
	AND A.RES_CODE = @RES_CODE

	ORDER BY A.RES_CODE DESC


-- 객실 갯수 및 정보

		SELECT R.ROOM_NO, A.ROOM_NAME, B.RES_STATE,
				CASE WHEN ROOM_TYPE = 1 THEN '싱글룸'  
					WHEN ROOM_TYPE = 2 THEN '더블룸' 
					WHEN ROOM_TYPE = 3 THEN '트윈룸'
					WHEN ROOM_TYPE = 4 THEN '트리플룸'
					WHEN ROOM_TYPE = 5 THEN '4인실' ELSE '' END as ROOM_TYPE,  
				CONVERT(VARCHAR,ROOM_COUNT) + '개  ' as ROOM_COUNT, 
				CONVERT(VARCHAR, DATEDIFF( D, B.CHECK_IN , B.CHECK_OUT ) ) + '박'  as DEF
				, CASE WHEN BREAKFAST_YN ='Y' THEN '조식포함' ELSE '조식불포함'  END  as BREAKFAST, 
				  CASE WHEN RC.AGE_TYPE = 0 THEN COUNT(RC.AGE_TYPE) ELSE 0 END  AS ADULT_COUNT,
				  CASE WHEN RCC.AGE_TYPE = 1 THEN COUNT(RC.AGE_TYPE) ELSE 0 END  AS CHILD_COUNT

			FROM RES_HTL_ROOM_DETAIL A
				   JOIN RES_HTL_ROOM_MASTER B 
					ON A.RES_CODE = B.RES_CODE 
					and A.RES_CODE = @RES_CODE
					JOIN RES_HTL_CUSTOMER_DETAIL R
					ON A.RES_CODE = R.RES_CODE
					AND A.ROOM_NO = R.ROOM_NO
					JOIN RES_CUSTOMER RC
					ON A.RES_CODE = RC.RES_CODE
					AND R.SEQ_NO = RC.SEQ_NO
					JOIN RES_CUSTOMER RCC
					ON A.RES_CODE = RCC.RES_CODE
					AND R.SEQ_NO = RCC.SEQ_NO

			GROUP BY A.ROOM_TYPE, B.RES_STATE, ROOM_TYPE, 
				ROOM_COUNT, B.CHECK_IN , B.CHECK_OUT ,
				 BREAKFAST_YN, R.ROOM_NO, RC.AGE_TYPE, RCC.AGE_TYPE, ROOM_NAME


/*고객 정보*/


Select A.RES_CODE, A.SEQ_NO, A.RES_STATE, A.CUS_NO, A.CUS_NAME, A.LAST_NAME,FIRST_NAME,
CASE 
WHEN A.AGE_TYPE = 0 THEN '성인'   
WHEN A.AGE_TYPE = 1 THEN '소아'   
WHEN A.AGE_TYPE = 2 THEN '유아'   
ELSE '없음' END as AGE_TYPE, 
A.GENDER, A.ETC_REMARK, A.BIRTH_DATE,  B.ROOM_NAME 
  from RES_CUSTOMER A
  inner join RES_HTL_ROOM_DETAIL B
  on A.RES_CODE = @RES_CODE
  and A.RES_CODE = B.RES_CODE 
END





GO
