USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_DHS_ERP_HOTEL_NAME_LIST_SELECT
■ DESCRIPTION					: 조회_ERP호텔명_리스트
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-18		오준혁			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DHS_ERP_HOTEL_NAME_LIST_SELECT]
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	-- 호텔명
	SELECT a.MASTER_CODE
		  ,'<' + a.MASTER_CODE + '> ' + a.MASTER_NAME AS 'MASTER_NAME'
	FROM   dbo.PKG_MASTER a
	WHERE a.ATT_CODE = '3'
	ORDER BY a.NEXT_DATE DESC
	
END
GO
