USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_HTL_RESERVE_CANCEL
■ DESCRIPTION				: 호텔 예약 정보 취소
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-17		박형만			최초생성
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_WEB_HTL_RESERVE_CANCEL]
	@RES_CODE	RES_CODE ,
	@RES_STATE	INT ,
	@HTL_RES_STATE INT , 
	@EDT_CODE EMP_CODE ,
	@CUS_NO INT 
AS 
BEGIN
	
	BEGIN TRAN 

	UPDATE RES_MASTER_damo SET RES_STATE = @RES_STATE, EDT_CODE = @EDT_CODE, EDT_DATE = GETDATE() , CXL_DATE = GETDATE(), CXL_CODE = @EDT_CODE
	WHERE RES_CODE = @RES_CODE

	UPDATE RES_HTL_ROOM_MASTER SET RES_STATE = @HTL_RES_STATE, EDT_CODE = @EDT_CODE, EDT_DATE = GETDATE() ,	ROOM_YN ='N' ,
		SALE_PRICE = 0 ,TAX_PRICE = 0 ,DC_PRICE= 0 ,CHG_PRICE= 0 ,PENALTY_PRICE= 0 ,NET_PRICE= 0 
	WHERE RES_CODE = @RES_CODE

	IF( @@ERROR <> 0 )
	BEGIN
		ROLLBACK TRAN 
	END 
	ELSE 
	BEGIN
		COMMIT TRAN 
	END 
END 
GO
