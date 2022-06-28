USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_PUB_JOINT_PROMOTION_INFO
■ DESCRIPTION				: 공동기획전 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC XP_PUB_JOINT_PROMOTION_INFO 2, 0, 0
	EXEC XP_PUB_JOINT_PROMOTION_INFO 2, 1, 0
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-10-14		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_PUB_JOINT_PROMOTION_INFO]
	@JOINT_SEQ INT,
	@MENU_SEQ INT,
	@ITEM_SEQ INT
AS 
BEGIN
	-- 공동기획전 마스터 정보
	SELECT 
		JOINT_SEQ, TYPE, SUBJECT, START_DATE, END_DATE, VIEW_YN, TOP_URL, 
		MENU_VIEW_YN, MENU_STYLE, LIST_VIEW_YN, LIST_COUNT, READ_COUNT, NEW_DATE
	FROM PUB_JOINT_MASTER WITH(NOLOCK)
	WHERE JOINT_SEQ = @JOINT_SEQ;

	-- 공동 기획전 메뉴 정보
	SELECT 
		JOINT_SEQ, MENU_SEQ, SORT_TYPE, CATEGORY_NAME, MENU_NAME, STYLE1, STYLE2, STYLE3, STYLE4
	FROM PUB_JOINT_MENU WITH(NOLOCK)
	WHERE JOINT_SEQ = @JOINT_SEQ 
		AND ( ISNULL(@MENU_SEQ, 0) = 0 OR MENU_SEQ = @MENU_SEQ );
	
	-- 공동 기획전 아이템 정보
	SELECT
		A.JOINT_SEQ, A.MENU_SEQ, A.ITEM_SEQ, A.SORT_TYPE, A.PRO_CODE, A.PRO_NAME, A.PRO_REMARK,
		A.REGION_NAME, A.CONTENT, A.SALE_PRICE, A.NORMAL_PRICE, A.LINK_URL, 
		B.AIRLINE_CODE AS AIRLINE_CODE, B.KOR_NAME AS AIRLINE_NAME, 
		A.IMAGE_URL, A.ETC1, A.ETC2,  A.NEW_DATE
	FROM PUB_JOINT_ITEM A WITH(NOLOCK)
	LEFT JOIN PUB_AIRLINE B WITH(NOLOCK) ON A.AIRLINE_CODE = B.AIRLINE_CODE
	WHERE JOINT_SEQ = @JOINT_SEQ
		AND ( ISNULL(@MENU_SEQ, 0) = 0 OR A.MENU_SEQ = @MENU_SEQ )
		AND ( ISNULL(@ITEM_SEQ, 0) = 0 OR A.ITEM_SEQ = @ITEM_SEQ );
END
	
GO
