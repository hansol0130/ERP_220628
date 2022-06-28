USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	SQL.함수_가상계좌_결제승인완료
====================================================================================
- SP 명 : SP_KICC_WEBPAY_PAYMENT_COMPLETE
- 기 능 : KICC WEBPAY(NONPLUGIN) 카드 결제 승인 완료 참좋은 처리 완료 값 
====================================================================================
	참고내용
====================================================================================
- 예제
 
 exec SP_KICC_WEBPAY_PAYMENT_COMPLETE @REQ_CTR_NO=N'00198312062823784858'
 , @RES_CTR_NO=N'20198312062823784858'
 ,@RES_CODE=N'RP1206282671',@RESULT_CODE=N'0000',@RESULT_MSG=N'입금완료'
 ,@PAY_NAME=N'박형만' 
 ,@CARD_NUM=NULL
 ,@AMOUNT=1000
 ,@REMARK=NULL
 ,@MALL_ID=NULL
 ,@PAY_SEQ=NULL
 
====================================================================================
	변경내역
====================================================================================
- 2016-08-03 박형만  생성
- 2019-02-07 박형만  REQ_SEQ_NO 추가 
===================================================================================*/
CREATE  PROC [dbo].[SP_KICC_WEBPAY_PAYMENT_COMPLETE]
	@REQ_CTR_NO VARCHAR(30),  --요청 승인 번호
	@RES_CTR_NO VARCHAR(20),  --응답 승인 번호
	@RES_CODE RES_CODE,
	@RESULT_CODE char(4),
	@RESULT_MSG varchar(100),
	
	@PAY_NAME VARCHAR(80), -- 입금자명 
	@CARD_NUM VARCHAR(20), --카드번호
	
	@AMOUNT INT,
	@REMARK varchar(MAX),	--	비고 
	@PAY_SEQ INT 
AS 
SET NOCOUNT ON 
BEGIN
	
	-------------------------------------------------------	
	
	--BEGIN TRAN 
 		--PAY_MASTER 에 등록이 안되었을경우에만  실행 
		--중복 호출시 PAY_MASTER_DAMO 가 두건이 되는걸 방지
		--IF NOT EXISTS (SELECT * FROM KICC_PAY_RESPONSE --WITH(NOLOCK)
		--		WHERE REQ_CTR_NO = @REQ_CTR_NO 
		--		AND RES_CTR_NO = @RES_CTR_NO 
		--		AND PAY_SEQ IS NOT NULL )
		--BEGIN 
		
		--PAY_MASTER_DAMO 에서 PG_APP_NO(PG사승인번호)  로 중복 체크  2012-08-10 
		--요청 SEQ_NO 구하기 
		DECLARE @SEQ_NO INT 
		SET @SEQ_NO = (SELECT TOP 1 SEQ_NO FROM KICC_PAY_REQUEST WHERE REQ_CTR_NO = @REQ_CTR_NO AND RES_CODE = @RES_CODE  )
		
			-- 결제승인 완료 입력 
			DECLARE @MCH_SEQ INT 
			SET @MCH_SEQ = ISNULL( ( SELECT MAX(MCH_SEQ) FROM KICC_PAY_RESPONSE WHERE REQ_CTR_NO = @REQ_CTR_NO ) , 0 ) + 1 
			
			INSERT INTO KICC_PAY_RESPONSE (
				REQ_CTR_NO,MCH_SEQ,RES_CTR_NO,APPR_YN,PAY_SEQ,
				AMOUNT,CARD_NUM,RESULT_CODE,RESULT_MSG,REMARK,NEW_CODE,NEW_DATE,REQ_SEQ_NO )
			VALUES
				(
				@REQ_CTR_NO,@MCH_SEQ,@RES_CTR_NO,'Y',@PAY_SEQ,
				@AMOUNT,@CARD_NUM,@RESULT_CODE,@RESULT_MSG,@REMARK,'9999999',GETDATE() ,@SEQ_NO	)

			UPDATE KICC_PAY_REQUEST 
			SET COMP_YN = 'Y' --   , RES_MCH_SEQ =  @MCH_SEQ 
			WHERE SEQ_NO = @SEQ_NO 
		
		--END 
				
	--	IF @@ERROR <> 0 
	--	BEGIN
	--		ROLLBACK TRAN 
	--		RETURN 
	--	END 
		
	--COMMIT TRAN

END 




GO
