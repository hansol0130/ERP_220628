USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_EVT_LOTTE_COUPON_ISSUE_INSERT
- 기 능 : 함수_롯데면세점_교환권발급
====================================================================================
	참고내용
====================================================================================
- 예제 EXEC SP_EVT_LOTTE_COUPON_ISSUE_INSERT 5 , 0 , 'M30306358' , 4480169 , '9999999'
EXEC SP_EVT_LOTTE_COUPON_ISSUE_INSERT @REQ_NO =1 ,@ISSUE_TYPE = 0, @PASS_NUM = 'M67606241' , @CUS_NO = 4045694, @ISSUER_CODE = '9999999'
EXEC SP_EVT_LOTTE_COUPON_ISSUE_INSERT @REQ_NO =2 ,@ISSUE_TYPE = 0, @PASS_NUM = 'M66510495' , @CUS_NO = 4480166, @ISSUER_CODE = '9999999'
EXEC SP_EVT_LOTTE_COUPON_ISSUE_INSERT @REQ_NO =3 ,@ISSUE_TYPE = 0, @PASS_NUM = 'M66306259' , @CUS_NO = 4480167, @ISSUER_CODE = '9999999'
EXEC SP_EVT_LOTTE_COUPON_ISSUE_INSERT @REQ_NO =4 ,@ISSUE_TYPE = 0, @PASS_NUM = 'M30524916' , @CUS_NO = 4480168, @ISSUER_CODE = '9999999'

====================================================================================
	변경내역
====================================================================================
- 2011-08-19 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_EVT_LOTTE_COUPON_ISSUE_INSERT]
	@REQ_NO		int	,--	신청순번	(FK)
	@RES_CODE	RES_CODE , 
	@SEQ_NO		int , 
	@ISSUE_TYPE	int	,--	발급타입	0 - 이메일 , 1= 인쇄
	--@PASS_NUM	varchar(20)	,--	여권번호
	@CUS_NO		int	,--	신청회원NO
	@ISSUER_CODE	char(7)	--	등록자(발급자)	
AS 
--SELECT TOP 100 PASS_NUM , CUS_NO, * FROM RES_CUSTOMER WHERE RES_CODE = 'RP1104150122'
----
--DECLARE 
--@REQ_NO		int	,--	신청순번	(FK)
--@ISSUE_TYPE	int	,--	발급타입	0 - 이메일 , 1= 인쇄
--@PASS_NUM	varchar(20)	,--	여권번호
--@CUS_NO		int	,--	신청회원NO
--@ISSUER_CODE	char(7)	--	등록자(발급자)	
--SELECT @REQ_NO =5 ,@ISSUE_TYPE = 0, @PASS_NUM = 'M30306358' , @CUS_NO = 4480169, @ISSUER_CODE = '9999999'
--SELECT @REQ_NO =1 ,@ISSUE_TYPE = 0, @PASS_NUM = 'M67606241' , @CUS_NO = 4045694, @ISSUER_CODE = '9999999'
--SELECT @REQ_NO =2 ,@ISSUE_TYPE = 0, @PASS_NUM = 'M66510495' , @CUS_NO = 4480166, @ISSUER_CODE = '9999999'
--SELECT @REQ_NO =3 ,@ISSUE_TYPE = 0, @PASS_NUM = 'M66306259' , @CUS_NO = 4480167, @ISSUER_CODE = '9999999'
--SELECT @REQ_NO =4 ,@ISSUE_TYPE = 0, @PASS_NUM = 'M30524916' , @CUS_NO = 4480168, @ISSUER_CODE = '9999999'

BEGIN TRY 
BEGIN TRAN 

DECLARE @MAX_ISSUE_NO INT 
SET @MAX_ISSUE_NO = 
ISNULL(( SELECT MAX(ISSUE_NO) FROM EVT_LOTTE_COUPON_ISSUED WITH(NOLOCK) WHERE REQ_NO = @REQ_NO ), 0 )


	DECLARE @LAST_ISSUE_TYPE INT --마지막 발급타입
	SET @LAST_ISSUE_TYPE = @ISSUE_TYPE --기본값 
	
	--기존 마지막 발급내역 N 으로 
	IF( @MAX_ISSUE_NO > 0 )
	BEGIN	
		UPDATE EVT_LOTTE_COUPON_ISSUED 
		SET LAST_YN='N' 
		WHERE REQ_NO = @REQ_NO 
		AND ISSUE_NO = @MAX_ISSUE_NO 
		
		--기존 이메일/SMS 발급내역이 있다면 
		--이메일로 마지막 발급타입을 설정해준다
		IF EXISTS ( 
			SELECT ISSUE_TYPE FROM EVT_LOTTE_COUPON_ISSUED 
			WHERE REQ_NO = @REQ_NO 
			AND ISSUE_TYPE = 1 )
		BEGIN
			SET @LAST_ISSUE_TYPE = 1
		END 
		
	END 
	
	--여권번호 가져오기
	DECLARE @PASS_NUM VARCHAR(80)
	--SELECT @PASS_NUM = damo.dbo.pred_meta_plain_v( B.PASS_NUM ,'DIABLO','dbo.EVT_LOTTE_COUPON','PASS_NUM') 
	SELECT @PASS_NUM = B.PASS_NUM  
	FROM EVT_LOTTE_COUPON AS A WITH(NOLOCK) 
		INNER JOIN RES_CUSTOMER AS B WITH(NOLOCK) 
			ON A.RES_CODE = B.RES_CODE 
			AND A.SEQ_NO = B.SEQ_NO 
	WHERE A.REQ_NO = @REQ_NO 
	AND A.RES_CODE = @RES_CODE 
	AND A.SEQ_NO = @SEQ_NO 
	
	--입력 
	INSERT INTO EVT_LOTTE_COUPON_ISSUED (REQ_NO, ISSUE_NO , ISSUE_TYPE, ISSUER_CODE, ISSUE_DATE , LAST_YN  ) 
	VALUES( @REQ_NO ,@MAX_ISSUE_NO+1, @ISSUE_TYPE ,  @ISSUER_CODE , GETDATE() , 'Y'  ) 

	--신청내역을 발급으로 수정 
	UPDATE EVT_LOTTE_COUPON
	SET PASS_NUM = @PASS_NUM
		, CUS_NO = @CUS_NO , ISSUE_YN ='Y'
		, ISSUE_TYPE = @LAST_ISSUE_TYPE , ISSUER_CODE = @ISSUER_CODE , ISSUE_DATE = GETDATE()
	WHERE REQ_NO = @REQ_NO 

COMMIT TRAN 
END TRY 
BEGIN CATCH
	ROLLBACK TRAN 
END CATCH 
GO
