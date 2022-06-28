USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_BBS_DETAIL_UPDATE
■ DESCRIPTION				: 게시물 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-22		저스트고-백경훈		최초생성
   2016-04-12		저스트고-이유라		STATUS, EMP_CODE, ALL_NOTICE_YN 추가
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_COM_BBS_DETAIL_UPDATE]
(
	@MASTER_SEQ		INT,
	@BOARD_SEQ		INT,
	@CATEGORY_SEQ	INT,
	@SUBJECT		NVARCHAR(400),
	@CONTENTS		NVARCHAR(MAX),
	@NOTICE_YN		VARCHAR(1),
	@DEL_YN			VARCHAR(1),
	@MASTER_CODE	VARCHAR(20),
	@NATION_CODE	VARCHAR(20),
	@REGION_CODE	VARCHAR(20),
	@REQUEST_SEQ    int,
	@BT_CODE	    VARCHAR(20),
	@STATUS			VARCHAR(1),
	@EMP_CODE		INT,
	@NEW_SEQ	INT,
	@ALL_NOTICE_YN  VARCHAR(1)
	)
AS  
BEGIN

	UPDATE COM_BBS_DETAIL SET
		CATEGORY_SEQ = @CATEGORY_SEQ,
		[SUBJECT] = @SUBJECT,
		CONTENTS = @CONTENTS,
		NOTICE_YN = @NOTICE_YN,
		DEL_YN = @DEL_YN,
		MASTER_CODE = @MASTER_CODE,
		NATION_CODE = @NATION_CODE,
		REGION_CODE = @REGION_CODE,
		EDT_SEQ = @NEW_SEQ,
		BT_CODE = @BT_CODE,
		REQUEST_SEQ = @REQUEST_SEQ,
		[STATUS] = @STATUS, 
		EMP_CODE = @EMP_CODE,
		EDT_DATE = GETDATE(),
		ALL_NOTICE_YN = @ALL_NOTICE_YN
	WHERE MASTER_SEQ = @MASTER_SEQ AND BOARD_SEQ = @BOARD_SEQ;

END

GO
