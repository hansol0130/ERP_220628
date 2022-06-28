USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_MEMBER_REAL_NAME_UPDATE
■ DESCRIPTION				: 실명 본인인증 정보 반영
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_WEB_RES_AIR_INFO_SELECT 'RT1704045185' 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-11-27		박형만			최초생성
   2018-03-22		박형만			본인인증시 이름,생년월일,성별,DI,CI 갱신 . 히스토리 추가 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_CUS_MEMBER_REAL_NAME_UPDATE]
	@CUS_NO INT,  
	@CUS_NAME VARCHAR(20),
	@BIRTH_DATE DATETIME,
	@GENDER VARCHAR(1),
	@FOREIGNER_YN VARCHAR(1),
	@IPIN_DUP_INFO char(64),
	@IPIN_CONN_INFO char(88),
	@VSOC_NUM char(13),
	@EDT_MESSAGE VARCHAR(200)
AS 
BEGIN

-- 히스토리 남기기 
	EXEC XP_CUS_CUSTOMER_HISTORY_INSERT  
		@CUS_NO = @CUS_NO, 
		@BIRTH_DATE = @BIRTH_DATE, 
		@GENDER = @GENDER , 
		@CUS_NAME = @CUS_NAME ,

		@FOREIGNER_YN = @FOREIGNER_YN , 
		@IPIN_DUP_INFO = @IPIN_DUP_INFO , 
		@IPIN_CONN_INFO = @IPIN_CONN_INFO , 
		--@VSOC_NUM = @VSOC_NUM , 
		@CERT_YN = 'Y',

		@EMP_CODE = '9999999' , 
		@EDT_REMARK = @EDT_MESSAGE , 
		@EDT_TYPE  = 2 


	--기존 DI 로 된 정회원 아닌것의 DI 지우기 
	IF EXISTS ( 
		SELECT * FROM CUS_CUSTOMER_DAMO WHERE CUS_NO <> @CUS_NO 
		AND IPIN_DUP_INFO = @IPIN_DUP_INFO  
	)
	BEGIN
		-- DI 초기화 
		UPDATE CUS_CUSTOMER_DAMO 
		SET IPIN_DUP_INFO = NULL , IPIN_CONN_INFO = NULL 
		WHERE CUS_NO <> @CUS_NO 
		AND IPIN_DUP_INFO = @IPIN_DUP_INFO  
	END 

	IF EXISTS ( SELECT * FROM CUS_MEMBER  WITH(NOLOCK) WHERE CUS_NO = @CUS_NO )
	BEGIN 
		UPDATE CUS_MEMBER 
		SET CUS_NAME = @CUS_NAME 
		, BIRTH_DATE = @BIRTH_DATE
		, GENDER = @GENDER 
		, FOREIGNER_YN = @FOREIGNER_YN 
		, IPIN_DUP_INFO = @IPIN_DUP_INFO
		, IPIN_CONN_INFO = @IPIN_CONN_INFO
		, VSOC_NUM = @VSOC_NUM
		, CERT_YN = 'Y' 
		, EDT_DATE = GETDATE()
		, EDT_CODE = '9999999'
		, EDT_MESSAGE = @EDT_MESSAGE
--		, ETC = ISNULL(ETC,'') + '
--['+ @EDT_MESSAGE +  CONVERT(VARCHAR(19), GETDATE(),121) +']'
		WHERE CUS_NO = @CUS_NO
	END 
	IF EXISTS ( SELECT * FROM CUS_CUSTOMER_DAMO  WITH(NOLOCK) WHERE CUS_NO = @CUS_NO )
	BEGIN 
		UPDATE CUS_CUSTOMER_DAMO 
		SET CUS_NAME = @CUS_NAME 
		, BIRTH_DATE = @BIRTH_DATE
		, GENDER = @GENDER 
		, FOREIGNER_YN = @FOREIGNER_YN 
		, IPIN_DUP_INFO = @IPIN_DUP_INFO
		, IPIN_CONN_INFO = @IPIN_CONN_INFO
		, VSOC_NUM = @VSOC_NUM
		, EDT_DATE = GETDATE()
		, EDT_CODE = '9999999'
		, EDT_MESSAGE = @EDT_MESSAGE
--		, ETC = ISNULL(ETC,'') + '
--['+ @EDT_MESSAGE +  CONVERT(VARCHAR(19), GETDATE(),121) +']'
		WHERE CUS_NO = @CUS_NO
	END

END 

GO
