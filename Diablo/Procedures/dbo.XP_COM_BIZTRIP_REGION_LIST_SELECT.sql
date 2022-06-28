USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_REGION_LIST_SELECT
■ DESCRIPTION				: BTMS 출장자 규정 지역 검색
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_COM_BIZTRIP_REGION_LIST_SELECT 92756, Y

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-31		김성호			최초생성
   2016-02-04		정지용			사용유무 검색 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_REGION_LIST_SELECT]
	@AGT_CODE		VARCHAR(10),
	@USE_YN			CHAR(1)
AS 
BEGIN

	WITH MASTER_LIST AS
	(
		SELECT A.AGT_CODE, A.REG_MASTER_SEQ, A.REGION_NAME, A.ALL_YN, A.USE_YN
		FROM COM_REGION_MASTER A WITH(NOLOCK)
		WHERE A.AGT_CODE = @AGT_CODE AND ((@USE_YN = '') OR (@USE_YN <> '' AND A.USE_YN = @USE_YN))
	), DETAIL_LIST AS
	(
		SELECT A.*, B.REG_DETAIL_SEQ, B.REG_TYPE, B.REG_CODE
		FROM MASTER_LIST A
		INNER JOIN COM_REGION_DETAIL B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.REG_MASTER_SEQ = B.REG_MASTER_SEQ
		WHERE A.ALL_YN = 'N' AND B.USE_YN = 'Y'
	)
	SELECT A.AGT_CODE, A.REG_MASTER_SEQ, B.REGION_NAME, B.ALL_YN, B.USE_YN, (MAX(REGION) + MAX(NATION) + MAX(CITY)) AS [REGION_LIST]
	FROM (
		SELECT A.AGT_CODE, A.REG_MASTER_SEQ, '전지역 ' AS [REGION], '' AS [NATION], '' AS [CITY]
		FROM MASTER_LIST A
		WHERE A.ALL_YN = 'Y'
		UNION ALL
		SELECT A.AGT_CODE, A.REG_MASTER_SEQ, (
			SELECT (KOR_NAME + ',') AS [text()] 
			FROM DETAIL_LIST AA
			INNER JOIN PUB_REGION BB WITH(NOLOCK) ON AA.REG_MASTER_SEQ = A.REG_MASTER_SEQ AND AA.REG_CODE = BB.REGION_CODE
			WHERE AA.REG_TYPE = 'R' FOR XML PATH('')), '', ''
		FROM MASTER_LIST A
		UNION ALL
		SELECT A.AGT_CODE, A.REG_MASTER_SEQ, '', (
			SELECT (KOR_NAME + ',') AS [text()] 
			FROM DETAIL_LIST AA
			INNER JOIN PUB_NATION BB WITH(NOLOCK) ON AA.REG_MASTER_SEQ = A.REG_MASTER_SEQ AND AA.REG_CODE = BB.NATION_CODE
			WHERE AA.REG_TYPE = 'N' FOR XML PATH('')), ''
		FROM MASTER_LIST A
		UNION ALL
		SELECT A.AGT_CODE, A.REG_MASTER_SEQ, '', '', (
			SELECT (KOR_NAME + ',') AS [text()] 
			FROM DETAIL_LIST AA
			INNER JOIN PUB_CITY BB WITH(NOLOCK) ON AA.REG_MASTER_SEQ = A.REG_MASTER_SEQ AND AA.REG_CODE = BB.CITY_CODE
			WHERE AA.REG_TYPE = 'C' FOR XML PATH('')) AS [CITY_NAME]
		FROM MASTER_LIST A
	) A
	INNER JOIN MASTER_LIST B ON A.AGT_CODE = B.AGT_CODE AND A.REG_MASTER_SEQ = B.REG_MASTER_SEQ
	GROUP BY A.AGT_CODE, A.REG_MASTER_SEQ, B.REGION_NAME, B.ALL_YN, B.USE_YN

END
GO
