USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_MEMBER_SECEDE
■ DESCRIPTION				: 회원탈퇴 SP 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec  XP_WEB_CUS_MEMBER_SECEDE 4228549 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-04-10		박형만			최초생성
   2018-07-27		박형만			본인인증 아닌 회원은 휴대폰 번호 보존 
   2020-05-25		김영민(EHD)		탈퇴시 CUS_SNS_INFO 삭제
================================================================================================================*/ 
CREATE PROC [dbo].[XP_CUS_MEMBER_SECEDE]
(
	@CUS_NO INT , 
	@REMARK VARCHAR(200),
	@NEW_CODE NEW_CODE
)
AS 

BEGIN


DECLARE @SECEDE_REMARK VARCHAR(200)
SET @SECEDE_REMARK =  '회원탈퇴' + ISNULL( '(' + @REMARK + ')' , '')  
	-- 히스토리 남기기 
	EXEC XP_CUS_CUSTOMER_HISTORY_INSERT  
	@CUS_NO = @CUS_NO, 
	@CUS_STATE = 'N' , 

	@EMP_CODE = @NEW_CODE, 
	@EDT_REMARK = @SECEDE_REMARK , 
	@EDT_TYPE  = 6 
	
	/* 탈퇴신청 */
	INSERT INTO CUS_SECEDE (CUS_NO, REMARK, NEW_DATE , EMP_CODE )
	VALUES (@CUS_NO, @REMARK, GETDATE() , @NEW_CODE )

	-- CUS_CUSTOMER 업데이트
	DECLARE @CERT_YN VARCHAR(1)  -- 구) 본인인증 
	DECLARE @PHONE_AUTH_YN VARCHAR(1) -- 신) 휴대폰 인증 
	DECLARE @SNS_MEM_YN VARCHAR(1) -- 신) SNS 회원가입 여부 
	
	SELECT @CERT_YN = ISNULL(A.CERT_YN,B.CERT_YN) , @PHONE_AUTH_YN =  ISNULL(A.PHONE_AUTH_YN,B.PHONE_AUTH_YN)  
		,@SNS_MEM_YN = ISNULL(A.SNS_MEM_YN,B.SNS_MEM_YN) 
	FROM CUS_MEMBER A 
		LEFT JOIN CUS_MEMBER_SLEEP B 
			ON A.CUS_NO = B.CUS_NO 
	WHERE A.CUS_NO = @CUS_NO 

	---- CUS_CUSTOMER 업데이트
	--DECLARE @CERT_YN VARCHAR(1)
	--SET @CERT_YN = 
	--	ISNULL((SELECT CERT_YN FROM CUS_MEMBER WHERE CUS_NO = @CUS_NO) , (SELECT CERT_YN FROM CUS_MEMBER_SLEEP WHERE CUS_NO = @CUS_NO))  

	-- 과거본인인증회원 만 
	-- 기존 개인 정보 보존 
	IF (@CERT_YN = 'Y') 
	BEGIN
		UPDATE CUS_CUSTOMER_DAMO
			SET EDT_DATE = GETDATE(), 
				EDT_CODE = @NEW_CODE, 
				EDT_MESSAGE = '회원탈퇴', 
				CXL_CODE = @NEW_CODE, 
				CXL_DATE = GETDATE(), 
				CXL_REMARK = @SECEDE_REMARK, 
				CUS_STATE = 'N',
				POINT_CONSENT = 'N',
				POINT_CONSENT_DATE = GETDATE() ,
				CUS_ID = NULL  -- ID 초기화 
		WHERE CUS_NO = @CUS_NO
	END 
	BEGIN  
		-- 비인증 (SNS 회원 )
		-- 비인증 기준 : 본인인증X , 휴대폰인증X 
		UPDATE CUS_CUSTOMER_DAMO
			SET EDT_DATE = GETDATE(), 
				EDT_CODE = @NEW_CODE, 
				EDT_MESSAGE = '회원탈퇴', 
				CXL_CODE = @NEW_CODE, 
				CXL_DATE = GETDATE(), 
				CXL_REMARK = @SECEDE_REMARK, 
				CUS_STATE = 'N',
				POINT_CONSENT = 'N',
				POINT_CONSENT_DATE = GETDATE() ,
				CUS_ID = NULL,  -- ID 초기화  17.10 SNS 오픈이후 부터 
-- 기타 정보들 초기화 
CUS_PASS = NULL,  LAST_NAME=NULL, FIRST_NAME=NULL, NICKNAME=NULL, EMAIL=NULL, GENDER=NULL, 
--NOR_TEL1=NULL, NOR_TEL2=NULL, NOR_TEL3=NULL,  휴대폰은 인증 기준이 되었으므로 보전
COM_TEL1=NULL, COM_TEL2=NULL, COM_TEL3=NULL, HOM_TEL1=NULL, HOM_TEL2=NULL, HOM_TEL3=NULL, FAX_TEL1=NULL, FAX_TEL2=NULL, FAX_TEL3=NULL, 
VISA_YN=NULL, PASS_YN=NULL, PASS_EXPIRE=NULL, PASS_ISSUE=NULL, [NATIONAL]=NULL, CUS_GRADE=0, BIRTHDAY=NULL, LUNAR_YN=NULL, 
RCV_EMAIL_YN='N', RCV_SMS_YN='N', ADDRESS1=NULL, ADDRESS2=NULL, ZIP_CODE=NULL,
sec_SOC_NUM2=NULL, sec1_SOC_NUM2=NULL, sec_PASS_NUM=NULL, sec1_PASS_NUM=NULL, VSOC_NUM=NULL, BIRTH_DATE=NULL
		WHERE CUS_NO = @CUS_NO 
	END 


	--포인트 소멸 
	DECLARE @DEL_CUS_TOTAL_POINT INT 
	SET @DEL_CUS_TOTAL_POINT = ISNULL( (SELECT TOP 1 TOTAL_PRICE FROM CUS_POINT WHERE CUS_NO = @CUS_NO ORDER BY POINT_NO DESC) , 0 )  
	IF @DEL_CUS_TOTAL_POINT > 0 
	BEGIN
		--탈퇴 소멸 처리로직 
		DECLARE @POINT_REMARK VARCHAR(200)
		SET @POINT_REMARK =  '탈퇴소멸'
		EXEC SP_CUS_POINT_HISTORY_INSERT 
			@CUS_NO = @CUS_NO ,  --삭제될 회원 
			@USE_TYPE = 5,  --탈퇴소멸
			@USE_POINT_PRICE = @DEL_CUS_TOTAL_POINT ,
			@TITLE =  @POINT_REMARK ,
			@NEW_CODE = @NEW_CODE , 
			@IS_PAYMENT = 0 
		
	END 

	--SNS 연결이 있을경우 끊어주기 
	DELETE CUS_SNS_INFO 
	WHERE CUS_NO = @CUS_NO


	-- CUS_MEMBER 삭제
	DELETE CUS_MEMBER 
	WHERE CUS_NO = @CUS_NO

	-- CUS_MEMBER 삭제
	DELETE CUS_MEMBER_SLEEP 
	WHERE CUS_NO = @CUS_NO

	-- 추가 정보 
	DELETE CUS_ADDITION
	WHERE CUS_NO = @CUS_NO

END 

GO
