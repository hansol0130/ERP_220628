USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_EVT_PROMOTION_PRODUCT_SELECT
■ DESCRIPTION				: 프로모션 이벤트 상품 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
EXEC SP_EVT_PROMOTION_PRODUCT_SELECT 11, 0
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-04-25		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[SP_EVT_PROMOTION_PRODUCT_SELECT]
	@SEC_SEQ INT,
	@GROUP_SEQ INT
AS 
BEGIN	

	SELECT
		A.SEC_SEQ, A.GROUP_SEQ, A.MASTER_CODE, A.PRODUCT_FEATURES, A.REGION_NAME,
		B.LOW_PRICE AS PRICE, DBO.FN_GET_TOUR_NIGHY_DAY_TEXT(A.MASTER_CODE,1) AS [TOUR_NIGHT_DAY], ISNULL(VIEW_CNT, 0) AS VIEW_CNT
	FROM EVT_PROMOTION_PRODUCT A WITH(NOLOCK)
	LEFT JOIN PKG_MASTER B WITH(NOLOCK) 
		ON A.MASTER_CODE = B.MASTER_CODE
	WHERE 
		A.SEC_SEQ = @SEC_SEQ AND (@GROUP_SEQ = 0 OR A.GROUP_SEQ = @GROUP_SEQ)

END
GO
