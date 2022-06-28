USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_PUB_MENU_SELECT
■ DESCRIPTION				: 메뉴 검색
■ INPUT PARAMETER			: 
	@SITE_CODE				: 사이트코드
	@MENU_CODE				: 메뉴코드
	@REAL_YN				: 실서버 유무
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_PUB_MENU_SELECT 'VGT', '102', 'N'

	SELECT * FROM MNU_MASTER WHERE MENU_CODE IN ('10101030101','101010301','1010103','10101','101')

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-02		김성호			최초생성
   2013-06-10		김성호			WITH(NOLOCK) 추가
   2015-09-17		박형만			중복으로 나오는 버그 수정 
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_PUB_MENU_SELECT]
(
	@SITE_CODE	VARCHAR(3),
	@MENU_CODE	VARCHAR(20),
	@REAL_YN	VARCHAR(1)
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

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
		 WHERE A.SITE_CODE = @SITE_CODE AND A.MENU_CODE = @MENU_CODE
	)
	SELECT
		A.MENU_CODE, A.PARENT_CODE, A.MENU_NAME, A.LINK_URL, A.FONT_COLOR, A.ORDER_NUM, A.USE_YN, A.NEW_CODE, A.NEW_DATE, A.EDT_CODE, A.EDT_DATE, A.BASIC_CODE,
		A.FONT_STYLE, A.IMAGE_URL, A.[LEVEL], 
		B.CITY_CODE, B.NATION_CODE, B.GROUP_CODE, B.ATT_CODE, B.CATEGORY_TYPE, B.VIEW_TYPE, B.ORDER_TYPE, B.BEST_CODE,
		---- 현재 항목에 지역코드가 있으면 자기걸 쓰고 없으면 1레벨 지역 코드를 쓴다.
		(CASE WHEN ISNULL(A.REGION_CODE, '''') <> '''' THEN A.REGION_CODE ELSE C.REGION_CODE END) AS [REGION_CODE]
	FROM LIST A
	LEFT JOIN ' + @TABLE_NAME + N' B WITH(NOLOCK) ON A.SITE_CODE = B.SITE_CODE AND B.MENU_CODE = (CASE WHEN A.BASIC_CODE > 0 THEN A.BASIC_CODE ELSE A.MENU_CODE END) -- 기준메뉴 값을 가진다.
	LEFT JOIN ' + @TABLE_NAME + N' C WITH(NOLOCK) ON A.SITE_CODE = C.SITE_CODE AND C.MENU_CODE = SUBSTRING(A.MENU_CODE, 1, 5) -- 항상 1레벨의 값을 가진다.
	WHERE A.USE_YN = ''Y''
	ORDER BY A.PARENT_CODE, A.ORDER_NUM'

	SET @PARMDEFINITION = N'
		@SITE_CODE VARCHAR(3),
		@MENU_CODE VARCHAR(20)';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@SITE_CODE,
		@MENU_CODE;

END

GO
