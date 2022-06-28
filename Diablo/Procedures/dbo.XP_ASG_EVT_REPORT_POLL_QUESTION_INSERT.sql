USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_POLL_QUESTION_INSERT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 POLL QUESTION 저장
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
 CREATE PROCEDURE [dbo].[XP_ASG_EVT_REPORT_POLL_QUESTION_INSERT] 
 ( 
     @OTR_POL_MASTER_SEQ            int                 -- (PK) 
   , @OTR_POL_QUESTION_SEQ          int                 -- (PK) 
   , @QUS_TYPE                      char(1)             --  
   , @QUESTION_TITLE                varchar(400)        --  
   , @NEW_CODE                      char(7)             --  
 
) 
AS 
BEGIN 

   INSERT INTO dbo.OTR_POL_QUESTION 
           (  
            OTR_POL_MASTER_SEQ, 
            OTR_POL_QUESTION_SEQ, 
            QUS_TYPE, 
            QUESTION_TITLE, 
            NEW_DATE, 
            NEW_CODE, 
            EDT_DATE, 
            EDT_CODE
           )   
    VALUES  
           (  
            @OTR_POL_MASTER_SEQ, 
            @OTR_POL_QUESTION_SEQ, 
            @QUS_TYPE, 
            @QUESTION_TITLE, 
            GETDATE(), 
            @NEW_CODE, 
            GETDATE(), 
            @NEW_CODE
           )  

END 

GO
