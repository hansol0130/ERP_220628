USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Server					: 
■ Database					: DIABLO
■ USP_Name					: XP_CUS_CUSTOMER_BASE_INSERT
■ Description				: 회원기본정보 입력 
■ Input Parameter			:                  
		
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC XP_CUS_CUSTOMER_BASE_INSERT 
■ Author					: 박형만  
■ Date						: 2013-10-22
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-10-22		박형만			최초생성
	2015-03-03		김성호			주민번호 삭제, 생년월일 사용
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[XP_CUS_CUSTOMER_BASE_INSERT] 
(
	@CUS_NAME VARCHAR(20),
	@BIRTH_DATE DATETIME , 
	@GENDER CHAR(1),
	--@SOC_NUM1 VARCHAR(6),
	--@SOC_NUM2 VARCHAR(7),
	@NOR_TEL1 VARCHAR(6),
	@NOR_TEL2 VARCHAR(5),
	@NOR_TEL3 VARCHAR(4),

	@EMAIL VARCHAR(40),
	@HOM_TEL1 VARCHAR(6),
	@HOM_TEL2 VARCHAR(5),
	@HOM_TEL3 VARCHAR(4),
	@ZIP_CODE VARCHAR(7),
	@ADDRESS1 VARCHAR(100),
	@ADDRESS2 VARCHAR(100),
	
	@LAST_NAME VARCHAR(20),
	@FIRST_NAME VARCHAR(20),

	@PASS_NUM VARCHAR(20), --업데이트 하지 않음
	@PASS_EXPIRE DATETIME ,
	 
	@IPIN_DUP_INFO CHAR(64),
	@IPIN_CONN_INFO CHAR(88),
	
	@NEW_CODE NEW_CODE 
) AS 
BEGIN

	DECLARE @TMP_CUS_NO INT
	SET @TMP_CUS_NO = 0

	--생년월일 없고 주민번호 800101-1 까지 있을경우. 생년월일  채워줌(ERP에서유입)
	--IF( @BIRTH_DATE IS NULL 
	--	AND ISNULL(@SOC_NUM1,'') <> '' 
	--	AND ISNULL(@SOC_NUM2,'') <> '' 
	--	AND LEN(@SOC_NUM1) = 6 )
	--BEGIN
	--	SET @BIRTH_DATE = DBO.FN_CUS_GET_BIRTH_DATE(@SOC_NUM1,@SOC_NUM2)
	--END 

	-- 기존 고객중 주민번호중복가입확인값(DI) 로 회원번호를 가져온다 2010-12-08
	-- ERP 에서 주민번호가 채워져 있으면 IPIN_DUP_INFO 도 채워짐  
	-- 정회원의 CUS_CUSTOMER 정보가 업데이트 될수 있음 
	IF(ISNULL(@IPIN_DUP_INFO,'') <> '' )
	BEGIN
		SELECT TOP 1 @TMP_CUS_NO = CUS_NO FROM CUS_CUSTOMER_DAMO WITH(NOLOCK)
		--WHERE SOC_NUM1 = @SOC_NUM1 AND SEC1_SOC_NUM2 = damo.dbo.pred_meta_plain_v (@SOC_NUM2,'DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2')
		WHERE IPIN_DUP_INFO = @IPIN_DUP_INFO AND CUS_STATE = 'Y' -- 탈퇴회원제외
		ORDER BY ISNULL(CUS_ID, 'Z'), ISNULL(CU_YY, '9999'), NEW_DATE, CUS_NO
	END

	--아이핀번호로 회원이 없으면
	IF @TMP_CUS_NO = 0
	BEGIN
		-- 비회원 기본 정보가 입력 되었을때 
		IF --NOT EXISTS ( SELECT * FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @CUS_NO )	AND 
			ISNULL(@CUS_NAME,'') <> ''
			AND @BIRTH_DATE IS NOT NULL 
			AND ISNULL(@GENDER,'') <> ''
			AND ISNULL(@NOR_TEL1,'') <> '' 
			AND ISNULL(@NOR_TEL2,'') <> ''
			AND ISNULL(@NOR_TEL3,'') <> ''
		BEGIN
			--비회원.정회원포함 찾기
			SET @TMP_CUS_NO = ISNULL(( SELECT TOP 1 CUS_NO FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) 
						WHERE CUS_NAME = @CUS_NAME
						AND BIRTH_DATE = @BIRTH_DATE 
						AND GENDER = @GENDER 
						AND NOR_TEL1 = @NOR_TEL1 AND NOR_TEL2 = @NOR_TEL2 AND NOR_TEL3 = @NOR_TEL3
						AND CUS_STATE = 'Y'
						ORDER BY CUS_ID DESC, CUS_NO DESC ) , 0 ) 
		END 
	END 

	--기존 회원이 있으면
	IF @TMP_CUS_NO > 0 
	BEGIN
		-- 기존 회원기본정보 업데이트 . 트리거 업데이트와 겹칠수 있음
		UPDATE CUS_CUSTOMER_DAMO 
		SET 
			EMAIL = CASE WHEN ISNULL(@EMAIL, '') = '' OR @EMAIL ='@' THEN EMAIL ELSE @EMAIL END,
			LAST_NAME = CASE WHEN ISNULL(@LAST_NAME, '') = '' THEN LAST_NAME ELSE @LAST_NAME END,
			FIRST_NAME = CASE WHEN ISNULL(@FIRST_NAME, '') = '' THEN FIRST_NAME ELSE @FIRST_NAME END,
			HOM_TEL1 = CASE WHEN ISNULL(@HOM_TEL1, '') = '' THEN HOM_TEL1 ELSE @HOM_TEL1 END ,
			HOM_TEL2 = CASE WHEN ISNULL(@HOM_TEL2, '') = '' THEN HOM_TEL2 ELSE @HOM_TEL2 END ,
			HOM_TEL3 = CASE WHEN ISNULL(@HOM_TEL3, '') = '' THEN HOM_TEL3 ELSE @HOM_TEL3 END ,
			ZIP_CODE = CASE WHEN ISNULL(@ZIP_CODE, '') = '' THEN ZIP_CODE ELSE @ZIP_CODE END ,
			ADDRESS1 = CASE WHEN ISNULL(@ADDRESS1, '') = '' THEN ADDRESS1 ELSE @ADDRESS1 END ,
			ADDRESS2 = CASE WHEN ISNULL(@ADDRESS2, '') = '' THEN ADDRESS2 ELSE @ADDRESS2 END ,
			--SOC_NUM1 = CASE WHEN ISNULL(@SOC_NUM1, '') = '' THEN SOC_NUM1 ELSE @SOC_NUM1 END ,
			--SEC_SOC_NUM2 =  CASE WHEN ISNULL(@SOC_NUM2, '') = '' THEN SEC_SOC_NUM2 ELSE damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2',@SOC_NUM2) END , 
			--SEC1_SOC_NUM2 =  CASE WHEN ISNULL(@SOC_NUM2, '') = '' THEN SEC1_SOC_NUM2 ELSE  damo.dbo.pred_meta_plain_v(@SOC_NUM2, 'DIABLO', 'dbo.CUS_CUSTOMER', 'SOC_NUM2') END ,
			BIRTH_DATE = @BIRTH_DATE,

			IPIN_DUP_INFO = CASE WHEN ISNULL(@IPIN_DUP_INFO, '') = '' THEN IPIN_DUP_INFO ELSE @IPIN_DUP_INFO END , 
			IPIN_CONN_INFO = CASE WHEN ISNULL(@IPIN_CONN_INFO, '') = '' THEN IPIN_CONN_INFO ELSE @IPIN_CONN_INFO END

			--,PASS_NUM = CASE WHEN ISNULL(PASS_EXPIRE, '1990-01-01') < ISNULL(@PASS_EXPIRE, '1990-01-01') THEN @PASS_NUM ELSE PASS_NUM  END,
			--PASS_EXPIRE = CASE WHEN ISNULL(PASS_EXPIRE, '1990-01-01') < ISNULL(@PASS_EXPIRE, '1990-01-01') THEN @PASS_EXPIRE ELSE PASS_EXPIRE END

		WHERE CUS_NO = @TMP_CUS_NO

		----정회원일때(ID있을때)
		--IF EXISTS(SELECT 1 FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) WHERE CUS_NO = @TMP_CUS_NO AND CUS_ID IS NOT NULL)
		--BEGIN
		--	--정회원 데이터 업데이트
		--	--변수값이 있으면 회원정보 업데이트
		--	--UPDATE CUS_CUSTOMER_DAMO
		--	--SET
		--	--	LAST_NAME = CASE WHEN ISNULL(@LAST_NAME, '') = '' THEN LAST_NAME ELSE @LAST_NAME END,
		--	--	FIRST_NAME = CASE WHEN ISNULL(@FIRST_NAME, '') = '' THEN FIRST_NAME ELSE @FIRST_NAME END,
		--	--	EMAIL = CASE WHEN ISNULL(@EMAIL, '') = '' THEN EMAIL ELSE @EMAIL END,
		--	--	PASS_NUM = CASE WHEN ISNULL(PASS_EXPIRE, '1990-01-01') < ISNULL(@PASS_EXPIRE, '1990-01-01') THEN @PASS_NUM ELSE PASS_NUM  END,
		--	--	PASS_EXPIRE = CASE WHEN ISNULL(PASS_EXPIRE, '1990-01-01') < ISNULL(@PASS_EXPIRE, '1990-01-01') THEN @PASS_EXPIRE ELSE PASS_EXPIRE END,
		--	--	EDT_DATE = GETDATE(),
		--	--	EDT_CODE = @NEW_CODE
		--	--WHERE CUS_NO = @TMP_CUS_NO

		--	--UPDATE CUS_MEMBER
		--	--SET
		--		--LAST_NAME = CASE WHEN ISNULL(@LAST_NAME, '') = '' THEN LAST_NAME ELSE @LAST_NAME END,
		--		--FIRST_NAME = CASE WHEN ISNULL(@FIRST_NAME, '') = '' THEN FIRST_NAME ELSE @FIRST_NAME END,
		--		--EMAIL = CASE WHEN ISNULL(@EMAIL, '') = '' THEN EMAIL ELSE @EMAIL END,
		--		--PASS_NUM = CASE WHEN ISNULL(PASS_EXPIRE, '1990-01-01') < ISNULL(@PASS_EXPIRE, '1990-01-01') THEN @PASS_NUM ELSE PASS_NUM  END,
		--		--PASS_EXPIRE = CASE WHEN ISNULL(PASS_EXPIRE, '1990-01-01') < ISNULL(@PASS_EXPIRE, '1990-01-01') THEN @PASS_EXPIRE ELSE PASS_EXPIRE END,
		--		--EDT_DATE = GETDATE(),
		--		--EDT_CODE = @NEW_CODE
		--	--WHERE CUS_NO = @TMP_CUS_NO
		--END
	END 
	ELSE 
	BEGIN
		--신규 회원기본정보 입력 
		INSERT INTO CUS_CUSTOMER_DAMO (CUS_NAME,
			BIRTH_DATE , GENDER , --SOC_NUM1, 
			--SEC_SOC_NUM2, 
			--SEC1_SOC_NUM2, 
			NOR_TEL1, NOR_TEL2 , NOR_TEL3 , EMAIL, 
			HOM_TEL1 , HOM_TEL2 , HOM_TEL3 , ZIP_CODE, ADDRESS1 , ADDRESS2 ,
			NEW_DATE, NEW_CODE , IPIN_DUP_INFO ,IPIN_CONN_INFO ,
			sec_PASS_NUM,
			sec1_PASS_NUM,
			PASS_EXPIRE 
		)
		VALUES (@CUS_NAME, 
			@BIRTH_DATE , @GENDER, --@SOC_NUM1 ,
			--damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2',@SOC_NUM2), 
			--damo.dbo.pred_meta_plain_v(@SOC_NUM2, 'DIABLO', 'dbo.CUS_CUSTOMER', 'SOC_NUM2') ,
			@NOR_TEL1, @NOR_TEL2 , @NOR_TEL3,  @EMAIL, 
			@HOM_TEL1 ,@HOM_TEL2 , @HOM_TEL3 , @ZIP_CODE, @ADDRESS1 , @ADDRESS2 , 
			GETDATE(), @NEW_CODE ,@IPIN_DUP_INFO, @IPIN_CONN_INFO , 
			damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM',@PASS_NUM),
			damo.dbo.pred_meta_plain_v(@PASS_NUM, 'DIABLO', 'dbo.CUS_CUSTOMER', 'PASS_NUM') ,
			@PASS_EXPIRE
		)

		SET @TMP_CUS_NO = @@IDENTITY
	END 
	
	SELECT @TMP_CUS_NO
END

GO
