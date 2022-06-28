USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_POL_QUESTION_LIST_SELECT
■ DESCRIPTION				: 폴질문리스트 검색
■ INPUT PARAMETER			: 
	@MASTER_SEQ				: 폴마스터 순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_POL_QUESTION_LIST_SELECT 1

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-05		최영준			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_POL_QUESTION_LIST_SELECT]
(
	@MASTER_SEQ		INT
)

AS  
BEGIN

	--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT * FROM POL_QUESTION WHERE MASTER_SEQ = @MASTER_SEQ

END




GO
