USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_EDI_CODE_UPDATE
■ DESCRIPTION				: 대외업무시스템 인솔자관리 배정행사 결재시 EDI 코드 업데이트
■ INPUT PARAMETER			: 
	@EDI_CODE                      char(10)            --  
   ,@NEW_CODE					   char(7)		
   ,@OTR_SEQ                       int       	
■ OUTPUT PARAMETER			: 
							: 
■ EXEC						: 
@EDI_CODE                      char(10)            --  
   ,@NEW_CODE					   char(7)		
   ,@OTR_SEQ                       int       	

	SELECT 

	exec XP_ASG_EVT_OTR_EDI_UPDATE
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-27		오인규			최초생성   
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_ASG_EVT_REPORT_EDI_CODE_UPDATE]
(
	@EDI_CODE                      char(10)            --  
   ,@NEW_CODE					   char(7)		
   ,@OTR_SEQ                       int  
   ,@OTR_STATE                     char(1)         	
)
AS  
BEGIN
	SET NOCOUNT OFF;

      UPDATE dbo.OTR_MASTER 
      SET  
          EDI_CODE                       = @EDI_CODE, 
		  OTR_STATE                      = @OTR_STATE,
          EDT_DATE                       = GETDATE(), 
          EDT_CODE                       = @NEW_CODE  
    WHERE OTR_SEQ = @OTR_SEQ 


END




	


GO
