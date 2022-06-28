USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PKG_DETAIL_SHOPPING_DELETE
■ DESCRIPTION				: 상품상세 쇼핑정보 삭제
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
CREATE PROC [dbo].[SP_PKG_DETAIL_SHOPPING_DELETE]
	@PRO_CODE VARCHAR(20)
AS 
BEGIN	
	SET NOCOUNT OFF;

	IF EXISTS (SELECT 1 FROM PKG_DETAIL_SHOPPING WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
	BEGIN
		DELETE FROM PKG_DETAIL_SHOPPING WHERE PRO_CODE = @PRO_CODE
	END
END 
GO
