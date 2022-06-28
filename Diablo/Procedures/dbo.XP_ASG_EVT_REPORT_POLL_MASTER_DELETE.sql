USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_POLL_MASTER_DELETE
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 POLL MASTER 삭제
■ INPUT PARAMETER			: 
	@OTR_SEQ                       int                 --  
   , @OTR_DATE1                     varchar(10)         --  
   , @OTR_DATE2                     varchar(10)         --  
   , @OTR_CITY                      varchar(60)         --  
   , @AGT_CODE                      varchar(10)         --  
   , @GUIDE_NAME                    varchar(50)         --  
   , @HOTEL_NAME                    varchar(60)         --  
   , @MEAL_TYPE                     varchar(1)          --  
   , @RESTAURANT_NAME               varchar(60)         --  
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
 CREATE PROCEDURE [dbo].[XP_ASG_EVT_REPORT_POLL_MASTER_DELETE] 
 ( 
     @OTR_POL_MASTER_SEQ			int  
) 
AS 
BEGIN 
  DELETE dbo.OTR_POL_MASTER 
   WHERE OTR_POL_MASTER_SEQ = @OTR_POL_MASTER_SEQ 

END 

GO
