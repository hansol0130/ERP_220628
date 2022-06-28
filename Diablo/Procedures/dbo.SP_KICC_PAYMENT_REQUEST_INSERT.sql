USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	SQL.함수_결제요청정보_등록
====================================================================================
- SP 명 : SP_KICC_PAYMENT_REQUEST_INSERT
- 기 능 : KICC 결제 요청정보 등록  
====================================================================================
	참고내용
====================================================================================
- 예제

18061119060110699433
 
 exec SP_KICC_PAYMENT_REQUEST_INSERT @REQ_CTR_NO='19011011170100_014228549',
  @RES_CODE=N'RP1812247210',
  @RES_SEQ_NO = 1,
  @KICC_ID = 'T5102001',
  @PAY_REQ_TYPE ='CARD',
  @BANK_CODE =NULL,@ACCT_NUM =NULL,@REQ_EXP_DATE= '2019-05-01',
  @CUS_NAME ='박형만',@CUS_TEL ='01091852481',@CUS_EMAIL= '',
  @REQ_AMOUNT =1000 ,@REQ_REMARK ='',@NEW_CODE= '2013007'

 
===============================================================================	=====
	변경내역
====================================================================================
- 2019-01-08 박형만  생성

===================================================================================*/
CREATE PROC [dbo].[SP_KICC_PAYMENT_REQUEST_INSERT]
	@REQ_CTR_NO varchar(30),
	@RES_CODE RES_CODE,
	@RES_SEQ_NO INT,
	@KICC_ID VARCHAR(15),
	@PAY_REQ_TYPE VARCHAR(10),
	@BANK_CODE VARCHAR(10), --가상계좌: 은행코드 , 신용카드:은행카드코드 (KICC기준)
	@ACCT_NUM VARCHAR(20),
	@REQ_EXP_DATE DATETIME,
	@CUS_NAME VARCHAR(20),
	@CUS_TEL VARCHAR(20),
	@CUS_EMAIL VARCHAR(40),
	@REQ_AMOUNT INT ,
	--@COMP_YN CHAR(1),
	--@SMS_YN CHAR(1),
	@REQ_REMARK VARCHAR(MAX), -- 요청파라미터정보 
	@NEW_CODE NEW_CODE 
AS 
BEGIN

	DECLARE @SMS_YN CHAR(1)
	DECLARE @LAST_SEND_DATE DATETIME
	DECLARE @LAST_SEND_EMP NEW_CODE
	
	SET @SMS_YN = CASE WHEN @PAY_REQ_TYPE = 'ARS' THEN 'Y' ELSE 'N' END 
	SET @LAST_SEND_DATE = CASE WHEN @PAY_REQ_TYPE = 'ARS' THEN GETDATE() ELSE NULL END 
	SET @LAST_SEND_EMP = CASE WHEN @PAY_REQ_TYPE = 'ARS' THEN @NEW_CODE ELSE NULL END 

	INSERT INTO  KICC_PAY_REQUEST ( 
		REQ_CTR_NO,RES_CODE,KICC_ID,PAY_REQ_TYPE,
		BANK_CODE,ACCT_NUM,REQ_EXP_DATE,CUS_NAME,CUS_TEL,CUS_EMAIL,REQ_AMOUNT,
		COMP_YN,SMS_YN,REQ_REMARK,NEW_CODE,RES_SEQ_NO,LAST_SEND_DATE,LAST_SEND_EMP)
	VALUES ( 
		@REQ_CTR_NO,@RES_CODE,@KICC_ID,@PAY_REQ_TYPE,
		@BANK_CODE,@ACCT_NUM,@REQ_EXP_DATE,@CUS_NAME,@CUS_TEL,@CUS_EMAIL,@REQ_AMOUNT,
		'N',@SMS_YN,@REQ_REMARK,@NEW_CODE,@RES_SEQ_NO,@LAST_SEND_DATE,@LAST_SEND_EMP )

	SELECT @@IDENTITY
END 


GO
