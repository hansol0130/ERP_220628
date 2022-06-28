USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_CUS_MEM_CLEAR
■ DESCRIPTION				: 정회원 고객정보 통합
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 

	정회원 고객정보 병합시 고려사항
		
		기존회원이 본인인증 회원 일경우 기존회원의 이름/생년월일/성별 기준으로 
			병합될(삭제될) 회원정보를 수정해준다 
		
		기준회원에 없는 정보는 대상회원정보로 갱신한다 
			단 휴대폰,전화번호,이메일은 최신으로 

		포인트 내역 합쳐 주기 
			병합될(삭제될) 회원의 포인트를 기존회원으로 양도 

		기존 XP_CUS_CLEAR 로직에 정회원 정보 수정과 , 포인트 부분 추가 

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2015-10-08		김성호			최초생성
	2015-10-13		정지용			예외테이블 추가(업데이트안되는테이블 및 제외테이블) / 예외처리 / 에러 수정
	2016-05-02		김성호			업데이트 테이블 최소화
	2017-03-07		정지용			고객병합 업데이트 테이블 추가
	2017-03-15		정지용			업데이트 항목 추가 ( 영문명 / 여권번호 / 우편번호/ 주소 )
	2017-12-06		정지용			모바일 신규테이블 CUVE 에 CUS_NO FORIGN KEY 로 되어있어서 삭제 쿼리 추가
	2018-03-27		박형만			모바일 신규테이블 DEVICE_MASTER CUS_NO FORIGN KEY 로 되어있어서 삭제 쿼리 추가
	2018-04-02		박형만			업그레이드 생성! 정회원끼리도 통합 가능하도록 수정 ( 비회원 -> 정회원 통합은 불가 ) 
	2018-04-18		박형만			포인트 양도 문구 수정 
	2018-04-23		박형만			휴면회원 탈퇴 버그 수정 (CUS_SECEDE 중복 해결 )  ,
	2018-06-05		박형만			관심상품 지우기 중복KEY 여서  , CUS_ID 빈값 들어가는것 처리 
	2018-07-04		박형만			FAX 여권인증정보 병합처리 
	2018-07-23		박형만			휴면회원은 휴면회원만 업데이트 , 인증정보도 병합처리  
	2018-10-01		박형만			휴대폰 인증 회원일때에도 포인트 양도 
	2018-11-01		박형만			휴대폰 인증 휴대폰인증값,SNS회원(아이디없음) 여부 업데이트 , 비밀번호 추가 
	2018-11-07		박형만			고객이 병합시 본인 등급 포함 높은 등급으로 처리 되도록 수정
	2019-07-24      김남훈          고객 병합시에 정회원 정보에 PASS가 없는 경우가 있으므로 CUS_CUSTOMER에서 없으면 가져오게 변경
	2020-03-18      김영민          중복sns사용자 update
	2020-03-25		김영민			카카오싱크 중복가입자 가입시 기존 회원가입일로 변경
	2020-05-21		김영민			병합시 inflowtype 1 => 2로 변경
	2020-09-15		김성호			고객등급 스키마 변경으로 통합 시 고객 등급 업데이트 쿼리 수정 CUS_VIP_HISTORY
	2020-09-15		오준혁			@CUS_SNS_SEQ = NULL 기본값 추가
	2020-10-14		김영민			병합시 inflowtype 1 => 2로 변경삭제(유입경로아님)
	2021-08-19		김성호			쿼리정리(미사용컬럼제외, view_member적용, 프로세스 정리 (이전 [onetime].[XP_CUS_MEM_CLEAR_TEMP] 로 백업)
	2021-08-24		김성호			병합대상 정회원 없고 원본 정회원일 경우 ID, PASS 체크
	2021-09-02		김성호			자동로그인 관련 CUS_LOGIN_INFO 삭제
	2022-01-06		김성호			회원병합 시 포인트 소멸 해제 요청 (김연옥 차장)
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_CUS_MEM_CLEAR]
	@ERROR_MSG		VARCHAR(1000) OUTPUT,
	@CUS_NO			INT,			-- 현재 회원(기준)
	@CUS_NAME		VARCHAR(40),	-- 현재 회원명 (기준) 
	@CUS_NO_LIST	VARCHAR(1000),	-- 병합될 회원명 
	@EMP_CODE		VARCHAR(7),		-- 시스템 관리자 
	@CUS_CLASS		INT,
	@NOR_TEL1		VARCHAR(4),
	@NOR_TEL2		VARCHAR(4),
	@NOR_TEL3		VARCHAR(4),
	@COM_TEL1		VARCHAR(4),
	@COM_TEL2		VARCHAR(4),
	@COM_TEL3		VARCHAR(4),
	@HOM_TEL1		VARCHAR(4),
	@HOM_TEL2		VARCHAR(4),
	@HOM_TEL3		VARCHAR(4),
	@BIRTH_DATE		DATETIME,
	@GENDER			VARCHAR(1),
	@EMAIL			VARCHAR(40),
	@FIRST_NAME		VARCHAR(20),
	@LAST_NAME		VARCHAR(20),
	@PASS_NUM		VARCHAR(20),
	@ZIP_CODE		VARCHAR(7),
	@ADDRESS1		VARCHAR(100),
	@ADDRESS2		VARCHAR(100), 
	@CUS_ID			VARCHAR(50) = NULL,	 -- 기준아이디 18.04 추가 
	@CUS_PASS		VARCHAR(500) = NULL, -- 기준패스워드 18.10 추가 
	@CUS_SNS_SEQ    INT = NULL --snsseq

AS
BEGIN
	
	-------------------------------------------------------------------------------------------------------------------
	-- 트리거 동작 제외
	SET CONTEXT_INFO 0x21884680;
	
	-------------------------------------------------------------------------------------------------------------------
	DECLARE @STEP_MSG VARCHAR(100)
	DECLARE @FROM_CUS_NO INT, @CUS_CLEAR_SEQ INT
		-- 기준고객, 병합고객 통합리스트, @CUS_NO_LIST과 혼동 금지
		, @TOTAL_CUS_LIST VARCHAR(1050) = CONVERT(VARCHAR(10), @CUS_NO) + ',' + @CUS_NO_LIST
		
	-------------------------------------------------------------------------------------------------------------------
	-- 기준 고객번호가 없거나 0, 1인 경우 RETURN (CUS_NO=1 예약 시 사용되는 임시 번호)
	IF @CUS_NO IS NULL OR @CUS_NO IN (0, 1)
	BEGIN
		SET @ERROR_MSG = '[통합 기준 고객번호가 없습니다.]';
		RETURN;
	END

	-- 정회원 병합 시 기준고객과 대상고객이 VIP인경우 리턴
	IF EXISTS(
		SELECT A.VIP_YEAR, COUNT(*)
		FROM (
			SELECT A.VIP_YEAR, A.CUS_GRADE 
			FROM CUS_VIP_HISTORY A
			WHERE A.CUS_NO = @CUS_NO
			UNION ALL
			SELECT B.VIP_YEAR, MAX(B.CUS_GRADE) CUS_GRADE
			FROM DBO.FN_SPLIT(@CUS_NO_LIST, ',') A
			INNER JOIN CUS_VIP_HISTORY B ON A.DATA = B.CUS_NO
			GROUP BY B.VIP_YEAR
		) A
		GROUP BY A.VIP_YEAR
		HAVING COUNT(*) > 1
	)
	BEGIN
		SET @ERROR_MSG = '[기준, 대상 고객 양쪽에 VIP등급이 존재합니다.]';
		RETURN;
	END

	-------------------------------------------------------------------------------------------------------------------
	-- 병합될(삭제될) 정회원 조회되었을 시 18.04 추가  
	DECLARE @ORG_CUS_MEM_CNT INT, @TARGET_CUS_MEM_CNT INT 
	
	SELECT
		@TARGET_CUS_MEM_CNT = ISNULL((SELECT COUNT(*) FROM VIEW_MEMBER WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','))), 0),
		@ORG_CUS_MEM_CNT = ISNULL((SELECT COUNT(*) FROM VIEW_MEMBER WHERE CUS_NO = @CUS_NO), 0)

	-- 병합대상회원에 정회원 있으면 
	IF @TARGET_CUS_MEM_CNT > 0 
	BEGIN
		-- 기준회원 정회원 아님 
		IF @ORG_CUS_MEM_CNT = 0 
		BEGIN
			SET @ERROR_MSG = '[통합할 고객에 정회원이 존재하고. 기준회원이 정회원이 아닙니다]'
			RETURN;	
		END 
		ELSE -- 대상회원,기준회원 모두 정회원
		BEGIN
			
			SELECT TOP 1 @CUS_ID = ISNULL(@CUS_ID, A.CUS_ID), @CUS_PASS = ISNULL(@CUS_PASS, A.CUS_PASS)
			FROM (
				SELECT 1 AS [ORDER_KEY], CUS_ID, CUS_PASS FROM VIEW_MEMBER WHERE CUS_NO = @CUS_NO AND CUS_PASS IS NOT NULL
				UNION
				SELECT 2 AS [ORDER_KEY], CUS_ID, CUS_PASS FROM VIEW_MEMBER WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ',')) AND CUS_PASS IS NOT NULL
			) A
			ORDER BY ORDER_KEY;
			
			-- 위코드로 대체 삭제 대상
			---- 아이디가 비었으면 현재회원껄로 수정 
			--IF ISNULL(@CUS_ID,'') =''
			--BEGIN
			--	SET @CUS_ID = ISNULL( (SELECT CUS_ID FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @CUS_NO) 
			--				, (SELECT CUS_ID FROM CUS_MEMBER_SLEEP WITH(NOLOCK) WHERE CUS_NO = @CUS_NO) )
			--END 
			---- 비번이 비었으면 현재회원껄로 수정 
			--IF ISNULL(@CUS_PASS,'') =''
			--BEGIN
			--	--CUS_PASS가 빈값으로 처리될 경우 ISNULL에서 걸러내지지 않으므로 해당값까지 처리 CUS_CUSTOMER에서도 없는 경우 이상한 계정이므로 걍 처리
			--	SET @CUS_PASS = ISNULL( (SELECT CASE WHEN CUS_PASS = '' THEN NULL ELSE CUS_PASS END FROM VIEW_MEMBER WITH(NOLOCK) WHERE CUS_NO = @CUS_NO) 
			--				, (SELECT CUS_PASS FROM CUS_CUSTOMER_damo WITH(NOLOCK) WHERE CUS_NO = @CUS_NO))
			--END 

		END 
	END
	ELSE IF @ORG_CUS_MEM_CNT > 0
	BEGIN
		-- 병합대상에 정회원 없고 원본이 정회원인 경우
		SELECT @CUS_ID = ISNULL(@CUS_ID, CUS_ID), @CUS_PASS = ISNULL(@CUS_PASS, CUS_PASS)
		FROM VIEW_MEMBER
		WHERE CUS_NO = @CUS_NO	
	END

------ 병합될(삭제될) 정회원이 여러명일때 18.04 추가  - 보류 
--IF  @TARGET_CUS_MEM_CNT > 1 
--BEGIN
--	SET @ERROR_MSG = '[통합할 정회원이 여러건이어서 통합이 불가능합니다]' 
--	--ROLLBACK TRAN;
--	RETURN;	
--END

	-------------------------------------------------------------------------------------------------------------------
	-- 인증된 회원은 정회원 정보에서 개인정보 가져오기 
	DECLARE @MEM_CERT_YN CHAR(1) = 'N'
	IF EXISTS(SELECT 1 FROM VIEW_MEMBER WHERE CUS_NO = @CUS_NO AND CERT_YN = 'Y')
	BEGIN
		-- 기준회원이 본인인증 회원일때는 이름.생년.성별을 본인인증 회원 그대로 둔다
		SELECT @MEM_CERT_YN = 'Y', @BIRTH_DATE = BIRTH_DATE, @CUS_NAME = CUS_NAME, @GENDER = GENDER
		FROM VIEW_MEMBER
		WHERE CUS_NO = @CUS_NO AND CUS_NAME IS NOT NULL
	END

	-------------------------------------------------------------------------------------------------------------------
	-- 고객중 최신 휴대폰 인증 정보 
	DECLARE @PHONE_AUTH_YN CHAR(1), @PHONE_AUTH_DATE DATETIME
	
	SELECT @PHONE_AUTH_YN = ISNULL(MAX(PHONE_AUTH_YN), 'N'), @PHONE_AUTH_DATE = MAX(PHONE_AUTH_DATE)
	FROM (
		SELECT PHONE_AUTH_YN, PHONE_AUTH_DATE 
		FROM VIEW_MEMBER 
		WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@TOTAL_CUS_LIST, ',')) AND NOR_TEL1 = @NOR_TEL1  AND NOR_TEL2 = @NOR_TEL2 AND NOR_TEL3 = @NOR_TEL3
	) A

	-------------------------------------------------------------------------------------------------------------------
	-- SNS 멤버 여부 (아이디 없음)
	-- 기준회원이 SNS 멤버이면 ( 기준회원이 인증회원이 아니면 SNS 멤버  ) 
	DECLARE @SNS_MEM_YN CHAR(1)
	SELECT @SNS_MEM_YN = ISNULL((SELECT SNS_MEM_YN FROM VIEW_MEMBER WHERE CUS_NO = @CUS_NO), 'N')
	
	-------------------------------------------------------------------------------------------------------------------
	-- 병합정보 중 최초 가입일 조회
	DECLARE @MIN_DATE DATETIME
	SELECT @MIN_DATE = MIN(MIN_DATE)
	FROM (
		SELECT MIN(NEW_DATE) AS [MIN_DATE] FROM VIEW_MEMBER WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@TOTAL_CUS_LIST, ','))
		UNION
		SELECT MIN(NEW_DATE) AS [MIN_DATE] FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@TOTAL_CUS_LIST, ',')) AND ISNULL(CUS_ID, '') <> ''
	) A

	-------------------------------------------------------------------------------------------------------------------
	--회원등급은 대상회원중 가능 높은것 
	--2021.08.18 주석 고객등급 CUS_VIP_HISTORY 사용
	--IF ISNULL(@CUS_CLASS,0)  = 0 --- 일반 또는 선택안했을때도 
	--BEGIN
	--	SELECT @CUS_CLASS = MAX(CUS_GRADE) FROM ( 
	--		SELECT CUS_GRADE FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) 
	--		WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','))
	--		UNION ALL 
	--		SELECT CUS_GRADE FROM CUS_CUSTOMER_DAMO WITH(NOLOCK)  -- 2018-11-07 본인 등급도 수정 
	--		WHERE CUS_NO = @CUS_NO 
	--	) T 
	--END 

	-------------------------------------------------------------------------------------------------------------------
	-- 병합대상 회원에  FAX 여권인증 기록이 있으면 18.07.04추가
	-- 21.08.18 주석 고유식별정보 갱신X
	--DECLARE @FAX_SEQ CHAR(17) 
	--DECLARE @PASS_DATE DATETIME
	--DECLARE @PASS_EMP_CODE EMP_CODE 
	--SELECT TOP 1 @FAX_SEQ = FAX_SEQ ,@PASS_DATE = PASS_DATE , @PASS_EMP_CODE = PASS_EMP_CODE FROM ( 
	--	SELECT  PASS_DATE,PASS_EMP_CODE, FAX_SEQ FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) 
	--	WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','))
	--	AND FAX_SEQ IS NOT NULL 
	--	UNION ALL 
	--	SELECT PASS_DATE,PASS_EMP_CODE, FAX_SEQ FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) 
	--	WHERE CUS_NO = @CUS_NO 
	--	AND FAX_SEQ IS NOT NULL 
	--) T
	--ORDER BY PASS_DATE DESC 

	-------------------------------------------------------------------------------------------------------------------
	BEGIN TRY
		BEGIN TRAN
			--------------------------------------------------------------------------------------------------------------
			-- 수정전 HISTORY 
			EXEC XP_CUS_CUSTOMER_HISTORY_INSERT  
				@CUS_ID = @CUS_ID,  -- 아이디추가 
				@CUS_NO = @CUS_NO, 
				@CUS_NAME = @CUS_NAME,
				@BIRTH_DATE = @BIRTH_DATE,
				@GENDER = @GENDER,

				@NOR_TEL1 = @NOR_TEL1,
				@NOR_TEL2 = @NOR_TEL2,
				@NOR_TEL3 = @NOR_TEL3,
				@HOM_TEL1 = @HOM_TEL1,
				@HOM_TEL2 = @HOM_TEL2,
				@HOM_TEL3 = @HOM_TEL3,
				@COM_TEL1 = @COM_TEL1,
				@COM_TEL2 = @COM_TEL2,
				@COM_TEL3 = @COM_TEL3,

				@ZIP_CODE = @ZIP_CODE,
				@ADDRESS1 = @ADDRESS1,
				@ADDRESS2 = @ADDRESS2,
				@EMAIL	= @EMAIL,

				@CUS_GRADE = @CUS_CLASS ,

				@LAST_NAME = @LAST_NAME,
				@FIRST_NAME = @FIRST_NAME,

				@EMP_CODE = @EMP_CODE , 
				@EDT_REMARK = '고객통합(병합기준고객)', 
				@EDT_TYPE  = 5 -- 고객병합  
		
			--SET @STEP_MSG= '고객히스토리 처리완료'

			--------------------------------------------------------------------------------------------------------------
			-- 기준 정회원 휴면회원 업데이트 
			IF EXISTS ( SELECT * FROM CUS_MEMBER_SLEEP WHERE CUS_NO = @CUS_NO )
			BEGIN
				UPDATE CUS_MEMBER_SLEEP SET 
					NOR_TEL1 = @NOR_TEL1, NOR_TEL2 = @NOR_TEL2, NOR_TEL3 = @NOR_TEL3, COM_TEL1 = @COM_TEL1, COM_TEL2 = @COM_TEL2, COM_TEL3 = @COM_TEL3
					, HOM_TEL1 = @HOM_TEL1, HOM_TEL2 = @HOM_TEL2, HOM_TEL3 = @HOM_TEL3
					, BIRTH_DATE = @BIRTH_DATE, GENDER = @GENDER, CUS_NAME = @CUS_NAME, EMAIL = @EMAIL --, CUS_GRADE = @CUS_CLASS
					, FIRST_NAME = @FIRST_NAME, LAST_NAME = @LAST_NAME, ZIP_CODE = @ZIP_CODE, ADDRESS1 = @ADDRESS1, ADDRESS2 = @ADDRESS2
					, EDT_CODE = @EMP_CODE, EDT_DATE = GETDATE(), EDT_MESSAGE =  '고객통합'
					, CUS_ID = (CASE WHEN ISNULL(@CUS_ID,'') <> '' THEN @CUS_ID ELSE NULL END)  
					, CUS_PASS = @CUS_PASS 
					, CERT_YN = @MEM_CERT_YN, PHONE_AUTH_YN = @PHONE_AUTH_YN, PHONE_AUTH_DATE = @PHONE_AUTH_DATE, SNS_MEM_YN = @SNS_MEM_YN
					, NEW_DATE = @MIN_DATE 
				WHERE CUS_NO = @CUS_NO 
			END 
			ELSE -- 휴면 회원이 없을때만 업데이트 
			BEGIN
				UPDATE CUS_MEMBER SET
					NOR_TEL1 = @NOR_TEL1, NOR_TEL2 = @NOR_TEL2, NOR_TEL3 = @NOR_TEL3, COM_TEL1 = @COM_TEL1, COM_TEL2 = @COM_TEL2, COM_TEL3 = @COM_TEL3
					, HOM_TEL1 = @HOM_TEL1, HOM_TEL2 = @HOM_TEL2, HOM_TEL3 = @HOM_TEL3
					, BIRTH_DATE = @BIRTH_DATE, GENDER = @GENDER, CUS_NAME = @CUS_NAME, EMAIL = @EMAIL --, CUS_GRADE = @CUS_CLASS
					, FIRST_NAME = @FIRST_NAME, LAST_NAME = @LAST_NAME, ZIP_CODE = @ZIP_CODE, ADDRESS1 = @ADDRESS1, ADDRESS2 = @ADDRESS2
					, EDT_CODE = @EMP_CODE, EDT_DATE = GETDATE(), EDT_MESSAGE =  '고객통합'
					, CUS_ID = (CASE WHEN ISNULL(@CUS_ID,'') <> '' THEN @CUS_ID ELSE NULL END)  
					, CUS_PASS = @CUS_PASS 
					, CERT_YN = @MEM_CERT_YN, PHONE_AUTH_YN = @PHONE_AUTH_YN, PHONE_AUTH_DATE = @PHONE_AUTH_DATE, SNS_MEM_YN = @SNS_MEM_YN
					, NEW_DATE = @MIN_DATE 
				WHERE CUS_NO = @CUS_NO 
			END 
		
			--------------------------------------------------------------------------------------------------------------
			-- 기준 회원 정보 업데이트
			UPDATE CUS_CUSTOMER_DAMO SET
				NOR_TEL1 = @NOR_TEL1, NOR_TEL2 = @NOR_TEL2, NOR_TEL3 = @NOR_TEL3, COM_TEL1 = @COM_TEL1, COM_TEL2 = @COM_TEL2, COM_TEL3 = @COM_TEL3
				, HOM_TEL1 = @HOM_TEL1, HOM_TEL2 = @HOM_TEL2, HOM_TEL3 = @HOM_TEL3 
				, BIRTH_DATE = @BIRTH_DATE, GENDER = @GENDER, EMAIL = @EMAIL, CUS_NAME = @CUS_NAME --, CUS_GRADE = @CUS_CLASS
				, FIRST_NAME = @FIRST_NAME, LAST_NAME = @LAST_NAME, ZIP_CODE = @ZIP_CODE, ADDRESS1 = @ADDRESS1, ADDRESS2 = @ADDRESS2
				--, SEC_PASS_NUM = damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM',@PASS_NUM)
				--, SEC1_PASS_NUM = damo.dbo.pred_meta_plain_v( @PASS_NUM ,'DIABLO','dbo.CUS_CUSTOMER','PASS_NUM')
				, EDT_CODE = @EMP_CODE, EDT_DATE = GETDATE(), EDT_MESSAGE = '고객통합'
				, CUS_ID = (CASE WHEN ISNULL(@CUS_ID,'') <> '' THEN @CUS_ID ELSE NULL END)  
				, CUS_PASS = @CUS_PASS
				--, FAX_SEQ =  CASE WHEN  ISNULL(@FAX_SEQ,'') <> ''  THEN @FAX_SEQ ELSE FAX_SEQ END    -- FAX 인증이 있을때만  
				--, PASS_DATE =  CASE WHEN @PASS_DATE IS NOT NULL  THEN @PASS_DATE ELSE PASS_DATE END
				--, PASS_EMP_CODE =  CASE WHEN ISNULL(@PASS_EMP_CODE,'') <> ''THEN @PASS_EMP_CODE ELSE PASS_EMP_CODE END
				, NEW_DATE = @MIN_DATE 
			WHERE CUS_NO = @CUS_NO

			--------------------------------------------------------------------------------------------------------------
			--SNS 중복사용자 UPDATE (?)
		    UPDATE CUS_SNS_CLEAR
		    SET    CHECK_YN = '1'
		          ,CHECK_DATE = GETDATE()
		    WHERE  CUS_NO =  @CUS_NO

--SNS 연결 계정도 이동 
--IF ISNULL(@CUS_NO, '') <> ''
--BEGIN
--	UPDATE CUS_SNS_INFO 
--	SET 
--	INFLOW_TYPE = 
--	(
--		CASE ISNULL(INFLOW_TYPE,1)   
--			WHEN 1 THEN 2   --20200521 병합시 inflow_type 변경 나머지 type 은 유입경로 존재
--			ELSE INFLOW_TYPE  
--		END 
--	)
--	WHERE CUS_NO = @CUS_NO
--END

--SET @STEP_MSG= '기준 회원정보 업데이트 처리완료'

--DECLARE @CUS_DEL_LIST TABLE  ( CUS_NO INT ) 
		
--INSERT INTO @CUS_DEL_LIST 
--SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ',')

--SET @STEP_MSG= '회원 한명씩 처리 커서 시작 '

			--------------------------------------------------------------------------------------------------------------
			-- 한건씩 커서 처리 
			DECLARE USER_CURSOR CURSOR FOR
				SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ',')
			OPEN USER_CURSOR
			FETCH NEXT FROM USER_CURSOR	INTO @FROM_CUS_NO
			WHILE @@FETCH_STATUS = 0
			BEGIN
				-------------------------------------------------------------------------------------------------------------------
				--삭제될 CUS_NO 들 히스토리 넣기 
				EXEC XP_CUS_CUSTOMER_HISTORY_INSERT @CUS_NO = @FROM_CUS_NO ,
					@EMP_CODE = @EMP_CODE , 
					@EDT_REMARK = '고객통합' , 
					@EDT_TYPE  = 5 -- 고객병합  

				--예약
				UPDATE RES_CUSTOMER_damo SET CUS_NO = @CUS_NO WHERE CUS_NO = @FROM_CUS_NO;
				UPDATE RES_MASTER_damo SET CUS_NO = @CUS_NO WHERE CUS_NO = @FROM_CUS_NO;
				--SMS발송 
				UPDATE RES_SND_SMS SET CUS_NO = @CUS_NO WHERE CUS_NO = @FROM_CUS_NO;
			
				--구스마트케어 삭제 
				DELETE FROM CUS_DEVICE WHERE CUS_NO = @FROM_CUS_NO

				-------------------------------------------------------------------------------------------------------------------
				-- 18-04-02 정회원 추가 처리 
				-- 통합될(삭제될) 회원번호에 
				-- 정회원 조회되었을 시 탈퇴 처리 , 포인트 처리 
				IF EXISTS(SELECT 1 FROM VIEW_MEMBER WHERE CUS_NO = @FROM_CUS_NO)
				BEGIN
					DECLARE @SECEDE_CUS_ID VARCHAR(20), @SECEDE_REMARK VARCHAR(50)

					SELECT @SECEDE_CUS_ID = CUS_ID, @SECEDE_REMARK  = '고객병합탈퇴('+ CONVERT(VARCHAR,@CUS_NO) + ')으로병합'
					FROM VIEW_MEMBER
					WHERE CUS_NO = @FROM_CUS_NO
									
					/* 탈퇴신청 */
					INSERT INTO CUS_SECEDE (CUS_NO, REMARK, NEW_DATE)
					VALUES ( @FROM_CUS_NO , @SECEDE_REMARK ,GETDATE() ) 

					-------------------------------------------------------------------------------------------------------------------
					-- CUS_CUSTOMER 탈퇴 업데이트
					UPDATE CUS_CUSTOMER_DAMO
						SET EDT_DATE = GETDATE(), 
							EDT_CODE = @EMP_CODE, 
							EDT_MESSAGE = @SECEDE_REMARK, 
							CXL_CODE = @EMP_CODE, 
							CXL_DATE = GETDATE(), 
							CXL_REMARK = @SECEDE_REMARK, 
							CUS_STATE = 'N',
							POINT_CONSENT = 'N',
							POINT_CONSENT_DATE = GETDATE() ,
							CUS_ID = NULL,  -- ID 초기화  17.10 SNS 오픈이후 부터 
							-- 기타 정보들 초기화 
							CUS_PASS = NULL,  LAST_NAME=NULL, FIRST_NAME=NULL, NICKNAME=NULL, EMAIL=NULL, GENDER=NULL, NOR_TEL1=NULL, NOR_TEL2=NULL, NOR_TEL3=NULL, 
							COM_TEL1=NULL, COM_TEL2=NULL, COM_TEL3=NULL, HOM_TEL1=NULL, HOM_TEL2=NULL, HOM_TEL3=NULL, FAX_TEL1=NULL, FAX_TEL2=NULL, FAX_TEL3=NULL, 
							VISA_YN=NULL, PASS_YN=NULL, PASS_EXPIRE=NULL, PASS_ISSUE=NULL, [NATIONAL]=NULL, CUS_GRADE=0, BIRTHDAY=NULL, LUNAR_YN=NULL, 
							RCV_EMAIL_YN='N', RCV_SMS_YN='N', ADDRESS1=NULL, ADDRESS2=NULL, ZIP_CODE=NULL,
							sec_SOC_NUM2=NULL, sec1_SOC_NUM2=NULL, sec_PASS_NUM=NULL, sec1_PASS_NUM=NULL, VSOC_NUM=NULL, BIRTH_DATE=NULL
					WHERE CUS_NO = @FROM_CUS_NO 

					-------------------------------------------------------------------------------------------------------------------
					--SNS 연결 계정도 이동 
					UPDATE CUS_SNS_INFO SET CUS_NO = @CUS_NO WHERE CUS_NO = @FROM_CUS_NO

					-------------------------------------------------------------------------------------------------------------------
					-- 포인트 병합 처리 . 회원삭제 이전 
					-- 병합될(삭제될)회원의 포인트가 있으면 
					IF ISNULL((SELECT TOP 1 TOTAL_PRICE FROM CUS_POINT WHERE CUS_NO = @FROM_CUS_NO ORDER BY POINT_NO DESC), 0) > 0
					BEGIN
						DECLARE @DEL_CUS_TOTAL_POINT INT = (SELECT TOP 1 TOTAL_PRICE FROM CUS_POINT WHERE CUS_NO = @FROM_CUS_NO ORDER BY POINT_NO DESC)
							, @POINT_REMARK VARCHAR(100)
						-- 병합 시 포인트 소멸 일시 정비
						--IF @MEM_CERT_YN = 'Y' OR @PHONE_AUTH_YN = 'Y' 
						BEGIN
							SET @POINT_REMARK = '고객병합양도('+ CONVERT(VARCHAR,@FROM_CUS_NO) + '->'+ CONVERT(VARCHAR,@CUS_NO)+')';
							EXEC SP_CUS_POINT_TRANSFER_INSERT 
								@ACC_CUS_NO = @CUS_NO ,  -- 병합될 정회원 
								@USE_CUS_NO = @FROM_CUS_NO,  --삭제될 회원 
								@USE_POINT_PRICE = @DEL_CUS_TOTAL_POINT,
								@TITLE = @POINT_REMARK,
								@NEW_CODE = @EMP_CODE 
						END 
						--ELSE 
						--BEGIN
						--	SET @POINT_REMARK = '고객병합탈퇴소멸('+ CONVERT(VARCHAR,@CUS_NO) + ')';
						--	--탈퇴 소멸 처리로직 
						--	EXEC SP_CUS_POINT_HISTORY_INSERT 
						--		@CUS_NO = @FROM_CUS_NO ,  --삭제될 회원 
						--		@USE_TYPE = 5,  --탈퇴소멸
						--		@USE_POINT_PRICE = @DEL_CUS_TOTAL_POINT,
						--		@TITLE = @POINT_REMARK,
						--		@NEW_CODE = @EMP_CODE , 
						--		@IS_PAYMENT = 0 
						--END 
					END
				END 
				--ELSE 
				--BEGIN
				--	------ 최종적으로 회원삭제!!  XX 맨 나중에 처리 REF 관계 때문 
				--	---- 비회원은 그냥 CUS_CUSTOMER_DAMO 삭제 
				--	--DELETE CUS_CUSTOMER_DAMO WHERE CUS_NO = @FROM_CUS_NO 
				--END 
				-------------------------------------------------------------------------------------------------------------------

				FETCH NEXT FROM USER_CURSOR	INTO @FROM_CUS_NO
			END

			CLOSE USER_CURSOR
			DEALLOCATE USER_CURSOR
			
			-------------------------------------------------------------------------------------------------------------------
			-- VIP 등급 기록 업데이트
			
			UPDATE A SET A.CUS_NO = @CUS_NO, A.EDT_DATE = GETDATE(), A.EDT_CODE = @EMP_CODE, A.REMARK = ('고객(' + CONVERT(VARCHAR, B.DATA) + ')통합')
			FROM CUS_VIP_HISTORY A
			INNER JOIN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ',')) B ON A.CUS_NO = B.[Data]

			-------------------------------------------------------------------------------------------------------------------
			-- CTI 업데이트
			-- 상담이력
			UPDATE SIRENS.CTI.CTI_CONSULT SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			-- 고객약속
			UPDATE SIRENS.CTI.CTI_CONSULT_RESERVATION SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));			
			-- 고객전화번호 별 고객번호
			--UPDATE SIRENS.CTI.CTI_CONSULT_CUS_TEL SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			-- 고객평가
			--UPDATE SIRENS.CTI.CTI_CUS_ESTI_MASTER SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			-- 고객평가
			--UPDATE SIRENS.CTI.CTI_CUS_ESTI_LIST SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			
			--SET @STEP_MSG= '상담이력 처리 완료'
			
			-------------------------------------------------------------------------------------------------------------------
			-- 2017-03-07 추가 업데이트
			-- 앱관련 테이블
			UPDATE dbo.APP_ALBUM_SHARE SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			UPDATE dbo.APP_DOWNLOAD_LOG SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			UPDATE dbo.APP_MESSAGE SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			UPDATE dbo.APP_RECEIVE SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			UPDATE dbo.PPT_MASTER SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));

			-------------------------------------------------------------------------------------------------------------------
			-- 3차 수정 추가 반영테이블
			UPDATE dbo.COM_EMPLOYEE_MATCHING SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			UPDATE dbo.CUS_RCV_AGREE SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			UPDATE dbo.CUS_SPECIAL SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			UPDATE dbo.HBS_DETAIL SET NEW_CODE = @CUS_NO WHERE NEW_CODE IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			--UPDATE dbo.CUS_DEVICE SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			UPDATE dbo.DEVICE_MASTER SET CUS_NO = @CUS_NO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			
			DELETE CUS_INTEREST WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));	-- 삭제로 변경
			DELETE CUVE WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			DELETE CUS_LOGIN_INFO WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
		
			--SET @STEP_MSG= '앱관련 및 추가 테이블 처리 완료'

			-------------------------------------------------------------------------------------------------------------------
			-- 기록 저장
			INSERT INTO CUS_CLEAR (CUS_NO, CUS_NO_LIST, EMP_CODE, NEW_DATE)
			VALUES (@CUS_NO, @CUS_NO_LIST, @EMP_CODE, GETDATE())

			SET @CUS_CLEAR_SEQ = @@IDENTITY;
			
			-- 기록 히스토리 저장
			INSERT INTO CUS_CLEAR_HISTORY
			(CUS_SEQ, CUS_NO, CUS_NAME, CUS_GRADE, BIRTH_DATE, GENDER, EMAIL, NOR_TEL1, NOR_TEL2, NOR_TEL3, COM_TEL1, COM_TEL2, COM_TEL3, HOM_TEL1, HOM_TEL2, HOM_TEL3)
			SELECT 
				@CUS_CLEAR_SEQ, CUS_NO, CUS_NAME,CUS_GRADE,BIRTH_DATE,GENDER,EMAIL,
				NOR_TEL1,NOR_TEL2,NOR_TEL3,
				COM_TEL1,COM_TEL2,COM_TEL3,
				HOM_TEL1,HOM_TEL2,HOM_TEL3			
			FROM CUS_CUSTOMER_damo WITH(NOLOCK) 
			WHERE CUS_NO IN ( SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ',') )

			--PRINT @CUS_NO_LIST
			--SET @STEP_MSG= '고객병합 전체 처리 완료!'
			
			-------------------------------------------------------------------------------------------------------------------
			-- 고객정보 삭제
			DELETE A 
			FROM CUS_CUSTOMER_DAMO A
			LEFT JOIN VIEW_MEMBER B ON A.CUS_NO = B.CUS_NO
			WHERE A.CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ',')) AND B.CUS_NO IS NULL;
			
			DELETE CUS_MEMBER WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));
			DELETE CUS_MEMBER_SLEEP WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','));

		COMMIT TRAN
	END TRY
	BEGIN CATCH

		SET @ERROR_MSG = '[' + ISNULL(@STEP_MSG,'') + ']' +  ISNULL(@ERROR_MSG,'') + '[' +  ERROR_MESSAGE() + ']';

		-- 커서 돌다 에러시 커서 종료하기 위해 추가
		IF CURSOR_STATUS('global', 'USER_CURSOR') > -1
		BEGIN
			CLOSE USER_CURSOR;
		END
	
		IF CURSOR_STATUS('global', 'USER_CURSOR') = -1
		BEGIN
			DEALLOCATE USER_CURSOR;
		END

		ROLLBACK TRAN
	END CATCH

END 


GO
