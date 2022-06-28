USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_DETAIL_CUS_UPDATE
■ DESCRIPTION				: 대외업무시스템 인솔자관리 배정행사 상세정보 출발고객 통화여부 저장
■ INPUT PARAMETER			: 
	@RES_CODE                      char(12)            -- (PK) 
   ,@SEQ_NO                        int                 -- (PK) 
   ,@CALL_DATE                     datetime            --  
■ OUTPUT PARAMETER			: 
							: 
■ EXEC						: 
	DECLARE @RES_CODE                      char(12)            -- (PK) 
   ,@SEQ_NO                        int                 -- (PK) 
   ,@CALL_DATE                     datetime            --  

	SELECT @PRO_CODE='APP0504-130327TG5'

	exec XP_ASG_EVT_DETAIL_CUS_LIST_SELECT @PRO_CODE ,@SEQ_NO , @CALL_DATE
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-27		오인규			최초생성   
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_ASG_EVT_DETAIL_CUS_UPDATE]
(
	@RES_CODE                      char(12)            -- (PK) 
   ,@SEQ_NO                        int                 -- (PK) 
   ,@CALL_DATE                     datetime            --  
   ,@EDT_CODE					   char(7)			
)
AS  
BEGIN
	SET NOCOUNT OFF;

    UPDATE  dbo.RES_CUSTOMER_damo 
	SET		CALL_DATE = @CALL_DATE
			,CALL_CODE = @EDT_CODE
			,EDT_CODE = @EDT_CODE
            ,EDT_DATE  = GETDATE()
	WHERE	RES_CODE = @RES_CODE 
      AND	SEQ_NO = @SEQ_NO 


END




	


GO
