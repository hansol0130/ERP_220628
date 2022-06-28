USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_GET_MASTER_TRANS_SELECT
■ Description				: 에어텔 출발 항공기 조회
■ Input Parameter			:                  
		@PRO_CODE			: 마스터코드
■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2019-12-09		프리랜서			최초생성
	2020-03-09		김성호			마스터관리 선호항공 등록순으로 노출되도록 수정 
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[FN_GET_MASTER_TRANS_SELECT]
(
	@MASTER_CODE	VARCHAR(10)
)
RETURNS VARCHAR(255)
AS
BEGIN
	
	DECLARE @TMP_MASTER_TRANS TABLE(
		TRANS_CODE		VARCHAR(2)
	,	KOR_NAME		VARCHAR(100)
	,	AIRLINE_TYPE	INT
	,	PREFER_ORDER	INT	
	);

	DECLARE @RETURN_STR		VARCHAR(255)
	,		@RETURN_STR2	VARCHAR(255)
	
	INSERT INTO @TMP_MASTER_TRANS (TRANS_CODE, KOR_NAME, AIRLINE_TYPE, PREFER_ORDER)  
	SELECT T1.DEP_TRANS_CODE, C.KOR_NAME, C.AIRLINE_TYPE, ISNULL(D.ID, 98) AS [PREFER_ID]  
	FROM (
		SELECT B.DEP_TRANS_CODE
		FROM   PKG_DETAIL   A WITH(NOLOCK)  
		INNER JOIN PRO_TRANS_SEAT  B WITH(NOLOCK)  ON  A.SEAT_CODE   =  B.SEAT_CODE  
		WHERE A.MASTER_CODE  =  @MASTER_CODE  
		AND  A.SHOW_YN   =  'Y'  
		AND  A.DEP_DATE   >=  GETDATE()  
		AND  A.TRANSFER_TYPE  =  1  
		GROUP BY B.DEP_TRANS_CODE
	) T1
	INNER JOIN PUB_AIRLINE   C WITH(NOLOCK)  ON  T1.DEP_TRANS_CODE =  C.AIRLINE_CODE  
	LEFT JOIN dbo.FN_SPLIT((SELECT AIRLINE FROM PKG_MASTER WITH(NOLOCK) WHERE MASTER_CODE = @MASTER_CODE), ',') D ON C.AIRLINE_CODE = CONVERT(VARCHAR(2), D.DATA)  
	UNION  
	SELECT T2.DEP_TRANS_CODE, C.KOR_NAME, '99' AS AIRLINE_TYPE, 99  
	FROM (
		SELECT B.DEP_TRANS_CODE
		FROM   PKG_DETAIL   A WITH(NOLOCK)  
		INNER JOIN PRO_TRANS_SEAT  B WITH(NOLOCK)  ON  A.SEAT_CODE   =  B.SEAT_CODE  
		WHERE A.MASTER_CODE  =  @MASTER_CODE  
		AND  A.SHOW_YN   =  'Y'  
		AND  A.DEP_DATE   >=  GETDATE()  
		AND  A.TRANSFER_TYPE  =  2  
		GROUP BY B.DEP_TRANS_CODE 
	) T2
	INNER JOIN PUB_SHIP   C WITH(NOLOCK)  ON  T2.DEP_TRANS_CODE =  C.SHIP_CODE;
	
	
	--SELECT	C.DEP_TRANS_CODE, B.KOR_NAME, B.AIRLINE_TYPE
	--FROM			PKG_DETAIL			A	WITH(NOLOCK)
	--INNER	JOIN	PRO_TRANS_SEAT		C	WITH(NOLOCK)		ON		A.SEAT_CODE			=		C.SEAT_CODE
	--INNER	JOIN	PUB_AIRLINE			B	WITH(NOLOCK)		ON		C.DEP_TRANS_CODE	=		B.AIRLINE_CODE

	--WHERE	A.MASTER_CODE		=		@MASTER_CODE
	--AND		A.SHOW_YN			=		'Y'
	--AND		A.DEP_DATE			>=		GETDATE()
	--AND		A.TRANSFER_TYPE		=		1
	--GROUP BY C.DEP_TRANS_CODE, B.KOR_NAME, B.AIRLINE_TYPE
	--UNION
	--SELECT	C.DEP_TRANS_CODE, B.KOR_NAME, '99' AS AIRLINE_TYPE
	--FROM			PKG_DETAIL			A	WITH(NOLOCK)
	--INNER	JOIN	PRO_TRANS_SEAT		C	WITH(NOLOCK)		ON		A.SEAT_CODE			=		C.SEAT_CODE
	--INNER	JOIN	PUB_SHIP			B	WITH(NOLOCK)		ON		C.DEP_TRANS_CODE	=		B.SHIP_CODE

	--WHERE	A.MASTER_CODE		=		@MASTER_CODE
	--AND		A.SHOW_YN			=		'Y'
	--AND		A.DEP_DATE			>=		GETDATE()
	--AND		A.TRANSFER_TYPE		=		2
	--GROUP BY C.DEP_TRANS_CODE, B.KOR_NAME;

	SELECT @RETURN_STR = (
	SELECT	TOP 1 ISNULL(TRANS_CODE, '') + '|^|' + ISNULL(KOR_NAME, '')
	FROM	@TMP_MASTER_TRANS
	ORDER BY PREFER_ORDER, AIRLINE_TYPE, KOR_NAME)

	SELECT @RETURN_STR2 = ('|^|' + CONVERT(VARCHAR(10), ISNULL(COUNT(TRANS_CODE), 0)))
	FROM	@TMP_MASTER_TRANS

	RETURN ISNULL(@RETURN_STR, '|^|') + ISNULL(@RETURN_STR2, '|^|')

END


GO
