USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BBS_DETAIL_DELETE
■ DESCRIPTION				: 게시물 삭제
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			 DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-27		저스트고-백경훈	  최초생성
   2016-04-14		저스트고-이유라	  공지사항 거래처목록 삭제 추가
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_COM_BBS_DETAIL_DELETE]
(
	@MASTER_SEQ		INT,
	@BOARD_SEQ		INT
)
AS  
BEGIN

	BEGIN TRY

		BEGIN TRAN

		--글 삭제
		UPDATE  COM_BBS_DETAIL SET DEL_YN = 'Y' WHERE MASTER_SEQ = @MASTER_SEQ AND BOARD_SEQ = @BOARD_SEQ;
		UPDATE  COM_BBS_DETAIL SET DEL_YN = 'Y'  WHERE MASTER_SEQ = @MASTER_SEQ AND PARENT_SEQ = @BOARD_SEQ AND BOARD_SEQ <> PARENT_SEQ;
		
		--공지사항 거래처목록
		DELETE COM_BBS_NOTICE WHERE MASTER_SEQ = @MASTER_SEQ AND BOARD_SEQ = @BOARD_SEQ
		
		COMMIT TRAN



	END TRY
	BEGIN CATCH

		ROLLBACK TRAN

	END	CATCH

END


GO
