USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_ERP_BIZTRIP_DETAIL_PAY_LATER_UPDATE
■ DESCRIPTION				: BTMS ERP 출장 예약 후불 처리자 정보 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-27		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_ERP_BIZTRIP_DETAIL_PAY_LATER_UPDATE]
	@AGT_CODE			VARCHAR(10),
	@BT_CODE			VARCHAR(20),
	@RES_CODE			VARCHAR(20),
	@EMP_SEQ			INT,
	@EMP_CODE			VARCHAR(10)
AS 
BEGIN

	UPDATE COM_BIZTRIP_DETAIL SET PAY_LATER_EMP_SEQ = @EMP_SEQ, PAY_LATER_DATE = GETDATE(), PAY_LATER_EMP_CODE = @EMP_CODE
	WHERE AGT_CODE = @AGT_CODE AND BT_CODE = @BT_CODE AND RES_CODE = @RES_CODE;

END

GO
