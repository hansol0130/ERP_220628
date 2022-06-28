USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_MEMBER_INSERT
■ DESCRIPTION				: 회원가입 정보 입력
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec  XP_WEB_CUS_MEMBER_INSERT 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-23		박형만			최초생성
   2013-08-30		박형만			비회원,탈퇴후재가입 은 모두 포인트 동의 로 입력 
   2013-11-18		이동호			회원가입 경로 추가(온라인,모바일) 
   2013-11-27		박형만			일반전화를 HOM_TEL(집전화)로 
   2013-12-03		박형만			DI 없는 비회원 가입시 비회원정보 조회후 처리 
   2013-12-05		박형만			회원실명인증여부(CERT_YN)추가 , 가입영역[웹,모바일](JOIN_TYPE) 추가 
   2014-01-04		박형만			CUS_NO SELECT 한번만 하도록 
   2014-07-01		정지용			회원가입시 룰렛이벤트 포인트 자동 적립
   2014-07-03		박형만			신규회원가입시 아이디 중복체크 추가 
   2014-11-05		박형만			비회원 회원가입시  비회원정보CUS_NO -> DI정보CUS_NO 로 예약이관 
   2015-01-01		정지용			룰렛이벤트 종료로 인한 적립로직 주석처리
   2015-03-03		김성호			주민번호 삭제, 생년월일 사용
   2015-10-15		박형만			휴면계정 체크 추가 
   2017-07-24		박형만			ERP 온라인회원전환 기능 추가 , DI 없을시 미인증 회원 CERT_YN =N 으로  , CUS_GRADE 추가 
   2017-08-22		박형만			ERP 온라인회원전환 가입자,가입일수정
   2017-12-11		박형만			SNS정회원은 비회원으로 인식. CUS_MEMBER UPDATE 추가 
   2018-07-26		박형만			휴대폰 인증 회원가입 적용 , CERT_YN = DI 값 없으면 NULL 
   2018-11-05		박형만			회원가입 유입처 INFLOW_TYPE 적용 
   2018-11-07		박형만			포인트 지급 부분 추가 
   2021-01-26		김영민			평생회원추가(FORMEMBER_YN)
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_WEB_CUS_MEMBER_INSERT]
(
	@MEM_TYPE INT , -- 0:신규가입 , 1:비회원전환가입,  4:탈퇴회원재가입

	@CUS_NO INT , 
	@CUS_ID VARCHAR(20), 
	@CUS_NAME VARCHAR(20),
	@LAST_NAME  VARCHAR(20),
	@FIRST_NAME VARCHAR(20),
	--@SOC_NUM1 VARCHAR(6),
	--@SOC_NUM2 VARCHAR(7),
	@BIRTH_DATE  datetime , 
	@GENDER char(1), 
	@CUS_PASS VARCHAR(100), 
	@NOR_TEL1 VARCHAR(6), 
	@NOR_TEL2 VARCHAR(5), 
	@NOR_TEL3 VARCHAR(4),
	@HOM_TEL1 VARCHAR(6), 
	@HOM_TEL2 VARCHAR(5), 
	@HOM_TEL3 VARCHAR(4), 
	@ZIP_CODE VARCHAR(7), 
	@ADDRESS1 VARCHAR(100), 
	@ADDRESS2 VARCHAR(100), 
	@EMAIL	VARCHAR(40),
	@RCV_EMAIL_YN CHAR(1),
	@RCV_SMS_YN CHAR(1), 
	--@BIRTH_DAY datetime, 
	--@LUNAR_YN CHAR(1), 
	
	@NEW_CODE NEW_CODE,
	 
	@FOREIGNER_YN VARCHAR(1),
	@VSOC_NUM CHAR(13),
	@IPIN_DUP_INFO CHAR(64),
	@IPIN_CONN_INFO CHAR(88),
	@SAFE_ID CHAR(13), 

	@PASS_NUM VARCHAR(20) , 
	@PASS_EXPIRE datetime , 

	@TERMS2_YN CHAR(1), --  제 3자 동의 제공
	@TERMS3_YN CHAR(1), --  개인정보  위탁

	@OCB_AGREE_YN CHAR(1),  --OK 캐쉬백 
	@OCB_AGREE_DATE datetime , 
	@OCB_AGREE_EMP_CODE EMP_CODE,
	@OCB_CARD_NUM CHAR(16), 
	
	@WEDDING_YN CHAR(1), 
	@WEDDING_DATE VARCHAR(10), 
	@MATE_BIRTHDAY VARCHAR(10), 
	@MATE_LUNAR_YN CHAR(1), 
	@HOPE_REGION VARCHAR(20), 
	@TRAVEL_TYPE VARCHAR(20), 
	@INFLOW_ROUTE VARCHAR(100),
	@JOIN_TYPE INT ,-- 모바일 가입: 0 , 웹회원가입 : 1
	@CUS_GRADE INT = 0,
	@PHONE_AUTH_YN CHAR(1) = NULL, 
	@PHONE_AUTH_DATE datetime = NULL,
	@SNS_MEM_YN CHAR(1) = NULL , 
	@INFLOW_TYPE INT = 0,
	@FORMEMBER_YN CHAR(1) = NULL 
)
AS 
BEGIN
	------------------------------------------------------------------------------------------------------------------------------------------
	--아이디 중복체크 한번더
	------------------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_ID = @CUS_ID)
		OR EXISTS ( SELECT * FROM CUS_MEMBER_SLEEP WITH(NOLOCK) WHERE CUS_ID = @CUS_ID)
	BEGIN 
		SELECT @CUS_NO = 0   -- 아이디 중복일 경우 진행안함
	END 
	ELSE 
	BEGIN

		DECLARE @CERT_YN CHAR(1)
		SET @CERT_YN = CASE WHEN ISNULL(@IPIN_DUP_INFO,'') <> '' THEN 'Y' ELSE NULL END 
		------------------------------------------------------------------------------------------------------------------------------------------
		--정상 신규 회원가입 
		------------------------------------------------------------------------------------------------------------------------------------------
		IF  @MEM_TYPE = 0 
		BEGIN
			IF @CUS_NO = 0 
			BEGIN
				-- 기본 회원정보 입력 (신규가입)
				-- 여행자 테이블
				INSERT INTO CUS_CUSTOMER_DAMO
					(CUS_ID, CUS_NAME, LAST_NAME, FIRST_NAME, 
					--SOC_NUM1, SEC_SOC_NUM2, SEC1_SOC_NUM2, 
					NOR_TEL1, NOR_TEL2, NOR_TEL3, 
					HOM_TEL1, HOM_TEL2, HOM_TEL3, ADDRESS1, ADDRESS2, 
					BIRTH_DATE , GENDER, NICKNAME, CUS_ICON, CUS_PASS, ZIP_CODE, EMAIL,
					BIRTHDAY , LUNAR_YN , NEW_CODE, NEW_DATE,
					VSOC_NUM ,IPIN_DUP_INFO,IPIN_CONN_INFO, SAFE_ID ,FOREIGNER_YN , CUS_GRADE,
					SEC_PASS_NUM , SEC1_PASS_NUM , PASS_EXPIRE ,
					RCV_EMAIL_YN, RCV_SMS_YN, EMAIL_AGREE_DATE, SMS_AGREE_DATE, EMAIL_INFLOW_TYPE, SMS_INFLOW_TYPE  -- 수신동의 정보 
					)
				VALUES
					(@CUS_ID, @CUS_NAME, @LAST_NAME, @FIRST_NAME, 
					--@SOC_NUM1, damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2',@SOC_NUM2), damo.dbo.pred_meta_plain_v( @SOC_NUM2 ,'DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2'), 
					@NOR_TEL1, @NOR_TEL2, @NOR_TEL3, 
					@HOM_TEL1, @HOM_TEL2, @HOM_TEL3, @ADDRESS1, @ADDRESS2, 
					@BIRTH_DATE ,@GENDER, NULL, 0, @CUS_PASS, @ZIP_CODE, @EMAIL,
					NULL , 'N' , @NEW_CODE, GETDATE(),
					@VSOC_NUM ,@IPIN_DUP_INFO,@IPIN_CONN_INFO, @SAFE_ID ,@FOREIGNER_YN ,@CUS_GRADE,
					damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM',@PASS_NUM),	damo.dbo.pred_meta_plain_v( @PASS_NUM ,'DIABLO','dbo.CUS_CUSTOMER','PASS_NUM'),@PASS_EXPIRE ,
					@RCV_EMAIL_YN, @RCV_SMS_YN, CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),121)), CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),121)), '99', '99'
					)

				SELECT @CUS_NO = @@IDENTITY
			END 
			ELSE  -- 신규 가입이면서 기존 CUS_NO 있는경우 (EX ERP 관리자 온라인 회원변환 가입)
			BEGIN
				UPDATE CUS_CUSTOMER_DAMO 
				SET CUS_ID = @CUS_ID
				, CUS_NAME = @CUS_NAME 
				, BIRTH_DATE = @BIRTH_DATE
				, GENDER = @GENDER
				, LAST_NAME = @LAST_NAME
				, FIRST_NAME = @FIRST_NAME
				, NOR_TEL1 = @NOR_TEL1
				, NOR_TEL2 = @NOR_TEL2
				, NOR_TEL3 = @NOR_TEL3
				, EMAIL = @EMAIL 
				, FOREIGNER_YN = @FOREIGNER_YN
				, NEW_CODE = @NEW_CODE 
				, NEW_DATE = GETDATE()
				, EDT_DATE = NULL 
				, EDT_CODE = NULL 
				, CUS_GRADE = @CUS_GRADE 
				, ETC = '관리자 회원가입' + ISNULL('-' + ETC,'') 
				--, POINT_CONSENT ='Y' 
				--, POINT_CONSENT_DATE = GETDATE() 
				WHERE CUS_NO = @CUS_NO 
			END 

			
		
			
			--회원 테이블
			INSERT INTO CUS_MEMBER
				(CUS_NO,CUS_ID, CUS_NAME, LAST_NAME, FIRST_NAME, 
				--SOC_NUM1, SEC_SOC_NUM2, SEC1_SOC_NUM2, 
				NOR_TEL1, NOR_TEL2, NOR_TEL3, 
				HOM_TEL1, HOM_TEL2, HOM_TEL3, ADDRESS1, ADDRESS2, 
				BIRTH_DATE , GENDER, NICKNAME, CUS_ICON, CUS_PASS, ZIP_CODE, EMAIL,
				BIRTHDAY , LUNAR_YN, NEW_CODE, NEW_DATE,
				VSOC_NUM ,IPIN_DUP_INFO,IPIN_CONN_INFO, TERMS2_YN, TERMS3_YN, SAFE_ID ,FOREIGNER_YN ,
				SEC_PASS_NUM , SEC1_PASS_NUM , PASS_EXPIRE ,
				RCV_EMAIL_YN, RCV_SMS_YN, 
				OCB_AGREE_YN, OCB_AGREE_DATE, OCB_AGREE_EMP_CODE, OCB_CARD_NUM, JOIN_TYPE , CERT_YN ,
				PHONE_AUTH_YN , PHONE_AUTH_DATE , SNS_MEM_YN ,INFLOW_TYPE, FORMEMBER_YN , FORMEMBER_DATE )
			VALUES
				(@CUS_NO,@CUS_ID, @CUS_NAME, @LAST_NAME, @FIRST_NAME, 
				--@SOC_NUM1, damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2',@SOC_NUM2), damo.dbo.pred_meta_plain_v( @SOC_NUM2 ,'DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2'), 
				@NOR_TEL1, @NOR_TEL2, @NOR_TEL3, 
				@HOM_TEL1, @HOM_TEL2, @HOM_TEL3, @ADDRESS1, @ADDRESS2, 
				@BIRTH_DATE ,@GENDER, NULL, 0, @CUS_PASS, @ZIP_CODE, @EMAIL,
				NULL , 'N', @NEW_CODE, GETDATE(),
				@VSOC_NUM ,@IPIN_DUP_INFO, @IPIN_CONN_INFO, @TERMS2_YN, @TERMS3_YN , @SAFE_ID ,@FOREIGNER_YN ,  
				damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM',@PASS_NUM),	damo.dbo.pred_meta_plain_v( @PASS_NUM ,'DIABLO','dbo.CUS_CUSTOMER','PASS_NUM'),@PASS_EXPIRE ,
				@RCV_EMAIL_YN, @RCV_SMS_YN,  
				@OCB_AGREE_YN, @OCB_AGREE_DATE, @OCB_AGREE_EMP_CODE, @OCB_CARD_NUM, @JOIN_TYPE ,@CERT_YN,
				@PHONE_AUTH_YN , @PHONE_AUTH_DATE , @SNS_MEM_YN ,@INFLOW_TYPE, ISNULL(@FORMEMBER_YN,'N'), GETDATE())

			-- 부가정보 입력		
			INSERT INTO CUS_ADDITION
				(CUS_NO, WEDDING_YN, WEDDING_DATE, MATE_BIRTHDAY, MATE_LUNAR_YN, HOPE_REGION, TRAVEL_TYPE, INFLOW_ROUTE)
			VALUES
				(@CUS_NO, @WEDDING_YN, @WEDDING_DATE, @MATE_BIRTHDAY, @MATE_LUNAR_YN, @HOPE_REGION, @TRAVEL_TYPE, @INFLOW_ROUTE)

			-- 포인트 지급!!!!!!
			-- 이미 지급되었으면 지급 안함(고객번호,휴대폰번호로 중복체크 11-02일부터)
			EXEC DBO.SP_CUS_POINT_CONSENT_UPDATE @CUS_NO, 1000, '가입 축하 포인트'
		END 
		------------------------------------------------------------------------------------------------------------------------------------------
		-- 비회원 전환 가입 OR 탈퇴 회원 재가입 
		------------------------------------------------------------------------------------------------------------------------------------------
		ELSE IF( @MEM_TYPE IN ( 1,4))
		BEGIN

			--DI 값으로 최근 회원 번호 찾기 
			--SELECT TOP 1 @CUS_NO = CUS_NO FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) WHERE SOC_NUM1 = @SOC_NUM1 AND SEC1_SOC_NUM2 = damo.dbo.pred_meta_plain_v (@SOC_NUM2,'DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2')
			IF( ISNULL(@IPIN_DUP_INFO,'') <> '') 
			BEGIN 
				SELECT TOP 1 @CUS_NO = CUS_NO FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) WHERE IPIN_DUP_INFO = @IPIN_DUP_INFO
				ORDER BY CUS_STATE DESC , ISNULL(CU_YY, '9999'), NEW_DATE, CUS_NO  -- CUS_STATE 'Y' 인 회원 우선

				--DI값으로 조회된 고객이 있을경우 2014.11.05 추가 
				--기존 비회원 CUS_NO 정보의 값을 이관 한다 
				IF( @CUS_NO > 0 )
				BEGIN
					--비회원  CUS_NO  조회 
					DECLARE @NON_MEM_CUS_NO INT 
					SELECT TOP 1 @NON_MEM_CUS_NO = CUS_NO FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) 
					WHERE CUS_NAME = @CUS_NAME 
					AND GENDER = @GENDER
					AND BIRTH_DATE = @BIRTH_DATE
					AND NOR_TEL1 = @NOR_TEL1
					AND NOR_TEL2 = @NOR_TEL2
					AND NOR_TEL3 = @NOR_TEL3
					AND IPIN_DUP_INFO IS NULL -- DI  없는것 
					ORDER BY CUS_STATE DESC , ISNULL(CU_YY, '9999'), NEW_DATE, CUS_NO

					--비회원 정보가 있고 DI 정보와 다르면 
					IF(@NON_MEM_CUS_NO > 0  AND @CUS_NO <> @NON_MEM_CUS_NO ) 
					BEGIN
						--비회원 예약마스터이동
						UPDATE RES_MASTER_DAMO 
						SET CUS_NO = @CUS_NO --, IPIN_DUP_INFO = @IPIN_DUP_INFO  --DI 값은 ..보류
						WHERE CUS_NO =  @NON_MEM_CUS_NO 
						AND RES_NAME = @CUS_NAME  -- 이름이 같은것만

						--비회원 예약출발자이동 
						UPDATE RES_CUSTOMER_DAMO 
						SET CUS_NO = @CUS_NO --, IPIN_DUP_INFO = @IPIN_DUP_INFO
						WHERE CUS_NO =  @NON_MEM_CUS_NO 
						AND CUS_NAME = @CUS_NAME  -- 이름이 같은것만
					END 
				END 

			END 
		
			-- DI 값으로 조회가 없을경우. 비회원 정보로 조회 
			IF( @CUS_NO = 0 or @CUS_NO is null  )
			BEGIN
				SELECT TOP 1 @CUS_NO = CUS_NO FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) 
				WHERE CUS_NAME = @CUS_NAME 
				AND GENDER = @GENDER
				AND BIRTH_DATE = @BIRTH_DATE
				AND NOR_TEL1 = @NOR_TEL1
				AND NOR_TEL2 = @NOR_TEL2
				AND NOR_TEL3 = @NOR_TEL3
				ORDER BY CUS_STATE DESC , ISNULL(CU_YY, '9999'), NEW_DATE, CUS_NO
			END 

			IF @CUS_NO > 0 
			BEGIN
				DECLARE @MEM_TYPE_DESC VARCHAR(20)
				SELECT @MEM_TYPE_DESC  = ( 
					SELECT CASE WHEN @MEM_TYPE = 1 THEN '비회원 회원가입'  
							WHEN @MEM_TYPE = 4 THEN '탈퇴회원 재가입' 
							ELSE '' END ) 

				UPDATE CUS_CUSTOMER_DAMO SET
					CUS_ID = @CUS_ID, CUS_PASS = @CUS_PASS, CUS_STATE = 'Y', CUS_NAME = @CUS_NAME, LAST_NAME = @LAST_NAME,
					FIRST_NAME = @FIRST_NAME, NICKNAME = NULL, CUS_ICON = 0, EMAIL = @EMAIL, GENDER = @GENDER,
					NOR_TEL1 = @NOR_TEL1, NOR_TEL2 = @NOR_TEL2, NOR_TEL3 = @NOR_TEL3,
					HOM_TEL1 = @HOM_TEL1, HOM_TEL2 = @HOM_TEL2, HOM_TEL3 = @HOM_TEL3, ADDRESS1 = @ADDRESS1, ADDRESS2 = @ADDRESS2,
					ZIP_CODE = @ZIP_CODE, RCV_EMAIL_YN = @RCV_EMAIL_YN, RCV_SMS_YN = @RCV_SMS_YN,
					--LUNAR_YN = @LUNAR_YN, BIRTHDAY = @BIRTHDAY, 
					BIRTH_DATE = @BIRTH_DATE, NEW_CODE = @NEW_CODE, NEW_DATE = GETDATE(),
					CXL_DATE = NULL, CXL_CODE = NULL, CXL_REMARK = NULL,
					--SOC_NUM1 = @SOC_NUM1 ,
					--SEC_SOC_NUM2 = damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2',@SOC_NUM2),
					--SEC1_SOC_NUM2= damo.dbo.pred_meta_plain_v( @SOC_NUM2 ,'DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2'),
					VSOC_NUM = @VSOC_NUM, SAFE_ID = @SAFE_ID, IPIN_DUP_INFO = @IPIN_DUP_INFO , IPIN_CONN_INFO = @IPIN_CONN_INFO ,
					EMAIL_AGREE_DATE = CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),121)), SMS_AGREE_DATE = CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),121)),
					EMAIL_INFLOW_TYPE = '99', SMS_INFLOW_TYPE = '99' , FOREIGNER_YN = @FOREIGNER_YN ,
					SEC_PASS_NUM = damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM',@PASS_NUM),
					SEC1_PASS_NUM = damo.dbo.pred_meta_plain_v( @PASS_NUM ,'DIABLO','dbo.CUS_CUSTOMER','PASS_NUM'),
					PASS_EXPIRE = @PASS_EXPIRE ,
					ETC = (@MEM_TYPE_DESC  + '_'+ ISNULL(ETC,'') ) ,
					POINT_CONSENT ='Y' , 
					POINT_CONSENT_DATE = GETDATE() 
				WHERE 
					CUS_NO = @CUS_NO
		
				--회원 테이블
				IF NOT EXISTS (SELECT 1 FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @CUS_NO)
				BEGIN

					INSERT INTO CUS_MEMBER
						(CUS_NO,CUS_ID, CUS_NAME, LAST_NAME, FIRST_NAME, 
						--SOC_NUM1, SEC_SOC_NUM2, SEC1_SOC_NUM2, 
						NOR_TEL1, NOR_TEL2, NOR_TEL3, 
						HOM_TEL1, HOM_TEL2, HOM_TEL3, ADDRESS1, ADDRESS2, 
						BIRTH_DATE , GENDER, NICKNAME, CUS_ICON, CUS_PASS, ZIP_CODE, EMAIL,
						BIRTHDAY , LUNAR_YN, NEW_CODE, NEW_DATE,
						VSOC_NUM ,IPIN_DUP_INFO,IPIN_CONN_INFO, TERMS2_YN, TERMS3_YN, SAFE_ID ,FOREIGNER_YN ,
						SEC_PASS_NUM , SEC1_PASS_NUM , PASS_EXPIRE ,
						RCV_EMAIL_YN, RCV_SMS_YN, 
						POINT_CONSENT , POINT_CONSENT_DATE ,
						OCB_AGREE_YN, OCB_AGREE_DATE, OCB_AGREE_EMP_CODE, OCB_CARD_NUM ,JOIN_TYPE , CERT_YN  ,
						PHONE_AUTH_YN , PHONE_AUTH_DATE , SNS_MEM_YN , INFLOW_TYPE , FORMEMBER_YN, FORMEMBER_DATE)
					VALUES
						(@CUS_NO,@CUS_ID, @CUS_NAME, @LAST_NAME, @FIRST_NAME, 
						--@SOC_NUM1, damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2',@SOC_NUM2), damo.dbo.pred_meta_plain_v( @SOC_NUM2 ,'DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2'), 
						@NOR_TEL1, @NOR_TEL2, @NOR_TEL3, 
						@HOM_TEL1, @HOM_TEL2, @HOM_TEL3, @ADDRESS1, @ADDRESS2, 
						@BIRTH_DATE ,@GENDER, NULL, 0, @CUS_PASS, @ZIP_CODE, @EMAIL,
						NULL , 'N', @NEW_CODE, GETDATE(),
						@VSOC_NUM ,@IPIN_DUP_INFO, @IPIN_CONN_INFO, @TERMS2_YN, @TERMS3_YN , @SAFE_ID ,@FOREIGNER_YN ,  
						damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM',@PASS_NUM),	damo.dbo.pred_meta_plain_v( @PASS_NUM ,'DIABLO','dbo.CUS_CUSTOMER','PASS_NUM'),@PASS_EXPIRE ,
						@RCV_EMAIL_YN, @RCV_SMS_YN,  
						'Y' , GETDATE() ,
						@OCB_AGREE_YN, @OCB_AGREE_DATE, @OCB_AGREE_EMP_CODE, @OCB_CARD_NUM , @JOIN_TYPE ,@CERT_YN ,
						@PHONE_AUTH_YN , @PHONE_AUTH_DATE , @SNS_MEM_YN , @INFLOW_TYPE, ISNULL(@FORMEMBER_YN,'N'), GETDATE())

					-- 포인트 지급!!!!!!
					-- 이미 지급되었으면 지급 안함(고객번호,휴대폰번호로 중복체크 11-02일부터)
					EXEC DBO.SP_CUS_POINT_CONSENT_UPDATE @CUS_NO, 1000, '가입 축하 포인트'
				END 
				ELSE 
				BEGIN
					-- 비회원의 경우에도 데이터가 있는경우가 있음! 갱신하기 !  SNS정회원=비회원
					UPDATE CUS_MEMBER 
					SET CUS_ID = @CUS_ID, CUS_PASS = @CUS_PASS, CUS_STATE = 'Y', CUS_NAME = @CUS_NAME, LAST_NAME = @LAST_NAME,
						FIRST_NAME = @FIRST_NAME, NICKNAME = NULL, CUS_ICON = 0, EMAIL = @EMAIL, GENDER = @GENDER,
						NOR_TEL1 = @NOR_TEL1, NOR_TEL2 = @NOR_TEL2, NOR_TEL3 = @NOR_TEL3,
						HOM_TEL1 = @HOM_TEL1, HOM_TEL2 = @HOM_TEL2, HOM_TEL3 = @HOM_TEL3, ADDRESS1 = @ADDRESS1, ADDRESS2 = @ADDRESS2,
						ZIP_CODE = @ZIP_CODE, RCV_EMAIL_YN = @RCV_EMAIL_YN, RCV_SMS_YN = @RCV_SMS_YN,
						--LUNAR_YN = @LUNAR_YN, BIRTHDAY = @BIRTHDAY, 
						BIRTH_DATE = @BIRTH_DATE, NEW_CODE = @NEW_CODE, NEW_DATE = GETDATE(),
						CXL_DATE = NULL, CXL_CODE = NULL, CXL_REMARK = NULL,
						--SOC_NUM1 = @SOC_NUM1 ,
						--SEC_SOC_NUM2 = damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2',@SOC_NUM2),
						--SEC1_SOC_NUM2= damo.dbo.pred_meta_plain_v( @SOC_NUM2 ,'DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2'),
						VSOC_NUM = @VSOC_NUM, SAFE_ID = @SAFE_ID, IPIN_DUP_INFO = @IPIN_DUP_INFO , IPIN_CONN_INFO = @IPIN_CONN_INFO ,
						FOREIGNER_YN = @FOREIGNER_YN ,
						SEC_PASS_NUM = damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM',@PASS_NUM),
						SEC1_PASS_NUM = damo.dbo.pred_meta_plain_v( @PASS_NUM ,'DIABLO','dbo.CUS_CUSTOMER','PASS_NUM'),
						PASS_EXPIRE = @PASS_EXPIRE ,
						ETC = (@MEM_TYPE_DESC  + '_'+ ISNULL(ETC,'') ) ,
						POINT_CONSENT ='Y' , 
						POINT_CONSENT_DATE = GETDATE() ,
						SNS_MEM_YN = @SNS_MEM_YN ,
						INFLOW_TYPE = @INFLOW_TYPE,
						FORMEMBER_YN = ISNULL(@FORMEMBER_YN,'N'),
					    FORMEMBER_DATE = GETDATE() 
					WHERE CUS_NO = @CUS_NO
				END 

				-- 탈퇴정보 삭제
				DELETE FROM CUS_SECEDE WHERE CUS_NO = @CUS_NO

				/* 부가정보 수정 */
				IF EXISTS(SELECT 1 FROM CUS_ADDITION WITH(NOLOCK) WHERE CUS_NO = @CUS_NO)
				BEGIN
					-- 부가정보 입력
					UPDATE CUS_ADDITION SET WEDDING_YN = @WEDDING_YN, WEDDING_DATE = @WEDDING_DATE, MATE_BIRTHDAY = @MATE_BIRTHDAY,
						MATE_LUNAR_YN = @MATE_LUNAR_YN, HOPE_REGION = @HOPE_REGION, TRAVEL_TYPE = @TRAVEL_TYPE , INFLOW_ROUTE = @INFLOW_ROUTE 
					WHERE CUS_NO = @CUS_NO
				END
				ELSE
				BEGIN
					INSERT INTO CUS_ADDITION
						(CUS_NO, WEDDING_YN, WEDDING_DATE, MATE_BIRTHDAY, MATE_LUNAR_YN, HOPE_REGION, TRAVEL_TYPE , INFLOW_ROUTE )
					VALUES
						(@CUS_NO, @WEDDING_YN, @WEDDING_DATE, @MATE_BIRTHDAY, @MATE_LUNAR_YN, @HOPE_REGION, @TRAVEL_TYPE , @INFLOW_ROUTE )
				END
			END 
		END 
		--------------------------------------------------------------------------------------

		/* 이벤트 종료로 인한 주석처리
		--------------------------------------------------------------------------------------
		-- 룰렛 이벤트 
		--------------------------------------------------------------------------------------
		IF EXISTS (
			SELECT RM.RES_CODE FROM PKG_DETAIL AS PD WITH(NOLOCK)
			INNER JOIN RES_MASTER_damo AS RM WITH(NOLOCK) ON PD.PRO_CODE = RM.PRO_CODE 
			INNER JOIN RES_CUSTOMER_damo AS RC WITH(NOLOCK) ON RM.RES_CODE = RC.RES_CODE 
			INNER JOIN CUS_MEMBER AS CC WITH(NOLOCK) ON RC.CUS_NO = CC.CUS_NO
			LEFT JOIN (
				SELECT RES_CODE, CUS_CODE FROM EVT_ROULETTE WITH(NOLOCK) GROUP BY RES_CODE, CUS_CODE
			) D ON RM.RES_CODE = D.RES_CODE AND CC.CUS_NO = D.CUS_CODE
			WHERE 
			RM.RES_STATE IN(3,4,5,6) -- 예약상태 결제중,결제완료,출발완료,해피콜 - 2010.07.12 결제중도 적립
			AND RC.RES_STATE IN (0) -- 출발고객상태 예약인것만
			AND PD.DEP_DATE >= '2014-06-01 00:00:00' -- 6월 1일 출발일인 사람부터
			AND CONVERT(VARCHAR(10), PD.ARR_DATE, 112) <= CONVERT(VARCHAR(10), GETDATE(), 112) -- 도착일이 오늘보다 같거나 작은사람
			AND CC.CUS_NO = @CUS_NO
			AND D.RES_CODE IS NULL
		)
		BEGIN

			DECLARE @ARR_RES_CODE VARCHAR(500)
			WITH LIST AS
			(	
				SELECT 
					RM.RES_CODE 
				FROM PKG_DETAIL AS PD WITH(NOLOCK)
				INNER JOIN RES_MASTER_damo AS RM WITH(NOLOCK) ON PD.PRO_CODE = RM.PRO_CODE 
				INNER JOIN RES_CUSTOMER_damo AS RC WITH(NOLOCK) ON RM.RES_CODE = RC.RES_CODE 
				INNER JOIN CUS_MEMBER AS CC WITH(NOLOCK) ON RC.CUS_NO = CC.CUS_NO
				LEFT JOIN (
					SELECT RES_CODE, CUS_CODE FROM EVT_ROULETTE WITH(NOLOCK) GROUP BY RES_CODE, CUS_CODE
				) D ON RM.RES_CODE = D.RES_CODE AND CC.CUS_NO = D.CUS_CODE
				WHERE 
				RM.RES_STATE IN(3,4,5,6) -- 예약상태 결제중,결제완료,출발완료,해피콜 - 2010.07.12 결제중도 적립
				AND RC.RES_STATE IN (0) -- 출발고객상태 예약인것만
				AND PD.DEP_DATE >= '2014-06-01 00:00:00' -- 6월 1일 출발일인 사람부터
				AND CONVERT(VARCHAR(10), PD.ARR_DATE, 112) <= CONVERT(VARCHAR(10), GETDATE(), 112) -- 도착일이 오늘보다 같거나 작은사람
				AND CC.CUS_NO = @CUS_NO
				AND D.RES_CODE IS NULL
			) SELECT @ARR_RES_CODE = STUFF(( SELECT ',' + RES_CODE FROM LIST FOR XML PATH('')),1,1,'')


			INSERT INTO EVT_ROULETTE ( EVT_ROU_SEQ, EVT_WIN_SEQ, RES_CODE, RES_SEQ_NO, CUS_CODE, REMARK, NEW_CODE, NEW_DATE )
			SELECT 
				(SELECT ISNULL(MAX(EVT_ROU_SEQ), 0) FROM EVT_ROULETTE) + ROW_NUMBER() OVER (ORDER BY RES_CODE),
				NULL, 
				RES_CODE, 
				SEQ_NO, 
				CUS_NO,
				'미적립_회원가입_적립',
				'9999999',
				GETDATE() 
			FROM (
				SELECT 
						Z.RES_CODE, SEQ_NO, CUS_NO, TOTAL_PRICE,
						CASE 
						WHEN TOTAL_PRICE >= 10000 AND TOTAL_PRICE < 1000000 THEN '1' 	  
						WHEN TOTAL_PRICE >= 1000000 AND TOTAL_PRICE < 2000000 THEN '2' 
						WHEN TOTAL_PRICE >= 2000000 AND TOTAL_PRICE < 3000000 THEN '3' 
						WHEN TOTAL_PRICE >= 3000000 AND TOTAL_PRICE < 9000000 THEN '4' 
						WHEN TOTAL_PRICE >= 9000000 THEN '5' 
					END AS GRADE
				FROM (
					SELECT RM.RES_CODE, RC.SEQ_NO, RC.CUS_NO, 
					DBO.FN_RES_GET_TOTAL_PRICE_ONE(RM.RES_CODE, RC.SEQ_NO) AS TOTAL_PRICE
					FROM PKG_DETAIL AS PD WITH(NOLOCK)
					INNER JOIN RES_MASTER_damo AS RM WITH(NOLOCK) ON PD.PRO_CODE = RM.PRO_CODE 
					INNER JOIN RES_CUSTOMER_damo AS RC WITH(NOLOCK) ON RM.RES_CODE = RC.RES_CODE 
					INNER JOIN CUS_MEMBER AS CC WITH(NOLOCK) ON RC.CUS_NO = CC.CUS_NO
					WHERE 
					RM.RES_STATE IN(3,4,5,6) 
					AND RC.RES_STATE IN (0) 
					AND RM.RES_CODE IN ( SELECT Data FROM dbo.FN_SPLIT(@ARR_RES_CODE, ',') )
					AND CC.CUS_NO = @CUS_NO
				) Z
			) AA
			INNER JOIN DBO.FN_SPLIT('1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,5,5,5,5,5', ',') TEMP ON AA.GRADE = TEMP.DATA
			ORDER BY RES_CODE ASC
		END
		--------------------------------------------------------------------------------------
		*/

	END 
	--------------------------------------------------------------------------------------


	-- 고객번호 리턴
	SELECT @CUS_NO
END
GO
