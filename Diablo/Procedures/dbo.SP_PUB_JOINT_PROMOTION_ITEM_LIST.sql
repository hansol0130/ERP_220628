USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PUB_JOINT_PROMOTION_ITEM_LIST
■ DESCRIPTION				: 공동기획전 관리 아이템 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
SP_PUB_JOINT_PROMOTION_ITEM_LIST 1, 1
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-10-11		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PUB_JOINT_PROMOTION_ITEM_LIST]
	@JOINT_SEQ INT,
	@MENU_SEQ INT
AS 
BEGIN
	SELECT 
		JOINT_SEQ, MENU_SEQ, ITEM_SEQ, SORT_TYPE, PRO_CODE, PRO_NAME, PRO_REMARK,
		REGION_NAME, REGION_CSS_TYPE, REGION_LINE_CNT, CONTENT, SALE_PRICE, NORMAL_PRICE, LINK_URL,
		AIRLINE_CODE, IMAGE_URL, ETC1, ETC2, ETC3, ETC4, NEW_DATE, NEW_CODE, EDT_CODE, EDT_DATE
	FROM PUB_JOINT_ITEM
	WHERE JOINT_SEQ = @JOINT_SEQ AND MENU_SEQ = @MENU_SEQ;
END
	
GO
