USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_TOTAL_VALUE_UPDATE
■ DESCRIPTION				: 대외업무시스템 인솔자관리 배정행사 결재시 TOTAL VALUE 업데이트
■ INPUT PARAMETER			: 
   @TOTAL_VALUE					  int,
   @OTR_SEQ                       int  	
■ OUTPUT PARAMETER			: 
							: 
■ EXEC						: 

	SELECT 

	exec XP_ASG_EVT_REPORT_TOTAL_VALUE_UPDATE
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-22		이상일			최초생성   
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_ASG_EVT_REPORT_TOTAL_VALUE_UPDATE]
(
   @TOTAL_VALUE					  int,
   @OTR_SEQ                       int
)
AS  
BEGIN
	SET NOCOUNT OFF;

      UPDATE dbo.OTR_MASTER 
      SET  
          TOTAL_VALUATION	= @TOTAL_VALUE 
    WHERE OTR_SEQ = @OTR_SEQ 


END




	


GO
