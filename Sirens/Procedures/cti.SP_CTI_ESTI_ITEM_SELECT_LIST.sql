USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ESTI_ITEM_SELECT_LIST
■ DESCRIPTION				: 상담평가 항목 조회
■ INPUT PARAMETER			: 
	@SHEET_CODE				: 상담평가 SHEET CODE
■ OUTPUT PARAMETER			: 
■ EXEC						: EXEC SP_CTI_ESTI_ITEM_SELECT_LIST 0
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-12-10		곽병삼			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ESTI_ITEM_SELECT_LIST]
--DECLARE
	@SHEET_CODE	INT

AS
SET NOCOUNT ON

	SELECT
		SHEET_CODE,
		ITEM_CODE,
		ITEM_NAME,
		ITEM_LEVEL,
		VALUE_MIN,
		VALUE_MAX,
		MEMO
	FROM Sirens.cti.CTI_ESTI_ITEM
	WHERE SHEET_CODE = @SHEET_CODE
	ORDER BY ITEM_CODE

SET NOCOUNT OFF


GO
