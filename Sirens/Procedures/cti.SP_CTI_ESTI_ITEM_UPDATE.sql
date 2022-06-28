USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ESTI_ITEM_UPDATE
■ DESCRIPTION				: 평가 ITEM 추가/수정
■ INPUT PARAMETER			: 
	@SHEET_CODE				:쉬트코드
	@ITEM_CODE				:항목코드
	@ITEM_NAME				:항목명
	@UPPER_ITEM_CODE		:상위코드
	@ITEM_LEVEL				:항목단계
	@VALUE_MIN				:최소값
	@VALUE_MAX				:최대값
	@MEMO					:메모
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXECUTE SP_CTI_ESTI_ITEM_UPDATE @SHEET_CODE,@ITEM_CODE,@ITEM_NAME,@UPPER_ITEM_CODE,@ITEM_LEVEL,@VALUE_MIN,@VALUE_MAX,@MEMO

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-12-16		곽병삼			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ESTI_ITEM_UPDATE]
--DECLARE
	@SHEET_CODE			INT,
	@ITEM_CODE			VARCHAR(4),
	@ITEM_NAME			NVARCHAR(100),
	@UPPER_ITEM_CODE	VARCHAR(4),
	@ITEM_LEVEL			INT,
	@VALUE_MIN			INT,
	@VALUE_MAX			INT,
	@MEMO				NVARCHAR(1000)

AS
--SET @SHEET_CODE = 4
--SET @ITEM_CODE = 'N'
--SET @ITEM_NAME = '고객맞이 인사말'
--SET @UPPER_ITEM_CODE = '0100'
--SET @ITEM_LEVEL = 2
--SET @VALUE_MIN = 0
--SET @VALUE_MAX = 10
--SET @MEMO = NULL

IF @ITEM_CODE = 'N'
BEGIN

	IF @ITEM_LEVEL = 1
	BEGIN
		SELECT
			@ITEM_CODE = RIGHT('0'+ CAST(ISNULL(MAX(CAST(LEFT(ITEM_CODE,2) AS SMALLINT))+1,1) AS VARCHAR(2)),2) + '00'
		FROM Sirens.cti.CTI_ESTI_ITEM
		WHERE SHEET_CODE = @SHEET_CODE
		AND ITEM_LEVEL = @ITEM_LEVEL;
	END
	ELSE
	BEGIN
		SELECT
			@ITEM_CODE = LEFT(@UPPER_ITEM_CODE,2) + RIGHT('0'+CAST(ISNULL(MAX(CAST(RIGHT(ITEM_CODE,2) AS SMALLINT))+1,1) AS VARCHAR(2)),2)
		FROM Sirens.cti.CTI_ESTI_ITEM
		WHERE SHEET_CODE = @SHEET_CODE
		AND ITEM_LEVEL = @ITEM_LEVEL
		AND LEFT(ITEM_CODE,2) = LEFT(@UPPER_ITEM_CODE,2);
	END


	INSERT INTO Sirens.cti.CTI_ESTI_ITEM
	VALUES (
		@SHEET_CODE,
		@ITEM_CODE,
		@ITEM_NAME,
		@ITEM_LEVEL,
		@VALUE_MIN,
		@VALUE_MAX,
		@MEMO
	);
END
ELSE
BEGIN
	UPDATE	Sirens.cti.CTI_ESTI_ITEM
	SET	ITEM_NAME = @ITEM_NAME,
		VALUE_MIN = @VALUE_MIN,
		VALUE_MAX = @VALUE_MAX,
		MEMO = @MEMO
	WHERE	SHEET_CODE = @SHEET_CODE
		AND ITEM_CODE = @ITEM_CODE
END
GO
