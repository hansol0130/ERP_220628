USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ Server					: 211.115.202.203
■ Database					: DIABLO
■ USP_Name					: SP_PAY_CASH_RECEIPT_SOC_UPDATE 
■ Description				: 현금영수증 주민등록번호 수정
■ Column					:
		@RECEIPT_NO			: 예약코드
		@SOC_NUM1			: 주민번호1
		@SOC_NUM2			: 주민번호2
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
================================================================================================================*/ 

CREATE PROC [dbo].[SP_PAY_CASH_RECEIPT_SOC_UPDATE]
(
	@RECEIPT_NO						INT,
	@SOC_NUM1						VARCHAR(6),
	@SOC_NUM2						VARCHAR(7),
	@EDT_CODE						INT
)

AS

	BEGIN
		DECLARE @CUS_NO INT

		SELECT @CUS_NO = CUS_NO
		FROM DBO.CUS_CUSTOMER_damo
		WHERE CUS_ID IS NOT NULL
		  AND SOC_NUM1 = @SOC_NUM1
		  AND SEC_SOC_NUM2 = damo.dbo.enc_varchar('DIABLO', 'dbo.CUS_CUSTOMER','SOC_NUM2', @SOC_NUM2)

		UPDATE DBO.PAY_CASH_RECEIPT_damo
			SET CUS_NO = @CUS_NO,
				SOC_NUM1 = @SOC_NUM1,
				SEC_SOC_NUM2 = damo.dbo.enc_varchar('DIABLO', 'dbo.PAY_CASH_RECEIPT','SOC_NUM2', @SOC_NUM2),
				EDT_CODE = @EDT_CODE,
				EDT_DATE = GETDATE()
		WHERE RECEIPT_NO = @RECEIPT_NO
	END
GO
