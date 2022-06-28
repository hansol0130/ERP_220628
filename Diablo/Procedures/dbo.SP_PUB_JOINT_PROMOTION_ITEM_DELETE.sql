USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PUB_JOINT_PROMOTION_ITEM_DELETE
■ DESCRIPTION				: 공동기획전 관리 아이템 삭제
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
CREATE PROC [dbo].[SP_PUB_JOINT_PROMOTION_ITEM_DELETE]
	@JOINT_SEQ INT,
	@MENU_SEQ INT,
	@ARR_ITEM_SEQ VARCHAR(100)
AS 
BEGIN
	DELETE FROM PUB_JOINT_ITEM 
	WHERE 
		JOINT_SEQ = @JOINT_SEQ 
			AND MENU_SEQ = @MENU_SEQ 
			AND ITEM_SEQ IN ( SELECT Data FROM dbo.FN_SPLIT(@ARR_ITEM_SEQ, ',') );

END	
GO
