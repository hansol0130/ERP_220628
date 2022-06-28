USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_HISTORY_INSERT
■ DESCRIPTION				: 입력_히스토리정보
■ INPUT PARAMETER			: HIS_TYPE, MASTER_CODE, EVT_SEQ, MASTER_SEQ, BOARD_SEQ, KEYWORD
■ HIS_TYPE					: 1: MASTER_CODE, 2: EVT_SEQ, 3: MASTER_SEQ, BOARD_SEQ, 5: KEYWORD
■ EXEC						: 
    -- SP_MOV2_HISTORY_INSERT 8505125, 5, '', 0, 0, 0, '동남아' 

■ MEMO						: 히스토리 정보를 입력한다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-07-27		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_HISTORY_INSERT]
	@CUS_NO			INT,
	@HIS_TYPE		INT,
	@MASTER_CODE	VARCHAR(20),
	@EVT_SEQ		INT,
	@MASTER_SEQ		INT,
	@BOARD_SEQ		INT,
	@KEYWORD		VARCHAR(100)
AS
BEGIN
	DECLARE @COUNT_NO INT
	SELECT @COUNT_NO = COUNT(*) FROM CUS_MASTER_HISTORY WITH(NOLOCK)
	WHERE CUS_NO = @CUS_NO 
		AND HIS_TYPE = @HIS_TYPE
		AND MASTER_CODE = @MASTER_CODE
		AND EVT_SEQ = @EVT_SEQ
		AND MASTER_SEQ = @MASTER_SEQ
		AND BOARD_SEQ = @BOARD_SEQ
		AND KEYWORD = @KEYWORD


	IF @COUNT_NO = 0 
		INSERT INTO CUS_MASTER_HISTORY ( CUS_NO, HIS_TYPE, MASTER_CODE, EVT_SEQ, MASTER_SEQ, BOARD_SEQ, KEYWORD, HIS_DATE)
		VALUES ( @CUS_NO, @HIS_TYPE, @MASTER_CODE, @EVT_SEQ, @MASTER_SEQ, @BOARD_SEQ, @KEYWORD, GETDATE() )
	ELSE
		UPDATE CUS_MASTER_HISTORY
		SET HIS_DATE = GETDATE()
		WHERE CUS_NO = @CUS_NO 
			AND HIS_TYPE = @HIS_TYPE
			AND MASTER_CODE = @MASTER_CODE
			AND EVT_SEQ = @EVT_SEQ
			AND MASTER_SEQ = @MASTER_SEQ
			AND BOARD_SEQ = @BOARD_SEQ
			AND KEYWORD = @KEYWORD

END           



GO
