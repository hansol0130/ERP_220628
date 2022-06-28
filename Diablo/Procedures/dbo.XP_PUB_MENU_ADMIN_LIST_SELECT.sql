USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_MENU_ADMIN_LIST_SELECT
■ DESCRIPTION				: 메뉴의 트리 레벨관계 검색
■ INPUT PARAMETER			: 
	@SITE_CODE				: 사이트코드
	@MENU_CODE				: 메뉴코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_PUB_MENU_ADMIN_LIST_SELECT 'VGT', '102'

	SELECT * FROM MNU_MASTER WHERE MENU_CODE IN ('10101030101','101010301','1010103','10101','101')

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-02		김성호			최초생성
   2013-06-10		김성호			WITH(NOLOCK) 추가
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_PUB_MENU_ADMIN_LIST_SELECT]
(
	@SITE_CODE	VARCHAR(3),
	@MENU_CODE	VARCHAR(20)
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);

	SET @SQLSTRING = N'
	WITH LIST AS
	(
		 SELECT A.*, 0 AS [LEVEL]
		 FROM MNU_MASTER A WITH(NOLOCK)
		 WHERE A.SITE_CODE = @SITE_CODE AND A.MENU_CODE = @MENU_CODE
		 UNION ALL
		 SELECT A.*, B.[LEVEL] + 1
		 FROM MNU_MASTER A WITH(NOLOCK)
		 INNER JOIN LIST B ON A.SITE_CODE = B.SITE_CODE AND A.PARENT_CODE = B.MENU_CODE
	)
	SELECT *
	FROM LIST A
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
