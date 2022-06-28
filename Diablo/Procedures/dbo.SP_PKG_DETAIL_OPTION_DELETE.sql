USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_PKG_DETAIL_OPTION_DELETE
■ DESCRIPTION				: 행사 옵션정보 삭제
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
CREATE PROC [dbo].[SP_PKG_DETAIL_OPTION_DELETE]
	@PRO_CODE VARCHAR(20)
AS 
BEGIN	
	SET NOCOUNT OFF;

	IF EXISTS (SELECT 1 FROM PKG_DETAIL_OPTION WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
	BEGIN
		DELETE FROM PKG_DETAIL_OPTION WHERE PRO_CODE = @PRO_CODE
	END
END 



GO
