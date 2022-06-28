USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_ERP_RES_HOTEL_MASTER_UPDATE
■ DESCRIPTION				: BTMS ERP 호텔 예약 마스터 정보 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-20		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_ERP_RES_HOTEL_MASTER_UPDATE]
	@RES_CODE			CHAR(12),
	@PRO_NAME			NVARCHAR(100),
	@COMM_RATE			NUMERIC(4,2),
	@COMM_AMT			DECIMAL,
	@LAST_PAY_DATE		DATETIME,
	@LAST_CXL_DATE		DATETIME,
	@EDT_CODE			CHAR(7),
	@ERROR_MSG			VARCHAR(1000) OUTPUT
AS 
BEGIN

BEGIN TRY
	BEGIN TRAN

	UPDATE RES_MASTER_damo SET
		PRO_NAME = @PRO_NAME, COMM_RATE = @COMM_RATE, COMM_AMT = @COMM_AMT, LAST_PAY_DATE = @LAST_PAY_DATE, EDT_CODE = @EDT_CODE, EDT_DATE = GETDATE()
	WHERE RES_CODE = @RES_CODE;

	UPDATE RES_HTL_ROOM_MASTER SET LAST_CXL_DATE = @LAST_CXL_DATE WHERE RES_CODE = @RES_CODE;

	COMMIT TRAN
END TRY
BEGIN CATCH

	SELECT @ERROR_MSG = ERROR_MESSAGE();

	ROLLBACK TRAN
END CATCH

END



GO
