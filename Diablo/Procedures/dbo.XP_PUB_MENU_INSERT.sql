USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_MENU_INSERT
■ DESCRIPTION				: 메뉴 등록
■ INPUT PARAMETER			: 
	@SITE_CODE				: 사이트코드
	@MENU_CODE				: 메뉴코드
	@REAL_YN				: 실서버 유무
■ OUTPUT PARAMETER			: 
■ EXEC						: 

■ MEMO						: MENU_CODE 900 이상은 수동입력
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-03		김성호			최초생성
   2018-01-24		김성호			모바일 메뉴 구분을 위해 컬럼 GROUP_REGION, GROUP_ATTRIBUTE 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_PUB_MENU_INSERT]
(
	@SITE_CODE		VARCHAR(3),
	@PARENT_CODE	VARCHAR(20),
	@MENU_NAME		VARCHAR(100),
	@NEW_CODE		NEW_CODE
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @FLAG VARCHAR(10)
	DECLARE @MENU_CODE VARCHAR(20)
	DECLARE @ORDER_NUM INT

	SET @FLAG = 'INSERT'

	IF @PARENT_CODE IS NULL OR @PARENT_CODE = ''
	BEGIN
		-- PARENT_CODE SETTING
		IF EXISTS(SELECT 1 FROM MNU_MASTER A WHERE A.SITE_CODE = @SITE_CODE AND A.PARENT_CODE IS NULL AND A.USE_YN = 'Y' AND A.MENU_CODE < 900)
			SELECT @MENU_CODE = CONVERT(NUMERIC, MAX(MENU_CODE)) + 1 FROM MNU_MASTER A WHERE A.SITE_CODE = @SITE_CODE AND A.MENU_CODE < 900 AND PARENT_CODE IS NULL AND USE_YN = 'Y' GROUP BY MENU_CODE
		ELSE
			SET @MENU_CODE = '101'	-- 메뉴코드는 101부터 시작, 어떤 레벨도 00번은 사용 하지 않는다.
	END
	ELSE
	BEGIN
		SELECT @ORDER_NUM = ISNULL(MAX(A.ORDER_NUM), 0) + 1 FROM MNU_MASTER A WHERE A.SITE_CODE = @SITE_CODE AND A.PARENT_CODE = @PARENT_CODE AND A.USE_YN = 'Y'
		SELECT @MENU_CODE = MAX(A.MENU_CODE) FROM MNU_MASTER A WHERE A.SITE_CODE = @SITE_CODE AND A.PARENT_CODE = @PARENT_CODE
		
		IF @MENU_CODE IS NULL
		BEGIN
			SET @MENU_CODE = @PARENT_CODE + '01'
		END
		ELSE IF @MENU_CODE = @PARENT_CODE + '99'	-- 99까지 값을 사용하면 사용하지 않는 코드를 수정해서 사용한다.
		BEGIN
			SELECT @MENU_CODE = MIN(A.MENU_CODE) FROM MNU_MASTER A WHERE A.SITE_CODE = @SITE_CODE AND A.PARENT_CODE = @PARENT_CODE AND A.USE_YN = 'N' GROUP BY A.MENU_CODE
			
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
		UPDATE MNU_MASTER 
		SET	MENU_NAME = @MENU_NAME, USE_YN = 'Y', ORDER_NUM = @ORDER_NUM, NEW_CODE = @NEW_CODE, NEW_DATE = GETDATE(), 
			REGION_CODE = NULL, NATION_CODE = NULL, CITY_CODE = NULL, ATT_CODE = NULL, GROUP_CODE = NULL, BASIC_CODE = NULL,
			CATEGORY_TYPE = NULL, VIEW_TYPE = NULL, LINK_URL = NULL, IMAGE_URL = NULL, BEST_CODE = NULL, FONT_STYLE = NULL, FONT_COLOR = NULL,
			ORDER_TYPE = NULL, EDT_CODE = NULL, EDT_DATE = NULL, GROUP_REGION = NULL, GROUP_ATTRIBUTE = NULL
		WHERE SITE_CODE = @SITE_CODE AND MENU_CODE = @MENU_CODE
	END
	ELSE
	BEGIN
		INSERT INTO MNU_MASTER (SITE_CODE, MENU_CODE, PARENT_CODE, MENU_NAME, ORDER_NUM, USE_YN, NEW_CODE, NEW_DATE)
		VALUES (@SITE_CODE, @MENU_CODE, @PARENT_CODE, @MENU_NAME, @ORDER_NUM, 'Y', @NEW_CODE, GETDATE())
	END
	
	SELECT @MENU_CODE
END


GO
