USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_EVT_PROMOTION_PRODUCT
■ DESCRIPTION				: 프로모션 이벤트 상품
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC XP_EVT_PROMOTION_PRODUCT 11, 1
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2017-04-28		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_EVT_PROMOTION_PRODUCT]
	@SEC_SEQ INT,
	@CATEGORY INT
AS 
BEGIN
	SELECT 
		A.CATEGORY, A.SEC_SEQ, A.GROUP_SEQ, A.GROUP_NAME, B.MASTER_CODE, B.PRODUCT_FEATURES, REGION_NAME,
		C.LOW_PRICE AS PRICE, DBO.FN_GET_TOUR_NIGHY_DAY_TEXT(B.MASTER_CODE,1) AS [TOUR_NIGHT_DAY], B.VIEW_CNT
	FROM EVT_PROMOTION_PRODUCT_GROUP A WITH(NOLOCK) 
	INNER JOIN 
		EVT_PROMOTION_PRODUCT B WITH(NOLOCK) ON A.SEC_SEQ = B.SEC_SEQ AND A.GROUP_SEQ = B.GROUP_SEQ
	LEFT JOIN 
		PKG_MASTER C WITH(NOLOCK) ON B.MASTER_CODE = C.MASTER_CODE
	WHERE 
	 	(@CATEGORY = 0 OR A.CATEGORY = @CATEGORY) AND A.SEC_SEQ = @SEC_SEQ
	ORDER BY GROUP_SEQ;	
END
GO
