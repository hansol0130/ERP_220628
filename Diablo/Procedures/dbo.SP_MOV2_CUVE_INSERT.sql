USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CUVE_INSERT
■ DESCRIPTION				: 입력_큐비메세지
■ INPUT PARAMETER			: CUS_NO, CUR_NO, CUR_TYPE, CUR_TITLE, CUR_MESSAGE, CUVE_ITEM, PRO_CODE, RES_CODE, CUVE_NO, INPUT_TYPE
■ EXEC						: 
    -- SP_MOV2_CUVE_INSERT 8712212, 4, 3, 'title', 'message', '', '', 'RP1703032908', 0, 1		-- 큐비에 메세지 등록 

■ MEMO						: 큐비에 메세지를 입력한다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-29		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CUVE_INSERT]
	@CUS_NO			INT,
	@HIS_NO			INT,
	@CUR_TYPE		INT,
	@CUR_TITLE		VARCHAR(100),
	@CUR_MESSAGE	VARCHAR(1000),
	@CUVE_ITEM    	VARCHAR(200),
	@CUVE_LINK    	VARCHAR(200),
	@PRO_CODE		VARCHAR(20),
	@RES_CODE		VARCHAR(20),
	@CUVE_NO		INT,
	@INPUT_TYPE		INT
AS
BEGIN
	IF @INPUT_TYPE = 1           
		BEGIN
			INSERT INTO CUVE ( CUS_NO, HIS_NO, CUR_TYPE, CUR_TITLE, CUR_MESSAGE, CUVE_ITEM, CUVE_LINK, PRO_CODE, RES_CODE, SEND_DATE)
			VALUES ( @CUS_NO, @HIS_NO, @CUR_TYPE, @CUR_TITLE, @CUR_MESSAGE, @CUVE_ITEM, @CUVE_LINK, @PRO_CODE, @RES_CODE, GETDATE() )

			select @@Identity
		END
	ELSE IF @INPUT_TYPE = 2
		BEGIN
			UPDATE CUVE 
			SET RCV_DATE = GETDATE()
			WHERE CUVE_NO = @CUVE_NO
		END
	ELSE IF @INPUT_TYPE = 3
		BEGIN
			INSERT INTO CUVE ( CUS_NO, HIS_NO, CUR_TYPE, CUR_TITLE, CUR_MESSAGE, CUVE_ITEM, CUVE_LINK, PRO_CODE, RES_CODE, SEND_DATE, RCV_DATE, CONFIRM_DATE)
			VALUES ( @CUS_NO, @HIS_NO, @CUR_TYPE, @CUR_TITLE, @CUR_MESSAGE, @CUVE_ITEM, @CUVE_LINK, @PRO_CODE, @RES_CODE, GETDATE(), GETDATE(), GETDATE() )

			select @@Identity
		END
END           



GO
