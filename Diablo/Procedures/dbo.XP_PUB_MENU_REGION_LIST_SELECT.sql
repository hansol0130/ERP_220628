USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_MENU_REGION_LIST_SELECT
■ DESCRIPTION				: 모바일 지역별 메뉴 검색
■ INPUT PARAMETER			: 
	@SITE_CODE				: 사이트코드
	@GROUP_REGION			: 지역코드
	@GROUP_ATTRIBITE		: 속성코드
	@REAL_YN				: 실서버 유무
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_PUB_MENU_REGION_LIST_SELECT 'VGT', '1', '1', 'N'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-01-26		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_PUB_MENU_REGION_LIST_SELECT]
(
	@SITE_CODE			VARCHAR(3),
	@GROUP_REGION		VARCHAR(1),
	@GROUP_ATTRIBITE	VARCHAR(1),
	@REAL_YN			VARCHAR(1)
)

AS  
BEGIN

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @TABLE_NAME VARCHAR(20);

	IF @REAL_YN = 'N'
		SET @TABLE_NAME = 'MNU_MASTER'
	ELSE
		SET @TABLE_NAME = 'MNU_MASTER_REL'

	SET @SQLSTRING = N'
	WITH LIST AS
	(
		 SELECT A.*, 0 AS [LEVEL]
		 FROM ' + @TABLE_NAME + N' A WITH(NOLOCK)
		 WHERE A.SITE_CODE = @SITE_CODE AND CHARINDEX(@GROUP_REGION, A.GROUP_REGION) > 0 AND CHARINDEX(@GROUP_ATTRIBITE, A.GROUP_ATTRIBUTE) > 0
		 UNION ALL
		 SELECT A.*, B.[LEVEL] + 1
		 FROM ' + @TABLE_NAME + N' A WITH(NOLOCK)
		 INNER JOIN LIST B ON A.SITE_CODE = B.SITE_CODE AND A.PARENT_CODE = B.MENU_CODE
	)
	SELECT
		A.MENU_CODE, A.PARENT_CODE, A.MENU_NAME, A.LINK_URL, A.FONT_COLOR, A.ORDER_NUM, A.USE_YN, A.NEW_CODE, A.NEW_DATE, A.EDT_CODE, A.EDT_DATE, A.BASIC_CODE,
		A.FONT_STYLE, A.IMAGE_URL, A.[LEVEL], 
		B.CITY_CODE, B.NATION_CODE, B.GROUP_CODE, B.ATT_CODE, B.CATEGORY_TYPE, B.VIEW_TYPE, B.ORDER_TYPE, B.BEST_CODE,
		---- 현재 항목에 지역코드가 있으면 자기걸 쓰고 없으면 1레벨 지역 코드를 쓴다.
		(CASE WHEN ISNULL(B.REGION_CODE, '''') <> '''' THEN B.REGION_CODE ELSE C.REGION_CODE END) AS [REGION_CODE]
		--, D.COUNT AS [EVENT_COUNT]
	FROM LIST A
	LEFT JOIN ' + @TABLE_NAME + N' B WITH(NOLOCK) ON A.SITE_CODE = B.SITE_CODE AND B.MENU_CODE = (CASE WHEN A.BASIC_CODE > 0 THEN A.BASIC_CODE ELSE A.MENU_CODE END) -- 기준메뉴 값을 가진다.
	LEFT JOIN ' + @TABLE_NAME + N' C WITH(NOLOCK) ON A.SITE_CODE = C.SITE_CODE AND C.MENU_CODE = SUBSTRING(A.MENU_CODE, 1, 5) -- 항상 1레벨의 값을 가진다.
	
	WHERE A.USE_YN = ''Y''
--	ORDER BY A.PARENT_CODE, A.ORDER_NUM
	ORDER BY A.MENU_CODE, A.ORDER_NUM'

	SET @PARMDEFINITION = N'
		@SITE_CODE VARCHAR(3),
		@GROUP_REGION VARCHAR(1),
		@GROUP_ATTRIBITE VARCHAR(1)';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@SITE_CODE,
		@GROUP_REGION,
		@GROUP_ATTRIBITE

END


GO
