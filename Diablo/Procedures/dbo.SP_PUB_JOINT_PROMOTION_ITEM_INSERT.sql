USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PUB_JOINT_PROMOTION_ITEM_INSERT
■ DESCRIPTION				: 공동기획전 관리 아이템 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
SELECT * FROM PUB_JOINT_ITEM;
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-10-12		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PUB_JOINT_PROMOTION_ITEM_INSERT]
	@JOINT_SEQ INT,
	@MENU_SEQ INT,
	@SORT_TYPE INT,
	@PRO_CODE VARCHAR(20),
	@PRO_NAME NVARCHAR(400),
	@PRO_REMARK VARCHAR(400),
	@REGION_NAME NVARCHAR(40),
	@REGION_CSS_TYPE INT,
	@REGION_LINE_CNT INT,
	@CONTENT NVARCHAR(400),
	@SALE_PRICE INT,
	@NORMAL_PRICE INT,
	@LINK_URL VARCHAR(300),
	@AIRLINE_CODE CHAR(2),
	@IMAGE_URL VARCHAR(300),
	@ETC1 VARCHAR(200),
	@ETC2 VARCHAR(200),
	@ETC3 VARCHAR(200),	
	@ETC4 VARCHAR(200),			
	@NEW_CODE CHAR(7)
AS 
BEGIN

	DECLARE @ITEM_SEQ INT;
	SELECT @ITEM_SEQ = ISNULL(MAX(ITEM_SEQ), 0) + 1 FROM PUB_JOINT_ITEM WITH(NOLOCK) WHERE JOINT_SEQ = @JOINT_SEQ AND MENU_SEQ = @MENU_SEQ;

	INSERT INTO PUB_JOINT_ITEM (
		JOINT_SEQ, MENU_SEQ, ITEM_SEQ, SORT_TYPE, PRO_CODE, PRO_NAME, PRO_REMARK,
		REGION_NAME, REGION_CSS_TYPE, REGION_LINE_CNT, CONTENT, SALE_PRICE, NORMAL_PRICE, LINK_URL, AIRLINE_CODE,
		IMAGE_URL, ETC1, ETC2, ETC3, ETC4, NEW_CODE, NEW_DATE
	)
	VALUES (
		@JOINT_SEQ, @MENU_SEQ, @ITEM_SEQ, @SORT_TYPE, @PRO_CODE, @PRO_NAME, @PRO_REMARK,
		@REGION_NAME, @REGION_CSS_TYPE, @REGION_LINE_CNT, @CONTENT, @SALE_PRICE, @NORMAL_PRICE, @LINK_URL, @AIRLINE_CODE,
		@IMAGE_URL, @ETC1, @ETC2, @ETC3, @ETC4, @NEW_CODE, GETDATE()
	);

END
	
GO
