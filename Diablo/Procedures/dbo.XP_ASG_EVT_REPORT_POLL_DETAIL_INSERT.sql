USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_POLL_DETAIL_INSERT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 POLL DETAIL 저장
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
   2014-05-16		김성호			EXAMPLE_DESC 형 변환 (400 -> 2000)
================================================================================================================*/ 
 CREATE PROCEDURE [dbo].[XP_ASG_EVT_REPORT_POLL_DETAIL_INSERT] 
 ( 
     @OTR_POL_MASTER_SEQ            int                 -- (PK) 
   , @OTR_POL_QUESTION_SEQ          int                 -- (PK) 
   , @OTR_POL_EXAMPLE_SEQ           int                 -- (PK) 
   , @EXAMPLE_DESC                  varchar(2000)        --  
   , @NEW_CODE                      char(7)             --  
 
) 
AS 
BEGIN 

    INSERT INTO dbo.OTR_POL_DETAIL 
           (  
            OTR_POL_MASTER_SEQ, 
            OTR_POL_QUESTION_SEQ, 
            OTR_POL_EXAMPLE_SEQ, 
            EXAMPLE_DESC, 
            NEW_DATE, 
            NEW_CODE, 
            EDT_DATE, 
            EDT_CODE
           )   
    VALUES  
           (  
            @OTR_POL_MASTER_SEQ, 
            @OTR_POL_QUESTION_SEQ, 
            @OTR_POL_EXAMPLE_SEQ, 
            @EXAMPLE_DESC, 
            GETDATE(), 
            @NEW_CODE, 
           GETDATE(),
            @NEW_CODE 
           ) 

END 

GO
