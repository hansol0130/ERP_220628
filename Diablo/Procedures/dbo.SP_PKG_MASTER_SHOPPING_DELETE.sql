USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_SHOPPING_DELETE
■ DESCRIPTION				: 마스터 쇼핑정보 삭제
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
CREATE PROC [dbo].[SP_PKG_MASTER_SHOPPING_DELETE]
	@MASTER_CODE VARCHAR(10)
AS 
BEGIN	
	SET NOCOUNT OFF;

	IF EXISTS (SELECT 1 FROM PKG_MASTER_SHOPPING WITH(NOLOCK) WHERE MASTER_CODE = @MASTER_CODE)
	BEGIN
		DELETE FROM PKG_MASTER_SHOPPING WHERE MASTER_CODE = @MASTER_CODE
	END
END 
GO
