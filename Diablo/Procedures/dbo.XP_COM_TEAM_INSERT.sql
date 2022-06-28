USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_TEAM_LIST_UPDATE
■ DESCRIPTION				: BTMS 팀등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-26		정지용			최초생성
   2018-07-30		박형만			팀명 20->40자
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_TEAM_INSERT]
	@AGT_CODE			VARCHAR(10),
	@TEAM_NAME			VARCHAR(40),
	@PARENT_TEAM_SEQ	INT,
	@COM_NUMBER			VARCHAR(20),
	@ORDER_NUM			INT,
	@USE_YN				CHAR(1),
	@NEW_SEQ			INT
AS 
BEGIN
	DECLARE @TEAM_SEQ INT;
	SELECT @TEAM_SEQ = ISNULL(MAX(TEAM_SEQ), 0) + 1 FROM COM_TEAM WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE;

	INSERT INTO COM_TEAM 
	( 
		AGT_CODE, 
		TEAM_SEQ, 
		TEAM_NAME, 
		PARENT_TEAM_SEQ, 
		COM_NUMBER, 
		ORDER_NUM, 
		USE_YN, 
		NEW_SEQ, 
		NEW_DATE 
	)
	VALUES
	(
		@AGT_CODE, 
		@TEAM_SEQ, 
		@TEAM_NAME, 
		@PARENT_TEAM_SEQ, 
		@COM_NUMBER, 
		@ORDER_NUM, 
		@USE_YN, 
		@NEW_SEQ, 
		GETDATE()
	)
END 

GO
