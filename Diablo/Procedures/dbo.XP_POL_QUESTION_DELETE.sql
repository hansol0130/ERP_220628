USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_POL_QUESTION_DELETE
■ DESCRIPTION				: 폴질문 삭제
■ INPUT PARAMETER			: 
	@MASTER_SEQ				: 폴마스터 코드
	@QUESTION_SEQ			: 폴질문 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_POL_QUESTION_DELETE 1, 1

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-11		이상일			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_POL_QUESTION_DELETE]
	@MASTER_SEQ			INT
AS
BEGIN
	SET NOCOUNT OFF;

	BEGIN
		DELETE FROM POL_QUESTION
		WHERE MASTER_SEQ = @MASTER_SEQ	
	END
END


GO
