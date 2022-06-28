USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_DISPLAY_SCREEN_MANAGE_SELECT
■ DESCRIPTION				: ERP 전광판 관리 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-09-16		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_DISPLAY_SCREEN_MANAGE_SELECT]
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	SELECT 
		SEQ_NO, TITLE, CONTENT, USE_YN, AUTO_YN, ORDER_NO, NEW_CODE, NEW_DATE, EDT_CODE, EDT_DATE
	FROM PUB_DISPLAY_SCREEN WITH(NOLOCK)	
	ORDER BY ORDER_NO ASC

END
GO
