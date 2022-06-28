USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_SCHEDULE_INSERT
■ DESCRIPTION				: CTI 고객약속 저장
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-04-06		정지용			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_CTI_SCHEDULE_INSERT]
	@CONSULT_TYPE		VARCHAR(1),
	@CUS_NO				INT,
	@CUS_NAME			VARCHAR(20),
	@CUS_TEL			VARCHAR(20),
	@CONSULT_CONTENT	NVARCHAR(4000),
	@RES_CODE			VARCHAR(12),
	@INNER_NUMBER		VARCHAR(4),
	@EMP_CODE			VARCHAR(7),
	@RESERVE_DATE		VARCHAR(10),
	@RESERVE_TIME		VARCHAR(5),
	@RESERVE_TEAM_CODE	VARCHAR(3),
	@RESERVE_EMP_CODE	VARCHAR(7)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT Sirens.cti.CTI_CONSULT_RESERVATION (
		CONSULT_RES_SEQ,
		CONSULT_RES_DATE,
		CONSULT_SEQ,
		CONSULT_TYPE,
		EMP_CODE,
		EMP_NAME,
		TEAM_CODE,
		TEAM_NAME,
		INNER_NUMBER,
		CUS_NO,
		CUS_NAME,
		CUS_TEL,
		CONSULT_RESULT,
		CONSULT_RES_CONTENT,
		NEW_DATE,
		NEW_CODE,
		EDT_DATE,
		EDT_CODE,
		RES_CODE
	)
	SELECT
		NEXT VALUE FOR Sirens.cti.CTI_CONSULT_RES_SEQ,
		CAST((@RESERVE_DATE + ' ' + @RESERVE_TIME) AS DATETIME),
		null,
		@CONSULT_TYPE,
		@RESERVE_EMP_CODE,
		(SELECT KOR_NAME FROM Diablo.dbo.EMP_MASTER WHERE EMP_CODE = @RESERVE_EMP_CODE),
		@RESERVE_TEAM_CODE,
		(SELECT TEAM_NAME FROM Diablo.dbo.EMP_TEAM WHERE TEAM_CODE = @RESERVE_TEAM_CODE),
		@INNER_NUMBER,
		@CUS_NO,
		@CUS_NAME,
		@CUS_TEL,
		'1',
		@CONSULT_CONTENT,
		GETDATE(),
		@EMP_CODE,
		NULL,
		NULL,
		@RES_CODE
END
GO
