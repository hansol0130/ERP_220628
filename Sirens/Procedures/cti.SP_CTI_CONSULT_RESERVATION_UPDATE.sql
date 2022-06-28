USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_CONSULT_RESERVATION_UPDATE
■ DESCRIPTION				: CTI 고객약속 미처리 내역 --> 직원처리
■ INPUT PARAMETER			: 
	@CONSULT_RES_SEQ		: 고객약속 SEQ
	@EMP_CODE				: 상담원코드
	@TEAM_CODE				: 팀코드
	@CONSULT_RESULT			: 처리결과(3)
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXECUTE SP_CTI_CONSULT_RESERVATION_UPDATE @CONSULT_RES_SEQ,@EMP_CODE,@TEAM_CODE,@CONSULT_RESULT

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-18		곽병삼			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CONSULT_RESERVATION_UPDATE]
--DECLARE
	@CONSULT_RES_SEQ	INT,
	@EMP_CODE	VARCHAR(7),
	@TEAM_CODE	VARCHAR(3),
	@CONSULT_RESULT	VARCHAR(1)

--SET @CONSULT_RES_SEQ = 140
--SET @EMP_CODE = '2013069'
--SET @TEAM_CODE = '538'
--SET @CONSULT_RESULT = '3'

AS

BEGIN

	UPDATE sirens.cti.CTI_CONSULT_RESERVATION
	SET CONSULT_RESULT = @CONSULT_RESULT,
		EDT_DATE = GETDATE(),
		EDT_CODE = @EMP_CODE
	WHERE CONSULT_RES_SEQ = @CONSULT_RES_SEQ

END
GO
