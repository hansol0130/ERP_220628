USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	SQL.함수_결제요청정보_조회
====================================================================================
- SP 명 : SP_KICC_PAYMENT_REQUEST_SELECT_COUNT
- 기 능 : KICC 결제 요청정보 카운트 , 합계  
====================================================================================
	참고내용
====================================================================================
- 예제

 
====================================================================================
	변경내역
====================================================================================
- 2019-01-08 박형만  생성
- 2021-06-23 김영민 SMSPAY추가
===================================================================================*/
CREATE PROC [dbo].[SP_KICC_PAYMENT_REQUEST_SELECT_COUNT]
	@RES_CODE RES_CODE
AS 
BEGIN
	-- 카운트 
	SELECT 
		SUM(CASE WHEN A.PAY_REQ_TYPE = 'VACCT' THEN 1 ELSE 0 END) AS VACCT_CNT,
		SUM(CASE WHEN A.PAY_REQ_TYPE = 'CARD' THEN 1 ELSE 0 END) AS CARD_CNT,
		SUM(CASE WHEN A.PAY_REQ_TYPE = 'ARS' THEN 1 ELSE 0 END) AS ARS_CNT , 
		SUM(CASE WHEN A.PAY_REQ_TYPE = 'SMSPAY' THEN 1 ELSE 0 END) AS SMSPAY_CNT , 
		SUM(CASE WHEN A.PAY_REQ_TYPE = 'VACCT' AND A.REQ_EXP_DATE > GETDATE() THEN A.REQ_AMOUNT ELSE 0 END) AS VACCT_AMOUNT,
		SUM(CASE WHEN A.PAY_REQ_TYPE = 'CARD' AND A.REQ_EXP_DATE > GETDATE() THEN A.REQ_AMOUNT ELSE 0 END) AS CARD_AMOUNT,
		SUM(CASE WHEN A.PAY_REQ_TYPE = 'SMSPAY' AND A.REQ_EXP_DATE > GETDATE() THEN A.REQ_AMOUNT ELSE 0 END) AS SMSPAY_AMOUNT,
		SUM(CASE WHEN A.PAY_REQ_TYPE = 'ARS' AND  (A.REQ_EXP_DATE > GETDATE() OR DATEADD(D,1,CONVERT(DATE,A.NEW_DATE)) > GETDATE()) THEN A.REQ_AMOUNT ELSE 0 END) AS ARS_AMOUNT 
	FROM KICC_PAY_REQUEST A 
	WHERE  A.RES_CODE = @RES_CODE  
	AND (A.DEL_YN ='N' OR A.DEL_YN IS NULL )
	--AND A.REQ_EXP_DATE > GETDATE()
	
END 

GO
