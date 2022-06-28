USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PUB_JOINT_PROMOTION_MASTER_SELECT
■ DESCRIPTION				: 공동기획전 관리 마스터 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-10-10		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PUB_JOINT_PROMOTION_MASTER_SELECT]
	@JOINT_SEQ INT
AS 
BEGIN
	SELECT
		JOINT_SEQ, TYPE, SUBJECT, START_DATE, END_DATE,
		VIEW_YN, TOP_URL, MENU_VIEW_YN, MENU_STYLE, MENU_COMMON_CSS,
		LIST_VIEW_YN, LIST_COUNT, READ_COUNT, NEW_DATE, EDT_DATE
	FROM PUB_JOINT_MASTER WITH(NOLOCK)
	WHERE JOINT_SEQ = @JOINT_SEQ;
END
	
GO
