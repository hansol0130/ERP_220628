USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- AUTHOR:김성호
-- CREATE DATE: 2011-10-21
-- DESCRIPTION:	메뉴 등록
-- =============================================
CREATE PROCEDURE [dbo].[SP_PUB_VGT_MENU_INSERT]
	@PARENT_CODE          VARCHAR(20),
	@MENU_NAME            VARCHAR(100),
	@NEW_CODE             NEW_CODE
AS
BEGIN

	SET NOCOUNT ON;	
	
	DECLARE @FLAG VARCHAR(10)
	DECLARE @MENU_CODE VARCHAR(20)
	DECLARE @ORDER_NUM INT
	
	SET @FLAG = 'INSERT'

	IF @PARENT_CODE IS NULL
	BEGIN
		-- PARENT_CODE SETTING
		IF EXISTS(SELECT 1 FROM PUB_VGT_MENU WHERE PARENT_CODE IS NULL AND USE_YN = 'Y')
			SELECT @MENU_CODE = CONVERT(NUMERIC, MAX(MENU_CODE)) + 1 FROM PUB_VGT_MENU WHERE PARENT_CODE IS NULL AND USE_YN = 'Y' GROUP BY MENU_CODE
		ELSE
			SET @MENU_CODE = '101'	-- 메뉴코드는 101부터 시작, 어떤 레벨도 00번은 사용 하지 않는다.
	END
	ELSE
	BEGIN
		SELECT @ORDER_NUM = ISNULL(MAX(ORDER_NUM), 0) + 1 FROM PUB_VGT_MENU WHERE PARENT_CODE = @PARENT_CODE AND USE_YN = 'Y'
		SELECT @MENU_CODE = MAX(MENU_CODE) FROM PUB_VGT_MENU WHERE PARENT_CODE = @PARENT_CODE
		
		IF @MENU_CODE IS NULL
		BEGIN
			SET @MENU_CODE = @PARENT_CODE + '01'
		END
		ELSE IF @MENU_CODE = @PARENT_CODE + '99'
		BEGIN
			SELECT @MENU_CODE = MIN(MENU_CODE) FROM PUB_VGT_MENU WHERE PARENT_CODE = @PARENT_CODE AND USE_YN = 'N' GROUP BY MENU_CODE
			
			SET @FLAG = 'UPDATE'
		END
		ELSE
		BEGIN
			SET @MENU_CODE = CAST(@MENU_CODE AS NUMERIC) + 1
		END
	END

	IF @FLAG = 'UPDATE'
	BEGIN
		-- 기존걸 살려서 쓰므로 UPDATE 하고, 기존 값들은 초기화
		UPDATE PUB_VGT_MENU 
		SET MENU_NAME = @MENU_NAME, USE_YN = 'Y', ORDER_NUM = @ORDER_NUM, NEW_CODE = @NEW_CODE, NEW_DATE = GETDATE(), 
			REGION_CODE = NULL, CITY_CODE = NULL, NATION_CODE = NULL, GROUP_CODE = NULL, ATT_CODE = NULL, LINK_URL = NULL, 
			CATEGORY_TYPE = NULL, VIEW_TYPE = NULL, ORDER_TYPE = NULL, BEST_CODE = NULL, FONT_COLOR = NULL, FONT_STYLE = NULL,
			BASIC_CODE = NULL, IMAGE_URL = NULL, OLD_MENU_CODE = NULL, EDT_CODE = NULL, EDT_DATE = NULL
		WHERE MENU_CODE = @MENU_CODE
	END
	ELSE
	BEGIN
		INSERT INTO PUB_VGT_MENU (MENU_CODE, PARENT_CODE, MENU_NAME, ORDER_NUM, USE_YN, NEW_CODE, NEW_DATE)
		VALUES (@MENU_CODE, @PARENT_CODE, @MENU_NAME, @ORDER_NUM, 'Y', @NEW_CODE, GETDATE())
	END
	
	SELECT @MENU_CODE
END
GO
