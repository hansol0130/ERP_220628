USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_COM_BBS_DETAIL_INSERT
■ DESCRIPTION				: 게시물 등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-29		저스트고-백경훈		최초생성
   2016-04-13		저스트고-이유라		STATUS,ALL_NOTICE_YN, EMP_CODE 추가
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_COM_BBS_DETAIL_INSERT]
(
	@AGT_CODE		VARCHAR(20),
	@MASTER_SEQ		INT,
	@BOARD_SEQ		INT,
	@CATEGORY_SEQ	INT,
	@PARENT_SEQ		INT,
	@SUBJECT		NVARCHAR(400),
	@CONTENTS		NVARCHAR(MAX),
	@NOTICE_YN		VARCHAR(1),
	@DEL_YN			VARCHAR(1),
	@IP_ADDRESS		VARCHAR(15),
	@FILE_PATH		NVARCHAR(500),
	@MASTER_CODE	VARCHAR(20),
	@NATION_CODE	VARCHAR(20),
	@REGION_CODE	VARCHAR(20),
	@REQUEST_SEQ    int,
	@BT_CODE	    VARCHAR(20),
	@STATUS			VARCHAR(1),
	@NEW_SEQ	INT,
	@ALL_NOTICE_YN  VARCHAR(1),
	@EMP_CODE	VARCHAR(10)
)

AS  
BEGIN

	BEGIN TRY

		BEGIN TRAN

		SELECT @BOARD_SEQ = ISNULL(MAX(BOARD_SEQ), 0) + 1 FROM COM_BBS_DETAIL WITH(NOLOCK) WHERE MASTER_SEQ = @MASTER_SEQ;


		INSERT INTO COM_BBS_DETAIL (AGT_CODE,
			MASTER_SEQ, BOARD_SEQ, CATEGORY_SEQ, PARENT_SEQ, 
			SUBJECT, CONTENTS, SHOW_COUNT, NOTICE_YN, 
			DEL_YN, IP_ADDRESS, MASTER_CODE,NATION_CODE,REGION_CODE, BT_CODE, REQUEST_SEQ, NEW_DATE, NEW_SEQ, [STATUS], ALL_NOTICE_YN, EMP_CODE
		) VALUES (
			@AGT_CODE, @MASTER_SEQ, @BOARD_SEQ, @CATEGORY_SEQ, (CASE WHEN @PARENT_SEQ = 0 THEN @BOARD_SEQ ELSE @PARENT_SEQ END), 
			@SUBJECT, @CONTENTS, 0, @NOTICE_YN, 
			'N', @IP_ADDRESS, @MASTER_CODE, @NATION_CODE, @REGION_CODE, @BT_CODE, @REQUEST_SEQ, GETDATE(), @NEW_SEQ, @STATUS, @ALL_NOTICE_YN, @EMP_CODE
		);


		COMMIT TRAN

	END TRY
	BEGIN CATCH

		ROLLBACK TRAN

	END	CATCH

	-- 디테일 순번 리턴
	SELECT @BOARD_SEQ;

END



GO
