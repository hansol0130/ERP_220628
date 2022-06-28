USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PKG_MASTER_CONNECT_SELECT
■ DESCRIPTION				: 액티비티 리스트 조회  
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
CREATE PROC [dbo].[XP_PKG_MASTER_CONNECT_SELECT]
	@MASTER_CODE         VARCHAR(10)
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	
	SELECT a.CON_MASTER_CODE AS 'MASTER_CODE'
	      ,b.MASTER_NAME
	FROM   PKG_MASTER_CONNECT a
	       INNER JOIN PKG_MASTER b
	            ON a.CON_MASTER_CODE = b.MASTER_CODE
	WHERE  a.MASTER_CODE = @MASTER_CODE
	 
END
GO
