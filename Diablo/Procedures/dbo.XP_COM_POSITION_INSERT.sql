USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_POSITION_INSERT
■ DESCRIPTION				: BTMS 직급 등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-07-28		이유라			최초생성
   2018-07-30		박형만			직급명 10->40자
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_POSITION_INSERT]
	@AGT_CODE			VARCHAR(10),
	@POS_NAME			VARCHAR(40),
	@NEW_SEQ			INT
AS 
BEGIN
	DECLARE @POS_SEQ INT;
	SELECT @POS_SEQ = ISNULL(MAX(POS_SEQ), 0) + 1 FROM COM_POSITION WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE;

	DECLARE @ORDER_NUM INT;
	SELECT @ORDER_NUM = ISNULL(MAX(ORDER_NUM), 0) + 1 FROM COM_POSITION WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE;

	INSERT INTO COM_POSITION 
	( 
		AGT_CODE, 
		POS_SEQ, 
		POS_NAME, 
		ORDER_NUM, 
		NEW_SEQ, 
		NEW_DATE 
	)
	VALUES
	(
		@AGT_CODE, 
		@POS_SEQ, 
		@POS_NAME,  
		@ORDER_NUM, 
		@NEW_SEQ, 
		GETDATE()
	)
END 

GO
