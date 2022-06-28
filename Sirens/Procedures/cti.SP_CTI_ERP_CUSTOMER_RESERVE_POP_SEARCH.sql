USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ERP_CUSTOMER_RESERVE_POP_SEARCH
■ DESCRIPTION				: ERP 고객정보 예약현황 팝업 검색
■ INPUT PARAMETER			: 
	@CUS_NO					: 고객ID
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec cti.SP_CTI_ERP_CUSTOMER_RESERVE_POP_SEARCH 6780406

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-18		곽병삼			최초생성
   2014-11-07		김성호			고객검색 예약 수와 출발일자 조건값 맞춤
   2014-11-15		김성호			고객의 예약 검색 조건 변경으로 수정
   2014-12-17		곽병삼			예약현황 1년이내 조회조건 제외.
================================================================================================================*/ 

CREATE PROCEDURE [cti].[SP_CTI_ERP_CUSTOMER_RESERVE_POP_SEARCH]
--DECLARE
	@CUS_NO	INT
AS

SET NOCOUNT ON;

WITH LIST AS
(
	-- 출발자 우선(M: 예약자, C: 출발자)
	SELECT A.RES_CODE, A.CUS_NO, MIN(A.FLAG) AS [CUS_TYPE]
	FROM (
		SELECT 'M' AS [FLAG], A.RES_CODE, A.CUS_NO
		FROM Diablo.DBO.RES_MASTER_DAMO A WITH(NOLOCK)
		WHERE A.DEP_DATE > DATEADD(YY, -1, GETDATE())
			AND A.RES_STATE <= 7 AND A.CUS_NO = @CUS_NO
		UNION ALL
		SELECT 'C' AS [FLAG], A.RES_CODE, B.CUS_NO
		FROM Diablo.DBO.RES_MASTER_DAMO A WITH(NOLOCK)
		INNER JOIN Diablo.DBO.RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		WHERE A.RES_STATE <= 7 AND B.RES_STATE = 0 AND B.CUS_NO = @CUS_NO
		--WHERE A.DEP_DATE > DATEADD(YY, -1, GETDATE())
		--	AND A.RES_STATE <= 7 AND B.RES_STATE = 0 AND B.CUS_NO = @CUS_NO
	) A
	GROUP BY A.RES_CODE, A.CUS_NO
)
SELECT
	A.CUS_NO,
	A.RES_CODE,
	A.CUS_TYPE,
	B.RES_STATE,
	B.RES_TYPE,
	B.RES_NAME,
	B.NOR_TEL1 + '-' + B.NOR_TEL2 + '-' + B.NOR_TEL3 AS RES_TEL,
	CONVERT(VARCHAR(10),B.DEP_DATE,120) AS DEP_DT,
	'(' + LEFT(DATENAME(dw,B.DEP_DATE),1) + ')' AS DEP_WEEKDAY,
	SUBSTRING(CONVERT(VARCHAR(16),B.DEP_DATE,120),12,5) AS DEP_TM,
	B.PRO_TYPE,
	B.PRO_CODE,
	B.PRO_NAME,
	B.NEW_CODE,
	C.KOR_NAME AS NEW_NAME
FROM LIST A
INNER JOIN Diablo.DBO.RES_MASTER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
INNER JOIN Diablo.DBO.EMP_MASTER C WITH(NOLOCK) ON B.NEW_CODE = C.EMP_CODE
ORDER BY B.DEP_DATE DESC;

/*
	SELECT
		A.CUS_NO,
		A.RES_STATE,
		A.RES_TYPE,
		A.RES_CODE,
		A.RES_NAME,
		A.NOR_TEL1 + '-' + A.NOR_TEL2 + '-' + A.NOR_TEL3 AS RES_TEL,
		CONVERT(VARCHAR(10),A.DEP_DATE,120) AS DEP_DT,
		'(' + LEFT(DATENAME(dw,A.DEP_DATE),1) + ')' AS DEP_WEEKDAY,
		SUBSTRING(CONVERT(VARCHAR(16),A.DEP_DATE,120),12,5) AS DEP_TM,
		A.PRO_TYPE,
		A.PRO_CODE,
		A.PRO_NAME,
		A.SALE_EMP_CODE,
		B.KOR_NAME AS SALE_EMP_NAME
	FROM Diablo.DBO.RES_MASTER_DAMO A WITH(NOLOCK), Diablo.DBO.EMP_MASTER B WITH(NOLOCK)
	WHERE CUS_NO = @CUS_NO
		AND DEP_DATE > DATEADD(DD, -1, GETDATE())
		--AND DEP_DATE > CAST('2014-10-18' AS DATETIME)
		AND RES_STATE <= 7
		AND A.SALE_EMP_CODE = B.EMP_CODE
	ORDER BY A.RES_CODE DESC
*/

SET NOCOUNT OFF
GO
