USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_SMS_MESSAGE_INSERT
■ DESCRIPTION				: SMS/LMS 발송 메세지 등록
■ INPUT PARAMETER			: 

	EXEC SEND.DBO.XP_SMS_MESSAGE_INSERT @TRAN_PHONE = '01032536841', @TRAN_CALLBACK = '0221884683'
		, @TRAN_MSG = '안녕하세요. 참좋은여행입니다. IT개발팀 김성호입니다. LMS 발송 테스트 문자입니다.!', @MMS_SUBJECT = '테스트 문자111'
		, @CUS_NO = 15, @REQ_DEPT_ID = '529', @REQ_USER_ID = '2008011'


	-- 문자정보
	SELECT * FROM SEND.dbo.em_LOG A WITH(NOLOCK) WHERE A.TRAN_PR = 580
	-- LMS 추가정보
	SELECT B.* 
	FROM SEND.dbo.em_LOG A WITH(NOLOCK)
	INNER JOIN SEND.dbo.EM_TRAN_MMS B WITH(NOLOCK) ON A.TRAN_ETC4 = B.MMS_SEQ
	WHERE A.TRAN_PR = 580


■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-06-12		김성호			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_SMS_MESSAGE_INSERT_TEST]
	@TRAN_PHONE		VARCHAR(15),		-- [수신자휴대폰번호] : 숫자만 입력 예) 01023456789
	@TRAN_CALLBACK	VARCHAR(15),		-- [사전등록된 발신자 전화번호]
	@TRAN_MSG		VARCHAR(255),		-- [발송메세지]
	@MMS_SUBJECT	VARCHAR(40),		-- [메세지제목]
	@REQ_DEPT_ID	VARCHAR(100),		-- [팀코드]
	@REQ_USER_ID	VARCHAR(100),		-- [발송자사번]
	@RES_CODE		VARCHAR(12) = NULL,	-- [예약코드]
	@CUS_NO			INT	= NULL,			-- [고객코드]
	@CUS_NAME		VARCHAR(20) = NULL, -- [고객명]
	@AGT_CODE		VARCHAR(10) = NULL, -- [업체코드]
	@EMP_SEQ		INT = NULL			-- [업체직원코드]
AS
BEGIN

	DECLARE
		@TRAN_PR		INT,
		@TRAN_STATUS	CHAR(1) = '1',			-- [전송상태] : [1: 발송대기, 2: 발송결과수신대기, 3: 발송결과수신완료]
		@TRAN_DATE		DATETIME = GETDATE(),	-- [발송요청일시]
		@TRAN_ETC3		VARCHAR(16) = 'sms',	-- [전송유형상세구분] : [소문자로 입력 : sms, lms, mms]
		@TRAN_ETC4		INT = NULL,				-- [LMS/MMS 발송 시 EM_TRAN_MMS 테이블의 MMS_SEQ 컬럼 값]
		@TRAN_TYPE		INT,					-- [4: SMS 전송, 6: LMS/MMS 전송]
		@SERVICE_NO		INT						-- [서비스번호] : [1:고객사SMS, 2:고객사LMS]

	
	IF DATALENGTH(@TRAN_MSG) <= 80				-- SMS
	BEGIN
		SELECT @TRAN_ETC3 = 'sms', @TRAN_TYPE = 4, @SERVICE_NO = 1
	END
	ELSE IF DATALENGTH(@TRAN_MSG) > 80			-- LMS
	BEGIN
		SELECT @TRAN_ETC4 = NEXT VALUE FOR SEND.dbo.EM_TRAN_MMS_SEQ

		INSERT INTO SEND.dbo.EM_TRAN_MMS (mms_seq, file_cnt, mms_body, mms_subject)
		VALUES (@TRAN_ETC4, 0, @TRAN_MSG, @MMS_SUBJECT)

		SELECT @TRAN_ETC3 = 'lms', @TRAN_TYPE = 6, @SERVICE_NO = 2
	END
	
	-- 메세지 본문 등록
	INSERT INTO SEND.dbo.em_tran (tran_phone, tran_callback, tran_status, tran_date, tran_msg, tran_type, tran_etc3, tran_etc4, SERVICE_NO, REQ_DEPT_ID, REQ_USER_ID)
	--INSERT INTO SEND.dbo.em_tran (tran_phone, tran_callback, tran_status, tran_date, tran_msg, tran_type, tran_etc3, SERVICE_NO, REQ_DEPT_ID, REQ_USER_ID)
	VALUES (
		@TRAN_PHONE,		-- [수신자휴대폰번호] : 숫자만 입력 예) 01023456789
		@TRAN_CALLBACK,		-- [사전등록된 발신자 전화번호]
		@TRAN_STATUS,		-- [전송상태] : [1: 발송대기, 2: 발송결과수신대기, 3: 발송결과수신완료]
		@TRAN_DATE,			-- [발송요청일시]
		@TRAN_MSG,			-- [발송메세지]
		@TRAN_TYPE,			-- [4: SMS 전송, 6: LMS/MMS 전송]
		@TRAN_ETC3,			-- [전송유형상세구분] : [소문자로 입력 : sms, lms, mms]
		@TRAN_ETC4,			-- [LMS/MMS 발송 시 EM_TRAN_MMS 테이블의 MMS_SEQ 컬럼 값]
		@SERVICE_NO,			-- [서비스번호] : [1:고객사SMS, 2:고객사LMS]
		@REQ_DEPT_ID,
		@REQ_USER_ID
	);

	SET @TRAN_PR = @@IDENTITY
	
	IF @TRAN_PR > 0
	BEGIN
		-- 메세지 마스터 등록
		INSERT INTO SEND.dbo.SMS_SEND_MASTER (TRAN_PR, RES_CODE, CUS_NO, CUS_NAME, AGT_CODE, EMP_SEQ, NEW_DATE)
		VALUES (@TRAN_PR, @RES_CODE, @CUS_NO, @CUS_NAME, @AGT_CODE, @EMP_SEQ, @TRAN_DATE)
	END

	SELECT @TRAN_PR
 
END

/*

--DROP TABLE SEND.dbo.SMS_SEND_MASTER

CREATE TABLE SEND.dbo.SMS_SEND_MASTER
(
	TRAN_PR		INT NOT NULL,
    RES_CODE	VARCHAR(12) NULL,
    CUS_NO		INT NULL,
	CUS_NAME	VARCHAR(20),
	AGT_CODE	VARCHAR(10),
	EMP_SEQ		INT,
	NEW_DATE	DATETIME
);

CREATE TABLE dbo.ALT_RESULT_MESSAGE
(
	RST_TYPE	CHAR(1) NOT NULL,
	RST_CODE	VARCHAR(5) NOT NULL,
	RST_TITLE	VARCHAR(100) NULL,
	RST_INFO	VARCHAR(4000) NULL
);


SELECT * FROM ALT_RESULT_MESSAGE


*/
GO
