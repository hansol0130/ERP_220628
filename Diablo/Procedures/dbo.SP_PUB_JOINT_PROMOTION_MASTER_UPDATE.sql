USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PUB_JOINT_PROMOTION_MASTER_UPDATE
■ DESCRIPTION				: 공동기획전 관리 마스터 수정
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
CREATE PROC [dbo].[SP_PUB_JOINT_PROMOTION_MASTER_UPDATE]
	@TYPE INT,
	@SUBJECT VARCHAR(50),
	@START_DATE DATETIME,
	@END_DATE DATETIME,
	@VIEW_YN CHAR(1),
	@TOP_URL VARCHAR(100),
	@MENU_VIEW_YN CHAR(1),
	@MENU_STYLE INT,
	@MENU_COMMON_CSS VARCHAR(500),
	@LIST_VIEW_YN CHAR(1),
	@LIST_COUNT INT,
	@EDT_CODE CHAR(7),
	@JOINT_SEQ INT
AS 
BEGIN
	UPDATE PUB_JOINT_MASTER SET 
		TYPE = @TYPE,
		SUBJECT = @SUBJECT,
		START_DATE = @START_DATE,
		END_DATE = @END_DATE,
		VIEW_YN = @VIEW_YN,
		TOP_URL = @TOP_URL,
		MENU_VIEW_YN = @MENU_VIEW_YN,
		MENU_STYLE = @MENU_STYLE,
		MENU_COMMON_CSS = @MENU_COMMON_CSS,
		LIST_VIEW_YN = @LIST_VIEW_YN,
		LIST_COUNT = @LIST_COUNT,
		EDT_CODE = @EDT_CODE,
		EDT_DATE = GETDATE()
	WHERE JOINT_SEQ = @JOINT_SEQ;
END
	
GO
