USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_PKG_FIRST_MAIN_CITY_SELECT
■ DESCRIPTION				: 행사의 첫번째 메인 도시 검색
■ INPUT PARAMETER			: 
	@SITE_CODE				: 행사코드
	@MENU_CODE				: 가격순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_WEB_PKG_FIRST_MAIN_CITY_SELECT 'JPP091-130502ZE', 1

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-08		김성호			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_WEB_PKG_FIRST_MAIN_CITY_SELECT]
(
	@PRO_CODE VARCHAR(20),
	@PRICE_SEQ INT
)

AS  
BEGIN

	SELECT TOP 1 C.*
	FROM PKG_DETAIL_SCH_DAY A WITH(NOLOCK) 
	INNER JOIN PKG_DETAIL_SCH_CITY B  WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE AND A.SCH_SEQ = B.SCH_SEQ AND A.DAY_SEQ = B.DAY_SEQ
	INNER JOIN PUB_CITY C WITH(NOLOCK) ON B.CITY_CODE = C.CITY_CODE
	WHERE A.PRO_CODE = @PRO_CODE
		AND A.SCH_SEQ IN (SELECT SCH_SEQ FROM PKG_DETAIL_PRICE  WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE AND PRICE_SEQ = @PRICE_SEQ)
		AND B.MAINCITY_YN = 'Y' AND C.NATION_CODE <> 'KR'
	ORDER BY A.DAY_NUMBER, B.CITY_SHOW_ORDER;

END

GO
