USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PUB_JOINT_PROMOTION_MENU_UPDATE
■ DESCRIPTION				: 공동기획전 관리 메뉴 수정
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
CREATE PROC [dbo].[SP_PUB_JOINT_PROMOTION_MENU_UPDATE]
	@JOINT_SEQ INT,
	@MENU_SEQ INT,
	@SORT_TYPE INT,
	@CATEGORY_NAME NVARCHAR(200),
	@MENU_NAME NVARCHAR(200),
	@STYLE1 VARCHAR(200),
	@STYLE2 VARCHAR(200),
	@STYLE3 VARCHAR(200),
	@STYLE4 VARCHAR(200),
	@EDT_CODE CHAR(7)
AS 
BEGIN

	UPDATE PUB_JOINT_MENU SET
		SORT_TYPE = @SORT_TYPE, CATEGORY_NAME = @CATEGORY_NAME, MENU_NAME = @MENU_NAME,
		STYLE1 = @STYLE1, STYLE2 = @STYLE2, STYLE3 = @STYLE3, STYLE4 = @STYLE4,
		EDT_CODE = @EDT_CODE, EDT_DATE = GETDATE()
	WHERE JOINT_SEQ = @JOINT_SEQ AND MENU_SEQ = @MENU_SEQ;

END
	
GO
