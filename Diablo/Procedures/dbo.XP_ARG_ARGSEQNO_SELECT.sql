USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ARG_ARGSEQNO_SELECT
■ DESCRIPTION				: 수배번호 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_ARG_ARGSEQNO_SELECT 'APP5042-130801'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-07-22		김완기
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_ARGSEQNO_SELECT]
 	@PRO_CODE varchar(20)
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	SELECT TOP 1 ARG_SEQ_NO FROM ARG_MASTER WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE ORDER BY NEW_DATE DESC

END 

GO
