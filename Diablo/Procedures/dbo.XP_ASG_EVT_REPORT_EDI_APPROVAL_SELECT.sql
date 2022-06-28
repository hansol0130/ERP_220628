USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_EDI_APPROVAL_SELECT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 배정행사 결재자 정보 조회
■ INPUT PARAMETER			: 
	@@EDI_CODE					   char(10)		
   	
■ OUTPUT PARAMETER			: 
							: 
■ EXEC						: 
  @@EDI_CODE					   char(10)		
   
	SELECT 

	exec XP_ASG_EVT_REPORT_EDI_APPROVAL_SELECT
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-27		오인규			최초생성   
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_ASG_EVT_REPORT_EDI_APPROVAL_SELECT]
(
	@EDI_CODE					   char(10)	
	,@APP_TYPE					   char(1)  -- 3경영기획실 4 CS팀 1 일반결재라인
)
AS  
BEGIN
    
select  APP_TYPE,SEQ_NO,TEAM_NAME,APP_NAME,DUTY_NAME,APP_DATE 
from EDI_APPROVAL WITH(NOLOCK)
where EDI_CODE = @EDI_CODE and app_type = @APP_TYPE 
ORDER BY seq_no asc

END




	


GO
