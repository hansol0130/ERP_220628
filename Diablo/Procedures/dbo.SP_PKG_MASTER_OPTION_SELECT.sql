USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_OPTION_SELECT
■ DESCRIPTION				: 마스터 옵션정보 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-07-25		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_MASTER_OPTION_SELECT]
	@MASTER_CODE VARCHAR(10)
AS 
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SELECT 
		 MASTER_CODE
		,OPT_SEQ
		,OPT_NAME
		,OPT_CONTENT
		,OPT_PRICE
		,OPT_USETIME
		,OPT_REPLACE
		,OPT_PLACE
		,OPT_COMPANION
	FROM PKG_MASTER_OPTION WITH(NOLOCK)
	WHERE MASTER_CODE = @MASTER_CODE
END 

GO
