USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ERP_CUSTOMER_RESERVE_LIST_SELECT
■ DESCRIPTION				: ERP 고객정보 최근예약 목록 검색
■ INPUT PARAMETER			: 
	@CUS_NO					: 고객NO
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec cti.SP_CTI_ERP_CUSTOMER_RESERVE_LIST_SELECT 15

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-18		곽병삼			최초생성
   2014-10-22		박형만			최근예약 리스트에만 필요한 정보로 수정 됨 
   2014-10-27		박형만			예약/출발자타입 수정 
   2014-11-27		박형만			호텔예약 나오도록 PKG_MASTER INNER JOIN -> LEFT JOIN 으로 변경  
   2014-12-16		박형만			최근1년이내 조회조건 제외.   
   2018-11-29		김남훈			최근2년이내 조회조건 생성.   
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ERP_CUSTOMER_RESERVE_LIST_SELECT]
--DECLARE
	@CUS_NO	INT
AS
SET NOCOUNT ON;


--DECLARE @CUS_NO	INT
--SET @CUS_NO = 6862089 ;
	
	--DECLARE @MEM_YN VARCHAR(1)  --정회원 여부 
 --	--회원정보 조회 
	--IF EXISTS ( SELECT * FROM Diablo.DBO.CUS_MEMBER  WITH(NOLOCK) WHERE CUS_NO = @CUS_NO AND CUS_STATE = 'Y'  )
	--BEGIN
	--	--정회원
	--	SET @MEM_YN = 'Y' 
	--END 
	--ELSE 
	--BEGIN
	--	--비회원
	--	SET @MEM_YN = 'N' 
	--END 

	
	--회원의 예약자+출발자(예약자일시제외) 정보 조회 
	WITH CUS_RES_LIST AS
	(
		SELECT RES_STATE , DEP_DATE  , PRO_TYPE , RES_CODE , NEW_DATE , RES_NAME , 
			COUNT(CUS_NO) AS RES_CUS_CNT , MAX(MASTER_YN) AS MASTER_YN 
		FROM ( 
			--예약,
			SELECT A.RES_STATE, A.DEP_DATE, A.PRO_TYPE , A.RES_CODE , A.NEW_DATE ,A.CUS_NO, 'Y' AS MASTER_YN , RES_NAME AS RES_NAME FROM Diablo.DBO.RES_MASTER_damo A WITH(NOLOCK) 
			WHERE CUS_NO = @CUS_NO  --AND (@PRO_TYPE IN(0,9) OR PRO_TYPE = @PRO_TYPE)
			AND A.DEP_DATE > DATEADD(YY,-2,GETDATE())
			--AND ( ( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) --비회원 출발일 30일 지난것은 표시 안함  
			--	OR( @MEM_YN = 'Y' AND A.DEP_DATE > DATEADD(YY,-1,GETDATE()) ) ) --정회원 출발일 1년 지난것은 표시 안함  
			--AND A.VIEW_YN ='Y' --노출여부
			AND A.RES_STATE NOT IN ( 7,8,9 )  -- 진행중인 예약만 
			UNION ALL 
			SELECT A.RES_STATE, A.DEP_DATE, A.PRO_TYPE , A.RES_CODE , A.NEW_DATE , A.CUS_NO, 'N' AS MASTER_YN , RES_NAME AS RES_NAME FROM Diablo.DBO.RES_MASTER_damo A WITH(NOLOCK) 
				INNER JOIN Diablo.DBO.RES_CUSTOMER_DAMO B WITH(NOLOCK) 
					ON A.RES_CODE = B.RES_CODE 
					--AND A.CUS_NO  <> B.CUS_NO
			WHERE B.CUS_NO = @CUS_NO  
			--AND (@PRO_TYPE IN(0,9) OR PRO_TYPE = @PRO_TYPE)
			AND B.RES_STATE = 0  --정상출발자만 
			AND (A.DEP_DATE > DATEADD(YY,-2,GETDATE())) -- CTI 예약정보 너무 느려져서 1년 조건 다시.
			--AND ( ( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) --비회원 출발일 30일 지난것은 표시 안함
			--	OR( @MEM_YN = 'Y' AND A.DEP_DATE > DATEADd(YY,-1,GETDATE()) ) ) --정회원 출발일 1년 지난것은 표시 안함   
			--AND B.VIEW_YN ='Y' --노출여부
			AND A.RES_STATE NOT IN ( 7,8,9 ) -- 진행중인 예약만  
		) TBL 
		GROUP BY  RES_STATE , DEP_DATE  , PRO_TYPE , RES_CODE , NEW_DATE , RES_NAME 

		--ORDER BY 
		--	(CASE WHEN @ORDER_BY = 1 AND TBL.RES_STATE IN(7,8,9) THEN -2 
		--		WHEN @ORDER_BY = 1 AND TBL.DEP_DATE < GETDATE() THEN -1  ELSE 0 END ) DESC , -- @ORDER_BY=1 모바일정렬 , 예약정상-출발일지난것-취소순
		--	(CASE WHEN @ORDER_BY = 1 AND TBL.RES_STATE IN(7,8,9) THEN TBL.NEW_DATE ELSE '2999-01-01' END ) DESC ,--모바일 취소된것은 등록일순
		--	(CASE WHEN @ORDER_BY = 1 THEN TBL.DEP_DATE ELSE '1900-01-01' END) ASC ,   -- @ORDER_BY=1 모바일정렬=출발일순 , 그외는 예약일순
		--	TBL.NEW_DATE DESC  --   예약일순
	)

	SELECT TOP 100
		A.VIEW_YN ,
		Z.MASTER_YN, -- 예약자 여부 
		Z.RES_CUS_CNT, -- 예약.출발 카운트 
		A.PRO_CODE,
		A.RES_CODE,
		A.PRO_NAME,
		A.RES_NAME,
		CASE WHEN A.PRO_TYPE = 1 AND G.DEP_DEP_TIME IS NOT NULL THEN CONVERT( DATETIME, CONVERT(VARCHAR(10),A.DEP_DATE,120) + ' '+G.DEP_DEP_TIME +':00') 
			WHEN A.PRO_TYPE = 2  THEN (SELECT TOP 1 START_DATE FROM Diablo.DBO.RES_SEGMENT WHERE RES_CODE = A.RES_CODE ORDER BY SEQ_NO ASC )  
			ELSE A.DEP_DATE END AS DEP_DATE ,
		A.RES_STATE,
		A.PRO_TYPE,
		A.PROVIDER,
		B.SIGN_CODE,
		C.KOR_NAME AS SIGN_NAME,
		B.ATT_CODE,
		D.PUB_VALUE AS ATT_NAME,
		(SELECT COUNT(*) FROM Diablo.DBO.RES_CUSTOMER_DAMO WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE AND RES_STATE IN (0, 3)) AS RES_COUNT , 
		A.NEW_TEAM_CODE,
		A.NEW_TEAM_NAME,
		A.NEW_CODE AS NEW_EMP_CODE,
		E.KOR_NAME AS NEW_EMP_NAME,

		CASE WHEN ISNULL(A.NOR_TEL3,'') <> '' THEN ISNULL(A.NOR_TEL1,'') + '-' + ISNULL(A.NOR_TEL2,'') + '-' + ISNULL(A.NOR_TEL3,'') END AS RES_TEL , 
		E.INNER_NUMBER1 + '-' + E.INNER_NUMBER2 +'-' + E.INNER_NUMBER3  AS NEW_EMP_TEL  

	FROM CUS_RES_LIST Z 
		INNER JOIN Diablo.DBO.RES_MASTER_DAMO A WITH(NOLOCK)
			ON Z.RES_CODE = A.RES_CODE 
		LEFT JOIN Diablo.DBO.PKG_MASTER B WITH(NOLOCK) 
			ON A.MASTER_CODE = B.MASTER_CODE 
		LEFT JOIN Diablo.DBO.PUB_REGION C WITH(NOLOCK)
			ON B.SIGN_CODE = C.SIGN
		LEFT JOIN Diablo.DBO.COD_PUBLIC D WITH(NOLOCK)
			ON B.ATT_CODE = D.PUB_CODE AND D.PUB_TYPE = 'PKG.ATTRIBUTE'
		LEFT JOIN Diablo.DBO.EMP_MASTER E WITH(NOLOCK)
			ON A.NEW_CODE = E.EMP_CODE
		LEFT JOIN Diablo.DBO.PKG_DETAIL F WITH(NOLOCK)
			ON A.PRO_CODE = F.PRO_CODE 
		LEFT JOIN Diablo.DBO.PRO_TRANS_SEAT G WITH(NOLOCK)
			ON F.SEAT_CODE = G.SEAT_CODE 
		--INNER JOIN Diablo.DBO.PUB_REGION C WITH(NOLOCK)
	ORDER BY ( CASE WHEN A.DEP_DATE < GETDATE() /*A.RES_STATE IN (3,4,5,6) */  THEN 2 
			WHEN A.DEP_DATE > GETDATE() /* A.RES_STATE IN (0,1,2,3,4) AND */ THEN 1 ELSE 0 END  ) ASC , DEP_DATE DESC 

SET NOCOUNT OFF

GO
