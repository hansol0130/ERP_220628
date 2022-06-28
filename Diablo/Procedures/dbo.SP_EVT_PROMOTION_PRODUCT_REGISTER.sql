USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_EVT_PROMOTION_PRODUCT_REGISTER
■ DESCRIPTION				: 프로모션 이벤트 상품 입력 / 수정
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
CREATE PROC [dbo].[SP_EVT_PROMOTION_PRODUCT_REGISTER]
	@SEC_SEQ INT,
	@GROUP_SEQ INT,
	@MASTER_CODE CHAR(10),
	@PRODUCT_FEATURES VARCHAR(300),
	@REGION_NAME VARCHAR(30),
	@NEW_CODE CHAR(7)

AS 
BEGIN	

	IF EXISTS ( SELECT 1 FROM EVT_PROMOTION_PRODUCT WITH(NOLOCK) WHERE SEC_SEQ = @SEC_SEQ AND GROUP_SEQ = @GROUP_SEQ AND MASTER_CODE = @MASTER_CODE )
	BEGIN
		UPDATE EVT_PROMOTION_PRODUCT SET
			MASTER_CODE = @MASTER_CODE,
			PRODUCT_FEATURES = @PRODUCT_FEATURES,
			REGION_NAME = @REGION_NAME,
			EDT_CODE = @NEW_CODE,
			EDT_DATE = GETDATE()	
		WHERE SEC_SEQ = @SEC_SEQ AND GROUP_SEQ = @GROUP_SEQ AND MASTER_CODE = @MASTER_CODE;
	END
	ELSE
	BEGIN
		INSERT INTO EVT_PROMOTION_PRODUCT 
			( SEC_SEQ, GROUP_SEQ, MASTER_CODE, PRODUCT_FEATURES, REGION_NAME, NEW_CODE, NEW_DATE )
		VALUES
			( @SEC_SEQ, @GROUP_SEQ, @MASTER_CODE, @PRODUCT_FEATURES, @REGION_NAME, @NEW_CODE, GETDATE() );
	END
	
END
GO
