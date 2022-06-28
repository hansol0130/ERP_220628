USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_POL_QUESTION_SELECT
■ DESCRIPTION				: 폴질문리스트 검색
■ INPUT PARAMETER			: 
	@MASTER_SEQ				: 폴마스터 순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_POL_QUESTION_SELECT 1

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-10		이상일			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_POL_QUESTION_SELECT]
(
	@MASTER_SEQ		INT
)

AS  
BEGIN

	--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT MASTER_SEQ, QUESTION_SEQ, QUS_TYPE, QUESTION_TITLE,
	(SELECT COUNT(*) FROM POL_DETAIL WHERE MASTER_SEQ = A.MASTER_SEQ AND QUESTION_SEQ = A.QUESTION_SEQ) AS ANSWER_CNT
	FROM POL_QUESTION A WHERE A.MASTER_SEQ = @MASTER_SEQ

END


GO
