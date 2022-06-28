USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ARG_DETAIL_SELECT
■ DESCRIPTION				: 수배현황 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

exec XP_ARG_DETAIL_SELECT @ARG_CODE='A141111-0099',@GRP_SEQ_NO=3

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-22		이규식			최초생성
   2014-03-27		박형만			기존쿼리로 재생성
   2014-04-01		박형만			행사정보 추가 
   2014-04-07		박형만			출발자 건수 ARG_CUSTOMER 에서  가져옴 
   2014-11-17		정지용			NOT EXISTS에 Count(*) -> TOP 1 ARG_CODE로 변경 / 교통편 관련 정보 추가
   2014-12-05		정지용			(LAST_ARG_STATUS) 문서마지막 상태값 추가 (중복인보이스 확정을막기위해)
   2014-12-09		정지용			출발자 SORT 변경
   2015-03-03		김성호			주민번호 삭제, 생년월일 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_DETAIL_SELECT]
 	@ARG_CODE		VARCHAR(12),
	@GRP_SEQ_NO		int  -- 0 일경우 요청된 가장최근걸 가져옴 
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	-- 수배상세 & 랜드사 정보 & 전자결제 상태 
	SELECT TOP 1 
		A.ARG_CODE, A.GRP_SEQ_NO, A.PAR_GRP_SEQ_NO, A.TITLE, A.CONTENT, A.ARG_TYPE, A.ARG_STATUS, 
		(SELECT TOP 1 ARG_STATUS FROM ARG_DETAIL WHERE  ARG_CODE = A.ARG_CODE AND PAR_GRP_SEQ_NO = A.GRP_SEQ_NO)  AS LAST_ARG_STATUS,
		A.DEP_DATE, A.ARR_DATE , A.NIGHTS , A.DAY , 
		A.CFM_CODE, A.CFM_DATE, A.NEW_DATE, A.NEW_CODE, A.EDT_DATE, A.EDT_CODE ,
		B.PRO_CODE,	

		--A.ADT_COUNT, A.CHD_COUNT, A.INF_COUNT, A.FOC_COUNT, 
		--A.ADT_COUNT +A.CHD_COUNT+A.INF_COUNT+A.FOC_COUNT  AS TOT_COUNT,
		-- 수배확정서 등록모드 @GRP_SEQ_NO =0 
		-- 행사 없는 수배상세 조회시 
		-- 인보이스는  ARG_DETAIL 에서 조회 
		-- 그외 수배요청,수배확정에서는 ARG_CUSTOMER 에서 조회  
		CASE WHEN @GRP_SEQ_NO = 0 OR ISNULL(B.PRO_CODE,'') ='' OR A.ARG_TYPE IN (3,4) OR C1.GRP_SEQ_NO IS NULL  THEN A.ADT_COUNT ELSE C1.ADT_COUNT END AS ADT_COUNT , 
		CASE WHEN @GRP_SEQ_NO = 0 OR ISNULL(B.PRO_CODE,'') ='' OR A.ARG_TYPE IN (3,4) OR C1.GRP_SEQ_NO IS NULL THEN A.CHD_COUNT ELSE C1.CHD_COUNT END AS CHD_COUNT , 
		CASE WHEN @GRP_SEQ_NO = 0 OR ISNULL(B.PRO_CODE,'') ='' OR A.ARG_TYPE IN (3,4) OR C1.GRP_SEQ_NO IS NULL THEN A.INF_COUNT ELSE C1.INF_COUNT END AS INF_COUNT , 
		A.FOC_COUNT ,
		CASE WHEN @GRP_SEQ_NO = 0 OR ISNULL(B.PRO_CODE,'') ='' THEN A.ADT_COUNT +A.CHD_COUNT+A.INF_COUNT+A.FOC_COUNT
			ELSE  C1.ADT_COUNT +C1.CHD_COUNT+C1.INF_COUNT +A.FOC_COUNT   END AS TOT_COUNT , 

		DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME,
		DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS NEW_TEAM_NAME,
		DBO.XN_COM_GET_EMP_NAME(A.CFM_CODE) AS CFM_NAME,
		DBO.XN_COM_GET_TEAM_NAME(A.CFM_CODE) AS CFM_TEAM_NAME,
		B.AGT_CODE,
		E.KOR_NAME AS AGT_NAME,
		E.ADDRESS1,
		E.ADDRESS2,
		E.NOR_TEL1,
		E.NOR_TEL2,
		E.NOR_TEL3,
		E.FAX_TEL1,
		E.FAX_TEL2,
		E.FAX_TEL3,
		E.AGT_CONDITION,
		E.AGT_ITEM,
		E.AGT_REGISTER,
		E.CEO_NAME,
		D.DOC_YN , 
		D.EDI_CODE ,
		CASE WHEN EXISTS (SELECT TOP 1 PRO_CODE FROM SET_MASTER WHERE PRO_CODE = B.PRO_CODE ) THEN 'Y' ELSE 'N' END AS SET_MASTER_YN 
		--'N' AS SET_MASTER_YN
	FROM ARG_DETAIL A WITH(NOLOCK) 
	INNER JOIN ARG_MASTER B WITH(NOLOCK) ON A.ARG_CODE = B.ARG_CODE
	LEFT JOIN ARG_INVOICE C WITH(NOLOCK) ON A.ARG_CODE = C.ARG_CODE	AND A.GRP_SEQ_NO = C.GRP_SEQ_NO
	LEFT JOIN SET_LAND_AGENT D WITH(NOLOCK) ON C.LAND_SEQ_NO = D.LAND_SEQ_NO AND B.PRO_CODE = D.PRO_CODE		
	LEFT JOIN AGT_MASTER E WITH(NOLOCK) ON B.AGT_CODE = E.AGT_CODE
	--LEFT JOIN AGT_MASTER E WITH(NOLOCK) ON B.AGT_CODE = E.AGT_CODE
	--LEFT JOIN PKG_DETAIL F WITH(NOLOCK) ON B.PRO_CODE = F.PRO_CODE 
	--LEFT JOIN EMP_MASTER G WITH(NOLOCK) ON F.NEW_CODE = G.EMP_CODE 

	LEFT JOIN 
	(
		SELECT
			A.ARG_CODE,
			B.GRP_SEQ_NO ,
			SUM(CASE WHEN A.AGE_TYPE = 0 THEN 1 ELSE 0 END ) ADT_COUNT, 
			SUM(CASE WHEN A.AGE_TYPE = 1 THEN 1 ELSE 0 END ) CHD_COUNT, 
			SUM(CASE WHEN A.AGE_TYPE = 2 THEN 1 ELSE 0 END ) INF_COUNT, 
			SUM(1) TOTAL_COUNT  
		FROM  ARG_CUSTOMER A 
			INNER JOIN ARG_DETAIL B
				ON A.ARG_CODE = B.ARG_CODE 
			INNER JOIN ARG_CONNECT C
				ON A.ARG_CODE = C.ARG_CODE 
				AND B.GRP_SEQ_NO = C.GRP_SEQ_NO 
				AND A.CUS_SEQ_NO = C.CUS_SEQ_NO 
				--AND C.GRP_SEQ_NO = ( SELECT MAX(GRP_SEQ_NO) FROM ARG_CONNECT WHERE ARG_CODE = C.ARG_CODE  AND CUS_SEQ_NO = C.CUS_SEQ_NO ) 
		WHERE A.ARG_CODE = @ARG_CODE
		AND B.GRP_SEQ_NO = @GRP_SEQ_NO  --OR @GRP_SEQ_NO = 0 ) 
		GROUP BY  A.ARG_CODE ,B.GRP_SEQ_NO --,A.AGE_TYPE 
	)  C1
		ON A.ARG_CODE = C1.ARG_CODE 
		AND A.GRP_SEQ_NO = C1.GRP_SEQ_NO
	
	WHERE A.ARG_CODE = @ARG_CODE 
	AND (A.GRP_SEQ_NO = @GRP_SEQ_NO OR @GRP_SEQ_NO = 0 )
	ORDER BY A.GRP_SEQ_NO DESC 
	
	---- 확정명단
	--SELECT 
	--*,
	--DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME,
	--DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS NEW_TEAM_NAME,
	--COUNT(ISNULL(A.RES_CODE, 0)) OVER(PARTITION BY ISNULL(A.RES_CODE, 0)) AS RSNum,
	--ISNULL(B.ROOMING, 'A') AS ResRoom
	--FROM ARG_CUSTOMER A WITH(NOLOCK)
	--LEFT JOIN RES_CUSTOMER B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE AND A.SEQ_NO = B.SEQ_NO
	--WHERE ARG_SEQ_NO = @ARG_SEQ_NO AND GRP_SEQ_NO = @GRP_SEQ_NO
	--ORDER BY CUS_SEQ_NO ASC
	SELECT
		ROW_NUMBER() OVER( ORDER BY A.CUS_SEQ_NO ) AS ROW_NUM,
		D.PRO_CODE, D.AGT_CODE , C.ARG_CODE , B.ARG_TYPE, C.GRP_SEQ_NO , 
		A.CUS_SEQ_NO,A.RES_CODE,A.SEQ_NO,A.ARG_STATUS,
		A.CUS_NAME,A.LAST_NAME,A.FIRST_NAME,A.AGE_TYPE,A.GENDER,A.BIRTH_DATE,A.EMAIL,A.CELLPHONE,A.PASS_NUM,A.PASS_EXPIRE,
		A.ROOMING,A.ETC_REMAKR,A.NEW_CODE,A.NEW_DATE,A.EDT_DATE,A.EDT_CODE ,
		CASE WHEN ISDATE(A.BIRTH_DATE) = 1 THEN  
			dbo.FN_CUS_GET_AGE(CONVERT(DATETIME,A.BIRTH_DATE) ,B.DEP_DATE ) 
		ELSE 0 END AS AGE ,
		DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME,
		DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS NEW_TEAM_NAME
	FROM  ARG_CUSTOMER A 
		INNER JOIN ARG_DETAIL B
			ON A.ARG_CODE = B.ARG_CODE 
		INNER JOIN ARG_CONNECT C
			ON A.ARG_CODE = C.ARG_CODE 
			AND B.GRP_SEQ_NO = C.GRP_SEQ_NO 
			AND A.CUS_SEQ_NO = C.CUS_SEQ_NO 
			--AND C.GRP_SEQ_NO = ( SELECT MAX(GRP_SEQ_NO) FROM ARG_CONNECT WHERE ARG_CODE = C.ARG_CODE  AND CUS_SEQ_NO = C.CUS_SEQ_NO ) 
		INNER JOIN ARG_MASTER D 
			ON A.ARG_CODE = D.ARG_CODE
	WHERE A.ARG_CODE = @ARG_CODE
	AND (B.GRP_SEQ_NO = @GRP_SEQ_NO OR @GRP_SEQ_NO = 0 )
	--AND (A.ARG_STATUS = @ARG_STATUS OR @ARG_STATUS = 0 )  --확정상태?? 
	ORDER BY RES_CODE ASC, SEQ_NO ASC

	-- 파일목록 
	SELECT * FROM ARG_FILE A 
	WHERE A.ARG_CODE = @ARG_CODE
	AND A.GRP_SEQ_NO = @GRP_SEQ_NO		

	-- 인보이스
	IF NOT EXISTS 
		(SELECT TOP 1 ARG_CODE FROM ARG_INVOICE WITH(NOLOCK) WHERE ARG_CODE = @ARG_CODE AND GRP_SEQ_NO = @GRP_SEQ_NO) 
	BEGIN
		SELECT
		'' AS ARG_SEQ_NO
		,'' AS GRP_SEQ_NO
		,'' AS NEW_CODE
		,'' AS NEW_DATE
		,'' AS CURRENCY
		,'' AS EXH_RATE
		,(SELECT TOP 1  /*'[' + (D.DEP_TRANS_CODE + D.DEP_TRANS_NUMBER) + ']' AS DEP_TRANS_NAME*/
			--D.DEP_DEP_AIRPORT_CODE + ' > ' + D.DEP_ARR_AIRPORT_CODE + ' [' + (D.DEP_TRANS_CODE + RTRIM(D.DEP_TRANS_NUMBER)) + '] / ' + 
			--D.ARR_DEP_AIRPORT_CODE + ' > ' + D.ARR_ARR_AIRPORT_CODE + ' [' + (D.ARR_TRANS_CODE + RTRIM(D.ARR_TRANS_NUMBER)) + ']'
			(D.DEP_TRANS_CODE + RTRIM(D.DEP_TRANS_NUMBER)) + ' > ' + (D.ARR_TRANS_CODE + RTRIM(D.ARR_TRANS_NUMBER))
			FROM PKG_DETAIL A WITH(NOLOCK)
			INNER JOIN ARG_MASTER B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE 
			LEFT JOIN PRO_TRANS_SEAT  D WITH(NOLOCK) ON A.SEAT_CODE = D.SEAT_CODE
			LEFT JOIN PUB_AIRLINE  E WITH(NOLOCK) ON D.DEP_TRANS_CODE = E.AIRLINE_CODE
			WHERE B.ARG_CODE = @ARG_CODE) AS AIRLINE
		,(SELECT TOP 1 A.STAY_INFO 
			FROM PKG_DETAIL_PRICE_HOTEL A WITH(NOLOCK) 
			INNER JOIN ARG_MASTER B WITH(NOLOCK) ON (A.PRO_CODE = B.PRO_CODE /*AND A.PRICE_SEQ = '1'*/ AND A.DAY_NUMBER = '1')
			WHERE B.ARG_CODE = @ARG_CODE) AS HOTEL
		,'' AS CONTENT
		,'' AS ACC_NAME
		,'' AS REG_NAME
		,'' AS REG_NUMBER
		,'' AS HOPE_PAYDATE
		,'' AS NEW_NAME
		,'' AS NEW_TEAM_NAME
	END
	ELSE
	BEGIN
		SELECT
		A.*,
		DBO.XN_COM_GET_EMP_NAME(B.NEW_CODE) AS NEW_NAME,
		DBO.XN_COM_GET_TEAM_NAME(B.NEW_CODE) AS NEW_TEAM_NAME
		FROM ARG_INVOICE A WITH(NOLOCK)
			INNER JOIN ARG_DETAIL B WITH(NOLOCK)
				ON A.ARG_CODE = B.ARG_CODE 
				AND A.GRP_SEQ_NO = B.GRP_SEQ_NO 
		WHERE A.ARG_CODE = @ARG_CODE AND A.GRP_SEQ_NO = @GRP_SEQ_NO
	END

	-- 인보이스 세부항목
	IF  EXISTS (SELECT * FROM ARG_INVOICE_DETAIL WITH(NOLOCK) 
		WHERE ARG_CODE = @ARG_CODE AND GRP_SEQ_NO = @GRP_SEQ_NO )  
	AND
		EXISTS (SELECT *
			FROM ARG_INVOICE_DETAIL A WITH(NOLOCK)
			INNER JOIN ARG_INVOICE_ITEM B WITH(NOLOCK) ON A.INV_SEQ_NO = B.INV_SEQ_NO
			WHERE ARG_CODE = @ARG_CODE
			  AND GRP_SEQ_NO = @GRP_SEQ_NO) 
	BEGIN
		SELECT
		A.*,
		B.TITLE -- ,
		--DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME,
		--DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS NEW_TEAM_NAME
		FROM ARG_INVOICE_DETAIL A WITH(NOLOCK)
		INNER JOIN ARG_INVOICE_ITEM B WITH(NOLOCK) ON A.INV_SEQ_NO = B.INV_SEQ_NO
		WHERE ARG_CODE = @ARG_CODE
		  AND GRP_SEQ_NO = @GRP_SEQ_NO
	END
	ELSE
	BEGIN
		SELECT 
				A.INV_SEQ_NO 
				,A.TITLE 
				, @ARG_CODE AS  ARG_SEQ_NO                    --  
				, @GRP_SEQ_NO AS  GRP_SEQ_NO                 --  
				--, 0 AS  ARG_SEQ_NO                    --  
				--, 0 AS  GRP_SEQ_NO                 --  
				, 0 AS ADT_PRICE                      --  
				, 0 AS CHD_PRICE                      --  
				, 0 AS INF_PRICE                      --  
				, 0 AS FOC                            --  
				, '' AS NEW_CODE                       --  
				, GETDATE() AS NEW_DATE                       --  
		FROM ARG_INVOICE_ITEM A WITH(NOLOCK)
		--INNER JOIN ARG_INVOICE_DETAIL B ON A.SEQ_NO = B.INV_SEQ_NO
		ORDER BY A.INV_SEQ_NO
	END
END 

GO