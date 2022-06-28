USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_MEMO_LIST_INSERT
■ DESCRIPTION				: 입력_메모정보
■ INPUT PARAMETER			: RES_CODE, SEQ_NO, DAY_NO, CNT_CODE, MEMO_TITLE, MEMO_CONTENT, MEMO_NO, INPUT_TYPE
■ EXEC						: 
    -- SP_MOV2_MEMO_LIST_INSERT 'RP1703032908', '1', '1', '19755', 'title', 'content', 0, 1	 -- 메모등록

■ MEMO						: 메모정보를 입력한다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_MEMO_LIST_INSERT]
	@RES_CODE		VARCHAR(20),
	@SEQ_NO			VARCHAR(20),
	@DAY_NO			VARCHAR(20),
	@CNT_CODE		VARCHAR(20),
	@MEMO_TITLE     VARCHAR(100),
	@MEMO_CONTENT	VARCHAR(4000),
	@MEMO_NO		INT,
	@INPUT_TYPE		INT
AS
BEGIN
	IF @INPUT_TYPE = 1           
		BEGIN
			DECLARE @TMP_NO INT
			SELECT @TMP_NO = ISNULL(MAX(T.MEMO_NO) + 1, 1) FROM TRAVEL_MEMO T WITH (NOLOCK) WHERE T.RES_CODE = @RES_CODE AND T.SEQ_NO = @SEQ_NO

			INSERT INTO TRAVEL_MEMO ( MEMO_NO, RES_CODE, SEQ_NO, DAY_NO, CNT_CODE, MEMO_TITLE, MEMO_CONTENT, NEW_DATE)
			VALUES ( @TMP_NO, @RES_CODE, @SEQ_NO, @DAY_NO, @CNT_CODE, @MEMO_TITLE, @MEMO_CONTENT, GETDATE() )

			SELECT @TMP_NO
		END
	ELSE IF @INPUT_TYPE = 2
		BEGIN
			UPDATE TRAVEL_MEMO 
			SET DAY_NO = @DAY_NO, 
				CNT_CODE = @CNT_CODE, 
				MEMO_TITLE = @MEMO_TITLE, 
				MEMO_CONTENT = @MEMO_CONTENT, 
				NEW_DATE = GETDATE()
			WHERE RES_CODE = @RES_CODE
				AND SEQ_NO = @SEQ_NO
				AND MEMO_NO = @MEMO_NO
		END
	ELSE
		BEGIN
			DELETE FROM TRAVEL_MEMO
			WHERE RES_CODE = @RES_CODE AND SEQ_NO = @SEQ_NO AND MEMO_NO = @MEMO_NO
		END
END           



GO
