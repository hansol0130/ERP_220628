USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: [XP_CUS_CUSTOMER_UPDATE_REALNAME]
■ DESCRIPTION				: 실명 본인인증 정보 반영(ERP)
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_WEB_CUS_MEMBER_REAL_NAME_UPDATE 'RT1704045185' 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-03-22		박형만			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_CUS_CUSTOMER_UPDATE_REALNAME]
	@CUS_NO INT,  
	@CUS_NAME VARCHAR(20),
	@BIRTH_DATE DATETIME,
	@GENDER VARCHAR(1),
	@FOREIGNER_YN VARCHAR(1),
	@LAST_NAME VARCHAR(20),
	@FIRST_NAME VARCHAR(20),
	--@IPIN_DUP_INFO char(64),
	--@IPIN_CONN_INFO char(88),
	--@VSOC_NUM char(13),
	@ETC VARCHAR(1000),
	@EDT_CODE NEW_CODE
AS 
BEGIN

-- 히스토리 남기기 
	EXEC XP_CUS_CUSTOMER_HISTORY_INSERT  
		@CUS_NO = @CUS_NO, 
		@BIRTH_DATE = @BIRTH_DATE, 
		@GENDER = @GENDER , 
		@CUS_NAME = @CUS_NAME ,

		@LAST_NAME = @LAST_NAME,
		@FIRST_NAME = @FIRST_NAME,
		@FOREIGNER_YN = @FOREIGNER_YN , 
		--@IPIN_DUP_INFO = @IPIN_DUP_INFO , 
		--@IPIN_CONN_INFO = @IPIN_CONN_INFO , 
		--@VSOC_NUM = @VSOC_NUM , 
		--@CERT_YN = 'Y',

		@EMP_CODE = @EDT_CODE , 
		@EDT_REMARK = @ETC , 
		@EDT_TYPE  = 2 


	IF EXISTS ( SELECT * FROM CUS_MEMBER  WITH(NOLOCK) WHERE CUS_NO = @CUS_NO )
	BEGIN 
		UPDATE CUS_MEMBER 
		SET CUS_NAME = @CUS_NAME 
		, BIRTH_DATE = @BIRTH_DATE
		, GENDER = @GENDER 
		, FOREIGNER_YN = @FOREIGNER_YN 
		, LAST_NAME = @LAST_NAME 
		, FIRST_NAME = @FIRST_NAME
		--, IPIN_DUP_INFO = @IPIN_DUP_INFO
		--, IPIN_CONN_INFO = @IPIN_CONN_INFO
		--, VSOC_NUM = @VSOC_NUM
		--, CERT_YN = 'Y' 
		, EDT_DATE = GETDATE()
		, EDT_CODE = @EDT_CODE
		, EDT_MESSAGE = @ETC
		WHERE CUS_NO = @CUS_NO
	END 

	IF EXISTS ( SELECT * FROM CUS_MEMBER_SLEEP  WITH(NOLOCK) WHERE CUS_NO = @CUS_NO )
	BEGIN 
		UPDATE CUS_MEMBER_SLEEP 
		SET CUS_NAME = @CUS_NAME 
		, BIRTH_DATE = @BIRTH_DATE
		, GENDER = @GENDER 
		, FOREIGNER_YN = @FOREIGNER_YN 
		, LAST_NAME = @LAST_NAME 
		, FIRST_NAME = @FIRST_NAME
		--, IPIN_DUP_INFO = @IPIN_DUP_INFO
		--, IPIN_CONN_INFO = @IPIN_CONN_INFO
		--, VSOC_NUM = @VSOC_NUM
		--, CERT_YN = 'Y' 
		, EDT_DATE = GETDATE()
		, EDT_CODE = @EDT_CODE
		, EDT_MESSAGE = @ETC
		WHERE CUS_NO = @CUS_NO
	END 
	IF EXISTS ( SELECT * FROM CUS_CUSTOMER_DAMO  WITH(NOLOCK) WHERE CUS_NO = @CUS_NO )
	BEGIN 
		UPDATE CUS_CUSTOMER_DAMO 
		SET CUS_NAME = @CUS_NAME 
		, BIRTH_DATE = @BIRTH_DATE
		, GENDER = @GENDER 
		, FOREIGNER_YN = @FOREIGNER_YN 
		, LAST_NAME = @LAST_NAME 
		, FIRST_NAME = @FIRST_NAME
		--, IPIN_DUP_INFO = @IPIN_DUP_INFO
		--, IPIN_CONN_INFO = @IPIN_CONN_INFO
		--, VSOC_NUM = @VSOC_NUM
		, EDT_DATE = GETDATE()
		, EDT_CODE = @EDT_CODE
		, EDT_MESSAGE = @ETC
		WHERE CUS_NO = @CUS_NO
	END

END 


GO
