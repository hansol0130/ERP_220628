USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_MEMBER_CREATE_ID
■ DESCRIPTION				: 회원 아이디 및 패스워드 생성 ( SNS 회원 대상 ) 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec  XP_WEB_CUS_MEMBER_CREATE_ID 10630065  , 'jerryhm2' , '
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-10-08		박형만			최초생성
   
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_WEB_CUS_MEMBER_CREATE_ID]
	@CUS_NO INT ,
	@CUS_ID VARCHAR(20),
	@CUS_PASS VARCHAR(100),
	@SYSTEM_TYPE INT = 0 
	--@SAFE_ID CHAR(13)
AS
BEGIN
	-- 히스토리 남기기 
	EXEC XP_CUS_CUSTOMER_HISTORY_INSERT  
	@CUS_NO = @CUS_NO, 
	@CUS_ID  =@CUS_ID,
	
	@EMP_CODE = '9999999' , 
	@EDT_REMARK = '고객수정' , 
	@SYSTEM_TYPE = @SYSTEM_TYPE ,
	@EDT_TYPE  = 1 

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
		
		UPDATE CUS_MEMBER 
		SET CUS_ID = @CUS_ID , CUS_PASS = @CUS_PASS 
			, EDT_MESSAGE = CONVERT(VARCHAR(10),GETDATE(),121) +'아이디 생성'
			, SNS_MEM_YN ='N' 
		WHERE CUS_NO = @CUS_NO

		UPDATE CUS_MEMBER_SLEEP
		SET CUS_ID = @CUS_ID , CUS_PASS = @CUS_PASS 
			, EDT_MESSAGE = CONVERT(VARCHAR(10),GETDATE(),121) +'아이디 생성'
			, SNS_MEM_YN ='N' 
		WHERE CUS_NO = @CUS_NO

		--여행자테이블 주민번호 삭제,DI CI 가상번호,성별 생년월일 업데이트
		--2013.12.06 --여행자 테이블의 주민번호는 삭제 하지 않음 
		UPDATE CUS_CUSTOMER_damo 
		SET CUS_ID = @CUS_ID , CUS_PASS = @CUS_PASS 
			, EDT_MESSAGE = CONVERT(VARCHAR(10),GETDATE(),121) +'아이디 생성'
			
		WHERE CUS_NO = @CUS_NO

		-- 고객번호 리턴
		SELECT @CUS_NO
		
	END
	ELSE 
	BEGIN
		SELECT -1
	END 

	
	
END

GO
