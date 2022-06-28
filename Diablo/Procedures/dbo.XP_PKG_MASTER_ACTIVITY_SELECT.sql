USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PKG_MASTER_ACTIVITY_SELECT
■ DESCRIPTION				: 마스터 액티비티 리스트 조회  
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2020-02-03		오준혁			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_PKG_MASTER_ACTIVITY_SELECT]
	 @MASTER_CODE     VARCHAR(10)
    ,@MASTER_NAME     VARCHAR(10)
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT MASTER_CODE
	      ,MASTER_NAME
	FROM   PKG_MASTER
	WHERE  SHOW_YN = 'Y'
	       AND SECTION_YN = 'N'
	       AND ATT_CODE = 'Q'
	       AND MASTER_CODE LIKE @MASTER_CODE + '%'
	       AND MASTER_NAME LIKE @MASTER_NAME + '%'
	       
	 
END
GO
