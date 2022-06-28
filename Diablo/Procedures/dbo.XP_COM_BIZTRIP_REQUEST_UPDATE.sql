USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_REQUEST_UPDATE
■ DESCRIPTION				: BTMS 출장자 예약현황 출장승인요청
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@BT_CODE				: 출장번호
	@NEW_SEQ				: 본인EMPSEQ
	@REQUEST_REMARK			: 승인요?비고
■ OUTPUT PARAMETER			: 
■ EXEC						: 

  EXEC XP_COM_BIZTRIP_REQUEST_UPDATE '92756','BT1605130292', 100, 1, '', '','Y'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-03		저스트고-이유라	최초생성
   2016-03-08		저스트고-이유라	승인요청용 -> 승인처리도 가능하도록 수정
   2016-04-19		김성호			승인요청, 승인처리 시 EDT관련 컬럼 업데이트 제외 해당 컬럼은 ERP 업데이트시에만 사용
   2016-05-13		저스트고-이유라 재승인요청 작업
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_REQUEST_UPDATE]
	@AGT_CODE		VARCHAR(10),
	@BT_CODE		VARCHAR(20),
	@NEW_SEQ		INT,
	@APPROVAL_STATE		INT,
	@REQUEST_REMARK		VARCHAR(500),
	@CONFIRM_REMARK     VARCHAR(500)
AS 
BEGIN
	--출장자 승인요청시 
	IF @APPROVAL_STATE = 1
		BEGIN 
			UPDATE COM_BIZTRIP_MASTER 
			SET
				APPROVAL_STATE = @APPROVAL_STATE,
				REQUEST_DATE = GETDATE(),
				REQUEST_REMARK = @REQUEST_REMARK
			WHERE
				AGT_CODE = @AGT_CODE AND BT_CODE = @BT_CODE
		END
	--출장자 승인재요청시
	ELSE IF @APPROVAL_STATE = 0
		BEGIN
			UPDATE COM_BIZTRIP_MASTER 
			SET
				APPROVAL_STATE = @APPROVAL_STATE,
				REQUEST_DATE = NULL,
				REQUEST_REMARK = NULL,
				CONFIRM_DATE = NULL,
				CONFIRM_REMARK = NULL,
				CONFIRM_EMP_SEQ = NULL
			WHERE
				AGT_CODE = @AGT_CODE AND BT_CODE = @BT_CODE
		END	
	--관리자 승인/반려시
	ELSE 
		BEGIN
			UPDATE COM_BIZTRIP_MASTER 
			SET
				APPROVAL_STATE = @APPROVAL_STATE,
				CONFIRM_DATE = GETDATE(),
				CONFIRM_EMP_SEQ = @NEW_SEQ,
				CONFIRM_REMARK = @CONFIRM_REMARK
			WHERE
				AGT_CODE = @AGT_CODE AND BT_CODE = @BT_CODE
		END
END 

GO
