USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_EMPLOYEE_UPDATE
■ DESCRIPTION				: BTMS 직원 기본정보 수정
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-28		김성호			최초생성
   2016-02-03		김성호			임시테이블 -> 테이블변수로 수정
   2016-02-16		김성호			호텔 규정 지역정보 기준 항상 검색되도록 수정
   2016-03-31		이유라			비자 타입 비고 컬럼 추가
   2016-05-26		김성호			VISA_REMARK 비자 비고 삭제
   2016-08-01		이유라			ERP수정시 VGT담당자정보 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_EMPLOYEE_UPDATE]
	@AGT_CODE			VARCHAR(10),
	@EMP_SEQ			INT,
	@EMP_ID				VARCHAR(20),
	@KOR_NAME			VARCHAR(20),
	@LAST_NAME			VARCHAR(20),
	@FIRST_NAME			VARCHAR(30),
	@BIRTH_DATE			DATE,
	@GENDER				CHAR(1),
	@HP_NUMBER			VARCHAR(20),
	@COM_NUMBER			VARCHAR(20),
	@FAX_NUMBER			VARCHAR(20),
	@JOIN_DATE			DATETIME,
	@EMAIL				VARCHAR(50),
	@TEAM_SEQ			INT,
	@POS_SEQ			INT,
	@WORK_TYPE			INT,
	@SEAT_REMARK		VARCHAR(100),
	@AIR_REMARK			VARCHAR(100),
	@HOTEL_REMARK		VARCHAR(100),
	@MANAGER_YN			CHAR(1),
	@MAIL_RECEIVE_YN	CHAR(1),
	@NEW_SEQ			INT,
	@VGL_CODE			VARCHAR(8),

	@PASS_INFO			XML,
	@VISA_INFO			XML,
	@MILEIGE_INFO		XML
AS 
BEGIN

	DECLARE @MAX_SEQ INT

	UPDATE COM_EMPLOYEE SET EMP_ID = @EMP_ID, KOR_NAME = @KOR_NAME, LAST_NAME = @LAST_NAME, FIRST_NAME = @FIRST_NAME, BIRTH_DATE = @BIRTH_DATE, GENDER = @GENDER
		, HP_NUMBER = @HP_NUMBER, COM_NUMBER = @COM_NUMBER, FAX_NUMBER = @FAX_NUMBER, JOIN_DATE = @JOIN_DATE, EMAIL = @EMAIL, MANAGER_YN = @MANAGER_YN, MAIL_RECEIVE_YN = @MAIL_RECEIVE_YN
		, TEAM_SEQ = @TEAM_SEQ, POS_SEQ = @POS_SEQ, WORK_TYPE = @WORK_TYPE, SEAT_REMARK = @SEAT_REMARK, AIR_REMARK = @AIR_REMARK, HOTEL_REMARK = @HOTEL_REMARK
		, EDT_DATE = CASE WHEN @VGL_CODE IS NOT NULL THEN EDT_DATE ELSE GETDATE() END
		, EDT_SEQ = CASE WHEN @VGL_CODE IS NOT NULL THEN EDT_SEQ ELSE @NEW_SEQ END
		, VGL_CODE = CASE WHEN @VGL_CODE IS NOT NULL THEN  @VGL_CODE ELSE VGL_CODE END
		, VGL_DATE = CASE WHEN @VGL_CODE IS NOT NULL THEN GETDATE() ELSE VGL_DATE END
	WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ = @EMP_SEQ;

	-- 여권
	DECLARE @TEMP_EMP_PASS TABLE (
		RowNumber			INT,
		PassportSeq			INT,
		NationCode			VARCHAR(2),
		PassportBirthDate	DATE,
		PassportNumber		VARCHAR(20),
		PassportIssue		DATE,
		PassportExpire		DATE
	)
	INSERT INTO @TEMP_EMP_PASS (RowNumber, PassportSeq, NationCode, PassportBirthDate, PassportNumber, PassportIssue, PassportExpire)
	SELECT
		ROW_NUMBER() OVER (ORDER BY t1.col.value('./PassportSeq[1]', 'int')) AS [RowNumber]
		, t1.col.value('./PassportSeq[1]', 'int') as [PassportSeq]
		, t1.col.value('./NationCode[1]', 'varchar(2)') as [NationCode]
		, t1.col.value('./PassportBirthDate[1]', 'date') as [PassportBirthDate]
		, t1.col.value('./PassportNumber[1]', 'varchar(20)') as [PassportNumber]
		, t1.col.value('./PassportIssue[1]', 'date') as [PassportIssue]
		, t1.col.value('./PassportExpire[1]', 'date') as [PassportExpire]
	FROM @PASS_INFO.nodes('/ArrayOfEmployeePassportRQ/EmployeePassportRQ') as t1(col)
	-- 삭제
	UPDATE A SET A.USE_YN = 'N', A.EDT_DATE = GETDATE(), A.EDT_SEQ = @NEW_SEQ
	FROM COM_EMP_PASSPORT A
	WHERE A.AGT_CODE = @AGT_CODE AND A.EMP_SEQ = @EMP_SEQ AND PASS_SEQ NOT IN (SELECT PassportSeq FROM @TEMP_EMP_PASS);
	-- 수정
	UPDATE A SET A.NATION_CODE = B.NationCode, A.PASS_BIRTHDATE = B.PassportBirthDate, A.PASS_NUM = B.PassportNumber, A.PASS_ISSUE = B.PassportIssue
		, A.PASS_EXPIRE = B.PassportExpire, A.EDT_DATE = GETDATE(), A.EDT_SEQ = @NEW_SEQ
	FROM COM_EMP_PASSPORT A
	INNER JOIN @TEMP_EMP_PASS B ON A.AGT_CODE = @AGT_CODE AND A.EMP_SEQ = @EMP_SEQ AND A.PASS_SEQ = B.PassportSeq
	-- 등록
	SELECT @MAX_SEQ = ISNULL((SELECT MAX(A.PASS_SEQ) FROM COM_EMP_PASSPORT A WITH(NOLOCK) WHERE A.AGT_CODE = @AGT_CODE AND A.EMP_SEQ = @EMP_SEQ), 0)

	INSERT INTO COM_EMP_PASSPORT (AGT_CODE, EMP_SEQ, PASS_SEQ, NATION_CODE, PASS_BIRTHDATE, PASS_NUM, PASS_ISSUE, PASS_EXPIRE, USE_YN, NEW_DATE, NEW_SEQ)
	SELECT @AGT_CODE, @EMP_SEQ, (@MAX_SEQ + A.RowNumber), A.NationCode, A.PassportBirthDate, A.PassportNumber, A.PassportIssue, A.PassportExpire, 'Y', GETDATE(), @NEW_SEQ
	FROM @TEMP_EMP_PASS A
	WHERE A.PassportSeq = 0

	-- 비자
	DECLARE @TEMP_EMP_VISA TABLE (
		RowNumber		INT,
		VisaSeq			INT,
		NationCode		VARCHAR(2),
		VisaType		INT,
		VisaNumber		VARCHAR(20),
		VisaIssue		DATE,
		VisaExpire		DATE
	)
	INSERT INTO @TEMP_EMP_VISA (RowNumber, VisaSeq, NationCode, VisaType, VisaNumber, VisaIssue, VisaExpire)
	SELECT
		ROW_NUMBER() OVER (ORDER BY t1.col.value('./VisaSeq[1]', 'int')) AS [RowNumber]
		, t1.col.value('./VisaSeq[1]', 'int') as [VisaSeq]
		, t1.col.value('./NationCode[1]', 'varchar(2)') as [NationCode]
		, t1.col.value('./VisaType[1]', 'int') as [VisaType]
		, t1.col.value('./VisaNumber[1]', 'varchar(20)') as [VisaNumber]
		, t1.col.value('./VisaIssue[1]', 'date') as [VisaIssue]
		, t1.col.value('./VisaExpire[1]', 'date') as [VisaExpire]
	FROM @VISA_INFO.nodes('/ArrayOfEmployeeVisaRQ/EmployeeVisaRQ') as t1(col)

	-- 삭제
	UPDATE A SET A.USE_YN = 'N', A.EDT_DATE = GETDATE(), A.EDT_SEQ = @NEW_SEQ
	FROM COM_EMP_VISA A
	WHERE A.AGT_CODE = @AGT_CODE AND A.EMP_SEQ = @EMP_SEQ AND VISA_SEQ NOT IN (SELECT VisaSeq FROM @TEMP_EMP_VISA);
	-- 수정
	UPDATE A SET A.NATION_CODE = B.NationCode, A.VISA_TYPE = B.VisaType, A.VISA_NUM = B.VisaNumber, A.VISA_ISSUE = B.VisaIssue
		, A.VISA_EXPIRE = B.VisaExpire, A.EDT_DATE = GETDATE(), A.EDT_SEQ = @NEW_SEQ
	FROM COM_EMP_VISA A
	INNER JOIN @TEMP_EMP_VISA B ON A.AGT_CODE = @AGT_CODE AND A.EMP_SEQ = @EMP_SEQ AND A.VISA_SEQ = B.VisaSeq
	-- 등록
	SELECT @MAX_SEQ = ISNULL((SELECT MAX(A.VISA_SEQ) FROM COM_EMP_VISA A WITH(NOLOCK) WHERE A.AGT_CODE = @AGT_CODE AND A.EMP_SEQ = @EMP_SEQ), 0)

	INSERT INTO COM_EMP_VISA (AGT_CODE, EMP_SEQ, VISA_SEQ, NATION_CODE, VISA_TYPE, VISA_NUM, VISA_ISSUE, VISA_EXPIRE, USE_YN, NEW_DATE, NEW_SEQ)
	SELECT @AGT_CODE, @EMP_SEQ, (@MAX_SEQ + A.RowNumber), A.NationCode, A.VisaType, A.VisaNumber, A.VisaIssue, A.VisaExpire, 'Y', GETDATE(), @NEW_SEQ
	FROM @TEMP_EMP_VISA A
	WHERE A.VisaSeq = 0

	-- 마일리지
	DECLARE @TEMP_EMP_MILEIGE TABLE (
		RowNumber		INT,
		MileigeSeq		INT,
		MileageProType	INT,
		MileageCode		VARCHAR(20),
		MileageNumber	VARCHAR(20)
	)
	INSERT INTO @TEMP_EMP_MILEIGE (RowNumber, MileigeSeq, MileageProType, MileageCode, MileageNumber)
	SELECT
		ROW_NUMBER() OVER (ORDER BY t1.col.value('./MileageSeq[1]', 'int')) AS [RowNumber]
		, t1.col.value('./MileageSeq[1]', 'int') as [MileigeSeq]
		, t1.col.value('./MileageProType[1]', 'int') as [MileageProType]
		, t1.col.value('./MileageCode[1]', 'varchar(20)') as [MileageCode]
		, t1.col.value('./MileageNumber[1]', 'varchar(20)') as [MileageNumber]
	FROM @MILEIGE_INFO.nodes('/ArrayOfEmployeeMileageRQ/EmployeeMileageRQ') as t1(col)
	-- 삭제
	DELETE FROM COM_EMP_MILEAGE
	WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ = @EMP_SEQ AND MIL_SEQ NOT IN (SELECT MileigeSeq FROM @TEMP_EMP_MILEIGE)
	-- 수정
	UPDATE A SET A.MIL_CODE = B.MileageCode, A.MIL_NUM = B.MileageNumber
	FROM COM_EMP_MILEAGE A
	INNER JOIN @TEMP_EMP_MILEIGE B ON A.AGT_CODE = @AGT_CODE AND A.EMP_SEQ = @EMP_SEQ AND A.MIL_SEQ = B.MileigeSeq
	-- 등록
	SELECT @MAX_SEQ = ISNULL((SELECT MAX(A.MIL_SEQ) FROM COM_EMP_MILEAGE A WITH(NOLOCK) WHERE A.AGT_CODE = @AGT_CODE AND A.EMP_SEQ = @EMP_SEQ), 0)

	INSERT INTO COM_EMP_MILEAGE (AGT_CODE, EMP_SEQ, MIL_SEQ, MIL_PRO_TYPE, MIL_CODE, MIL_NUM)
	SELECT @AGT_CODE, @EMP_SEQ, (@MAX_SEQ + A.RowNumber), A.MileageProType, A.MileageCode, A.MileageNumber
	FROM @TEMP_EMP_MILEIGE A
	WHERE A.MileigeSeq = 0

END 


GO
