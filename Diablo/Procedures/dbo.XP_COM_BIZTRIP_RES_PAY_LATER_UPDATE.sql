USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_RES_PAY_LATER_UPDATE
■ DESCRIPTION				: BTMS 출장예약 후불결제 처리  
■ INPUT PARAMETER			: 
	
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-06		박형만			최초생성
   2016-04-19		김성호			COM_BIZTRIP_DETAIL 테이블에서 PAY_REQUEST_DATE 제거
   2016-05-19		박형만			후불결제시 예약 상태변경하지 않음 - 김민정대리 요청
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_RES_PAY_LATER_UPDATE] 
(
	@RES_CODE VARCHAR(20),
	@AGT_CODE VARCHAR(20),
	@EMP_SEQ INT ,
	@EMP_CODE EMP_CODE
)
AS 
BEGIN 

	--UPDATE RES_MASTER_damo SET RES_STATE = 4 , EDT_CODE = @EMP_CODE, EDT_DATE = GETDATE()
	--WHERE RES_CODE = @RES_CODE

	UPDATE COM_BIZTRIP_DETAIL 
	SET PAY_LATER_EMP_SEQ = @EMP_SEQ ,
		PAY_LATER_DATE = GETDATE(),
		PAY_LATER_EMP_CODE = @EMP_CODE
	WHERE AGT_CODE = @AGT_CODE AND RES_CODE = @RES_CODE
END 


GO
