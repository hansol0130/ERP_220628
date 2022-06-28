USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_POL_QUESTION_INSERT
■ DESCRIPTION				: 폴질문 등록
■ INPUT PARAMETER			:
	@MASTER_SEQ				: 폴마스터 순번
	@QUESTION_SEQ			: 폴질문 순번
	@QUS_TYPE				: 질문 형태(0-객관식, 1-무)객관식, 3-주관식)
	@QUESTION_TITLE			: 질문	
	@NEW_CODE				: 등록자 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_POL_QUESTION_INSERT (1, '1', '폴질문 등록 테스트', '9999999')

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-05		최영준			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_POL_QUESTION_INSERT]
	@MASTER_SEQ			INT,
	@QUESTION_SEQ		INT,
	@QUS_TYPE			CHAR(1),
	@QUESTION_TITLE		VARCHAR(400),		
	@NEW_CODE			CHAR(7),		
	@EDT_CODE			CHAR(7)
AS
BEGIN
	
	INSERT INTO POL_QUESTION
		(MASTER_SEQ, QUESTION_SEQ, QUS_TYPE, QUESTION_TITLE, NEW_CODE, EDT_CODE)
	VALUES
		(@MASTER_SEQ, @QUESTION_SEQ, @QUS_TYPE, @QUESTION_TITLE, @NEW_CODE, @EDT_CODE);

	SELECT @@IDENTITY;

END


GO
