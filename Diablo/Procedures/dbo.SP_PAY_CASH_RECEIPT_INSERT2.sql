USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ Server					: 211.115.202.203
■ Database					: DIABLO
■ USP_Name					: SP_PAY_CASH_RECEIPT_INSERT 
■ Description				: 현금영수증 신청 저장
■ Column					:
		@RES_CODE			: 예약코드
		@CUS_NAME			: 고객명
		@SOC_NUM1			: 주민번호1
		@SOC_NUM2			: 주민번호2
		@NOR_TEL1			: 전화번호1
		@NOR_TEL2			: 전화번호2
		@NOR_TEL3			: 전화번호3
		@CPN_NUM1			: 사업자번호1
		@CPN_NUM2			: 사업자번호2
		@CPN_NUM3			: 사업자번호3
		@TARGET_USE			: 용도
		@TARGET_PRICE		: 신청금액
		@APPROVAL_NO		: 승인번호
		@APPROVAL_SEQ		: 승인SEQ
		@REPLY_CODER		: 응답코더
		@APPROVAL_DATE		: 승인일시
		@RECEIPT_STATE		: 상태
		@NEW_CODE		   	: 생성자
		@PG_NO		   		: PG거래번호
		@RECEIPT_TYPE		: 현금영수증 기존모듈 = 0, 신규모듈 = 1
■ Author					: 임형민
■ Date						: 2010-11-08 
■ Memo						:
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
   Date				Author			Description           
------------------------------------------------------------------------------------------------------------------
    2010-11-08       임형민			최초생성  
	2011-11-01       박형만			AGT_CODE 추가 
	2013-08-20       이동호			PG_NO 추가 PG거래번호 고유번호
	2013-08-20       이동호			RECEIPT_TYPE 추가 기존모듈 신규모듈 구분
	2015-03-03		 김성호			주민번호 삭제, 생년월일 추가
================================================================================================================*/ 

CREATE PROC [dbo].[SP_PAY_CASH_RECEIPT_INSERT2]
(
	@RES_CODE						CHAR(12),
	@CUS_NAME						VARCHAR(20),
	--@SOC_NUM1						VARCHAR(6),
	--@SOC_NUM2						VARCHAR(7),
	@NOR_TEL1						VARCHAR(3),
	@NOR_TEL2						VARCHAR(4),
	@NOR_TEL3						VARCHAR(4),
	@CPN_NUM1						VARCHAR(3),
	@CPN_NUM2						VARCHAR(2),
	@CPN_NUM3						VARCHAR(5),
	@TARGET_USE						INT,
	@TARGET_PRICE					INT,
	@APPROVAL_NO					VARCHAR(30),
	@APPROVAL_SEQ					VARCHAR(30),
	@REPLY_CODER					VARCHAR(5),
	@APPROVAL_DATE					DATETIME,	
	@RECEIPT_STATE					INT,
	@NEW_CODE						INT,
	@AGT_CODE						VARCHAR(10),
	@PG_NO							VARCHAR(30),
	@RECEIPT_TYPE					INT
)

AS

	BEGIN
		--DECLARE @CUS_NO INT

		--SELECT @CUS_NO = CUS_NO
		--FROM DBO.CUS_CUSTOMER_damo
		--WHERE CUS_ID IS NOT NULL
		--  AND SOC_NUM1 = @SOC_NUM1
		--  AND SEC_SOC_NUM2 = damo.dbo.enc_varchar('DIABLO', 'dbo.CUS_CUSTOMER','SOC_NUM2', @SOC_NUM2)

		--INSERT INTO DBO.PAY_CASH_RECEIPT_damo(RES_CODE, CUS_NO, CUS_NAME, SOC_NUM1, NOR_TEL1, NOR_TEL2, NOR_TEL3, CPN_NUM1, CPN_NUM2, CPN_NUM3, TARGET_USE, TARGET_PRICE, APPROVAL_NO, APPROVAL_SEQ, REPLY_CODER, APPROVAL_DATE, RECEIPT_STATE, NEW_CODE, NEW_DATE, SEC_SOC_NUM2 , AGT_CODE, PG_NO, RECEIPT_TYPE)
		--VALUES (@RES_CODE, @CUS_NO, @CUS_NAME, @SOC_NUM1, @NOR_TEL1, @NOR_TEL2, @NOR_TEL3, @CPN_NUM1, @CPN_NUM2, @CPN_NUM3, @TARGET_USE, @TARGET_PRICE, @APPROVAL_NO, @APPROVAL_SEQ, @REPLY_CODER, @APPROVAL_DATE, @RECEIPT_STATE, @NEW_CODE, GETDATE(), damo.dbo.enc_varchar('DIABLO', 'dbo.PAY_CASH_RECEIPT','SOC_NUM2', @SOC_NUM2) ,@AGT_CODE, @PG_NO, @RECEIPT_TYPE)

		INSERT INTO DBO.PAY_CASH_RECEIPT_damo(RES_CODE, CUS_NAME, NOR_TEL1, NOR_TEL2, NOR_TEL3, CPN_NUM1, CPN_NUM2, CPN_NUM3, TARGET_USE, TARGET_PRICE, APPROVAL_NO, APPROVAL_SEQ, REPLY_CODER, APPROVAL_DATE, RECEIPT_STATE, NEW_CODE, NEW_DATE, AGT_CODE, PG_NO, RECEIPT_TYPE)
		VALUES (@RES_CODE, @CUS_NAME, @NOR_TEL1, @NOR_TEL2, @NOR_TEL3, @CPN_NUM1, @CPN_NUM2, @CPN_NUM3, @TARGET_USE, @TARGET_PRICE, @APPROVAL_NO, @APPROVAL_SEQ, @REPLY_CODER, @APPROVAL_DATE, @RECEIPT_STATE, @NEW_CODE, GETDATE(), @AGT_CODE, @PG_NO, @RECEIPT_TYPE)

	END
	
GO
