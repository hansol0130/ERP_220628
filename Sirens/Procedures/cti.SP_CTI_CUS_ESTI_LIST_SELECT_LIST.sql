USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_CUS_ESTI_LIST_SELECT_LIST
■ DESCRIPTION				: 고객평가표 조회
■ INPUT PARAMETER			: 
	@ESTI_WOL				: 평가 기준월
	@SHEET_CODE				: 고객평가 SHEET CODE
	@CUS_NO					: 고객번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 
EXEC SP_CTI_CUS_ESTI_LIST_SELECT_LIST '201412', 1, 6814087

ESTI_WOL SHEET_CODE  SHEET_NAME                                                                                           CUS_NO      ITEM_CODE ITEM_NAME                                                                                            RESULT_ITEM_CODE RESULT_ITEM_NAME                                                                                     RESULT_ITEM_VALUE
-------- ----------- ---------------------------------------------------------------------------------------------------- ----------- --------- ---------------------------------------------------------------------------------------------------- ---------------- ---------------------------------------------------------------------------------------------------- -----------------
201412   1           고객평가표                                                                                                6814087     0100      고객평가질문1                                                                                              0101             매우만족                                                                                                 10
201412   1           고객평가표                                                                                                6814087     0100      고객평가질문1                                                                                              0102             만족                                                                                                   8

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-12-30		곽병삼			최초생성
   2015-02-06		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CUS_ESTI_LIST_SELECT_LIST]
--DECLARE
	@ESTI_WOL	VARCHAR(6),
	@SHEET_CODE	INT,
	@CUS_NO		INT

AS
--SET @ESTI_WOL = '201412'
--SET @SHEET_CODE = 1
--SET @CUS_NO = 6814087

SET NOCOUNT ON

	SELECT
		CUS.ESTI_WOL,
		CUS.SHEET_CODE,
		ESTI.TITLE AS SHEET_NAME,
		CUS.CUS_NO,
		ITEM1.ITEM_CODE,
		ITEM1.ITEM_NAME,
		ITEM2.ITEM_CODE AS RESULT_ITEM_CODE,
		ITEM2.ITEM_NAME AS RESULT_ITEM_NAME,
		ITEM2.ITEM_VALUE AS RESULT_ITEM_VALUE
	FROM sirens.cti.CTI_CUS_ESTI_MASTER CUS, sirens.cti.CTI_CUS_ESTI_SHEET ESTI, sirens.cti.CTI_CUS_ESTI_ITEM ITEM1, sirens.cti.CTI_CUS_ESTI_ITEM ITEM2
	WHERE CUS.ESTI_WOL = @ESTI_WOL
		AND CUS.SHEET_CODE = @SHEET_CODE
		AND CUS.CUS_NO = @CUS_NO
		AND CUS.SHEET_CODE = ESTI.SHEET_CODE
		AND ESTI.SHEET_CODE = ITEM1.SHEET_CODE
		AND ITEM1.ITEM_LEVEL = 1
		AND ESTI.SHEET_CODE = ITEM2.SHEET_CODE
		AND ITEM2.ITEM_LEVEL = 2
		AND LEFT(ITEM1.ITEM_CODE,2) = LEFT(ITEM2.ITEM_CODE,2)
	ORDER BY ITEM2.ITEM_CODE

SET NOCOUNT OFF
GO
