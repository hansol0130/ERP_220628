USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	SQL.함수_결제요청정보_조회
====================================================================================
- SP 명 : SP_KICC_PAYMENT_REQUEST_SELECT
- 기 능 : KICC 결제 요청정보 조회 
====================================================================================
	참고내용
====================================================================================
- 예제
 

 select top 100 * from
 
 LAST_SEND_DATE
 

 exec  SP_KICC_PAYMENT_REQUEST_SELECT @SEQ_NO=1244359 , @REQ_CTR_NO = '' 
 
====================================================================================
	변경내역
====================================================================================
- 2019-01-08 박형만  생성

===================================================================================*/
CREATE PROC [dbo].[SP_KICC_PAYMENT_REQUEST_SELECT]
	@SEQ_NO INT  , 
	@REQ_CTR_NO VARCHAR(30) = NULL 
AS 
BEGIN

	IF( @SEQ_NO > 0 ) 
	BEGIN
		SELECT TOP 1 
		A.SEQ_NO,
		A.REQ_CTR_NO,
		A.RES_CODE,
		A.RES_SEQ_NO,
		A.KICC_ID,
		A.PAY_REQ_TYPE,
		A.BANK_CODE,
		A.ACCT_NUM,
		A.REQ_EXP_DATE,
		A.CUS_NAME,
		A.CUS_TEL,
		A.CUS_EMAIL,
		A.REQ_AMOUNT,
		A.COMP_YN,
		A.REQ_REMARK,
		A.NEW_CODE,
		A.NEW_DATE,
		A.EDT_CODE,
		A.EDT_DATE,

		B.PAY_SEQ ,
		B.RES_CTR_NO ,

		C.SALE_COM_CODE ,
		C.PRO_CODE ,
		C.PRO_TYPE , 
		C.PROVIDER ,

		C.PRO_NAME ,
		C.PRICE_SEQ
		FROM KICC_PAY_REQUEST A WITH(NOLOCK)  
			LEFT JOIN KICC_PAY_RESPONSE B WITH(NOLOCK)
				ON A.REQ_CTR_NO = B.REQ_CTR_NO 
			LEFT JOIN RES_MASTER_DAMO C WITH(NOLOCK)
				ON A.RES_CODE = C.RES_CODE 
		WHERE A.SEQ_NO = @SEQ_NO
		ORDER BY A.SEQ_NO DESC
	END 
	ELSE 
	BEGIN
	
		SELECT TOP 1 
		A.SEQ_NO,
		A.REQ_CTR_NO,
		A.RES_CODE,
		A.RES_SEQ_NO,
		A.KICC_ID,
		A.PAY_REQ_TYPE,
		A.BANK_CODE,
		A.ACCT_NUM,
		A.REQ_EXP_DATE,
		A.CUS_NAME,
		A.CUS_TEL,
		A.CUS_EMAIL,
		A.REQ_AMOUNT,
		A.COMP_YN,
		A.REQ_REMARK,
		A.NEW_CODE,
		A.NEW_DATE,
		A.EDT_CODE,
		A.EDT_DATE,

		B.PAY_SEQ ,
		B.RES_CTR_NO ,

		C.SALE_COM_CODE ,
		C.PRO_CODE ,
		C.PRO_TYPE , 
		C.PROVIDER ,

		C.PRO_NAME ,
		C.PRICE_SEQ
		FROM KICC_PAY_REQUEST A WITH(NOLOCK)  
			LEFT JOIN KICC_PAY_RESPONSE B WITH(NOLOCK)
				ON A.REQ_CTR_NO = B.REQ_CTR_NO 
			LEFT JOIN RES_MASTER_DAMO C WITH(NOLOCK)
				ON A.RES_CODE = C.RES_CODE 
		WHERE A.REQ_CTR_NO = @REQ_CTR_NO
		ORDER BY A.SEQ_NO DESC

	END 
	

END 

GO
