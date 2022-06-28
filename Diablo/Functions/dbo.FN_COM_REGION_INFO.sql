USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_COM_REGION_INFO
■ Description				: 고객사 지역구분 정보 검색
■ Input Parameter			: 

	@AGT_CODE VARCHAR(10)	: 거래처코드
	@CODES VARCHAR(100)		: 지역순번

■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 

	SELECT * FROM DBO.FN_COM_REGION_INFO('92756', 0)	-- 리스트 전체

	SELECT * FROM DBO.FN_COM_REGION_INFO('92756', 4)	-- 4번 지역값

---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2016-03-14		김성호			최초생성
-------------------------------------------------------------------------------------------------*/ 
create FUNCTION [dbo].[FN_COM_REGION_INFO]
(	
	@AGT_CODE			VARCHAR(10),
	@REG_MASTER_SEQ		VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
	WITH MASTER_LIST AS
	(
		SELECT A.AGT_CODE, A.REG_MASTER_SEQ, A.REGION_NAME, A.ALL_YN, A.USE_YN
		FROM COM_REGION_MASTER A WITH(NOLOCK)
		WHERE A.AGT_CODE = @AGT_CODE AND ((@REG_MASTER_SEQ = 0 AND A.USE_YN = 'Y') OR A.REG_MASTER_SEQ = @REG_MASTER_SEQ)
	), DETAIL_LIST AS
	(
		SELECT A.*, B.REG_DETAIL_SEQ, B.REG_TYPE, B.REG_CODE
		FROM MASTER_LIST A
		INNER JOIN COM_REGION_DETAIL B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.REG_MASTER_SEQ = B.REG_MASTER_SEQ
		WHERE A.ALL_YN = 'N' AND B.USE_YN = 'Y'
	)
	SELECT AGT_CODE, REG_MASTER_SEQ, USE_YN, REGION_LIST
	FROM (
		SELECT A.AGT_CODE, A.REG_MASTER_SEQ, B.USE_YN, SUBSTRING((MAX(REGION) + MAX(NATION) + MAX(CITY)), 2, 100) AS [REGION_LIST]
		FROM
		(
			SELECT A.AGT_CODE, A.REG_MASTER_SEQ, ',전지역' AS [REGION], '' AS [NATION], '' AS [CITY]
			FROM MASTER_LIST A
			WHERE A.ALL_YN = 'Y'
			UNION ALL
			SELECT A.AGT_CODE, A.REG_MASTER_SEQ, (
				SELECT (',' + KOR_NAME) AS [text()] 
				FROM DETAIL_LIST AA
				INNER JOIN PUB_REGION BB WITH(NOLOCK) ON AA.REG_MASTER_SEQ = A.REG_MASTER_SEQ AND AA.REG_CODE = BB.REGION_CODE
				WHERE AA.REG_TYPE = 'R' FOR XML PATH('')), '', ''
			FROM MASTER_LIST A
			UNION ALL
			SELECT A.AGT_CODE, A.REG_MASTER_SEQ, '', (
				SELECT (',' + KOR_NAME) AS [text()] 
				FROM DETAIL_LIST AA
				INNER JOIN PUB_NATION BB WITH(NOLOCK) ON AA.REG_MASTER_SEQ = A.REG_MASTER_SEQ AND AA.REG_CODE = BB.NATION_CODE
				WHERE AA.REG_TYPE = 'N' FOR XML PATH('')), ''
			FROM MASTER_LIST A
			UNION ALL
			SELECT A.AGT_CODE, A.REG_MASTER_SEQ, '', '', (
				SELECT (',' + KOR_NAME) AS [text()] 
				FROM DETAIL_LIST AA
				INNER JOIN PUB_CITY BB WITH(NOLOCK) ON AA.REG_MASTER_SEQ = A.REG_MASTER_SEQ AND AA.REG_CODE = BB.CITY_CODE
				WHERE AA.REG_TYPE = 'C' FOR XML PATH('')) AS [CITY_NAME]
			FROM MASTER_LIST A
		) A
		LEFT JOIN MASTER_LIST B ON A.AGT_CODE = B.AGT_CODE AND A.REG_MASTER_SEQ = B.REG_MASTER_SEQ
		GROUP BY A.AGT_CODE, A.REG_MASTER_SEQ, B.USE_YN
	) REGION_MAST
)

GO
