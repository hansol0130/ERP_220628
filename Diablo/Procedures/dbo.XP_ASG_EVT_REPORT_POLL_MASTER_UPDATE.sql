USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_POLL_MASTER_UPDATE
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 POLL MASTER 수정
■ INPUT PARAMETER			: 
	@OTR_SEQ                       int                 --  
   , @OTR_DATE1                     varchar(10)         --  
   , @OTR_DATE2                     varchar(10)         --  
   , @OTR_CITY                      varchar(60)         --  
   , @AGT_CODE                      varchar(10)         --  
   , @AGT_NAME                      varchar(50)         --  
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
   2014-01-15		이동호			APP_LIST 컬럼 추가 임시 참조자 정보 등록 컬럼 
   2014-03-07		이동호			AGT_NAME 회사명 직접입력 컬럼 추가 
================================================================================================================*/ 
 CREATE PROCEDURE [dbo].[XP_ASG_EVT_REPORT_POLL_MASTER_UPDATE] 
 ( 
     @OTR_SEQ                       int                 --  
   , @OTR_DATE1                     varchar(10)         --  
   , @OTR_DATE2                     varchar(10)         --  
   , @OTR_CITY                      varchar(60)         --  
   , @AGT_CODE                      varchar(10)         -- 
   , @AGT_NAME                      varchar(50)         --  
   , @GUIDE_NAME                    varchar(50)         --  
   , @MEM_CODE                    varchar(7)         -- 
   , @HOTEL_NAME                    varchar(60)         --  
   , @MEAL_TYPE                     varchar(1)          --  
   , @RESTAURANT_NAME               varchar(60)         --  
   , @NEW_CODE                      char(7)             --  
   , @MASTER_SEQ					int
   , @TARGET						char(1)             --  
   , @POL_TYPE                      char(1)             --  
   , @SUBJECT                       varchar(400)        --  
   , @POL_DESC                      varchar(MAX)       --  
   , @OTR_POL_MASTER_SEQ			int  
   , @APP_LIST						varchar(500)  
) 
AS 
BEGIN 
 
     UPDATE dbo.OTR_POL_MASTER 
      SET  
          OTR_SEQ                        = @OTR_SEQ, 
          TARGET                         = @TARGET, 
          POL_TYPE                       = @POL_TYPE, 
          SUBJECT                        = @SUBJECT, 
          POL_DESC                       = @POL_DESC, 
          OTR_DATE1                      = @OTR_DATE1, 
          OTR_DATE2                      = @OTR_DATE2, 
          OTR_CITY                       = @OTR_CITY, 
          AGT_CODE                       = @AGT_CODE, 
		  AGT_NAME                       = @AGT_NAME, 
          GUIDE_NAME                     = @GUIDE_NAME, 
		  MEM_CODE						 = @MEM_CODE,
          HOTEL_NAME                     = @HOTEL_NAME, 
          MEAL_TYPE                      = @MEAL_TYPE, 
          RESTAURANT_NAME                = @RESTAURANT_NAME, 
           EDT_DATE                       = GETDATE(), 
          EDT_CODE                       = @NEW_CODE,   
		  APP_LIST                       = @APP_LIST  
    WHERE OTR_POL_MASTER_SEQ = @OTR_POL_MASTER_SEQ 

END 

GO
