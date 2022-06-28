USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_POL_MASTER_SELECT_MAX
■ DESCRIPTION				: 폴마스터 검색
■ INPUT PARAMETER			: 
	@MASTER_SEQ				: 폴마스터 순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_POL_MASTER_SELECT_MAX

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-05		최영준			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_POL_MASTER_SELECT_MAX]
AS  
BEGIN

	--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT MAX(MASTER_SEQ) AS MASTER_SEQ FROM POL_MASTER 

END



GO
