USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_ERP_RES_MASTER_COMMON_SELECT
■ DESCRIPTION				: BTMS 예약 마스터 공통정보 검색
■ INPUT PARAMETER			: 
	@RES_CODE				: 예약코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_COM_ERP_RES_MASTER_COMMON_SELECT 'RH1603182784';

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-22		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_ERP_RES_MASTER_COMMON_UPDATE]
	@RES_CODE		VARCHAR(20),
	@SALE_COM_CODE	VARCHAR(10),
	@CUS_NO			INT,
	@NOR_TEL1		VARCHAR(6),
	@NOR_TEL2		VARCHAR(5),
	@NOR_TEL3		VARCHAR(5),
	@RES_EMAIL		VARCHAR(100),
	@ETC			NVARCHAR(MAX),
	@SENDING_REMARK	NVARCHAR(1000),
	@CUS_RESPONSE	NVARCHAR(2000),
	@CARD_PROVE		VARCHAR(4000),
	@STAY_ADDRESS	VARCHAR(100),
	@ERROR_MSG		VARCHAR(1000) OUTPUT
AS 
BEGIN

BEGIN TRY
	BEGIN TRAN

	-- 예약마스터 업데이트
	UPDATE RES_MASTER_damo SET SALE_COM_CODE = @SALE_COM_CODE, NOR_TEL1 = @NOR_TEL1, NOR_TEL2 = @NOR_TEL2, NOR_TEL3 = @NOR_TEL3, RES_EMAIL = @RES_EMAIL
		, ETC = @ETC, SENDING_REMARK = @SENDING_REMARK, CUS_RESPONSE = @CUS_RESPONSE, CARD_PROVE = (CASE WHEN @CARD_PROVE IS NULL THEN CARD_PROVE ELSE @CARD_PROVE END)
	WHERE RES_CODE = @RES_CODE

	-- 항공예약만 업데이트
	IF EXISTS(SELECT 1 FROM RES_MASTER_damo A WITH(NOLOCK) WHERE RES_CODE = @RES_CODE AND PRO_TYPE = 2) AND @STAY_ADDRESS IS NOT NULL
	BEGIN
		UPDATE RES_AIR_DETAIL SET STAY_ADDRESS = @STAY_ADDRESS WHERE RES_CODE = @RES_CODE
	END

	COMMIT TRAN
END TRY
BEGIN CATCH

	SELECT @ERROR_MSG = ERROR_MESSAGE();

	ROLLBACK TRAN
END CATCH

END 

GO
