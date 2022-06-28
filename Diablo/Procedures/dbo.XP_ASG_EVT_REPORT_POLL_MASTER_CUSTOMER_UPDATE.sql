USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_POLL_MASTER_CUSTOMER_UPDATE
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 POLL MASTER 수정
■ INPUT PARAMETER			: 
	@OTR_POL_MASTER_SEQ	int : POLL MASTER SEQ
	@CLIENTCALLYN varchar(1): 통화여부
    @NEW_CODE     char(7)	: 수정자 코드

■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC XP_ASG_EVT_REPORT_POLL_MASTER_CUSTOMER_UPDATE '17897' , 'Y', '9999999'
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-10-30		김완기			최초생성   
================================================================================================================*/ 
 CREATE PROCEDURE [dbo].[XP_ASG_EVT_REPORT_POLL_MASTER_CUSTOMER_UPDATE] 
 ( 
     @OTR_POL_MASTER_SEQ            int
   , @CLIENTCALLYN					varchar(1)
   , @NEW_CODE                      char(7) 
) 
AS 
BEGIN 
    UPDATE dbo.OTR_POL_MASTER 
       SET CLIENT_CALL_YN = @CLIENTCALLYN,
           EDT_DATE = getdate(), 
           EDT_CODE = @NEW_CODE
	 WHERE OTR_POL_MASTER_SEQ = @OTR_POL_MASTER_SEQ

END 


GO
