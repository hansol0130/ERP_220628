USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ESTI_EMP_ITEM_SELECT_LIST
■ DESCRIPTION				: 직원상담평가 항목 조회
■ INPUT PARAMETER			: 
	@SHEET_CODE				: 상담평가 SHEET CODE
	@ESTI_WOL				: 평가월
	@ESTI_EMP_CODE			: 직원코드
■ OUTPUT PARAMETER			: 
■ EXEC						: EXEC SP_CTI_ESTI_EMP_ITEM_SELECT_LIST 0
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-12-16		곽병삼			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ESTI_EMP_ITEM_SELECT_LIST]
--DECLARE
	@SHEET_CODE		INT,
	@ESTI_WOL		VARCHAR(10),
	@ESTI_EMP_CODE	VARCHAR(7)

AS
SET NOCOUNT ON

	SELECT
		A.SHEET_CODE,
		A.ITEM_CODE,
		B.ITEM_NAME AS UPPER_ITEM_NAME,
		B.VALUE_MAX AS UPPER_ITEM_MAX,
		A.ITEM_NAME,
		A.VALUE_MIN,
		A.VALUE_MAX,
		ISNULL(C.ITEM_VALUE,0) AS ITEM_VALUE,
		C.ITEM_MEMO,
		C.ESTI_WOL
	FROM Sirens.cti.CTI_ESTI_ITEM A
	LEFT OUTER JOIN Sirens.cti.CTI_ESTI_LIST C
	ON C.ESTI_WOL = LEFT(REPLACE(@ESTI_WOL,'-',''),6)
	AND C.SHEET_CODE = A.SHEET_CODE
	AND C.EMP_CODE = @ESTI_EMP_CODE
	AND C.ITEM_CODE = A.ITEM_CODE
	, CTI_ESTI_ITEM B
	WHERE A.SHEET_CODE = @SHEET_CODE
	AND A.ITEM_LEVEL = 2
	AND A.SHEET_CODE = B.SHEET_CODE
	AND B.ITEM_LEVEL = 1
	AND LEFT(A.ITEM_CODE,2) = LEFT(B.ITEM_CODE,2)
	ORDER BY A.ITEM_CODE

SET NOCOUNT OFF
GO
