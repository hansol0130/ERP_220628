USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PKG_DETAIL_SHOPPING_SELECT
■ DESCRIPTION				: 상품상세 쇼핑정보 리스트
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
CREATE PROC [dbo].[SP_PKG_DETAIL_SHOPPING_SELECT]
	@PRO_CODE VARCHAR(20)
AS 
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SELECT 
		 PRO_CODE
		,SHOP_SEQ
		,SHOP_NAME
		,SHOP_PLACE
		,SHOP_TIME
		,SHOP_REMARK
	FROM PKG_DETAIL_SHOPPING WITH(NOLOCK)
	WHERE PRO_CODE = @PRO_CODE
END 
GO
