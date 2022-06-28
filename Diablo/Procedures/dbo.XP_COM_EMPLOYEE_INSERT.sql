USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_EMPLOYEE_INSERT
■ DESCRIPTION				: BTMS 직원 기본정보 등록
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
   2016-02-18		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_EMPLOYEE_INSERT]
	@AGT_CODE			VARCHAR(10),
	@EMP_SEQ			INT,
	@EMP_ID				VARCHAR(20),
	@KOR_NAME			VARCHAR(20),
	@LAST_NAME			VARCHAR(20),
	@FIRST_NAME			VARCHAR(30),
	@BIRTH_DATE			DATE,
	@GENDER				CHAR(1),
	@PASSWORD			VARCHAR(100),
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

	@PASS_INFO			XML,
	@VISA_INFO			XML,
	@MILEIGE_INFO		XML
AS 
BEGIN

	SELECT @EMP_SEQ = (ISNULL((SELECT MAX(EMP_SEQ) FROM COM_EMPLOYEE A WITH(NOLOCK) WHERE A.AGT_CODE = @AGT_CODE), 0) + 1)

	INSERT INTO COM_EMPLOYEE (AGT_CODE, EMP_SEQ, TEAM_SEQ, EMP_ID, KOR_NAME, LAST_NAME, FIRST_NAME, BIRTH_DATE, GENDER, PASS_WORD, POS_SEQ, WORK_TYPE, JOIN_DATE, OUT_DATE
		, EMAIL, COM_NUMBER, HP_NUMBER, FAX_NUMBER, SEAT_REMARK, AIR_REMARK, HOTEL_REMARK, FAIL_COUNT, MANAGER_YN, MAIL_RECEIVE_YN, NEW_DATE, NEW_SEQ)
	SELECT @AGT_CODE, @EMP_SEQ, @TEAM_SEQ, @EMP_ID, @KOR_NAME, @LAST_NAME, @FIRST_NAME, @BIRTH_DATE, @GENDER, @PASSWORD, @POS_SEQ, @WORK_TYPE, @JOIN_DATE, NULL
		, @EMAIL, @COM_NUMBER, @HP_NUMBER, @FAX_NUMBER, @SEAT_REMARK, @AIR_REMARK, @HOTEL_REMARK, 0, @MANAGER_YN, @MAIL_RECEIVE_YN, GETDATE(), @NEW_SEQ

	-- 여권
	INSERT INTO COM_EMP_PASSPORT (AGT_CODE, EMP_SEQ, PASS_SEQ, NATION_CODE, PASS_BIRTHDATE, PASS_NUM, PASS_ISSUE, PASS_EXPIRE, USE_YN, NEW_DATE, NEW_SEQ)
	SELECT @AGT_CODE, @EMP_SEQ, A.RowNumber, A.NationCode, A.PassportBirthDate, A.PassportNumber, A.PassportIssue, A.PassportExpire, 'Y', GETDATE(), @NEW_SEQ
	FROM (
		SELECT
			ROW_NUMBER() OVER (ORDER BY t1.col.value('./PassportSeq[1]', 'int')) AS [RowNumber]
			, t1.col.value('./PassportSeq[1]', 'int') as [PassportSeq]
			, t1.col.value('./NationCode[1]', 'varchar(2)') as [NationCode]
			, t1.col.value('./PassportBirthDate[1]', 'date') as [PassportBirthDate]
			, t1.col.value('./PassportNumber[1]', 'varchar(20)') as [PassportNumber]
			, t1.col.value('./PassportIssue[1]', 'date') as [PassportIssue]
			, t1.col.value('./PassportExpire[1]', 'date') as [PassportExpire]
		FROM @PASS_INFO.nodes('/ArrayOfEmployeePassportRQ/EmployeePassportRQ') as t1(col)
	) A

	-- 비자
	INSERT INTO COM_EMP_VISA (AGT_CODE, EMP_SEQ, VISA_SEQ, NATION_CODE, VISA_TYPE, VISA_NUM, VISA_ISSUE, VISA_EXPIRE, USE_YN, NEW_DATE, NEW_SEQ)
	SELECT @AGT_CODE, @EMP_SEQ, A.RowNumber, A.NationCode, A.VisaType, A.VisaNumber, A.VisaIssue, A.VisaExpire, 'Y', GETDATE(), @NEW_SEQ
	FROM (
		SELECT
			ROW_NUMBER() OVER (ORDER BY t1.col.value('./VisaSeq[1]', 'int')) AS [RowNumber]
			, t1.col.value('./VisaSeq[1]', 'int') as [VisaSeq]
			, t1.col.value('./NationCode[1]', 'varchar(2)') as [NationCode]
			, t1.col.value('./VisaType[1]', 'int') as [VisaType]
			, t1.col.value('./VisaNumber[1]', 'varchar(20)') as [VisaNumber]
			, t1.col.value('./VisaIssue[1]', 'date') as [VisaIssue]
			, t1.col.value('./VisaExpire[1]', 'date') as [VisaExpire]
		FROM @VISA_INFO.nodes('/ArrayOfEmployeeVisaRQ/EmployeeVisaRQ') as t1(col)
	) A

	-- 마일리지
	INSERT INTO COM_EMP_MILEAGE (AGT_CODE, EMP_SEQ, MIL_SEQ, MIL_PRO_TYPE, MIL_CODE, MIL_NUM)
	SELECT @AGT_CODE, @EMP_SEQ, A.RowNumber, A.MileageProType, A.MileageCode, A.MileageNumber
	FROM (
		SELECT
			ROW_NUMBER() OVER (ORDER BY t1.col.value('./MileageSeq[1]', 'int')) AS [RowNumber]
			, t1.col.value('./MileageSeq[1]', 'int') as [MileigeSeq]
			, t1.col.value('./MileageProType[1]', 'int') as [MileageProType]
			, t1.col.value('./MileageCode[1]', 'varchar(20)') as [MileageCode]
			, t1.col.value('./MileageNumber[1]', 'varchar(20)') as [MileageNumber]
		FROM @MILEIGE_INFO.nodes('/ArrayOfEmployeeMileageRQ/EmployeeMileageRQ') as t1(col)
	) A

END 
GO
