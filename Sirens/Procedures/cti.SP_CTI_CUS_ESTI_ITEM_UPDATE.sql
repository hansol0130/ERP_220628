USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_CUS_ESTI_ITEM_UPDATE
■ DESCRIPTION				: 고객평가 ITEM 추가/수정
■ INPUT PARAMETER			: 
	@SHEET_CODE				: 쉬트 코드
	@ITEM_CODE				: 항목코드
	@ITEM_NAME				: 항목명
	@UPPER_ITEM_CODE		: 상위 항목코드
	@ITEM_LEVEL				: 항목레벨
	@ITEM_VALUE				: 항목값
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXECUTE SP_CTI_CUS_ESTI_ITEM_UPDATE @SHEET_CODE,@ITEM_CODE,@ITEM_NAME,@UPPER_ITEM_CODE,@ITEM_LEVEL,@ITEM_VALUE

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-12-29		곽병삼			최초생성
   2015-02-06		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CUS_ESTI_ITEM_UPDATE]
--DECLARE
	@SHEET_CODE			INT,
	@ITEM_CODE			VARCHAR(4),
	@ITEM_NAME			NVARCHAR(100),
	@UPPER_ITEM_CODE	VARCHAR(4),
	@ITEM_LEVEL			INT,
	@ITEM_VALUE			INT

AS
--SET @SHEET_CODE = 1
--SET @ITEM_CODE = 'N'
--SET @ITEM_NAME = '고객평가 질문1'
--SET @UPPER_ITEM_CODE = NULL
--SET @ITEM_LEVEL = 1
--SET @ITEM_VALUE = 10

IF @ITEM_CODE = 'N'
BEGIN

	IF @ITEM_LEVEL = 1
	BEGIN
		SELECT
			@ITEM_CODE = RIGHT('0'+ CAST(ISNULL(MAX(CAST(LEFT(ITEM_CODE,2) AS SMALLINT))+1,1) AS VARCHAR(2)),2) + '00'
		FROM sirens.cti.CTI_CUS_ESTI_ITEM
		WHERE SHEET_CODE = @SHEET_CODE
		AND ITEM_LEVEL = @ITEM_LEVEL;
	END
	ELSE
	BEGIN
		SELECT
			@ITEM_CODE = LEFT(@UPPER_ITEM_CODE,2) + RIGHT('0'+CAST(ISNULL(MAX(CAST(RIGHT(ITEM_CODE,2) AS SMALLINT))+1,1) AS VARCHAR(2)),2)
		FROM sirens.cti.CTI_CUS_ESTI_ITEM
		WHERE SHEET_CODE = @SHEET_CODE
		AND ITEM_LEVEL = @ITEM_LEVEL
		AND LEFT(ITEM_CODE,2) = LEFT(@UPPER_ITEM_CODE,2);
	END


	INSERT INTO sirens.cti.CTI_CUS_ESTI_ITEM
	VALUES (
		@SHEET_CODE,
		@ITEM_CODE,
		@ITEM_LEVEL,
		@ITEM_NAME,
		@ITEM_VALUE
	);
END
ELSE
BEGIN
	UPDATE	sirens.cti.CTI_CUS_ESTI_ITEM
	SET	ITEM_NAME = @ITEM_NAME,
		ITEM_VALUE = @ITEM_VALUE
	WHERE	SHEET_CODE = @SHEET_CODE
		AND ITEM_CODE = @ITEM_CODE
END
GO
