USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_BBS_AGT_BOARD_MASTER_INSERT
■ DESCRIPTION				: 거래처 자유게시판 등록
■ INPUT PARAMETER			: 
	@AGT_CODE VARCHAR(10)	: 거래처 코드
	@EMP_CODE CHAR(7)		: 등록자 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-08		김성호			최초생성
   2013-06-10		김성호			WITH(NOLOCK) 추가
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_BBS_AGT_BOARD_MASTER_INSERT]
	@AGT_CODE VARCHAR(10),
	@EMP_CODE CHAR(7)
AS
BEGIN
	SET NOCOUNT OFF;

	IF NOT EXISTS(SELECT 1 FROM BBS_MASTER_AGT_LINK WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE)
	BEGIN

		DECLARE @MASTER_SEQ INT

		-- MASTER_SEQ 생성
		EXEC SP_COD_GETSEQ_UNLIMITED 'BA', @MASTER_SEQ OUTPUT
	
		--print @MASTER_SEQ

		-- 게시판 등록
		INSERT INTO BBS_MASTER (
			MASTER_SEQ, MASTER_TYPE, MASTER_ATTR, MASTER_SUBJECT, FILE_COUNT, NOTICE_YN
			, SHOW_COUNT, HISTORY_YN, COMMENT_YN, USE_YN, REALNAME_YN, CATEGORY_GROUP, ICON_YN, TEAM_CODE
			, NEW_NAME, NEW_CODE, NEW_DATE, SCOPE_YN, MANAGER_YN)
		SELECT
			@MASTER_SEQ, 1, 10, AGT_NAME, 3, 'Y'
			, 15, 'N', 'Y', 'Y', 'Y', '', 'N', ''
			, DBO.XN_COM_GET_TEAM_NAME(@EMP_CODE), @EMP_CODE, GETDATE(), 'N', 'N'
		FROM AGT_MASTER WITH(NOLOCK)
		WHERE AGT_CODE = @AGT_CODE

		-- 게시판과 거래처 연결
		INSERT INTO BBS_MASTER_AGT_LINK (MASTER_SEQ, AGT_CODE, USE_YN)
		VALUES (@MASTER_SEQ, @AGT_CODE, 'Y')

	END
END

GO
