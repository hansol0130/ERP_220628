USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_MENU_RELEASE
■ DESCRIPTION				: 메뉴 배포
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-03		김성호			최초생성
   2013-05-24		김성호			MENU_TYPE 컬럼 추가
   2013-06-10		김성호			WITH(NOLOCK) 추가
   2018-01-24		김성호			모바일 메뉴 구분을 위해 컬럼 GROUP_REGION, GROUP_ATTRIBUTE 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_PUB_MENU_RELEASE]
(
	@SITE_CODE		VARCHAR(3),
	@MENU_CODE		VARCHAR(20)
)
AS
BEGIN

	-- 해당 대분류 그룹 항목 삭제
	DELETE FROM MNU_MASTER_REL WHERE SITE_CODE = @SITE_CODE AND MENU_CODE LIKE (@MENU_CODE + '%')

	-- 관리 테이블에서 홈페이지 메뉴 테이블로 이관
	-- 홈페이지에서는 USE_YN이 N인건 사용하지 않으므로 Y인것만 복사
	INSERT INTO MNU_MASTER_REL (
		SITE_CODE, MENU_CODE, PARENT_CODE, MENU_NAME, REGION_CODE, NATION_CODE, CITY_CODE, ATT_CODE, GROUP_CODE, BASIC_CODE, CATEGORY_TYPE, 
		VIEW_TYPE, LINK_URL, IMAGE_URL, BEST_CODE, FONT_STYLE, FONT_COLOR, ORDER_TYPE, ORDER_NUM, USE_YN, NEW_CODE, NEW_DATE, EDT_CODE, EDT_DATE, MENU_TYPE, GROUP_REGION, GROUP_ATTRIBUTE
	)
	SELECT
		SITE_CODE, MENU_CODE, PARENT_CODE, MENU_NAME, REGION_CODE, NATION_CODE, CITY_CODE, ATT_CODE, GROUP_CODE, BASIC_CODE, CATEGORY_TYPE, 
		VIEW_TYPE, LINK_URL, IMAGE_URL, BEST_CODE, FONT_STYLE, FONT_COLOR, ORDER_TYPE, ORDER_NUM, USE_YN, NEW_CODE, NEW_DATE, EDT_CODE, EDT_DATE, MENU_TYPE, GROUP_REGION, GROUP_ATTRIBUTE
	FROM MNU_MASTER WITH(NOLOCK) WHERE SITE_CODE = @SITE_CODE AND MENU_CODE LIKE (@MENU_CODE + '%') AND USE_YN = 'Y'

END
GO
