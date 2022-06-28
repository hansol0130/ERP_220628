USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_DHS_HOTEL_NAME_LIST_SELECT
■ DESCRIPTION					: 조회_호텔명_리스트
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-11		오준혁			최초생성
   2022-01-14		김성호			PKG_AGT_MASTER 스키마 변경으로 SP 수정
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DHS_HOTEL_NAME_LIST_SELECT]
	@AGT_CODE VARCHAR(5)
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	-- 호텔명
	SELECT b.MASTER_CODE
		  ,b.MASTER_NAME
	FROM   dbo.PKG_AGT_MASTER a
		   INNER JOIN dbo.PKG_MASTER b
				ON  b.MASTER_CODE = a.TOT_CODE
	WHERE  a.AGT_CODE = @AGT_CODE

END
GO
