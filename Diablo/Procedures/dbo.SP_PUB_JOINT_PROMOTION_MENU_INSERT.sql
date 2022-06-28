USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PUB_JOINT_PROMOTION_MENU_INSERT
■ DESCRIPTION				: 공동기획전 관리 메뉴 입력
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
CREATE PROC [dbo].[SP_PUB_JOINT_PROMOTION_MENU_INSERT]
	@JOINT_SEQ INT,
	@SORT_TYPE INT,
	@CATEGORY_NAME NVARCHAR(200),
	@MENU_NAME NVARCHAR(200),
	@STYLE1 VARCHAR(200),
	@STYLE2 VARCHAR(200),
	@STYLE3 VARCHAR(200),
	@STYLE4 VARCHAR(200),
	@NEW_CODE CHAR(7)
AS 
BEGIN

	DECLARE @MENU_SEQ INT;
	SELECT @MENU_SEQ = ISNULL(MAX(MENU_SEQ), 0) + 1 FROM PUB_JOINT_MENU WITH(NOLOCK) WHERE JOINT_SEQ = @JOINT_SEQ;

	INSERT INTO PUB_JOINT_MENU
		( JOINT_SEQ, MENU_SEQ, SORT_TYPE, CATEGORY_NAME, MENU_NAME, STYLE1, STYLE2, STYLE3, STYLE4, NEW_CODE, NEW_DATE )
	VALUES
		( @JOINT_SEQ, @MENU_SEQ, @SORT_TYPE, @CATEGORY_NAME, @MENU_NAME, @STYLE1, @STYLE2, @STYLE3, @STYLE4, @NEW_CODE, GETDATE() )
END
	
GO
