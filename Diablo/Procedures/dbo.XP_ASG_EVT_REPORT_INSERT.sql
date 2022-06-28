USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_INSERT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 저장
■ INPUT PARAMETER			: 
	 @PRO_CODE                      varchar(20)         --  
   , @NEW_CODE                      char(7)             --  
   , @OTR_SEQ                       int    OUTPUT   

■ OUTPUT PARAMETER			: 

■ EXEC						: 
	
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-09		오인규			최초생성
   2014-01-15		김성호			퀴리수정
================================================================================================================*/ 
 CREATE PROCEDURE [dbo].[XP_ASG_EVT_REPORT_INSERT] 
 ( 
     @PRO_CODE                      varchar(20)         --  
   , @NEW_CODE                      char(7)             --  
   , @OTR_SEQ                       int    OUTPUT   
) 
AS 
BEGIN 
    
	IF NOT EXISTS(SELECT OTR_SEQ FROM dbo.OTR_MASTER WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
    BEGIN
		INSERT INTO dbo.OTR_MASTER 
		(
			PRO_CODE, 
			OTR_STATE,  
			EDI_CODE, 
			NEW_DATE, 
			NEW_CODE,
			EDT_DATE,
			EDT_CODE
		)   
		VALUES  
		(
			@PRO_CODE, 
			'1',  /* 출장보고서 상태 : 0-미작성, 1-작성중, 2-진행중, 3-작성완료, 4-재검토 */
			'',--@EDI_CODE, 
			GETDATE(), 
			@NEW_CODE,
			GETDATE(),
			@NEW_CODE
		)  
 
		SELECT @OTR_SEQ = @@IDENTITY;
	END
    ELSE
	BEGIN
		SELECT @OTR_SEQ = OTR_SEQ FROM OTR_MASTER WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE;
		--SELECT @OTR_SEQ = @@IDENTITY; 
	END
END 

GO
