USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_DEVICE_MASTER_INSERT_UPDATE
■ DESCRIPTION				: 입력_디바이스정보_수정
■ INPUT PARAMETER			: APP_CODE, DEVICE_NO, CUS_DEVICE_ID, REMARK, NEW_CODE
■ EXEC						: 
    -- SP_MOV2_DEVICE_MASTER_INSERT_UPDATE

■ MEMO						: 디바이스정보 입력 및 수정
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-23		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_DEVICE_MASTER_INSERT_UPDATE]
	@APP_CODE		INT,
	@DEVICE_NO		VARCHAR(512),
	@CUS_DEVICE_ID	VARCHAR(4000),
	@REMARK			VARCHAR(2000),
	@NEW_CODE		CHAR(7)
	
AS
BEGIN
	DECLARE @DEVICE_ID VARCHAR(4000);  --디바이스 토큰아이디
	SELECT @DEVICE_ID = A.CUS_DEVICE_ID FROM DEVICE_MASTER A WITH(NOLOCK) WHERE A.DEVICE_NO = @DEVICE_NO

	IF @DEVICE_ID IS NULL
		BEGIN
			INSERT INTO DEVICE_MASTER (APP_CODE, DEVICE_NO, CUS_DEVICE_ID, REMARK, NEW_CODE, NEW_DATE ) 
			  VALUES ( @APP_CODE, @DEVICE_NO, @CUS_DEVICE_ID, @REMARK, @NEW_CODE, GETDATE()  )

		END
	ELSE 
		BEGIN
			IF @DEVICE_ID <> @CUS_DEVICE_ID
				BEGIN	
					UPDATE DEVICE_MASTER 
						SET CUS_DEVICE_ID = @CUS_DEVICE_ID, 
						REMARK = @REMARK, 
						NEW_DATE = GETDATE(),
						APP_CODE = @APP_CODE
					WHERE DEVICE_NO = @DEVICE_NO
				END
		END
END           



GO
