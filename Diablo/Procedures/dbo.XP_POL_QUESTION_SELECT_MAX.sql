USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_POL_MASTER_SELECT_MAX
■ DESCRIPTION				: 폴질문 최상위 검색 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_POL_QUESTION_SELECT_MAX

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-10		이상일			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_POL_QUESTION_SELECT_MAX]
AS  
BEGIN

	--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT MAX(QUESTION_SEQ) AS QUESTION_SEQ FROM POL_QUESTION 

END



GO
