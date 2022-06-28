USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_DISPLAY_SCREEN_SELECT
■ DESCRIPTION				: ERP 전광판 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
		EXEC SP_DISPLAY_SCREEN_SELECT 0
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-09-16		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_DISPLAY_SCREEN_SELECT]
	@ORDER_NO INT
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	IF EXISTS (
		SELECT TOP 1 1 FROM PUB_DISPLAY_SCREEN WITH(NOLOCK)	WHERE ORDER_NO > @ORDER_NO AND USE_YN = 'Y'
	)
	BEGIN
		SELECT TOP 1
			SEQ_NO, TITLE, CONTENT, USE_YN, AUTO_YN, ORDER_NO, FILE_PATH, NEW_CODE, NEW_DATE, EDT_CODE, EDT_DATE
		FROM PUB_DISPLAY_SCREEN WITH(NOLOCK)	
		WHERE ORDER_NO > @ORDER_NO AND USE_YN = 'Y'
		ORDER BY ORDER_NO ASC
	END	
	ELSE
	BEGIN
		SELECT TOP 1
			SEQ_NO, TITLE, CONTENT, USE_YN, AUTO_YN, ORDER_NO, FILE_PATH, NEW_CODE, NEW_DATE, EDT_CODE, EDT_DATE
		FROM PUB_DISPLAY_SCREEN WITH(NOLOCK)	
		WHERE ORDER_NO > 0 AND USE_YN = 'Y'
		ORDER BY ORDER_NO ASC		
	END
END



GO
