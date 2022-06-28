USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CUS_ASCALL_SELECT
■ DESCRIPTION				: AS CALL 조회 ( 일주일 단위 픽스 )
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	SP_CUS_ASCALL_SELECT '2014-08-09', '2014-08-10'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-08-11		정지용
   2015-10-12		정지용			판매업체, 판매직원, 유입처 추가
   2017-03-29		박형만			하루씩 조회 안되는 현상 수정
   2017-07-21		김성호			예약자 포함되도록 수정
   2017-07-24		박형만			담당자 이름 나오도록 수정 
   2017-08-11		박형만			패널티(3) 제외 
   2017-08-17		박형만			환불(7) 제외
   2018-03-26		김성호			생년월일 추가
   2018-11-13		김남훈			비회원 카운트 제외
================================================================================================================*/ 
CREATE PROC [dbo].[SP_CUS_ASCALL_SELECT]
	@START_DATE DATETIME,
	@END_DATE DATETIME
AS 
BEGIN	

--DECLARE @START_DATE DATETIME,
--@END_DATE DATETIME
--SELECT @START_DATE = '2017-01-06' , @END_DATE  ='20173-01-06' 

	-- 조회 종료일 +1 일 
	SET @END_DATE = DATEADD(DD ,1,@END_DATE );

	WITH RES_LIST AS
	(
		SELECT A.PRO_CODE, A.RES_CODE, A.PRO_NAME, A.DEP_DATE, A.ARR_DATE, A.RES_NAME, A.RES_EMAIL
			, A.NOR_TEL1, A.NOR_TEL2, A.NOR_TEL3, A.PROFIT_TEAM_NAME, A.PROVIDER, A.CUS_NO
			, (CASE A.PRO_TYPE WHEN 1 THEN '행사' WHEN 2 THEN '항공' WHEN 3 THEN '호텔' END) AS [PRO_TYPE]
			, ( SELECT TOP 1 PUB_VALUE FROM COD_PUBLIC WHERE PUB_TYPE = 'RES.AGENT.TYPE'  AND  PUB_CODE =  A.PROVIDER ) AS [PUB_VALUE]
			, (SELECT KOR_NAME FROM AGT_MASTER WITH(NOLOCK) WHERE AGT_CODE = A.SALE_COM_CODE) AS SALE_COM_KOR_NAME
			, DBO.FN_CUS_GET_EMP_NAME(A.SALE_EMP_CODE) AS SALE_EMP_NAME
			, (SELECT KOR_NAME FROM EMP_MASTER_DAMO WHERE EMP_CODE = A.NEW_CODE) AS KOR_NAME -- NEW_CODE 담당자 
		FROM RES_MASTER_damo A WITH(NOLOCK)
		WHERE A.ARR_DATE >= @START_DATE AND A.ARR_DATE < @END_DATE AND A.RES_STATE < 7
			AND (A.NOR_TEL1 IS NOT NULL AND A.NOR_TEL2 IS NOT NULL AND A.NOR_TEL3 IS NOT NULL)
	), CUS_LIST AS
	(
		SELECT A.PRO_CODE, A.RES_CODE, 0 AS [SEQ_NO], A.PRO_NAME, A.DEP_DATE, A.ARR_DATE, A.PRO_TYPE, A.PUB_VALUE
			, A.RES_NAME, A.CUS_NO, '' AS [CUS_NAME], A.PROFIT_TEAM_NAME ,A.KOR_NAME
			, A.SALE_COM_KOR_NAME, A.SALE_EMP_NAME
			, ISNULL(A.RES_EMAIL, B.EMAIL) AS [EMAIL], (
			CASE
				WHEN A.NOR_TEL3 IS NOT NULL THEN A.NOR_TEL1 + '-' + A.NOR_TEL2 + '-' + A.NOR_TEL3
				ELSE B.NOR_TEL1 + '-' + B.NOR_TEL2 + '-' + B.NOR_TEL3
			END) AS [TEL_NUMBER­], CONVERT(VARCHAR(10), B.BIRTH_DATE, 120) AS [BIRTH_DATE]
		FROM RES_LIST A
		INNER JOIN CUS_CUSTOMER_damo B WITH(NOLOCK) ON A.CUS_NO = B.CUS_NO
		UNION ALL
		SELECT A.PRO_CODE, A.RES_CODE, B.SEQ_NO, A.PRO_NAME, A.DEP_DATE, A.ARR_DATE, A.PRO_TYPE, A.PUB_VALUE
			, A.RES_NAME, B.CUS_NO, B.CUS_NAME, A.PROFIT_TEAM_NAME ,A.KOR_NAME
			, A.SALE_COM_KOR_NAME, A.SALE_EMP_NAME
			, ISNULL(B.EMAIL, C.EMAIL), (
				CASE
					WHEN B.NOR_TEL3 IS NOT NULL THEN B.NOR_TEL1 + '-' + B.NOR_TEL2 + '-' + B.NOR_TEL3
					ELSE C.NOR_TEL1 + '-' + C.NOR_TEL2 + '-' + C.NOR_TEL3
				END) AS [TEL_NUMBER­], CONVERT(VARCHAR(10), C.BIRTH_DATE, 120) AS [BIRTH_DATE]
		FROM RES_LIST A
		INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		INNER JOIN CUS_CUSTOMER_damo C WITH(NOLOCK) ON B.CUS_NO = C.CUS_NO
		WHERE B.RES_STATE IN (0)
			AND ((B.NOR_TEL1 IS NOT NULL AND B.NOR_TEL2 IS NOT NULL AND B.NOR_TEL3 IS NOT NULL) OR (C.NOR_TEL1 IS NOT NULL AND C.NOR_TEL2 IS NOT NULL AND C.NOR_TEL3 IS NOT NULL))
	)
	SELECT A.*, (
		SELECT COUNT(*)
		FROM RES_MASTER_damo AA WITH(NOLOCK)
		INNER JOIN RES_CUSTOMER_damo BB WITH(NOLOCK) ON AA.RES_CODE = BB.RES_CODE 
		WHERE AA.RES_STATE < 7 AND BB.RES_STATE = 0 AND BB.CUS_NO = A.CUS_NO
		AND A.CUS_NO <> '1'
	) AS [TRAVEL_CNT]
	FROM CUS_LIST A
	ORDER BY A.PRO_CODE, A.RES_CODE, A.SEQ_NO

	/*
	WITH LIST AS
	(
		SELECT A.PRO_CODE AS [PRO_CODE], A.RES_CODE AS [RES_CODE], A.PRO_NAME AS [PRO_NAME]
			, C.DEP_DATE AS [DEP_DATE], C.ARR_DATE AS [ARR_DATE]
			, (CASE A.PRO_TYPE WHEN 1 THEN '행사' WHEN 2 THEN '항공' WHEN 3 THEN '호텔' END) AS [PRO_TYPE]
			--, D.PUB_VALUE AS [PUB_VALUE]
			, ( SELECT TOP 1 PUB_VALUE FROM COD_PUBLIC WHERE PUB_TYPE = 'RES.AGENT.TYPE'  AND  PUB_CODE =  A.PROVIDER ) AS [PUB_VALUE]
			, A.RES_NAME, B.CUS_NAME AS [CUS_NAME]
			, (
				CASE
					WHEN B.NOR_TEL3 IS NOT NULL THEN B.NOR_TEL1 + '-' + B.NOR_TEL2 + '-' + B.NOR_TEL3
					ELSE F.NOR_TEL1 + '-' + F.NOR_TEL2 + '-' + F.NOR_TEL3
				END) AS [TEL_NUMBER­]
			, ISNULL(B.EMAIL, F.EMAIL) AS [EMAIL], A.PROFIT_TEAM_NAME AS [PROFIT_TEAM_NAME­], E.KOR_NAME AS [KOR_NAME], B.CUS_NO
			, (SELECT KOR_NAME FROM AGT_MASTER WITH(NOLOCK) WHERE AGT_CODE = A.SALE_COM_CODE) AS SALE_COM_KOR_NAME
			, A.PROVIDER, DBO.FN_CUS_GET_EMP_NAME(SALE_EMP_CODE) AS SALE_EMP_NAME
		FROM RES_MASTER_damo A WITH(NOLOCK)
		INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		INNER JOIN PKG_DETAIL C WITH(NOLOCK) ON A.PRO_CODE = C.PRO_CODE
		--LEFT JOIN COD_PUBLIC D WITH(NOLOCK) ON D.PUB_TYPE = 'RES.AGENT.TYPE' AND A.PROVIDER = D.PUB_CODE
		INNER JOIN EMP_MASTER_damo E WITH(NOLOCK) ON A.NEW_CODE = E.EMP_CODE
		INNER JOIN CUS_CUSTOMER_damo F WITH(NOLOCK) ON B.CUS_NO = F.CUS_NO
		WHERE A.ARR_DATE >= @START_DATE AND A.ARR_DATE < @END_DATE
			AND A.RES_STATE <= 7 AND B.RES_STATE IN (0, 3)
			AND ((B.NOR_TEL1 IS NOT NULL AND B.NOR_TEL2 IS NOT NULL AND B.NOR_TEL3 IS NOT NULL) OR (F.NOR_TEL1 IS NOT NULL AND F.NOR_TEL2 IS NOT NULL AND F.NOR_TEL3 IS NOT NULL))
	)
	SELECT A.*, (
		SELECT COUNT(*)
		FROM RES_MASTER_damo AA WITH(NOLOCK)
		INNER JOIN RES_CUSTOMER_damo BB WITH(NOLOCK) ON AA.RES_CODE = BB.RES_CODE 
		WHERE AA.RES_STATE <= 7 AND BB.RES_STATE = 0 AND BB.CUS_NO = A.CUS_NO
	) AS [TRAVEL_CNT]
	FROM LIST A
	ORDER BY A.PRO_CODE, A.RES_CODE
	*/

END 


GO
