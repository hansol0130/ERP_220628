USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_EVT_PROMOTION_PRODUCT_CLICK_SELECT
■ DESCRIPTION				: 프로모션 이벤트 상품 클릭수 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_EVT_PROMOTION_PRODUCT_CLICK_SELECT 11
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2017-05-12		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_EVT_PROMOTION_PRODUCT_CLICK_SELECT]
	@SEC_SEQ INT 	
AS 
BEGIN
	SELECT
		A.GROUP_SEQ, A.GROUP_NAME, SUM(ISNULL(VIEW_CNT, 0)) AS VIEW_CNT
	FROM EVT_PROMOTION_PRODUCT_GROUP A WITH(NOLOCK)
	INNER JOIN EVT_PROMOTION_PRODUCT B WITH(NOLOCK) ON A.SEC_SEQ = B.SEC_SEQ AND A.GROUP_SEQ = B.GROUP_SEQ	
	GROUP BY A.SEC_SEQ, A.GROUP_SEQ, A.GROUP_NAME 	
	HAVING A.SEC_SEQ = @SEC_SEQ
	ORDER BY GROUP_SEQ
END



GO
