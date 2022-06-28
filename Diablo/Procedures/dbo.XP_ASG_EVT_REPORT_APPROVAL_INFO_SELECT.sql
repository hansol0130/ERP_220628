USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_APPROVAL_INFO_SELECT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 배정행사 결재자 정보 조회
■ INPUT PARAMETER			: 
	@NEW_CODE					   char(7)		
   	
■ OUTPUT PARAMETER			: 
							: 
■ EXEC						: 
  @NEW_CODE					   char(7)		
   
	SELECT 

	exec XP_ASG_EVT_REPORT_APPROVAL_INFO_SELECT
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-27		오인규			최초생성   
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_ASG_EVT_REPORT_APPROVAL_INFO_SELECT]
(
	@NEW_CODE					   char(7)		
)
AS  
BEGIN
	
     SELECT [dbo].[XN_COM_GET_TEAM_CODE](@NEW_CODE)

END




	


GO
