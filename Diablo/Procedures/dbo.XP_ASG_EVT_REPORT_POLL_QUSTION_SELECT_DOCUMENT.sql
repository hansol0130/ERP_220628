USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_POLL_QUSTION_SELECT_DOCUMENT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 POLL ANSWER 조회
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
 CREATE PROCEDURE [dbo].[XP_ASG_EVT_REPORT_POLL_QUSTION_SELECT_DOCUMENT] 
 ( 
    @OTR_POL_MASTER_SEQ            int                 -- (PK) 

) 
AS 
BEGIN 
	SELECT OTR_POL_MASTER_SEQ, OTR_POL_QUESTION_SEQ, OTR_POL_ANSWER_SEQ, OTR_POL_EXAMPLE_SEQ, ANSWER_TEXT, NEW_DATE, NEW_CODE, EDT_DATE, EDT_CODE 
	FROM OTR_POL_ANSWER WITH(NOLOCK)
    WHERE OTR_POL_MASTER_SEQ = @OTR_POL_MASTER_SEQ 


END 

GO
