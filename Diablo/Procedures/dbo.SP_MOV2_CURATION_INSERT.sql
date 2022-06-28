USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_INSERT
■ DESCRIPTION				: 입력_큐레이션정보
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- EXEC SP_MOV2_CURATION_INSERT 
■ MEMO						: 큐레이션정보 입력
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-05		IBSOLUTION			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_INSERT]
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

	INSERT INTO CUR_INFO
		(CUR_ITEM, CUR_TITLE, CUR_MESSAGE, CUR_ORDER, CUR_TYPE,
		PUSH_YN, USE_YN, CUR_LINK, CUR_BASIC, CUR_DAY,
		CUR_HOUR, CUR_MINUTE, CUR_BA, NEW_CODE, NEW_DATE)
		VALUES(
		@CUR_ITEM, @CUR_TITLE, @CUR_MESSAGE, @CUR_ORDER, @CUR_TYPE,
		@PUSH_YN, @USE_YN, @CUR_LINK, @CUR_BASIC, @CUR_DAY,
		@CUR_HOUR, @CUR_MINUTE, @CUR_BA, @NEW_CODE, getDate())

END           



GO
