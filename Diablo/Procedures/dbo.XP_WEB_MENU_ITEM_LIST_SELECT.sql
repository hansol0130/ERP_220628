USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_MENU_ITEM_LIST_SELECT
■ DESCRIPTION				: 상품베스트 리스트 출력
■ INPUT PARAMETER			: 
	@SITE_CODE				: 사이트 코드
	@MENU_CODE				: 메뉴 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_WEB_MENU_ITEM_LIST_SELECT 'VGT', '10101'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-19		김성호			최초생성
   2015-02-24		김성호			SEC_CODE ORDER BY 정렬 방향 설정과 TOP 설정값 추가 (최근베스트 상품 검색 이유)
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_WEB_MENU_ITEM_LIST_SELECT]
(
	@SITE_CODE VARCHAR(3),
	@MENU_CODE VARCHAR(20)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- 기본
	EXEC DBO.XP_WEB_MENU_ITEM_BASIC_LIST_SELECT @SITE_CODE, @MENU_CODE, '', 0, '';

	-- 상품
	EXEC DBO.XP_WEB_MENU_ITEM_PACKGAGE_LIST_SELECT @SITE_CODE, @MENU_CODE, '', 0, '';

	-- 호텔
	EXEC DBO.XP_WEB_MENU_ITEM_HOTEL_LIST_SELECT @SITE_CODE, @MENU_CODE, '', 0, '';

	-- 게시물
	EXEC DBO.XP_WEB_MENU_ITEM_BOARD_LIST_SELECT @SITE_CODE, @MENU_CODE, '', 0, '';

	-- 이벤트
	EXEC DBO.XP_WEB_MENU_ITEM_EVENT_LIST_SELECT @SITE_CODE, @MENU_CODE, '', 0, '';

END


GO
