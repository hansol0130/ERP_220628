USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_EVT_PROMOTION_PRODUCT_GROUP_SELECT
■ DESCRIPTION				: 프로모션 이벤트 상품 그룹 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-04-25		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[SP_EVT_PROMOTION_PRODUCT_GROUP_SELECT]
	@SEC_SEQ INT,
	@GROUP_SEQ INT
AS 
BEGIN	

	SELECT 
		SEC_SEQ, GROUP_SEQ, GROUP_NAME 
	FROM EVT_PROMOTION_PRODUCT_GROUP WITH(NOLOCK) 
	GROUP BY 
		SEC_SEQ, GROUP_SEQ, GROUP_NAME
	HAVING SEC_SEQ = @SEC_SEQ 
		AND ( @GROUP_SEQ = 0 OR GROUP_SEQ = @GROUP_SEQ )

END
GO
