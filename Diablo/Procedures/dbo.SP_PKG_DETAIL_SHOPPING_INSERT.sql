USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PKG_DETAIL_SHOPPING_INSERT
■ DESCRIPTION				: 상품상세 쇼핑정보 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-06-23		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_DETAIL_SHOPPING_INSERT]
	@PRO_CODE VARCHAR(20),
	@SHOP_SEQ INT,
	@SHOP_NAME VARCHAR(30),
	@SHOP_PLACE VARCHAR(30),
	@SHOP_TIME VARCHAR(30),
	@SHOP_REMARK VARCHAR(50)
AS 
BEGIN	
	SET NOCOUNT OFF;

	IF @SHOP_SEQ = 0
	BEGIN
		SELECT @SHOP_SEQ = ISNULL(MAX(SHOP_SEQ), 0) + 1 FROM PKG_DETAIL_SHOPPING WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE
	END
	
	INSERT INTO PKG_DETAIL_SHOPPING ( PRO_CODE, SHOP_SEQ, SHOP_NAME, SHOP_PLACE, SHOP_TIME, SHOP_REMARK )
	VALUES( @PRO_CODE, @SHOP_SEQ, @SHOP_NAME, @SHOP_PLACE, @SHOP_TIME, @SHOP_REMARK )
END 
GO
