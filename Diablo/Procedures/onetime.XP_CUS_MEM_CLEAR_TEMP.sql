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

================================================================================================================*/ 
CREATE PROCEDURE [onetime].[XP_CUS_MEM_CLEAR_TEMP]
	@ERROR_MSG		VARCHAR(1000) OUTPUT,
	@CUS_NO			INT,			-- 현재 회원(기준)
	@CUS_NAME		VARCHAR(40),	-- 현재 회원명 (기준) 
	@CUS_NO_LIST	VARCHAR(1000), -- 병합될 회원명 
	@EMP_CODE		VARCHAR(7), --  시스템 관리자 
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
	@CUS_ID			VARCHAR(50) = NULL, -- 기준아이디 18.04 추가 
	@CUS_PASS		VARCHAR(500) = NULL, -- 기준패스워드 18.10 추가 
	@CUS_SNS_SEQ    INT = NULL --snsseq

AS
BEGIN

DECLARE @STEP_MSG VARCHAR(100)
DECLARE @SQLSTRING NVARCHAR(MAX), @FROM_CUS_NO INT, @CUS_CLEAR_SEQ INT
-------------------------------------------------------------------------------------------------------------------
-- 기준 고객번호가 안넘아 왔을시 팅김
IF ISNULL(@CUS_NO, '') = '' OR @CUS_NO = 0
BEGIN
	SET @ERROR_MSG = '[통합 기준 고객번호가 없습니다.]';
	--ROLLBACK TRAN;
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

-- 병합될(삭제될) 정회원 조회되었을 시 18.04 추가  
DECLARE @ORG_CUS_MEM_CNT INT 
DECLARE @TARGET_CUS_MEM_CNT INT 
SET @TARGET_CUS_MEM_CNT = 
	ISNULL(( SELECT COUNT(*) FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','))),0)
		+ ISNULL(( SELECT COUNT(*) FROM CUS_MEMBER_SLEEP WITH(NOLOCK) WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','))),0)
		
SET @ORG_CUS_MEM_CNT = 
	ISNULL( (SELECT COUNT(*) FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @CUS_NO) ,0)
		+ ISNULL( (SELECT COUNT(*) FROM CUS_MEMBER_SLEEP WITH(NOLOCK) WHERE CUS_NO = @CUS_NO) ,0)

--대상회원에 정회원 있으면 
IF @TARGET_CUS_MEM_CNT > 0 
BEGIN
	-- 기준회원 정회원 아님 
	IF @ORG_CUS_MEM_CNT = 0 
	BEGIN
		SET @ERROR_MSG = '[통합할 고객에 정회원이 존재하고. 기준회원이 정회원이 아닙니다]'
		--ROLLBACK TRAN;
		RETURN;	
	END 
	ELSE -- 대상회원,기준회원 모두 정회원  
	BEGIN
		-- 아이디가 비었으면 현재회원껄로 수정 
		IF ISNULL(@CUS_ID,'') =''
		BEGIN
			SET @CUS_ID = ISNULL( (SELECT CUS_ID FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @CUS_NO) 
						, (SELECT CUS_ID FROM CUS_MEMBER_SLEEP WITH(NOLOCK) WHERE CUS_NO = @CUS_NO) )
		END 
		-- 비번이 비었으면 현재회원껄로 수정 
		IF ISNULL(@CUS_PASS,'') =''
		BEGIN
			--CUS_PASS가 빈값으로 처리될 경우 ISNULL에서 걸러내지지 않으므로 해당값까지 처리 CUS_CUSTOMER에서도 없는 경우 이상한 계정이므로 걍 처리
			SET @CUS_PASS = ISNULL( (SELECT CASE WHEN CUS_PASS = '' THEN NULL ELSE CUS_PASS END FROM VIEW_MEMBER WITH(NOLOCK) WHERE CUS_NO = @CUS_NO) 
						, (SELECT CUS_PASS FROM CUS_CUSTOMER_damo WITH(NOLOCK) WHERE CUS_NO = @CUS_NO))
		END 

	END 
END
------ 병합될(삭제될) 정회원이 여러명일때 18.04 추가  - 보류 
--IF  @TARGET_CUS_MEM_CNT > 1 
--BEGIN
--	SET @ERROR_MSG = '[통합할 정회원이 여러건이어서 통합이 불가능합니다]' 
--	--ROLLBACK TRAN;
--	RETURN;	
--END
-- 인증된 회원은 정회원 정보에서 개인정보 가져오기 
DECLARE @MEM_CERT_YN CHAR(1) 
SET @MEM_CERT_YN = 'N' 
IF EXISTS ( SELECT 1 FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO  = @CUS_NO AND CERT_YN ='Y' )
	OR EXISTS ( SELECT 1 FROM CUS_MEMBER_SLEEP WITH(NOLOCK) WHERE CUS_NO  = @CUS_NO AND CERT_YN ='Y' ) 
BEGIN
	SET @MEM_CERT_YN = 'Y'

	-- 기준회원이 본인인증 회원일때는 , 이름.생년.성별을 본인인증 회원 그대로 둔다 
	-- 이름,생년,성별을 기존 본인인증 회원값으로 
	SELECT @BIRTH_DATE = BIRTH_DATE , @CUS_NAME = CUS_NAME ,@GENDER = GENDER 
	FROM 
	( SELECT BIRTH_DATE , CUS_NAME , GENDER FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @CUS_NO 
		UNION ALL 
		SELECT BIRTH_DATE , CUS_NAME , GENDER FROM CUS_MEMBER_SLEEP WITH(NOLOCK) WHERE CUS_NO = @CUS_NO  ) T 
	WHERE CUS_NAME IS NOT NULL 
END  

-- 고객중 최신 휴대폰 인증 정보 
DECLARE @PHONE_AUTH_YN CHAR(1) 
DECLARE @PHONE_AUTH_DATE DATETIME

SELECT  @PHONE_AUTH_YN =  ISNULL( MAX(PHONE_AUTH_YN),'N') , 
	 @PHONE_AUTH_DATE = MAX(PHONE_AUTH_DATE) 
FROM ( 
	SELECT PHONE_AUTH_YN,PHONE_AUTH_DATE,SNS_MEM_YN FROM CUS_MEMBER WITH(NOLOCK) 
	WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ',')) AND NOR_TEL1 = @NOR_TEL1  AND NOR_TEL2 = @NOR_TEL2 AND NOR_TEL3 = @NOR_TEL3
	UNION ALL 
	SELECT PHONE_AUTH_YN,PHONE_AUTH_DATE,SNS_MEM_YN FROM CUS_MEMBER WITH(NOLOCK) 
	WHERE CUS_NO = @CUS_NO AND NOR_TEL1 = @NOR_TEL1  AND NOR_TEL2 = @NOR_TEL2 AND NOR_TEL3 = @NOR_TEL3
	UNION ALL 
	SELECT PHONE_AUTH_YN,PHONE_AUTH_DATE,SNS_MEM_YN FROM CUS_MEMBER_SLEEP WITH(NOLOCK) 
	WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ',')) AND NOR_TEL1 = @NOR_TEL1  AND NOR_TEL2 = @NOR_TEL2 AND NOR_TEL3 = @NOR_TEL3
	UNION ALL 
	SELECT PHONE_AUTH_YN,PHONE_AUTH_DATE,SNS_MEM_YN FROM CUS_MEMBER_SLEEP WITH(NOLOCK) 
	WHERE CUS_NO = @CUS_NO AND NOR_TEL1 = @NOR_TEL1  AND NOR_TEL2 = @NOR_TEL2 AND NOR_TEL3 = @NOR_TEL3 ) T 

-- SNS 멤버 여부 (아이디 없음)
-- 기준회원이 SNS 멤버이면 ( 기준회원이 인증회원이 아니면 SNS 멤버  ) 
DECLARE @SNS_MEM_YN CHAR(1) 
SET @SNS_MEM_YN = ISNULL ( (SELECT SNS_MEM_YN FROM CUS_MEMBER_SLEEP WITH(NOLOCK) WHERE CUS_NO = @CUS_NO)
	,(SELECT SNS_MEM_YN FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @CUS_NO))

--회원등급은 대상회원중 가능 높은것 
IF ISNULL(@CUS_CLASS,0)  = 0 --- 일반 또는 선택안했을때도 
BEGIN
	SELECT @CUS_CLASS = MAX(CUS_GRADE) FROM ( 
		SELECT CUS_GRADE FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) 
		WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','))
		UNION ALL 
		SELECT CUS_GRADE FROM CUS_CUSTOMER_DAMO WITH(NOLOCK)  -- 2018-11-07 본인 등급도 수정 
		WHERE CUS_NO = @CUS_NO 
	) T 
END 

-- 병합대상 회원에  FAX 여권인증 기록이 있으면 18.07.04추가
DECLARE @FAX_SEQ CHAR(17) 
DECLARE @PASS_DATE DATETIME
DECLARE @PASS_EMP_CODE EMP_CODE 
SELECT TOP 1 @FAX_SEQ = FAX_SEQ ,@PASS_DATE = PASS_DATE , @PASS_EMP_CODE = PASS_EMP_CODE FROM ( 
	SELECT  PASS_DATE,PASS_EMP_CODE, FAX_SEQ FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) 
	WHERE CUS_NO IN (SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ','))
	AND FAX_SEQ IS NOT NULL 
	UNION ALL 
	SELECT PASS_DATE,PASS_EMP_CODE, FAX_SEQ FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) 
	WHERE CUS_NO = @CUS_NO 
	AND FAX_SEQ IS NOT NULL 
) T
ORDER BY PASS_DATE DESC 



-------------------------------------------------------------------------------------------------------------------
BEGIN TRY
	BEGIN TRAN
		--------------------------------------------------------------------------------------------------------------
		-- 수정전 HISTORY 넣기 
		-- 기록남기기 
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
			@EDT_REMARK = '고객통합' , 
			@EDT_TYPE  = 5 -- 고객병합  
		
		--SET @STEP_MSG= '고객히스토리 처리완료'

		
		-- 기준 정회원 휴면회원 업데이트 
		IF EXISTS ( SELECT * FROM CUS_MEMBER_SLEEP WHERE CUS_NO = @CUS_NO )
		BEGIN
			UPDATE CUS_MEMBER_SLEEP 
			SET NOR_TEL1 = @NOR_TEL1, NOR_TEL2 = @NOR_TEL2, NOR_TEL3 = @NOR_TEL3, COM_TEL1 = @COM_TEL1, COM_TEL2 = @COM_TEL2, COM_TEL3 = @COM_TEL3
			, HOM_TEL1 = @HOM_TEL1, HOM_TEL2 = @HOM_TEL2, HOM_TEL3 = @HOM_TEL3
			, BIRTH_DATE = @BIRTH_DATE, GENDER = @GENDER, CUS_NAME = @CUS_NAME
			, EMAIL = @EMAIL, CUS_GRADE = @CUS_CLASS
			, FIRST_NAME = @FIRST_NAME, LAST_NAME = @LAST_NAME, ZIP_CODE = @ZIP_CODE, ADDRESS1 = @ADDRESS1, ADDRESS2 = @ADDRESS2
			, EDT_CODE = @EMP_CODE, EDT_DATE = GETDAte() , EDT_MESSAGE =  '고객통합'
			, CUS_ID  =  CASE WHEN ISNULL(@CUS_ID,'') <> '' THEN @CUS_ID ELSE NULL END  
			, CUS_PASS = @CUS_PASS 
			, CERT_YN = @MEM_CERT_YN , PHONE_AUTH_YN = @PHONE_AUTH_YN , PHONE_AUTH_DATE = @PHONE_AUTH_DATE , SNS_MEM_YN = @SNS_MEM_YN 
			WHERE CUS_NO = @CUS_NO 
		END 
		ELSE -- 휴면 회원이 없을때만 업데이트 
		BEGIN
			-- 기준 정회원 정보 업데이트 , 이름,생년,성별 수정O
			UPDATE CUS_MEMBER  
			SET NOR_TEL1 = @NOR_TEL1, NOR_TEL2 = @NOR_TEL2, NOR_TEL3 = @NOR_TEL3, COM_TEL1 = @COM_TEL1, COM_TEL2 = @COM_TEL2, COM_TEL3 = @COM_TEL3
			, HOM_TEL1 = @HOM_TEL1, HOM_TEL2 = @HOM_TEL2, HOM_TEL3 = @HOM_TEL3
			, BIRTH_DATE = @BIRTH_DATE, GENDER = @GENDER, CUS_NAME = @CUS_NAME
			, EMAIL = @EMAIL, CUS_GRADE = @CUS_CLASS
			, FIRST_NAME = @FIRST_NAME, LAST_NAME = @LAST_NAME, ZIP_CODE = @ZIP_CODE, ADDRESS1 = @ADDRESS1, ADDRESS2 = @ADDRESS2
			, EDT_CODE = @EMP_CODE, EDT_DATE = GETDAte() , EDT_MESSAGE =  '고객통합'
			, CUS_ID  = CASE WHEN ISNULL(@CUS_ID,'') <> '' THEN @CUS_ID ELSE NULL END 
			, CUS_PASS = @CUS_PASS 
			, CERT_YN = @MEM_CERT_YN , PHONE_AUTH_YN = @PHONE_AUTH_YN , PHONE_AUTH_DATE = @PHONE_AUTH_DATE , SNS_MEM_YN = @SNS_MEM_YN 
			WHERE CUS_NO = @CUS_NO 
		END 
		
		--------------------------------------------------------------------------------------------------------------
		-- 기준 회원 정보 업데이트
		UPDATE CUS_CUSTOMER_DAMO SET NOR_TEL1 = @NOR_TEL1, NOR_TEL2 = @NOR_TEL2, NOR_TEL3 = @NOR_TEL3, COM_TEL1 = @COM_TEL1, COM_TEL2 = @COM_TEL2, COM_TEL3 = @COM_TEL3
			, HOM_TEL1 = @HOM_TEL1, HOM_TEL2 = @HOM_TEL2, HOM_TEL3 = @HOM_TEL3, BIRTH_DATE = @BIRTH_DATE, GENDER = @GENDER, EMAIL = @EMAIL, CUS_GRADE = @CUS_CLASS, CUS_NAME = @CUS_NAME
			, FIRST_NAME = @FIRST_NAME, LAST_NAME = @LAST_NAME, ZIP_CODE = @ZIP_CODE, ADDRESS1 = @ADDRESS1, ADDRESS2 = @ADDRESS2
			, SEC_PASS_NUM = damo.dbo.enc_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM',@PASS_NUM)
			, SEC1_PASS_NUM = damo.dbo.pred_meta_plain_v( @PASS_NUM ,'DIABLO','dbo.CUS_CUSTOMER','PASS_NUM')
			, EDT_CODE = @EMP_CODE, EDT_DATE = GETDAte() , EDT_MESSAGE =  '고객통합'
			, CUS_ID  =  CASE WHEN ISNULL(@CUS_ID,'') <> '' THEN @CUS_ID ELSE NULL END  
			, CUS_PASS = @CUS_PASS 
			, FAX_SEQ =  CASE WHEN  ISNULL(@FAX_SEQ,'') <> ''  THEN @FAX_SEQ ELSE FAX_SEQ END    -- FAX 인증이 있을때만  
			, PASS_DATE =  CASE WHEN @PASS_DATE IS NOT NULL  THEN @PASS_DATE ELSE PASS_DATE END
			, PASS_EMP_CODE =  CASE WHEN ISNULL(@PASS_EMP_CODE,'') <> ''THEN @PASS_EMP_CODE ELSE PASS_EMP_CODE END
		WHERE CUS_NO = @CUS_NO

		--SNS 중복사용자 UPDATE
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

		-- DIABLO 업데이트
		-- 한건씩 커서 처리 
		DECLARE USER_CURSOR CURSOR FOR
			SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ',')
		OPEN USER_CURSOR
		FETCH NEXT FROM USER_CURSOR	INTO @FROM_CUS_NO
		WHILE @@FETCH_STATUS = 0
		BEGIN
			---------------------------------------------------------------------------------------------------------
			DECLARE @OLD_CUS_ID VARCHAR(20) , @OLD_CUS_ID_MEM VARCHAR(20) --카카오싱크 중복가입자 가입시기존 회원가입일로 변경
			SET @OLD_CUS_ID_MEM = ISNULL((SELECT CUS_ID FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO  = @FROM_CUS_NO),'')
			SET @OLD_CUS_ID = ISNULL((SELECT CUS_ID FROM CUS_CUSTOMER_damo WITH(NOLOCK) WHERE CUS_NO  = @FROM_CUS_NO),'')
			
			IF(ISNULL(@OLD_CUS_ID,'') <> '')  --ID존재정회원
			BEGIN
				UPDATE CUS_CUSTOMER_damo SET 
				NEW_DATE =  (SELECT NEW_DATE FROM  CUS_CUSTOMER_damo  WHERE CUS_NO = @FROM_CUS_NO)
				WHERE CUS_NO = @CUS_NO
			END
			
			IF(ISNULL(@OLD_CUS_ID_MEM,'') <> '') --ID존재정회원
			BEGIN
				UPDATE CUS_MEMBER SET 
				NEW_DATE =  (SELECT NEW_DATE FROM  CUS_MEMBER  WHERE CUS_NO = @FROM_CUS_NO)
				WHERE CUS_NO = @CUS_NO
			END
			
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

			------------------------------------------------------
			-- 18-04-02 정회원 추가 처리 
			-- 통합될(삭제될) 회원번호에 
			-- 정회원 조회되었을 시 탈퇴 처리 , 포인트 처리 
			IF EXISTS ( SELECT 1 FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @FROM_CUS_NO ) 
			  OR EXISTS ( SELECT 1 FROM CUS_MEMBER_SLEEP WITH(NOLOCK) WHERE CUS_NO = @FROM_CUS_NO)
			BEGIN
				DECLARE @SECEDE_CUS_ID VARCHAR(20) 
				DECLARE @SECEDE_REMARK VARCHAR(50) 
				SET @SECEDE_REMARK = '고객병합탈퇴('+ CONVERT(VARCHAR,@CUS_NO) + ')으로병합' 

				SET @SECEDE_CUS_ID = 
				ISNULL((SELECT CUS_ID FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @FROM_CUS_NO)
					,(SELECT CUS_ID FROM CUS_MEMBER_SLEEP WITH(NOLOCK) WHERE CUS_NO = @FROM_CUS_NO))

				
				/* 탈퇴신청 */
				INSERT INTO CUS_SECEDE (CUS_NO, REMARK, NEW_DATE)
				VALUES ( @FROM_CUS_NO , @SECEDE_REMARK ,GETDATE() ) 

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

				--SNS 연결 계정도 이동 
				UPDATE CUS_SNS_INFO SET CUS_NO = @CUS_NO WHERE CUS_NO = @FROM_CUS_NO

				-- 포인트 병합 처리 . 회원삭제 이전 
				-- 병합될(삭제될)회원의 포인트가 있으면 
				IF EXISTS ( SELECT * FROM CUS_POINT WHERE CUS_NO = @FROM_CUS_NO )
				BEGIN
					-- 기존회원 또는 병합될 회원의 사용된 내역이 있을경우 
					DECLARE @DEL_CUS_TOTAL_POINT INT 
					SET @DEL_CUS_TOTAL_POINT =  (SELECT TOP 1 TOTAL_PRICE FROM CUS_POINT WHERE CUS_NO = @FROM_CUS_NO  ORDER BY POINT_NO DESC )
					IF( @DEL_CUS_TOTAL_POINT > 0 ) 
					BEGIN
						DECLARE @POINT_REMARK VARCHAR(100) 
						-- 기준회원이 본인인증 회원일때만 양도로 처리 
						IF @MEM_CERT_YN = 'Y'  OR @PHONE_AUTH_YN = 'Y' 
						BEGIN 
							SET @POINT_REMARK =  '고객병합양도('+ CONVERT(VARCHAR,@SECEDE_CUS_ID) + '->'+ CONVERT(VARCHAR,@CUS_ID)+')'  
							EXEC SP_CUS_POINT_TRANSFER_INSERT 
								@ACC_CUS_NO = @CUS_NO ,  -- 병합될 정회원 
								@USE_CUS_NO = @FROM_CUS_NO,  --삭제될 회원 
								@USE_POINT_PRICE = @DEL_CUS_TOTAL_POINT ,
								@TITLE =  @POINT_REMARK ,
								@NEW_CODE = @EMP_CODE 
						END 
						ELSE 
						BEGIN
							--탈퇴 소멸 처리로직 
							SET @POINT_REMARK =  '고객병합탈퇴소멸('+ CONVERT(VARCHAR,@CUS_ID) + ')으로병합'  
							EXEC SP_CUS_POINT_HISTORY_INSERT 
								@CUS_NO = @FROM_CUS_NO ,  --삭제될 회원 
								@USE_TYPE = 5,  --탈퇴소멸
								@USE_POINT_PRICE = @DEL_CUS_TOTAL_POINT ,
								@TITLE =  @POINT_REMARK ,
								@NEW_CODE = @EMP_CODE , 
								@IS_PAYMENT = 0 
						END 
					END 
				END 
			
				---- 최종적으로 회원삭제!!  XX 맨 나중에 처리 REF 관계 때문 
				--DELETE CUS_MEMBER 
				--WHERE CUS_NO = @FROM_CUS_NO
				--DELETE CUS_MEMBER_SLEEP
				--WHERE CUS_NO = @FROM_CUS_NO 
			END 
			--ELSE 
			--BEGIN
			--	------ 최종적으로 회원삭제!!  XX 맨 나중에 처리 REF 관계 때문 
			--	---- 비회원은 그냥 CUS_CUSTOMER_DAMO 삭제 
			--	--DELETE CUS_CUSTOMER_DAMO WHERE CUS_NO = @FROM_CUS_NO 
			--END 
			------------------------------------------------------

			FETCH NEXT FROM USER_CURSOR	INTO @FROM_CUS_NO
		END

		CLOSE USER_CURSOR
		DEALLOCATE USER_CURSOR
		---------------------------------------------------------------------------------------------------------
		
		-- VIP 등급 기록 업데이트
		;WITH TMP(CUS_NO, DATAITEM, CUS_NO_LIST) AS
		(
			SELECT
				@CUS_NO,
				CONVERT(INT, LEFT(@CUS_NO_LIST, CHARINDEX(',', @CUS_NO_LIST + ',') - 1)),
				STUFF(@CUS_NO_LIST, 1, CHARINDEX(',', @CUS_NO_LIST + ','), '')	
			UNION ALL
			SELECT
				@CUS_NO,
				CONVERT(INT, LEFT(CUS_NO_LIST, CHARINDEX(',', CUS_NO_LIST + ',') - 1)),
				STUFF(CUS_NO_LIST, 1, CHARINDEX(',', CUS_NO_LIST + ','), '')
			FROM TMP
			WHERE
				CUS_NO_LIST > ''
		)
		UPDATE A SET A.CUS_NO = B.CUS_NO, A.EDT_DATE = GETDATE(), A.EDT_CODE = @EMP_CODE
		FROM CUS_VIP_HISTORY A
		INNER JOIN TMP B ON A.CUS_NO = B.DATAITEM

		-- CTI 업데이트
		SELECT @SQLSTRING = N'
-- 상담이력
UPDATE SIRENS.CTI.CTI_CONSULT SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');
-- 고객약속
UPDATE SIRENS.CTI.CTI_CONSULT_RESERVATION SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');\

-- 고객전화번호 별 고객번호
-- UPDATE SIRENS.CTI.CTI_CONSULT_CUS_TEL SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');
-- 고객평가
-- UPDATE SIRENS.CTI.CTI_CUS_ESTI_MASTER SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');
-- 고객평가
-- UPDATE SIRENS.CTI.CTI_CUS_ESTI_LIST SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');'
		EXEC SP_EXECUTESQL @SQLSTRING;
		--SET @STEP_MSG= '상담이력 처리 완료'

		-- 2017-03-07 추가 업데이트 
		SET @SQLSTRING = '';
		SET @SQLSTRING = N'
-- 앱관련 테이블
UPDATE APP_ALBUM_SHARE SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');
UPDATE APP_DOWNLOAD_LOG SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');
UPDATE APP_MESSAGE SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');

UPDATE APP_RECEIVE SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');
UPDATE PPT_MASTER SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');   -- 추가사항'
		EXEC SP_EXECUTESQL @SQLSTRING;

		-- 3차 수정 추가 반영테이블
		SET @SQLSTRING = '';
		SET @SQLSTRING = N'
UPDATE COM_EMPLOYEE_MATCHING SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');
UPDATE CUS_RCV_AGREE SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');   
UPDATE CUS_SPECIAL SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');
DELETE CUS_INTEREST WHERE CUS_NO IN (' + @CUS_NO_LIST + N');  -- 삭제로변경
--UPDATE CUS_DEVICE SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');	
UPDATE HBS_DETAIL SET NEW_CODE = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE NEW_CODE IN (' + @CUS_NO_LIST + N');

UPDATE DEVICE_MASTER SET CUS_NO = ' + CONVERT(VARCHAR(12), @CUS_NO) + N' WHERE CUS_NO IN (' + @CUS_NO_LIST + N');-- 18-03-27 추가 
		
DELETE FROM CUVE WHERE CUS_NO IN (' + @CUS_NO_LIST + N'); '
		EXEC SP_EXECUTESQL @SQLSTRING;
		--SET @STEP_MSG= '앱관련 및 추가 테이블 처리 완료'

		-- 삭제
		SET @SQLSTRING = '';
		SET @SQLSTRING = N'
--정회원 아닌것만 삭제 . 정회원은 아래에서 삭제 처리 
DELETE A 
FROM CUS_CUSTOMER_DAMO A 
	LEFT JOIN CUS_MEMBER B 
		ON A.CUS_NO = B.CUS_NO 
	LEFT JOIN CUS_MEMBER_SLEEP C
		ON A.CUS_NO = C.CUS_NO 
WHERE B.CUS_NO IS NULL 	AND C.CUS_NO IS NULL  -- 정회원,휴면회원에 없어야함 
AND A.CUS_NO IN (' + @CUS_NO_LIST + N') ;
		
-- 최종적으로 회원삭제!! 
DELETE CUS_MEMBER		WHERE CUS_NO IN (' + @CUS_NO_LIST + N') ;
DELETE CUS_MEMBER_SLEEP WHERE CUS_NO IN (' + @CUS_NO_LIST + N') ;' ;
		EXEC SP_EXECUTESQL @SQLSTRING;

		-- 기록 저장
		INSERT INTO CUS_CLEAR (CUS_NO, CUS_NO_LIST, EMP_CODE, NEW_DATE)
		VALUES (@CUS_NO, @CUS_NO_LIST, @EMP_CODE, GETDATE())

		SET @CUS_CLEAR_SEQ = @@IDENTITY;
		
		-- 기록 히스토리 저장
		INSERT INTO CUS_CLEAR_HISTORY
		(CUS_SEQ, CUS_NO, CUS_NAME, CUS_GRADE, BIRTH_DATE, GENDER, EMAIL, NOR_TEL1, NOR_TEL2, NOR_TEL3, COM_TEL1, COM_TEL2, COM_TEL3, HOM_TEL1, HOM_TEL2, HOM_TEL3)
		SELECT 
			@CUS_CLEAR_SEQ,CUS_NO,CUS_NAME,CUS_GRADE,BIRTH_DATE,GENDER,EMAIL,
			NOR_TEL1,NOR_TEL2,NOR_TEL3,
			COM_TEL1,COM_TEL2,COM_TEL3,
			HOM_TEL1,HOM_TEL2,HOM_TEL3			
		FROM CUS_CUSTOMER_damo WITH(NOLOCK) 
		WHERE CUS_NO IN ( SELECT Data FROM DBO.FN_XML_SPLIT(@CUS_NO_LIST, ',') )

		--print @CUS_NO_LIST
		--SET @STEP_MSG= '고객병합 전체 처리 완료!'
		--------------------------------------------------------------------------------------------------------------

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
