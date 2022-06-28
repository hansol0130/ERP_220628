USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PUB_JOINT_PROMOTION_MENU_LIST
■ DESCRIPTION				: 공동기획전 관리 메뉴 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-10-11		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PUB_JOINT_PROMOTION_MENU_LIST]
	@JOINT_SEQ INT
AS 
BEGIN
	SELECT 
		JOINT_SEQ, MENU_SEQ, SORT_TYPE, CATEGORY_NAME, MENU_NAME, STYLE1, STYLE2, STYLE3, STYLE4
	FROM PUB_JOINT_MENU
	WHERE JOINT_SEQ = @JOINT_SEQ
END
	
GO
