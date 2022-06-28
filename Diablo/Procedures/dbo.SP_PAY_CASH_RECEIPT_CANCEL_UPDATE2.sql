USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ Server					: 211.115.202.203
■ Database					: DIABLO
■ USP_Name					: SP_PAY_CASH_RECEIPT_CANCEL_UPDATE2 
■ Description				: 현금영수증 취소처리 신규
■ Column					:
		@RECEIPT_NO			: 예약코드
		@EDT_CODE		   	: 수정자
■ Author					: 이동호
■ Date						: 2013-08-20 
■ Memo						:
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
   Date				Author			Description           
------------------------------------------------------------------------------------------------------------------
   2013-08-19       이동호			최초생성  
================================================================================================================*/ 

CREATE PROC [dbo].[SP_PAY_CASH_RECEIPT_CANCEL_UPDATE2]
(
	@RECEIPT_NO						INT,
	@REPLY_CODER					VARCHAR(5),
	@APPROVAL_DATE					DATETIME,	
	@RECEIPT_STATE					INT,
	@EDT_CODE						EMP_CODE,
	@CXL_TYPE						INT,
	@PG_NO							VARCHAR(30)
)

AS
	BEGIN
		UPDATE DBO.PAY_CASH_RECEIPT_damo
			SET
				RECEIPT_STATE = @RECEIPT_STATE,
				CXL_REPLY_CODER	= @REPLY_CODER , 
				CXL_CODE = @EDT_CODE ,
				CXL_DATE = GETDATE() ,
				CXL_REMARK = '[RETURN]PG_NO:' + @PG_NO,
				CXL_TYPE = @CXL_TYPE 
		WHERE RECEIPT_NO = @RECEIPT_NO
	END


GO
