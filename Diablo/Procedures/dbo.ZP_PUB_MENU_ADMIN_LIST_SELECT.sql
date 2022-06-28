USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_PUB_MENU_ADMIN_LIST_SELECT
■ DESCRIPTION				: 메뉴 자동완성
■ INPUT PARAMETER			: 
	@SITE_CODE				: 사이트코드
	@MENU_CODE				: 메뉴코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC ZP_PUB_MENU_ADMIN_LIST_SELECT 'VGT', '102','N'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-02		김성호			최초생성
   2013-06-10		김성호			WITH(NOLOCK) 추가
   2019-08-28		김주환			MOBILE 조회조건 추가
   2019-09-30	    고병호			테이블 left outer jojn MNU_MNG_GROUP B 추가
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[ZP_PUB_MENU_ADMIN_LIST_SELECT]
(
	@SITE_CODE	VARCHAR(3),
	@MENU_CODE	VARCHAR(20),
	@MOBILE_YN  CHAR(1) = 'Y'
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);

	SET @SQLSTRING = N'
	WITH LIST AS
	(
		 SELECT		A.*, 0 AS [LEVEL]
		 FROM		MNU_MASTER A WITH(NOLOCK)
		 WHERE		A.SITE_CODE = @SITE_CODE AND A.MENU_CODE = @MENU_CODE
		 UNION ALL
		 SELECT		A.*, B.[LEVEL] + 1
		 FROM		MNU_MASTER A WITH(NOLOCK)	INNER JOIN LIST B	ON	A.SITE_CODE	=	B.SITE_CODE 
																	AND A.PARENT_CODE = B.MENU_CODE
	)
	SELECT	  DISTINCT
	          A.SITE_CODE
			, A.MENU_CODE
			, A.PARENT_CODE
			, A.MENU_NAME
			, A.REGION_CODE
			, A.NATION_CODE
			, A.CITY_CODE
			, A.ATT_CODE
			, A.GROUP_CODE
			, A.BASIC_CODE
			, A.CATEGORY_TYPE
			, A.VIEW_TYPE
			, A.LINK_URL
			, A.IMAGE_URL
			, A.BEST_CODE
			, A.FONT_STYLE
			, A.FONT_COLOR
			, A.ORDER_TYPE
			, A.ORDER_NUM
			, A.USE_YN
			, A.NEW_CODE
			, A.NEW_DATE
			, A.EDT_CODE
			, A.EDT_DATE
			, A.MENU_TYPE
			, A.GROUP_REGION
			, A.GROUP_ATTRIBUTE
			, A.MOBILE_YN
			, isNull(B.GRP_DESC,'''') AS ENG_MENU_NAME
			, A.LEVEL
	FROM				LIST			A
	LEFT OUTER JOIN		MNU_MNG_GROUP	B		ON		A.SITE_CODE		=		B.SITE_CODE
												AND		A.MENU_CODE		=		B.MENU_CODE
	WHERE		A.USE_YN = ''Y''
	AND			A.MOBILE_YN = @MOBILE_YN
	ORDER BY	A.PARENT_CODE, A.ORDER_NUM'

	SET @PARMDEFINITION = N'
		@SITE_CODE VARCHAR(3),
		@MENU_CODE VARCHAR(20),
		@MOBILE_YN CHAR(1)';
	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @SITE_CODE, @MENU_CODE, @MOBILE_YN;

END

GO
