USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_HBS_DETAIL_ADMIN_UPDATE
■ DESCRIPTION				: 고객 작성 게시물 관리자 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-30		김성호			최초생성
   2013-06-27		김성호			답변글 본문과 마스터코드 동기화
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_HBS_DETAIL_ADMIN_UPDATE]
(
	@MASTER_SEQ		INT,
	@BOARD_SEQ		INT,
	@CATEGORY_SEQ	INT,
	@NOTICE_YN		VARCHAR(1),
	@MASTER_CODE	VARCHAR(20),
	@REGION_NAME	VARCHAR(30),
	@DEL_YN			VARCHAR(1),
	@EDT_CODE		INT
)
AS  
BEGIN

	-- 담당자별 게시판에서 게시물을 수정하면 해당 담당자의 지역을 설정해준다.
	IF @MASTER_SEQ = 24
	BEGIN
		SELECT @REGION_NAME = REGION FROM HBS_EMPLOYEE WITH(NOLOCK) WHERE SEQ_NO = @CATEGORY_SEQ;
	END

	BEGIN TRY

		BEGIN TRAN
			-- 마스터코드 동기화
			UPDATE HBS_DETAIL SET MASTER_CODE = @MASTER_CODE WHERE MASTER_SEQ = @MASTER_SEQ AND PARENT_SEQ = @BOARD_SEQ AND LEVEL > 0

			UPDATE HBS_DETAIL SET
				CATEGORY_SEQ = @CATEGORY_SEQ,
				NOTICE_YN = @NOTICE_YN,
				MASTER_CODE = @MASTER_CODE,
				REGION_NAME = @REGION_NAME,
				DEL_YN = @DEL_YN,
				EDT_DATE = GETDATE(),
				EDT_CODE = @EDT_CODE
			WHERE MASTER_SEQ = @MASTER_SEQ AND BOARD_SEQ = @BOARD_SEQ;

		COMMIT TRAN

	END TRY
	BEGIN CATCH

		ROLLBACK TRAN

	END	CATCH

END
GO
