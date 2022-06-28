USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_UPDATE
■ DESCRIPTION				: 수정_큐레이션정보
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- EXEC SP_MOV2_CURATION_UPDATE 
■ MEMO						: 큐레이션정보 수정
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-05		IBSOLUTION			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_UPDATE]
	@CUR_NO					INT,
	@CUR_ITEM				VARCHAR(20),
	@CUR_TITLE				VARCHAR(100),
	@CUR_MESSAGE			VARCHAR(200),
	@CUR_ORDER				INT,
	@CUR_TYPE				INT,
	@PUSH_YN				char(1),
	@USE_YN					char(1),
	@CUR_LINK				VARCHAR(200),
	@CUR_BASIC				INT,
	@CUR_DAY				INT,
	@CUR_HOUR				INT,
	@CUR_MINUTE				INT,
	@CUR_BA					VARCHAR(20),
	@NEW_CODE				char(7)
AS
BEGIN

	UPDATE CUR_INFO SET
		CUR_ITEM = @CUR_ITEM,
		CUR_TITLE = @CUR_TITLE,
		CUR_MESSAGE = @CUR_MESSAGE,
		CUR_ORDER = @CUR_ORDER,
		CUR_TYPE = @CUR_TYPE,
		PUSH_YN = @PUSH_YN,
		USE_YN = @USE_YN,
		CUR_LINK = @CUR_LINK,
		CUR_BASIC = @CUR_BASIC,
		CUR_DAY = @CUR_DAY,
		CUR_HOUR = @CUR_HOUR,
		CUR_MINUTE = @CUR_MINUTE,
		CUR_BA = @CUR_BA,
		NEW_CODE = @NEW_CODE, 
		NEW_DATE = getDate()
		WHERE CUR_NO = @CUR_NO

END           



GO
