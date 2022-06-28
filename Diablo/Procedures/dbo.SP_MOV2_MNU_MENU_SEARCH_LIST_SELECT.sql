USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_MNU_MENU_SEARCH_LIST_SELECT
■ DESCRIPTION				: 메뉴경로를 포함한 메뉴명 검색
■ INPUT PARAMETER			: 

	@SITE_CODE				: 사이트코드
	@REAL_YN				: 실서버 유무
	@KEYWORD				: 검색어

■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_MOV2_MNU_MENU_SEARCH_LIST_SELECT 'VGT', '프리미엄', 'Y'


	select * from MNU_MASTER_REL a with(nolock) where site_code = 'vgt'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2017-12-08			김성호			메뉴명 검색
	2018-01-24			김성호			최상위 메뉴 분리
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_MNU_MENU_SEARCH_LIST_SELECT]
(
	@SITE_CODE		VARCHAR(3),
	@KEYWORD		VARCHAR(20),
	@REAL_YN		VARCHAR(1) = 'Y'
	
)
AS  
BEGIN

	WITH MENU_LIST AS
	(
		SELECT A.SITE_CODE, A.MENU_CODE, A.PARENT_CODE, A.MENU_NAME, B.MENU_CODE AS [MAIN_CODE], B.MENU_NAME AS [MAIN_NAME]
			, ROW_NUMBER() OVER(ORDER BY A.MENU_CODE) AS [ROWNUM]
		FROM MNU_MASTER_REL A WITH(NOLOCK)
		INNER JOIN MNU_MASTER_REL B WITH(NOLOCK) ON A.SITE_CODE = B.SITE_CODE AND CONVERT(VARCHAR(3), A.PARENT_CODE) = B.MENU_CODE
		WHERE A.SITE_CODE = @SITE_CODE AND A.PARENT_CODE IS NOT NULL AND A.MENU_NAME LIKE ('%' + @KEYWORD + '%') AND A.USE_YN = 'Y' AND A.MENU_CODE LIKE '[1,2,3,4,5,6,7,8]%' AND @REAL_YN = 'Y'
		UNION ALL
		SELECT A.SITE_CODE, A.MENU_CODE, A.PARENT_CODE, A.MENU_NAME, B.MENU_CODE AS [MAIN_CODE], B.MENU_NAME AS [MAIN_NAME]
			, ROW_NUMBER() OVER(ORDER BY A.MENU_CODE) AS [ROWNUM]
		FROM MNU_MASTER A WITH(NOLOCK)
		INNER JOIN MNU_MASTER B WITH(NOLOCK) ON A.SITE_CODE = B.SITE_CODE AND CONVERT(VARCHAR(3), A.PARENT_CODE) = B.MENU_CODE
		WHERE A.SITE_CODE = @SITE_CODE AND A.PARENT_CODE IS NOT NULL AND A.MENU_NAME LIKE ('%' + @KEYWORD + '%') AND A.USE_YN = 'Y' AND A.MENU_CODE LIKE '[1,2,3,4,5,6,7,8]%' AND @REAL_YN = 'N'
	)
	, TEMP_LIST AS
	(
		SELECT A.SITE_CODE, A.MENU_CODE, A.PARENT_CODE, A.MENU_NAME, A.ROWNUM, 0 AS [LEVEL]
		FROM MENU_LIST A
		UNION ALL
		SELECT A.SITE_CODE, A.MENU_CODE, A.PARENT_CODE, A.MENU_NAME, B.ROWNUM, B.LEVEL + 1
		FROM MNU_MASTER_REL A WITH(NOLOCK)
		INNER JOIN TEMP_LIST B ON B.PARENT_CODE = A.MENU_CODE AND A.PARENT_CODE IS NOT NULL
		WHERE A.SITE_CODE = @SITE_CODE
	)
	SELECT A.MAIN_CODE, A.MAIN_NAME
		, STUFF((SELECT (' > ' + A1.MENU_NAME) AS [text()] FROM TEMP_LIST A1 WHERE A1.ROWNUM = A.ROWNUM ORDER BY A1.LEVEL DESC FOR XML PATH('')), 1, 6, '') AS [PATH_NAME], B.*
	FROM MENU_LIST A
	INNER JOIN MNU_MASTER_REL B WITH(NOLOCK) ON A.SITE_CODE = B.SITE_CODE AND A.MENU_CODE = B.MENU_CODE

END


GO
