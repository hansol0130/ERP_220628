USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_CUS_ESTI_ITEM_SELECT_LIST
■ DESCRIPTION				: 상담평가 항목 조회
■ INPUT PARAMETER			: 
	@SHEET_CODE				: 상담평가 SHEET CODE
	@ITEM_CODE				: 항목코드
	@ITEM_LEVEL				: 항목 단계
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_CTI_CUS_ESTI_ITEM_SELECT_LIST 1,'0101',1

	SHEET_CODE  ITEM_CODE ITEM_NAME                                                                                            ITEM_LEVEL  ITEM_VALUE  MODIFY_FLAG
----------- --------- ---------------------------------------------------------------------------------------------------- ----------- ----------- -----------
1           0100      고객평가질문1                                                                                              1           10          Y
1           0200      고객평가질문2                                                                                              1           20          Y


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-12-24		곽병삼			최초생성
   2015-02-06		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CUS_ESTI_ITEM_SELECT_LIST]
--DECLARE
	@SHEET_CODE	INT,
	@ITEM_CODE	VARCHAR(4),
	@ITEM_LEVEL	INT

AS
SET NOCOUNT ON

	IF @ITEM_LEVEL = 1
	BEGIN
		SELECT
			ITEM.SHEET_CODE,
			ITEM.ITEM_CODE,
			ITEM.ITEM_NAME,
			ITEM.ITEM_LEVEL,
			ITEM.ITEM_VALUE,
			SHEET.MODIFY_FLAG
		FROM sirens.cti.CTI_CUS_ESTI_ITEM ITEM, sirens.cti.CTI_CUS_ESTI_SHEET SHEET
		WHERE ITEM.SHEET_CODE = @SHEET_CODE
		AND ITEM.ITEM_LEVEL = @ITEM_LEVEL
		AND ITEM.SHEET_CODE = SHEET.SHEET_CODE
		ORDER BY ITEM.ITEM_CODE
	END
	ELSE
	BEGIN
		SELECT
			ITEM.SHEET_CODE,
			ITEM.ITEM_CODE,
			ITEM.ITEM_NAME,
			ITEM.ITEM_LEVEL,
			ITEM.ITEM_VALUE,
			SHEET.MODIFY_FLAG
		FROM sirens.cti.CTI_CUS_ESTI_ITEM ITEM, sirens.cti.CTI_CUS_ESTI_SHEET SHEET
		WHERE ITEM.SHEET_CODE = @SHEET_CODE
		AND ITEM.ITEM_LEVEL = @ITEM_LEVEL
		AND LEFT(ITEM.ITEM_CODE,2) = LEFT(@ITEM_CODE,2)
		AND ITEM.SHEET_CODE = SHEET.SHEET_CODE
		ORDER BY ITEM.ITEM_CODE
	END

SET NOCOUNT OFF
GO
