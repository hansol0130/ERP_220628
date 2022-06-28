USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_PKG_DETAIL_OPTION_SELECT
■ DESCRIPTION				: 행사 옵션정보 리스트
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
CREATE PROC [dbo].[SP_PKG_DETAIL_OPTION_SELECT]
	@PRO_CODE VARCHAR(20)
AS 
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SELECT 
		 PRO_CODE
		,OPT_SEQ
		,OPT_NAME
		,OPT_CONTENT
		,OPT_PRICE
		,OPT_USETIME
		,OPT_REPLACE
		,OPT_PLACE
		,OPT_COMPANION
	FROM PKG_DETAIL_OPTION WITH(NOLOCK)
	WHERE PRO_CODE = @PRO_CODE
END 


GO
