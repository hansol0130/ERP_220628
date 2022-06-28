USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_POLL_DETAIL_DELETE
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 POLL DETAIL 삭제
■ INPUT PARAMETER			: 
	@OTR_POL_MASTER_SEQ            int                 -- (PK) 
   , @OTR_POL_QUESTION_SEQ          int                 -- (PK) 
   , @QUS_TYPE                      char(1)             --  
   , @QUESTION_TITLE                varchar(400)        --  
   , @NEW_CODE                      char(7)             --  
■ OUTPUT PARAMETER			: 

■ EXEC						: 
	
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-09		오인규			최초생성   
================================================================================================================*/ 
 CREATE PROCEDURE [dbo].[XP_ASG_EVT_REPORT_POLL_DETAIL_DELETE] 
 ( 
     @OTR_POL_MASTER_SEQ            int                 -- (PK) 
   , @OTR_POL_QUESTION_SEQ          int                 -- (PK) 
   , @OTR_POL_EXAMPLE_SEQ           int                 -- (PK) 
) 
AS 
BEGIN 

DELETE dbo.OTR_POL_DETAIL 
   WHERE OTR_POL_MASTER_SEQ = @OTR_POL_MASTER_SEQ 
     AND OTR_POL_QUESTION_SEQ = @OTR_POL_QUESTION_SEQ 
     AND OTR_POL_EXAMPLE_SEQ = @OTR_POL_EXAMPLE_SEQ 

END 

GO
