USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_MENU_ROOT_LIST_SELECT
■ DESCRIPTION				: 최상위 메뉴 리스트 검색
■ INPUT PARAMETER			: 
	@SITE_CODE				: 사이트코드
	@MENU_TYPE				: 메뉴종류 MenuRootTypeEnum { 상품관련메뉴 = 1, 이벤트메뉴 = 2, 비상품메뉴 = 3, 기타메뉴 = 9 };
	@REAL_YN				: 실서버 유무
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_PUB_MENU_ROOT_LIST_SELECT 'VGT', 1, 'Y'
	exec XP_PUB_MENU_ROOT_LIST_SELECT 'VGT', 2, 'Y'

	SELECT * FROM MNU_MASTER WHERE MENU_CODE IN ('10101030101','101010301','1010103','10101','101')

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-15		김성호			최초생성
   2013-06-27		김성호			ORDER BY 추가 (ORDER_NUM)
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_PUB_MENU_ROOT_LIST_SELECT]
(
	@SITE_CODE	VARCHAR(3),
	@MENU_TYPE	INT,
	@REAL_YN	VARCHAR(1)
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @TABLE_NAME VARCHAR(20), @WHERE VARCHAR(50);

	IF @MENU_TYPE > 0
		SET @WHERE = N' AND MENU_TYPE <= @MENU_TYPE'
	ELSE
		SET @WHERE = ''

	IF @REAL_YN = 'N'
		SET @TABLE_NAME = 'MNU_MASTER'
	ELSE
		SET @TABLE_NAME = 'MNU_MASTER_REL'


	SET @SQLSTRING = N'
	SELECT * FROM ' + @TABLE_NAME + N' WITH(NOLOCK) WHERE SITE_CODE = @SITE_CODE AND PARENT_CODE IS NULL AND USE_YN = ''Y''' + @WHERE + N' ORDER BY ORDER_NUM;'

	SET @PARMDEFINITION = N'
		@SITE_CODE VARCHAR(3),
		@MENU_TYPE INT';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@SITE_CODE,
		@MENU_TYPE;

END


GO
