USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_SHOPPING_SELECT
■ DESCRIPTION				: 마스터 쇼핑정보 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-06-20		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_MASTER_SHOPPING_SELECT]
	@MASTER_CODE VARCHAR(10)
AS 
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SELECT 
		 MASTER_CODE
		,SHOP_SEQ
		,SHOP_NAME
		,SHOP_PLACE
		,SHOP_TIME
		,SHOP_REMARK
	FROM PKG_MASTER_SHOPPING WITH(NOLOCK)
	WHERE MASTER_CODE = @MASTER_CODE
END 
GO
