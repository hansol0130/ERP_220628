USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_AFFILIATE_SELECT_LIST
■ DESCRIPTION				: 제휴사 관리 현황 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_PKG_AFFILIATE_SELECT_LIST 'StartDate=2015-01-01&EndDate=2015-03-01&Team='

	EXEC SP_PKG_AFFILIATE_SELECT_LIST 'StartDate=2018-01-01&EndDate=2018-02-01&Team=610'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-11-02		정지용			최초생성
   2016-11-07		이유라			페이징로직삭제
   2017-11-14		정지용			삼성카드 추가
   2018-02-06		박형만			마스터 노출 조건 SHOW_YN = 'Y' 조건 추가 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_AFFILIATE_SELECT_LIST]
	@KEY		VARCHAR(400)
AS 
BEGIN

--DECLARE @KEY		VARCHAR(400)
--SELECT @KEY = 'StartDate=2018-01-01&EndDate=2018-02-01&Team=610' 
	DECLARE @START_DATE VARCHAR(10), @END_DATE VARCHAR(10), @TEAM VARCHAR(500)

	SELECT
		@START_DATE = DBO.FN_PARAM(@KEY, 'StartDate'),
		@END_DATE = DBO.FN_PARAM(@KEY, 'EndDate'),
		@TEAM = DBO.FN_PARAM(@KEY, 'Team');

--SELECT A.MASTER_CODE, A.NEW_CODE, A.PROVIDER, B.MASTER_NAME, C.KOR_NAME, D.TEAM_NAME FROM PKG_MASTER_AFFILIATE A WITH(NOLOCK) 
--	INNER JOIN PKG_MASTER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
--	LEFT JOIN EMP_MASTER C WITH(NOLOCK) ON B.NEW_CODE = C.EMP_CODE
--	LEFT JOIN EMP_TEAM D WITH(NOLOCK) ON C.TEAM_CODE = D.TEAM_CODE
--	WHERE 
--		A.PROVIDER IN  ('15', '17', '29', '30', '31', '34', '21', '19', '14', '37') 
--		AND A.USE_YN = 'Y' 
--		AND (@TEAM = '' OR @TEAM <> '' AND C.TEAM_CODE IN (SELECT DATA FROM DBO.FN_SPLIT(@TEAM, ',')))
--		AND B.SHOW_YN = 'Y' 
	/*
	14:지마켓
	15:신한카드
	17:롯데카드
	19:다음
	21:네이버
	29:현대카드
	30:KB국민카드
	31:11번가
	34:하나카드
	37:삼성카드
	*/	

	WITH LIST  AS (
		SELECT A.MASTER_CODE, A.NEW_CODE, A.PROVIDER, B.MASTER_NAME, C.KOR_NAME, D.TEAM_NAME FROM PKG_MASTER_AFFILIATE A WITH(NOLOCK) 
		INNER JOIN PKG_MASTER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
		LEFT JOIN EMP_MASTER C WITH(NOLOCK) ON B.NEW_CODE = C.EMP_CODE
		LEFT JOIN EMP_TEAM D WITH(NOLOCK) ON C.TEAM_CODE = D.TEAM_CODE
		WHERE 
			A.PROVIDER IN  ('15', '17', '29', '30', '31', '34', '21', '19', '14', '37') 
			AND A.USE_YN = 'Y' 
			AND (@TEAM = '' OR @TEAM <> '' AND C.TEAM_CODE IN (SELECT DATA FROM DBO.FN_SPLIT(@TEAM, ',')))
			AND B.SHOW_YN ='Y'
	) 
	SELECT 
		MASTER_CODE,
		MASTER_NAME,
		TEAM_NAME,
		KOR_NAME,
		ISNULL([지마켓], 'N') AS [AFF_G_MARKET],
		ISNULL([신한카드], 'N') AS [AFF_SH_CARD],
		ISNULL([롯데카드], 'N') AS [AFF_LT_CARD],
		ISNULL([다음], 'N') AS [AFF_DAUM],
		ISNULL([네이버], 'N') AS [AFF_NAVER],
		ISNULL([현대카드], 'N') AS [AFF_HD_CARD],
		ISNULL([KB국민카드], 'N') AS [AFF_KB_CARD],
		ISNULL([11번가], 'N') AS [AFF_ELEVEN_MARKET],
		ISNULL([하나카드], 'N') AS [AFF_HN_CARD],
		ISNULL([삼성카드], 'N') AS [AFF_SC_CARD]
	FROM (
		SELECT 
			A.MASTER_CODE,
			A.MASTER_NAME,
			A.KOR_NAME,
			A.TEAM_NAME,
			CASE 
				WHEN C.PUB_CODE = 14 THEN '지마켓'
				WHEN C.PUB_CODE = 15 THEN '신한카드'
				WHEN C.PUB_CODE = 17 THEN '롯데카드'
				WHEN C.PUB_CODE = 19 THEN '다음'
				WHEN C.PUB_CODE = 21 THEN '네이버'
				WHEN C.PUB_CODE = 29 THEN '현대카드'
				WHEN C.PUB_CODE = 30 THEN 'KB국민카드'
				WHEN C.PUB_CODE = 31 THEN '11번가'
				WHEN C.PUB_CODE = 34 THEN '하나카드'
				WHEN C.PUB_CODE = 37 THEN '삼성카드'
			END AS PUB_CODE,
			CASE 
				WHEN C.PUB_CODE = 14 THEN 'Y'
				WHEN C.PUB_CODE = 15 THEN 'Y'
				WHEN C.PUB_CODE = 17 THEN 'Y'
				WHEN C.PUB_CODE = 19 THEN 'Y'
				WHEN C.PUB_CODE = 21 THEN 'Y'
				WHEN C.PUB_CODE = 29 THEN 'Y'
				WHEN C.PUB_CODE = 30 THEN 'Y'
				WHEN C.PUB_CODE = 31 THEN 'Y'
				WHEN C.PUB_CODE = 34 THEN 'Y'
				WHEN C.PUB_CODE = 37 THEN 'Y'
			ELSE 'N' END AS AFF_NAME
		FROM LIST A
		INNER JOIN PKG_DETAIL B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
		INNER JOIN COD_PUBLIC C WITH(NOLOCK) ON C.PUB_TYPE = 'RES.AGENT.TYPE' AND A.PROVIDER = C.PUB_CODE
		WHERE B.DEP_DATE >= @START_DATE + ' 00:00:00' AND B.DEP_DATE < @END_DATE + ' 23:59:59'
	) AA
	PIVOT
	(
		MIN(AFF_NAME) FOR 
		PUB_CODE IN ([지마켓],[신한카드],[롯데카드],[다음],[네이버],[현대카드],[KB국민카드],[11번가],[하나카드], [삼성카드])
	) PV
	ORDER BY TEAM_NAME, MASTER_CODE

END 





GO
