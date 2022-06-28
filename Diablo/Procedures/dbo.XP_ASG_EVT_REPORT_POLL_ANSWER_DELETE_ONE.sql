USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_POLL_ANSWER_DELETE_ONE
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 POLL ANSWER 삭제(마스터로 묶어서)
■ INPUT PARAMETER			: 
	@OTR_POL_MASTER_SEQ            int                 -- (PK) 
■ OUTPUT PARAMETER			: 

■ EXEC						: 
	
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-20		이상일			최초생성   
================================================================================================================*/ 
 CREATE PROCEDURE [dbo].[XP_ASG_EVT_REPORT_POLL_ANSWER_DELETE_ONE] 
 ( 
    @OTR_POL_MASTER_SEQ            int                 -- (PK) 
) 
AS 
BEGIN 

 DELETE dbo.OTR_POL_ANSWER 
   WHERE OTR_POL_MASTER_SEQ = @OTR_POL_MASTER_SEQ 


END 

GO
