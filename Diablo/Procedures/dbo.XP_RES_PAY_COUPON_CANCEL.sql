USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_RES_PAY_COUPON_CANCEL
■ DESCRIPTION				: 업체 쿠폰 취소  
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec XP_RES_PAY_COUPON_CANCEL 'RT1704185201'  ,0 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-04-25		박형만			최초생성
================================================================================================================*/ 
create PROC [dbo].[XP_RES_PAY_COUPON_CANCEL]
	@RES_CODE	RES_CODE,
	@CPN_SEQ INT = 0 
AS 
BEGIN
	
	IF( @CPN_SEQ > 0 )
	BEGIN
		UPDATE PAY_COUPON 
		SET CXL_YN = 'Y' ,CXL_DATE = GETDATE()
		WHERE RES_CODE = @RES_CODE 
		AND CPN_SEQ = @CPN_SEQ
		AND CXL_YN = 'N' 
	END 
	ELSE 
	BEGIN
		UPDATE PAY_COUPON 
		SET CXL_YN = 'Y' ,CXL_DATE = GETDATE()
		WHERE RES_CODE = @RES_CODE  
	END 
END 
GO
