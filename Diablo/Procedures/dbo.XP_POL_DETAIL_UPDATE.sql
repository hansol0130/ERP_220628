USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_POL_DETAIL_UPDATE
■ DESCRIPTION				: 폴질문 수정
■ INPUT PARAMETER			: 
	@MASTER_SEQ				: 폴마스터 코드
	@QUESTION_SEQ			: 폴질문 코드
	@EXAMPLE_SEQ			: 폴답변 코드
	@EXAMPLE_DESC			: 답변
	@EDT_CODE				: 수정자 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_POL_DETAIL_UPDATE (1, 1, 1, '폴답변 등록 테스트 수정', '9999999')

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-05		최영준			최초생성
   2014-05-16		김성호			EXAMPLE_DESC 형 변환 (400 -> 2000)
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_POL_DETAIL_UPDATE]
	@MASTER_SEQ			INT,
	@QUESTION_SEQ		INT,
	@EXAMPLE_SEQ		INT,
	@EXAMPLE_DESC		VARCHAR(2000),
	@EDT_CODE			CHAR(7)
AS
BEGIN
	SET NOCOUNT OFF;

	BEGIN

		UPDATE POL_DETAIL SET 
			EXAMPLE_DESC = @EXAMPLE_DESC,	
			EDT_CODE = @EDT_CODE,
			EDT_DATE = GETDATE()
		WHERE MASTER_SEQ = @MASTER_SEQ AND QUESTION_SEQ = @QUESTION_SEQ AND EXAMPLE_SEQ = @EXAMPLE_SEQ
		
	END
END


GO
