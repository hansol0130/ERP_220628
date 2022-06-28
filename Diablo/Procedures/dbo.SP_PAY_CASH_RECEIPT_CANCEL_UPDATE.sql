USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ Server					: 211.115.202.203
■ Database					: DIABLO
■ USP_Name					: SP_PAY_CASH_RECEIPT_CANCEL_UPDATE 
■ Description				: 현금영수증 취소처리
■ Column					:
		@RECEIPT_NO			: 예약코드
		@EDT_CODE		   	: 수정자
■ Author					: 임형민
■ Date						: 2010-11-09 
■ Memo						:
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
   Date				Author			Description           
------------------------------------------------------------------------------------------------------------------
   2010-11-09       임형민			최초생성  
   2012-10-02		박형만			취소컬럼 추가 
================================================================================================================*/ 

CREATE PROC [dbo].[SP_PAY_CASH_RECEIPT_CANCEL_UPDATE]
(
	@RECEIPT_NO						INT,
	@APPROVAL_NO					VARCHAR(30),
	@APPROVAL_SEQ					VARCHAR(30),
	@REPLY_CODER					VARCHAR(5),
	@APPROVAL_DATE					DATETIME,	
	@RECEIPT_STATE					INT,
	@EDT_CODE						EMP_CODE,
	@CXL_TYPE						INT
)

AS
	BEGIN
		UPDATE DBO.PAY_CASH_RECEIPT_damo
			SET
				--APPROVAL_NO = @APPROVAL_NO,
				--APPROVAL_SEQ = @APPROVAL_SEQ,
				--REPLY_CODER = @REPLY_CODER,
				--APPROVAL_DATE = @APPROVAL_DATE,
				RECEIPT_STATE = @RECEIPT_STATE,
				--EDT_CODE = @EDT_CODE,
				--EDT_DATE = GETDATE()
				CXL_REPLY_CODER	= @REPLY_CODER , 
				CXL_CODE = @EDT_CODE ,
				CXL_DATE = GETDATE() ,
				CXL_REMARK = '[RETURN]APPROVAL_NO:' + ISNULL(@APPROVAL_NO,'') + ',APPROVAL_NO:' + ISNULL(@APPROVAL_SEQ,''),
				CXL_TYPE = @CXL_TYPE 
		WHERE RECEIPT_NO = @RECEIPT_NO
	END
GO
