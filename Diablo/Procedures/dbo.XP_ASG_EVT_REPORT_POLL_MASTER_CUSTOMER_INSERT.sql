USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_POLL_MASTER_CUSTOMER_INSERT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 POLL MASTER 저장
■ INPUT PARAMETER			: 
	@OTR_SEQ                       int                 --  
   , @OTR_DATE1                     varchar(10)         --  
   , @OTR_DATE2                     varchar(10)         --  
   , @CLIENTNAME					varchar(50)         --  
   , @CLIENTTEL						varchar(16)         --  
   , @CLIENTCALLYN					varchar(1)         --  
   , @NEW_CODE                      char(7)             --  
   , @MASTER_SEQ					int
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
 CREATE PROCEDURE [dbo].[XP_ASG_EVT_REPORT_POLL_MASTER_CUSTOMER_INSERT] 
 ( 
     @OTR_SEQ                       int                 --  
   , @OTR_DATE1                     varchar(10)         --  
   , @OTR_DATE2                     varchar(10)         --  
   , @CLIENTNAME					varchar(50)
   , @CLIENTTEL						varchar(16)
   , @CLIENTCALLYN					varchar(1)
   , @NEW_CODE                      char(7)             --  
   , @MASTER_SEQ					int
   , @TARGET						char(1)             --  
   , @POL_TYPE                      char(1)             --  
   , @SUBJECT                       varchar(400)        --  
   , @POL_DESC                      varchar(MAX)       --   
   , @OTR_POL_MASTER_SEQ			int    OUTPUT   
) 
AS 
BEGIN 
    INSERT INTO dbo.OTR_POL_MASTER 
           (  
            OTR_SEQ, 
            TARGET, 
            POL_TYPE, 
            SUBJECT, 
            POL_DESC, 
            OTR_DATE1, 
            OTR_DATE2, 
			CLIENT_NAME,
			CLIENT_TEL,
			CLIENT_CALL_YN,
            NEW_DATE, 
            NEW_CODE, 
            EDT_DATE, 
            EDT_CODE
           )   
    VALUES  
           (  
            @OTR_SEQ, 
            @TARGET, 
            @POL_TYPE, 
            @SUBJECT, 
            @POL_DESC, 
            @OTR_DATE1, 
            @OTR_DATE2, 
			@CLIENTNAME,
			@CLIENTTEL,
			@CLIENTCALLYN,
            GETDATE(), 
            @NEW_CODE, 
            GETDATE(), 
            @NEW_CODE
           )  

   SELECT @OTR_POL_MASTER_SEQ = @@IDENTITY;

END 



 --select * from OTR_POL_MASTER

GO
