USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_CTI_ERP_RES_CALL_RESULT_UPDATE
■ DESCRIPTION				: 출발전 고객 상담처리
■ INPUT PARAMETER			: 
	@CUS_NO
	@ERP_RES_CALL_RESULT
	@ERP_RES_CALL_CONTENT
	@RESULT_CONSULT_SEQ
	@RES_CODE
	@DEP_DATE
	@EDT_CODE
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXECUTE SP_CTI_ERP_RES_CALL_RESULT_UPDATE

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-10		곽병삼			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ERP_RES_CALL_RESULT_UPDATE]
--DECLARE
	@CUS_NO	INT,
	@ERP_RES_CALL_RESULT	VARCHAR(1),
	@ERP_RES_CALL_CONTENT	VARCHAR(1000),
	@RESULT_CONSULT_SEQ		VARCHAR(14),
	@RES_CODE				VARCHAR(12),
	@DEP_DATE				VARCHAR(20),
	@EDT_CODE				VARCHAR(7)

AS

--SET @CUS_NO  = 5430400
--SET @ERP_RES_CALL_RESULT = '1'
--SET @ERP_RES_CALL_CONTENT = '테스트'
--SET @RESULT_CONSULT_SEQ = '20141030000036'
--SET @RES_CODE = 'RP1411061978'
--SET @DEP_DATE = '2014-12-31 00:00'
--SET @EDT_CODE = '2012010'

DECLARE
	@ERP_RES_CALL_SEQ	INT

SELECT
	@ERP_RES_CALL_SEQ = ERP_RES_CALL_SEQ
FROM CTI_ERP_RES_CALL_RESULT
WHERE CUS_NO = @CUS_NO
AND RES_CODE = @RES_CODE

IF @ERP_RES_CALL_SEQ IS NULL
BEGIN
	INSERT INTO CTI_ERP_RES_CALL_RESULT (
		ERP_RES_CALL_SEQ,
		ERP_RES_CALL_RESULT,
		ERP_RES_CALL_CONTENT,
		RESULT_CONSULT_SEQ,
		RES_CODE,
		CUS_NO,
		DEP_DATE,
		NEW_DATE,
		NEW_CODE,
		EDT_DATE,
		EDT_CODE )
	VALUES (
		NEXT VALUE FOR CTI_CONSULT_RES_SEQ,
		@ERP_RES_CALL_RESULT,
		@ERP_RES_CALL_CONTENT,
		@RESULT_CONSULT_SEQ,
		@RES_CODE,
		@CUS_NO,
		CAST(@DEP_DATE AS DATETIME),
		GETDATE(),
		@EDT_CODE,
		GETDATE(),
		@EDT_CODE );

END
ELSE
BEGIN
	UPDATE	CTI_ERP_RES_CALL_RESULT
	SET	ERP_RES_CALL_RESULT = @ERP_RES_CALL_RESULT,
		ERP_RES_CALL_CONTENT = @ERP_RES_CALL_CONTENT,
		RESULT_CONSULT_SEQ = @RESULT_CONSULT_SEQ,
		EDT_DATE = GETDATE(),
		EDT_CODE = @EDT_CODE
	WHERE ERP_RES_CALL_SEQ = @ERP_RES_CALL_SEQ;
END
GO
