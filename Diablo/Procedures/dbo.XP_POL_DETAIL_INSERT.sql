USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_POL_DETAIL_INSERT
■ DESCRIPTION				: 폴답변 등록
■ INPUT PARAMETER			:
	@MASTER_SEQ				: 폴마스터 순번
	@QUESTION_SEQ			: 폴질문 순번
	@EXAMPLE_SEQ			: 폴답변 순번
	@EXAMPLE_DESC			: 답변	
	@NEW_CODE				: 등록자 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_POL_DETAIL_INSERT (1, 1, '폴답변 등록 테스트', '9999999')

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-05		최영준			최초생성
   2014-05-16		김성호			EXAMPLE_DESC 형 변환 (400 -> 2000)
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_POL_DETAIL_INSERT]
	@MASTER_SEQ		INT,
	@QUESTION_SEQ	INT,
	@EXAMPLE_SEQ	INT,
	@EXAMPLE_DESC	VARCHAR(2000),	
	@NEW_CODE		CHAR(7),	
	@EDT_CODE		CHAR(7)
AS
BEGIN
	
	INSERT INTO POL_DETAIL
		(MASTER_SEQ, QUESTION_SEQ, EXAMPLE_SEQ, EXAMPLE_DESC, NEW_CODE, EDT_CODE)
	VALUES
		(@MASTER_SEQ, @QUESTION_SEQ, @EXAMPLE_SEQ, @EXAMPLE_DESC, @NEW_CODE, @EDT_CODE);

END


GO
