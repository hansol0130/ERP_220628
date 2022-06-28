USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_POL_QUESTION_UPDATE
■ DESCRIPTION				: 폴질문 수정
■ INPUT PARAMETER			: 
	@MASTER_SEQ				: 폴마스터 코드
	@QUESTION_SEQ			: 폴질문 코드
	@QUS_TYPE				: 질문 형태(객관식-0, 무객관식-1, 주관식-2)
	@QUESTION_TITLE			: 질문
	@EDT_CODE				: 수정자 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_POL_QUESTION_UPDATE (1, 1, '0', '폴질문 등록 테스트 수정', '9999999')

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-05		최영준			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_POL_QUESTION_UPDATE]
	@MASTER_SEQ			INT,
	@QUESTION_SEQ		INT,
	@QUS_TYPE			CHAR(1),
	@QUESTION_TITLE		VARCHAR(400),
	@EDT_CODE			CHAR(7)
AS
BEGIN
	SET NOCOUNT OFF;

	BEGIN

		UPDATE POL_QUESTION SET 
			QUS_TYPE = @QUS_TYPE,			
			QUESTION_TITLE = @QUESTION_TITLE,
			EDT_CODE = @EDT_CODE,
			EDT_DATE = GETDATE()
		WHERE MASTER_SEQ = @MASTER_SEQ AND QUESTION_SEQ = @QUESTION_SEQ
		
	END
END


GO
