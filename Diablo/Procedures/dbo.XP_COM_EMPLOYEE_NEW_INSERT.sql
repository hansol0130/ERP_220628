USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: [[XP_COM_EMPLOYEE_NEW_INSERT]]
■ DESCRIPTION				: 팝업 직원정보 추가 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 

■ EXEC						: 
	EXEC XP_COM_EMPLOYEE_NEW_INSERT '92756','2016021','','1','test','19790909','M','2EA6201A068C5FA0EEA5D81A3863321A87F8D533','010-123-1233','010','123','1233','2010-03-01','KNIHGT@NAVER.COM','1','100'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-14		저스트고-백경훈			최초생성
   2016-04-24		박형만					직원만 등록 하기 
   2016-04-26		박형만					고객정보와 매핑정보도 등록 , 예약정보  , CUS_NO -1 이면 고객정보 등록 안함 
   2016-04-29		박형만					VGL_CODE - 직원 사번 추가 
   2016-05-20		박형만					로직변경 
   2016-09-12		박형만					이름생년월일로 중복 체크  
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_COM_EMPLOYEE_NEW_INSERT]
(
	@AGT_CODE			VARCHAR(10),
	@EMP_ID				VARCHAR(20),
	@EMP_SEQ			int,
	@TEAM_SEQ			int,
	@POS_SEQ			int,

	@KOR_NAME			VARCHAR(20),
	@BIRTH_DATE			VARCHAR(10),
	@GENDER				CHAR(1),
	@PASSWORD			VARCHAR(100),
	@HP_NUMBER			VARCHAR(20),
	--@HP_TEL01			VARCHAR(20),
	--@HP_TEL02			VARCHAR(20),
	--@HP_TEL03			VARCHAR(20),
	@EMAIL				VARCHAR(50),
	
	@CUS_NO				INT= 0 ,
	@NEW_CODE			EMP_CODE=NULL,
	@NEW_SEQ			INT = 0, -- 기본 0 
	@EDT_SEQ			INT = 0 ,

	@RES_CODE			VARCHAR(12) = NULL 
)
AS

BEGIN

	 --//empSeq = 0 인경우 
  --      // 직원등록 , 고객정보등록 , 직원-고객매핑정보등록 
  --      //cusNo = 0 인경우 
  --      // 고객정보등록 , 직원-고객매핑정보등록 
  
	-- NULL 값 넣기 
	SET @TEAM_SEQ = CASE WHEN ISNULL(@TEAM_SEQ,0) = 0 THEN NULL ELSE @TEAM_SEQ END 
	SET @BIRTH_DATE = CASE WHEN ISNULL(@BIRTH_DATE,'') = '' THEN NULL ELSE @BIRTH_DATE END 
   
	DECLARE @NEW_EMP_SEQ INT
	DECLARE @NEW_CUS_NO INT
	--DECLARE @EMP_IDSEL VARCHAR(30)
	--DECLARE @EMP_MATCHING INT
	--DECLARE @CUS_NO INT
	--DECLARE @ORDER_NUM INT
	--DECLARE @EMP_IDX INT
	--SET @EMP_IDX = (ISNULL((SELECT EMP_SEQ FROM COM_EMPLOYEE WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ = @EMP_SEQ), 99))
	
	-- 직원 신규 등록 
	-- 아이디 중복체크 
	IF ISNULL(@EMP_ID,'') <> '' 
		AND EXISTS (SELECT * FROM COM_EMPLOYEE  WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE AND EMP_ID = @EMP_ID  )
	BEGIN
		-----<결과반환>-----
		SELECT -2 AS RESULT_STATUS , 0 AS CUS_NO , 0 AS EMP_SEQ 
	END 
	-- 이름 중복체크 
	ELSE IF EXISTS (SELECT * FROM COM_EMPLOYEE WHERE AGT_CODE = @AGT_CODE AND KOR_NAME = @KOR_NAME  
		AND BIRTH_DATE = @BIRTH_DATE )
	BEGIN
		-----<결과반환>-----
		SELECT -1 AS RESULT_STATUS , 0 AS CUS_NO , 0 AS EMP_SEQ 
	END 
	ELSE
	BEGIN
		
		-- 고객 정보 등록전 
		-- 휴대폰 번호 갱신 
		DECLARE @NOR_TEL1 VARCHAR(6)
		DECLARE @NOR_TEL2 VARCHAR(6)
		DECLARE @NOR_TEL3 VARCHAR(6)
		IF(ISNULL(@HP_NUMBER,'') <> '')
		BEGIN
			SET @NOR_TEL1 =  (SELECT DATA FROM DBO.FN_SPLIT(@HP_NUMBER,'-') WHERE ID = 1)
			SET @NOR_TEL2 =  (SELECT DATA FROM DBO.FN_SPLIT(@HP_NUMBER,'-') WHERE ID = 2)
			SET @NOR_TEL3 =  (SELECT DATA FROM DBO.FN_SPLIT(@HP_NUMBER,'-') WHERE ID = 3)
		END 

		SET @NEW_EMP_SEQ = (ISNULL((SELECT MAX(EMP_SEQ) FROM COM_EMPLOYEE A WITH(NOLOCK) WHERE A.AGT_CODE = @AGT_CODE), 99) + 1)

		--직원등록 
		INSERT INTO COM_EMPLOYEE (AGT_CODE, EMP_SEQ, TEAM_SEQ, EMP_ID, KOR_NAME, BIRTH_DATE, GENDER, PASS_WORD, POS_SEQ,WORK_TYPE, JOIN_DATE, OUT_DATE
		, EMAIL, HP_NUMBER, FAIL_COUNT, NEW_DATE, NEW_SEQ , VGL_CODE , VGL_DATE )
		SELECT @AGT_CODE, @NEW_EMP_SEQ, @TEAM_SEQ, @EMP_ID, @KOR_NAME, @BIRTH_DATE, @GENDER, @PASSWORD, @POS_SEQ,1, GETDATE(), NULL
			, @EMAIL, @HP_NUMBER, 0, GETDATE(), @NEW_SEQ , @NEW_CODE , GETDATE()

		--고객신규 등록 
		IF NOT EXISTS (SELECT * FROM COM_EMPLOYEE_MATCHING WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ = @NEW_EMP_SEQ )
		BEGIN
			
			--고객등록 
			INSERT CUS_CUSTOMER_damo (CUS_STATE, CUS_NAME, EMAIL, GENDER, NOR_TEL1,NOR_TEL2,NOR_TEL3, CUS_GRADE, NEW_DATE, NEW_CODE, BIRTH_DATE)
			VALUES('Y',@KOR_NAME, @EMAIL, @GENDER, @NOR_TEL1,@NOR_TEL2,@NOR_TEL3,0, GETDATE(), @NEW_CODE,@BIRTH_DATE)
		
			SET @NEW_CUS_NO = @@IDENTITY

			--고객 매핑 정보 등록 
			INSERT COM_EMPLOYEE_MATCHING (AGT_CODE, EMP_SEQ,CUS_NO,NEW_DATE,NEW_CODE)
			VALUES(@AGT_CODE,@NEW_EMP_SEQ,@NEW_CUS_NO,GETDATE(),@NEW_CODE)
		END 
		--ELSE 
		--BEGIN
		--END 

		-----<결과반환>-----
		SELECT 1 AS RESULT_STATUS , @NEW_CUS_NO AS CUS_NO , @NEW_EMP_SEQ AS EMP_SEQ , @RES_CODE AS RES_CODE
	END 

	
		
	--ELSE
	--BEGIN
	--	 -- com_employee 엔 있고 com_employee_matching 에 없다면 
	--	SET @EMP_MATCHING = (ISNULL((SELECT MAX(EMP_SEQ) FROM COM_EMPLOYEE_MATCHING A WITH(NOLOCK) WHERE A.AGT_CODE = @AGT_CODE and A.EMP_SEQ = @EMP_SEQ),0))
	--	IF @EMP_MATCHING = 0
	--	BEGIN
		
	--			INSERT CUS_CUSTOMER_damo (CUS_STATE, CUS_NAME, EMAIL, GENDER, NOR_TEL1,NOR_TEL2,NOR_TEL3, CUS_GRADE, NEW_DATE, NEW_CODE,BIRTH_DATE)
	--			VALUES('Y',@KOR_NAME, @EMAIL, @GENDER, @HP_TEL01,@HP_TEL02,@HP_TEL03,0, GETDATE(), @NEW_SEQ,@BIRTH_DATE)
	--			SET @CUS_NO = (SELECT MAX(CUS_NO) FROM CUS_CUSTOMER_damo)

	--			INSERT COM_EMPLOYEE_MATCHING (AGT_CODE, EMP_SEQ,CUS_NO,NEW_DATE,NEW_CODE)VALUES(@AGT_CODE,@EMP_SEQ, @CUS_NO,GETDATE(),@NEW_SEQ)

	--	END


	--END


END
GO
