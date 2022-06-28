USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_MENU_ITEM_EVENT_LIST_SELECT
■ DESCRIPTION				: 베스트 상품 이벤트 검색
■ INPUT PARAMETER			: 
	@SITE_CODE				: 사이트 코드
	@MENU_CODE				: 메뉴 코드
	@SEC_CODE				: 섹션 코드
	@ORDER_BY				: 섹션 코드 정렬 방향 (D: DESC, 이외 ASC)
	@TOP_COUNT				: 최대 검색 수
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_WEB_MENU_ITEM_EVENT_LIST_SELECT 'VGT', '10101', '', 0, ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-19		김성호			최초생성
   2013-05-29		김성호			SEC_CODE VARCHAR(4)로 수정
   2013-06-10		김성호			WITH(NOLOCK) 추가
   2015-01-12		정지용			GROUP_TIELE / GROUP_DESC 추가
   2015-02-24		김성호			SEC_CODE ORDER BY 정렬 방향 설정과 TOP 설정값 추가 (최근베스트 상품 검색 이유)
   2015-02-26		정지용			A.SITE_CODE, A.MENU_CODE, A.SEC_CODE, A.DTI_ITEM1, A.DTI_ITEM2 컬럼 추가
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_WEB_MENU_ITEM_EVENT_LIST_SELECT]
(
	@SITE_CODE	VARCHAR(3),
	@MENU_CODE	VARCHAR(20),
	@SEC_CODE	VARCHAR(4),
	@TOP_COUNT	INT,
	@ORDER_BY	VARCHAR(1)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(100);

	IF @SEC_CODE = ''
		SET @WHERE = ''
	ELSE
		SET @WHERE = ' AND A.SEC_CODE = @SEC_CODE'


	SET @SQLSTRING = N'
	SELECT ' + (CASE @TOP_COUNT WHEN 0 THEN '' ELSE 'TOP (@TOP_COUNT) ' END) + N'
		 A.SITE_CODE, A.MENU_CODE, A.SEC_CODE, A.DTI_ITEM1, A.DTI_ITEM2, B.*, C.GRP_TITLE, C.GRP_DESC FROM MNU_MNG_ITEM A WITH(NOLOCK)
	INNER JOIN MNU_MNG_GROUP C WITH(NOLOCK) ON C.SITE_CODE = A.SITE_CODE AND C.MENU_CODE = A.MENU_CODE AND C.SEC_CODE = A.SEC_CODE AND C.GRP_SEQ = A.GRP_SEQ
	INNER JOIN PUB_EVENT B WITH(NOLOCK) ON A.EVT_SEQ = B.EVT_SEQ
	WHERE A.SITE_CODE = @SITE_CODE AND A.MENU_CODE = @MENU_CODE' + @WHERE + '
	ORDER BY A.SITE_CODE, A.MENU_CODE, A.SEC_CODE' + (CASE @ORDER_BY WHEN 'D' THEN ' DESC' ELSE '' END) + ', A.GRP_SEQ, A.ORDER_NO;'

	SET @PARMDEFINITION = N'
		@SITE_CODE	VARCHAR(3),
		@MENU_CODE	VARCHAR(20),
		@SEC_CODE	VARCHAR(4),
		@TOP_COUNT	INT';

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@SITE_CODE,
		@MENU_CODE,
		@SEC_CODE,
		@TOP_COUNT;

END
GO
