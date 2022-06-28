USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PUB_JOINT_PROMOTION_MENU_DELETE
■ DESCRIPTION				: 공동기획전 관리 메뉴 삭제
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
CREATE PROC [dbo].[SP_PUB_JOINT_PROMOTION_MENU_DELETE]
	@JOINT_SEQ INT,
	@MENU_SEQ INT
AS 
BEGIN
	
	IF EXISTS ( SELECT 1 FROM PUB_JOINT_ITEM WITH(NOLOCK) WHERE JOINT_SEQ = @JOINT_SEQ AND MENU_SEQ = @MENU_SEQ )
	BEGIN		
		SELECT 1;
		RETURN;
	END

	-- 메뉴관련 아이템이 없을 때만 삭제;
	DELETE FROM PUB_JOINT_MENU WHERE JOINT_SEQ = @JOINT_SEQ AND MENU_SEQ = @MENU_SEQ;
	
	SELECT 0;
	
END
	
GO
