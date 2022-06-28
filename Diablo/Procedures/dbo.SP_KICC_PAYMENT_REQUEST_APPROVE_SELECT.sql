USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	SQL.함수_결제요청정보_조회
====================================================================================
- SP 명 : SP_KICC_PAYMENT_REQUEST_APPROVE_SELECT
- 기 능 : KICC 결제 요청정보 조회 (승인노티받을시)
====================================================================================
	참고내용
====================================================================================
- 예제
 

 select top 100 * from
 
 LAST_SEND_DATE
 

 exec  SP_KICC_PAYMENT_REQUEST_APPROVE_SELECT @REQ_CTR_NO = '19040315020210947188' ,
 @RES_CODE = 'RP1904036889',
 @PAY_NAME = '서민교',
 @ACCT_NUM = '56211159152205',
 @AMOUNT =  100000
 
====================================================================================
	변경내역
====================================================================================
- 2019-02-19 박형만  생성
- 2019-04-11 박형만  DEL_YN ='Y' 여도 입금 되도록 ,,가상계좌 삭제 하는 직원들이 있네요,,,휴

===================================================================================*/
CREATE PROC [dbo].[SP_KICC_PAYMENT_REQUEST_APPROVE_SELECT]
	@REQ_CTR_NO VARCHAR(30) ,
	

	@RES_CODE RES_CODE = NULL ,
	
	@PAY_NAME VARCHAR(80)= NULL , -- 입금자명 
	@ACCT_NUM	VARCHAR(20)	= NULL ,--계좌 번호 
	
	@AMOUNT INT = 0 

AS 
BEGIN



WITH LIST AS 
( 
	--SELECT TOP 1 @SEQ_NO = SEQ_NO,
	--@CUS_TEL = CUS_TEL,
	--@REQ_BANK_CODE = BANK_CODE,
	--@REQ_ACCT_NUM = ACCT_NUM,
	--@KICC_ID = KICC_ID,
	--@ORDER_NUM = ORDER_NUM,
	--@REQ_CUS_NAME = CUS_NAME ,
	--@REQ_AMOUNT =  REQ_AMOUNT 
	--FROM ( 
	SELECT 
		SEQ_NO , CUS_TEL , BANK_CODE , ACCT_NUM , KICC_ID  , CUS_NAME , REQ_AMOUNT ,
		--!! 정렬 우선 순위 
		-- 계좌번호,금액,이름,예약번호
		CASE WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CUS_NAME = @PAY_NAME AND RES_CODE = @RES_CODE  THEN 10 
			WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CHARINDEX(CUS_NAME , @PAY_NAME)  > 0 AND RES_CODE = @RES_CODE  THEN 11
		-- 계좌번호,금액,이름,기존예약번호
		WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CUS_NAME = @PAY_NAME AND ORG_RES_CODE = @RES_CODE  THEN 12
		WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CHARINDEX(CUS_NAME , @PAY_NAME)  > 0 AND ORG_RES_CODE = @RES_CODE  THEN 13
				
		-- 계좌번호,금액,이름
			WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CUS_NAME = @PAY_NAME  THEN 20
			WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT AND CHARINDEX(CUS_NAME , @PAY_NAME)  > 0 THEN 21
		-- 계좌번호,이름
			WHEN ACCT_NUM = @ACCT_NUM  AND CUS_NAME = @PAY_NAME THEN 30
			WHEN ACCT_NUM = @ACCT_NUM  AND CHARINDEX(CUS_NAME , @PAY_NAME)  > 0 THEN 31
		-- 계좌번호,금액
			WHEN ACCT_NUM = @ACCT_NUM  AND REQ_AMOUNT = @AMOUNT THEN 40
		-- 계좌번호만 
			WHEN ACCT_NUM = @ACCT_NUM  THEN 50
		ELSE 999 END AS ORDER_NUM 
	FROM KICC_PAY_REQUEST  WITH(NOLOCK)
	WHERE REQ_CTR_NO = @REQ_CTR_NO 
	--AND (DEL_YN = 'N'  OR DEL_YN IS NULL)  -- 2019-04-11 주석 처리 
	--WHERE REQ_CTR_NO = '19011817171510362898'
			
)  -- 

--T ORDER BY ORDER_NUM ASC , SEQ_NO DESC -- 중복되면 최신꺼 



	SELECT  	
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
		C.PRICE_SEQ ,
		M.ORDER_NUM 
	FROM LIST M 
		INNER JOIN  KICC_PAY_REQUEST A WITH(NOLOCK)  
			ON M.SEQ_NO = A.SEQ_NO 
		LEFT JOIN KICC_PAY_RESPONSE B WITH(NOLOCK)
			ON A.REQ_CTR_NO = B.REQ_CTR_NO 
		LEFT JOIN RES_MASTER_DAMO C WITH(NOLOCK)
			ON A.RES_CODE = C.RES_CODE 
	WHERE A.REQ_CTR_NO = @REQ_CTR_NO
	ORDER BY M.ORDER_NUM ASC , A.SEQ_NO DESC  -- 중복시 최신 

END 


GO
