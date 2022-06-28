USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_HBS_DETAIL_DELETE
■ DESCRIPTION				: 게시물 삭제
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
   2017-02-28		정지용			고객들 답변 진행중으로 변경 수정
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_HBS_DETAIL_DELETE]
(
	@MASTER_SEQ		INT,
	@BOARD_SEQ		INT,
	@DEL_YN			VARCHAR(1)
)
AS  
BEGIN

	BEGIN TRY

		BEGIN TRAN

		DECLARE @LEVEL INT;
		--답변 삭제
		UPDATE HBS_DETAIL SET DEL_YN = @DEL_YN, @LEVEL = [LEVEL] = [LEVEL] WHERE MASTER_SEQ = @MASTER_SEQ AND BOARD_SEQ = @BOARD_SEQ;

		--고객글 답변 진행중으로 변경
		--UPDATE HBS_DETAIL SET COMPLETE_YN = (CASE @DEL_YN WHEN 'N' THEN 'Y' ELSE 'Y' END)

		-- 수정 : 원글삭제시에는 무조건 완료처리 / 답글삭제시에는 상태 진행중으로 변경
		UPDATE HBS_DETAIL SET 
			COMPLETE_YN = (CASE 
				WHEN @LEVEL = 0 AND @DEL_YN = 'Y' THEN 'Y' 
				WHEN @LEVEL > 0 AND @DEL_YN = 'Y' THEN 'N'
				ELSE 'Y' END)
		WHERE MASTER_SEQ = @MASTER_SEQ AND BOARD_SEQ = (SELECT PARENT_SEQ FROM HBS_DETAIL AA WHERE AA.MASTER_SEQ = @MASTER_SEQ AND AA.BOARD_SEQ = @BOARD_SEQ);

		COMMIT TRAN

	END TRY
	BEGIN CATCH

		ROLLBACK TRAN

	END	CATCH

END
GO
