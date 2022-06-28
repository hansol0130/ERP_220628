USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ARG_INVOICE_STATUS_UPDATE
■ DESCRIPTION				: 수배현황 인보이스 상태 업데이트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	DECLARE @ARG_SEQ_NO INT ,
		    @GRP_SEQ_NO INT,
	        @ARG_DETAIL_STATUS INT,
			@LAND_SEQ_NO INT,
			@NEW_CODE VARCHAR(7)

	SET @ARG_SEQ_NO = 3
	SET @GRP_SEQ_NO = 3
	SET @ARG_DETAIL_STATUS = 1
	SET @LAND_SEQ_NO = 1
	SET @NEW_CODE = 'L130142'

	EXEC DBO.XP_ARG_INVOICE_STATUS_UPDATE @ARG_SEQ_NO, @GRP_SEQ_NO, @ARG_DETAIL_STATUS, @LAND_SEQ_NO, @NEW_CODE
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-10-14		김완기			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_INVOICE_STATUS_UPDATE]
	@ARG_SEQ_NO INT ,
	@GRP_SEQ_NO INT,
	@ARG_DETAIL_STATUS INT,
	@LAND_SEQ_NO INT,
	@NEW_CODE VARCHAR(7)
AS 
BEGIN

	UPDATE ARG_DETAIL
	SET ARG_DETAIL_STATUS = @ARG_DETAIL_STATUS, LAND_SEQ_NO = @LAND_SEQ_NO, EDT_CODE = @NEW_CODE, EDT_DATE = getdate()
	WHERE ARG_SEQ_NO =  @ARG_SEQ_NO AND GRP_SEQ_NO = @GRP_SEQ_NO


END 

-------------------------------------------------------------------------------------
GO
