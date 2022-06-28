USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_MEMBER_UPDATE_CHANGE
■ DESCRIPTION				: 기존 주민번호 회원 인증 회원전환 (아이핀)
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec  XP_WEB_CUS_MEMBER_SELECT 4228549 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-23		박형만			최초생성
   2013-12-06		박형만			CERT_YN = 인증여부 수정, EDT_MESSAGE 수정 , cus_customer 의 주민번호 삭제 안함
   2015-03-03		김성호			주민번호 삭제, 생년월일 사용
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_WEB_CUS_MEMBER_UPDATE_CHANGE]
	@CUS_NO INT ,
	@BIRTH_DATE  datetime , 
	@GENDER char(1), 
	@VSOC_NUM CHAR(13),
	@IPIN_DUP_INFO CHAR(64),
	@IPIN_CONN_INFO CHAR(88) --,
	--@SAFE_ID CHAR(13)
AS
BEGIN
	IF(@CUS_NO > 0)
	BEGIN
		----주민번호 삭제전에 기존 생년월일 업데이트
		--IF( (SELECT BIRTHDAY FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @CUS_NO) IS NULL
		--	AND (SELECT BIRTHDAY FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) WHERE CUS_NO = @CUS_NO) IS NULL
		-- )
		--BEGIN
		--	DECLARE @BIRTHDAY DATETIME 
		--	SET @BIRTHDAY = (SELECT dbo.FN_CUS_GET_BIRTH_DATE( SOC_NUM1, damo.dbo.dec_varchar('DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2', SEC_SOC_NUM2)) 
		--					FROM CUS_CUSTOMER_damo WITH(NOLOCK) WHERE CUS_NO = @CUS_NO ) 
			
		--	--생년월일
		--	UPDATE CUS_CUSTOMER_DAMO 
		--	SET BIRTHDAY = @BIRTHDAY
		--	WHERE CUS_NO = @CUS_NO
			
		--	--생년월일
		--	UPDATE CUS_MEMBER
		--	SET BIRTHDAY = @BIRTHDAY
		--	WHERE CUS_NO = @CUS_NO
		--END	
		
		--멤버테이블 주민번호 삭제,DI CI 가상번호,성별 생년월일 업데이트
		UPDATE CUS_MEMBER 
		SET SOC_NUM1 = NULL  ,SOC_NUM2 = NULL , sec_SOC_NUM2 = NULL , sec1_SOC_NUM2 = NULL 
		, VSOC_NUM = @VSOC_NUM
		, BIRTH_DATE = @BIRTH_DATE
		, GENDER = @GENDER
		, IPIN_DUP_INFO = @IPIN_DUP_INFO 
		, IPIN_CONN_INFO = @IPIN_CONN_INFO
		, IPIN_ACC_DATE = GETDATE()
		, CERT_YN = 'Y' 
		, EDT_MESSAGE = CONVERT(VARCHAR(10),GETDATE(),121) +'아이핀전환가입'
		WHERE CUS_NO = @CUS_NO

		--여행자테이블 주민번호 삭제,DI CI 가상번호,성별 생년월일 업데이트
		--2013.12.06 --여행자 테이블의 주민번호는 삭제 하지 않음 
		UPDATE CUS_CUSTOMER_damo 
		SET --SOC_NUM1 = NULL  ,SOC_NUM2 = NULL , sec_SOC_NUM2 = NULL , sec1_SOC_NUM2 = NULL 
			VSOC_NUM = @VSOC_NUM
		, BIRTH_DATE = @BIRTH_DATE
		, GENDER = @GENDER
		, IPIN_DUP_INFO = @IPIN_DUP_INFO 
		, IPIN_CONN_INFO = @IPIN_CONN_INFO
		, IPIN_ACC_DATE = GETDATE()
		
		WHERE CUS_NO = @CUS_NO

	END

	-- 고객번호 리턴
	SELECT @CUS_NO
END



GO
