USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_REQUEST_UPDATE
■ DESCRIPTION				: BTMS 출장 예약현황 출장상태변경
■ INPUT PARAMETER			: 
	@AGT_CODE		VARCHAR(10),
	@BT_CODE		VARCHAR(20),
	@EMP_CODE		EMP_CODE,
	@APPROVAL_STATE		INT
■ OUTPUT PARAMETER			: 
■ EXEC						: 

  EXEC XP_COM_BIZTRIP_APPROVAL_STATE_UPDATE '93086','BT1612090494', '2013007',2   


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-06-02		박형만	최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_APPROVAL_STATE_UPDATE]
	@AGT_CODE		VARCHAR(10),
	@BT_CODE		VARCHAR(20),
	@APPROVAL_STATE		INT ,
	@EMP_CODE		EMP_CODE,
	@NEW_SEQ		INT = NULL 
AS 
BEGIN
	--출장확정상태로
	IF @APPROVAL_STATE = 2
	BEGIN
		UPDATE COM_BIZTRIP_MASTER 
		SET
			APPROVAL_STATE = @APPROVAL_STATE,
			CONFIRM_DATE = GETDATE(),
			--CONFIRM_EMP_SEQ = @NEW_SEQ,
			CONFIRM_REMARK =' ' +  ISNULL(CONFIRM_REMARK,'') + @EMP_CODE + '출장확정' ,
			EDT_DATE = GETDATE(),
			EDT_CODE = @EMP_CODE
		WHERE
			AGT_CODE = @AGT_CODE AND BT_CODE = @BT_CODE
	END
	--출장접수상태로 
	ELSE IF @APPROVAL_STATE = 0
	BEGIN
		UPDATE COM_BIZTRIP_MASTER 
		SET
			APPROVAL_STATE = @APPROVAL_STATE,
			REQUEST_DATE = NULL,
			REQUEST_REMARK = NULL,
			CONFIRM_DATE = NULL,
			CONFIRM_REMARK = NULL,
			CONFIRM_EMP_SEQ = NULL,
			EDT_DATE = GETDATE(),
			EDT_CODE = @EMP_CODE
		WHERE
			AGT_CODE = @AGT_CODE AND BT_CODE = @BT_CODE
	END	
	--출장승인상태로
	ELSE IF @APPROVAL_STATE = 1
	BEGIN 
		UPDATE COM_BIZTRIP_MASTER 
		SET
			APPROVAL_STATE = @APPROVAL_STATE,
			REQUEST_DATE = GETDATE(),
			REQUEST_REMARK =' ' +  ISNULL(REQUEST_REMARK,'') + @EMP_CODE + '출장승인요청' ,
			EDT_DATE = GETDATE(),
			EDT_CODE = @EMP_CODE
		WHERE
			AGT_CODE = @AGT_CODE AND BT_CODE = @BT_CODE
	END



END 


GO
