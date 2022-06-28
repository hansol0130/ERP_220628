USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_APP_RECEIVE_INSERT
■ DESCRIPTION				: 입력_앱수신정보_비회원가능
■ INPUT PARAMETER			: MSG_SEQ_NO, RES_CODE, RES_SEQ_NO, CUS_NO, OS_TYPE, CUS_DEVICE_ID
■ EXEC						: 
    -- EXEC SP_MOV2_APP_RECEIVE_INSERT 98483, NULL, 2, 0, 1

■ MEMO						: 앱수신정보를 입력한다. 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-09-07		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_APP_RECEIVE_INSERT]
	@MSG_SEQ_NO		VARCHAR(20),
	@RES_CODE		VARCHAR(20),
	@RES_SEQ_NO		VARCHAR(20),
	@CUS_NO			VARCHAR(20),
	@OS_TYPE	    VARCHAR(100),
	@CUS_DEVICE_ID	VARCHAR(1000)
AS
BEGIN
	DECLARE @TMP_NO INT
	SELECT @TMP_NO = ISNULL(MAX(SEQ_NO) + 1, 1) FROM APP_RECEIVE WHERE MSG_SEQ_NO = @MSG_SEQ_NO
	IF @CUS_NO <> 0
		BEGIN
			INSERT INTO APP_RECEIVE(MSG_SEQ_NO, SEQ_NO, RES_CODE, RES_SEQ_NO, CUS_NO, OS_TYPE, RCV_TYPE, CUS_DEVICE_ID)
			VALUES (@MSG_SEQ_NO, @TMP_NO, @RES_CODE, @RES_SEQ_NO, @CUS_NO, @OS_TYPE, 2, @CUS_DEVICE_ID)
		END
	ELSE 
		BEGIN
			INSERT INTO APP_RECEIVE(MSG_SEQ_NO, SEQ_NO, RES_CODE, RES_SEQ_NO, OS_TYPE, RCV_TYPE, CUS_DEVICE_ID)
			VALUES (@MSG_SEQ_NO, @TMP_NO, @RES_CODE, @RES_SEQ_NO, @OS_TYPE, 2, @CUS_DEVICE_ID)
		END

	SELECT @TMP_NO
END           



GO
