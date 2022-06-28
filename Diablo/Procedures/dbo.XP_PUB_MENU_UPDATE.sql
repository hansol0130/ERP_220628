USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_MENU_UPDATE
■ DESCRIPTION				: 메뉴 수정
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
   2018-01-24		김성호			모바일 메뉴 구분을 위해 컬럼 GROUP_REGION, GROUP_ATTRIBUTE 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_PUB_MENU_UPDATE]
(
	@SITE_CODE		VARCHAR(3),
	@MENU_CODE		VARCHAR(20),
	@MENU_NAME		VARCHAR(100),
	@REGION_CODE	VARCHAR(30),
	@NATION_CODE	VARCHAR(30),
	@CITY_CODE		VARCHAR(30),
	@ATT_CODE		VARCHAR(50),
	@GROUP_CODE		VARCHAR(100),
	@BASIC_CODE		VARCHAR(20),
	@CATEGORY_TYPE	VARCHAR(1),
	@VIEW_TYPE		VARCHAR(1),
	@LINK_URL		VARCHAR(200),
	@IMAGE_URL		VARCHAR(200),
	@BEST_CODE		VARCHAR(30),
	@FONT_STYLE		VARCHAR(30),
	@FONT_COLOR		VARCHAR(30),
	@ORDER_TYPE		INTEGER,
	@EDT_CODE		EDT_CODE,
	@GROUP_REGION	VARCHAR(20),
	@GROUP_ATTRIBUTE	VARCHAR(20)
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	UPDATE MNU_MASTER
	SET	MENU_NAME = @MENU_NAME, REGION_CODE = @REGION_CODE, NATION_CODE = @NATION_CODE, CITY_CODE = @CITY_CODE,
		ATT_CODE = @ATT_CODE, GROUP_CODE = @GROUP_CODE, BASIC_CODE = @BASIC_CODE, CATEGORY_TYPE = @CATEGORY_TYPE,
		VIEW_TYPE = @VIEW_TYPE, LINK_URL = @LINK_URL, IMAGE_URL = @IMAGE_URL, BEST_CODE = @BEST_CODE,
		FONT_STYLE = @FONT_STYLE, FONT_COLOR = @FONT_COLOR, ORDER_TYPE = @ORDER_TYPE,
		EDT_CODE = @EDT_CODE, EDT_DATE = GETDATE(), GROUP_REGION = @GROUP_REGION, GROUP_ATTRIBUTE = @GROUP_ATTRIBUTE
	WHERE SITE_CODE = @SITE_CODE AND MENU_CODE = @MENU_CODE

END


GO
