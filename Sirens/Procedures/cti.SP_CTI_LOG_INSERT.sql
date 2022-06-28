USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_LOG_INSERT
■ DESCRIPTION				: CTI LOG INSERT
■ INPUT PARAMETER			: 
	@LOG_TYPE				:로그 유형
	@LOG_CODE				:로그 seq
	@LOG_DESCRIPT			:내용
	@LOG_IP					:client ip
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXECUTE SP_CTI_LOG_INSERT @LOG_DATE, @LOG_TYPE, @LOG_CODE, @LOG_DESCRIPT, @LOG_IP

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-11		곽병삼			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_LOG_INSERT]
--DECLARE
	--@LOG_DATE		VARCHAR(20),
	@LOG_TYPE		VARCHAR(20),
	@LOG_CODE		CHAR(7),
	@LOG_DESCRIPT	VARCHAR(1000),
	@LOG_IP			VARCHAR(20)

--SET @LOG_DATE = GETDATE()
--SET @LOG_TYPE = ''
--SET @LOG_CODE = '2012010'
--SET @LOG_DESCRIPT = '테스트'
--SET @LOG_IP = '110.11.44.185'

AS

BEGIN
	-- LOG_SEQ 생성
	DECLARE
		@CTI_SEQ_TYPE	TINYINT,
		@SEQ	INT,
		@YMD	VARCHAR(8),
		@LOG_SEQ	CHAR(16)

	SET @CTI_SEQ_TYPE = 2
	SET @YMD = CONVERT(VARCHAR(8),GETDATE(),112)

	UPDATE Sirens.cti.CTI_SEQ_NUMBER
	SET @SEQ = CTI_SEQ = CTI_SEQ + 1
	WHERE CTI_SEQ_TYPE = @CTI_SEQ_TYPE
	AND CTI_SEQ_YMD = @YMD

	IF @SEQ  IS NULL
	BEGIN
		INSERT Sirens.cti.CTI_SEQ_NUMBER(CTI_SEQ_TYPE,CTI_SEQ_YMD,CTI_SEQ)
		VALUES (@CTI_SEQ_TYPE,@YMD,1)

		SET @SEQ = 1
	END

	SET @LOG_SEQ = @YMD + RIGHT(REPLICATE('0',8) + LTRIM(STR(@SEQ)),8)

	INSERT INTO Sirens.cti.CTI_LOG (
		LOG_SEQ, LOG_DATE, LOG_TYPE, LOG_CODE, LOG_DESCRIPT, LOG_IP)
	VALUES (@LOG_SEQ, GETDATE(), @LOG_TYPE, @LOG_CODE, @LOG_DESCRIPT, @LOG_IP );

END
GO
