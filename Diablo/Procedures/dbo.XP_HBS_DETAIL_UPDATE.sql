USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_HBS_DETAIL_UPDATE
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
   2013-05-29		김성호			최초생성
   2013-06-17		김성호			마스터코드 유효성 검사
   2017-02-28		정지용			ERP 게시판 답변글 삭제시 상태 변경
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_HBS_DETAIL_UPDATE]
(
	@MASTER_SEQ		INT,
	@BOARD_SEQ		INT,
	@CATEGORY_SEQ	INT,
	@SUBJECT		NVARCHAR(400),
	@CONTENTS		NVARCHAR(MAX),
	@NOTICE_YN		VARCHAR(1),
	@DEL_YN			VARCHAR(1),
	@LOCK_YN		VARCHAR(1),
	@MASTER_CODE	VARCHAR(20),
	@REGION_NAME	VARCHAR(30),
	@EMAIL			VARCHAR(50),
	@EDT_CODE		INT,
	@EMP_CODE		VARCHAR(7)
)
AS  
BEGIN

	IF LEN(@MASTER_CODE) > 1
	BEGIN
		IF EXISTS(SELECT 1 FROM RES_MASTER_damo WITH(NOLOCK) WHERE RES_CODE = @MASTER_CODE)
			SELECT @MASTER_CODE = MASTER_CODE FROM RES_MASTER_damo WITH(NOLOCK) WHERE RES_CODE = @MASTER_CODE
		ELSE IF EXISTS(SELECT 1 FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @MASTER_CODE)
			SELECT @MASTER_CODE = MASTER_CODE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @MASTER_CODE
		ELSE IF NOT EXISTS(SELECT 1 FROM PKG_MASTER WITH(NOLOCK) WHERE MASTER_CODE = @MASTER_CODE)
			SELECT @MASTER_CODE = ''

		-- 마스터코드가 있고 지역명이 없을때 지역명을 넣어준다
		IF ISNULL(@REGION_NAME, '') = '' AND LEN(@MASTER_CODE) > 1
		BEGIN
			SELECT @REGION_NAME = KOR_NAME FROM PUB_REGION WITH(NOLOCK) WHERE [SIGN] = SUBSTRING(@MASTER_CODE, 1, 1)
		END
	END

	DECLARE @PARENT_SEQ INT;
	UPDATE HBS_DETAIL SET
		@PARENT_SEQ = PARENT_SEQ = PARENT_SEQ,
		CATEGORY_SEQ = @CATEGORY_SEQ,
		[SUBJECT] = @SUBJECT,
		CONTENTS = @CONTENTS,
		NOTICE_YN = @NOTICE_YN,
		DEL_YN = @DEL_YN,
		LOCK_YN = @LOCK_YN,
		MASTER_CODE = @MASTER_CODE,
		REGION_NAME = @REGION_NAME,
		EMAIL = @EMAIL,
		EMP_CODE = @EMP_CODE,
		EDT_DATE = GETDATE(),
		EDT_CODE = @EDT_CODE
	WHERE MASTER_SEQ = @MASTER_SEQ AND BOARD_SEQ = @BOARD_SEQ;

	-- 추가 : ERP에서 답글 삭제 후 다시 수정시 완료 처리 될 수 있도록 수정
	IF ISNULL(@PARENT_SEQ, 0) > 0 AND EXISTS ( SELECT 1 FROM HBS_DETAIL WITH(NOLOCK) WHERE MASTER_SEQ = @MASTER_SEQ AND PARENT_SEQ = @PARENT_SEQ AND [LEVEL] > 0 AND DEL_YN = 'N' )
	BEGIN
		UPDATE HBS_DETAIL SET COMPLETE_YN = 'Y' WHERE MASTER_SEQ = @MASTER_SEQ AND BOARD_SEQ = @PARENT_SEQ;
	END

END

GO
