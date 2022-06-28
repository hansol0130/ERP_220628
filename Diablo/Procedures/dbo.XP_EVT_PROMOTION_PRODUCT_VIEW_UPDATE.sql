USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_EVT_PROMOTION_PRODUCT_VIEW_UPDATE
■ DESCRIPTION				: 프로모션 이벤트 상품 클릭수
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2017-05-10		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_EVT_PROMOTION_PRODUCT_VIEW_UPDATE]
	@SEC_SEQ INT,
	@GROUP_SEQ INT,
	@MASTER_CODE CHAR(10)
AS 
BEGIN
	SET NOCOUNT OFF;

	UPDATE EVT_PROMOTION_PRODUCT SET 
		VIEW_CNT = ISNULL(VIEW_CNT, 0)  + 1 
	WHERE SEC_SEQ = @SEC_SEQ AND GROUP_SEQ = @GROUP_SEQ AND MASTER_CODE = @MASTER_CODE
END
GO
