USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_EVT_PROMOTION_PRODUCT_GROUP_REGISTER
■ DESCRIPTION				: 프로모션 이벤트 상품 그룹 입력/수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-04-25		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_EVT_PROMOTION_PRODUCT_GROUP_REGISTER]
	@SEC_SEQ INT,
	@GROUP_SEQ INT,
	@GROUP_NAME NVARCHAR(600),
	@NEW_CODE CHAR(7)
AS 
BEGIN	
	SET NOCOUNT OFF;
	
	IF @SEC_SEQ <> 0 AND @GROUP_SEQ <> 0
	BEGIN
		UPDATE EVT_PROMOTION_PRODUCT_GROUP SET 
			GROUP_NAME = @GROUP_NAME, EDT_CODE = @NEW_CODE, EDT_DATE = GETDATE() 
		WHERE SEC_SEQ = @SEC_SEQ AND GROUP_SEQ = @GROUP_SEQ;
	END
	ELSE
	BEGIN
		SELECT @GROUP_SEQ = ISNULL(MAX(GROUP_SEQ), 0) + 1 FROM EVT_PROMOTION_PRODUCT_GROUP WITH(NOLOCK) WHERE SEC_SEQ = @SEC_SEQ;
		INSERT INTO EVT_PROMOTION_PRODUCT_GROUP ( SEC_SEQ, GROUP_SEQ, GROUP_NAME, NEW_CODE, NEW_DATE ) 
		VALUES ( @SEC_SEQ, @GROUP_SEQ, @GROUP_NAME, @NEW_CODE, GETDATE() );
	END

END
GO
