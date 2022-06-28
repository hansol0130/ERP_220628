USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	SQL.함수_가상계좌_결제승인완료
====================================================================================
- SP 명 : SP_KICC_WEBPAY_PAYMENT_RESPONSE
- 기 능 : KICC WEBPAY(NONPLUGIN) 카드 결제 승인 완료시 응답값
====================================================================================
	참고내용
====================================================================================
- 예제
 
 exec SP_KICC_WEBPAY_PAYMENT_RESPONSE @REQ_CTR_NO=N'00198312062823784858'
 ,@REMARK=NULL
 
====================================================================================
	변경내역
====================================================================================
- 2016-08-03 박형만  생성
===================================================================================*/
CREATE  PROC [dbo].[SP_KICC_WEBPAY_PAYMENT_RESPONSE]
	@REQ_CTR_NO VARCHAR(30),  --요청 승인 번호
	@REMARK varchar(MAX)	--	응답 비고  
AS 
SET NOCOUNT ON 
BEGIN
	
	--요청정보 조회( 요청정보가 있는지 없는지)
	IF EXISTS ( SELECT * FROM KICC_PAY_REQUEST  WITH(NOLOCK)
		WHERE REQ_CTR_NO = @REQ_CTR_NO 
		/*AND	RES_CODE = @RES_CODE*/ )
	BEGIN
	
		UPDATE KICC_PAY_REQUEST 
		SET RES_REMARK = @REMARK 
		WHERE REQ_CTR_NO = @REQ_CTR_NO 
	END 
	--ELSE
	--BEGIN
	--	SET @RET_MSG = '가상계좌 요청정보가 존재하지 않습니다!' 
		
	--	SET @RET_MSG = @RET_MSG +'요청PG거래번호:' +ISNULL(@REQ_CTR_NO ,'')
	--	SET @RET_MSG = @RET_MSG +',응답PG거래번호:' +ISNULL(@RES_CTR_NO ,'')
	--	SET @RET_MSG = @RET_MSG +',예약코드:' +ISNULL(@RES_CODE ,'')
	--	SET @RET_MSG = @RET_MSG +',은행계좌:(' +ISNULL(@BANK_CODE ,'')+')'+ISNULL(@ACCT_NUM ,'')
	--	SET @RET_MSG = @RET_MSG +',입금자:' +ISNULL(@PAY_NAME ,'')
	--	SET @RET_MSG = @RET_MSG +',금액:' +ISNULL( CONVERT(VARCHAR,@AMOUNT) ,'');
		
	--	THROW 50001,@RET_MSG,1;
	--	RETURN 
	--END 
	
END 
GO
