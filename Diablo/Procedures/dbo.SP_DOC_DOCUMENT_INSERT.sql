USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_DOC_DOCUMENT_INSERT
■ DESCRIPTION				: 전자결재 등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2008-04-26		김성호			최초생성
   2018-01-08		김성호			영업부 문서 작성 시 참고자 예외처리 (김우현 부본부장님)
   2018-01-18		김성호			참고자 예외처리 삭제 (영업부 재요청)
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_DOC_DOCUMENT_INSERT]
	@EDI_CODE		CHAR(10),
	@DOC_TYPE		VARCHAR(10),
	@DETAIL_TYPE	VARCHAR(10),
	@DETAIL_NAME	VARCHAR(20),
	@EDI_STATUS		CHAR(1),
	@REF_CODE		CHAR(10),
	@RCV_TEAM_CODE	CHAR(3),
	@APP_TYPE		CHAR(1),
	@SUBJECT		VARCHAR(100),
	@CONTENTS		NVARCHAR(MAX),
	@FILE1			VARCHAR(255),
	@FILE2			VARCHAR(255),
	@FILE3			VARCHAR(255),
	@OFF_DOCUMENT	VARCHAR(200),
	@JOIN_DATE		DATETIME,
	@OUT_DATE		DATETIME,
	@VAC_DAY		NUMERIC(18,1),
	@PRICE			DECIMAL(12),
	@REAL_PRICE		DECIMAL(12),
	@CURRENCY		CHAR(3),
	@EXC_RATE		NUMERIC(18,2),
	@PAY_BANK		VARCHAR(20),
	@PAY_ACCOUNT	VARCHAR(20),
	@PAY_RECEIPT	VARCHAR(20),
	@TERM_PAYMENT	SMALLDATETIME,
	@NEW_CODE		CHAR(7),
	@NEW_NAME		VARCHAR(20),
	@NEW_TEAM_NAME	VARCHAR(50),
	@NEW_DUTY_NAME	VARCHAR(20),
	@NEW_POS_NAME	VARCHAR(20),
	@PRO_CODE		VARCHAR(20),
	@MASTER_CODE	VARCHAR(10),
	@PRO_TYPE		INT,
	@RES_CODE		VARCHAR(12),
	@AGT_CODE		VARCHAR(10),
	@PAY_SEQ		INT,
	@FOLDER_TYPE	INT
AS
BEGIN
	SET NOCOUNT ON;
	
	/* 행사지결(8)이고 지상비지결(1) 공동경비지결(2) 이면서
	 행사코드가 NULL이 아니고 더존코드가 생성되어 있지 않으면 */
	IF @DOC_TYPE = '8' AND @DETAIL_TYPE IN ('1', '2') AND @PRO_CODE IS NOT NULL AND NOT EXISTS(SELECT 1 FROM ACC_MATCHING WHERE PRO_CODE = @PRO_CODE)
	BEGIN
		EXEC DBO.SP_ACC_GET_DUZ_CODE_BY_PRO @PRO_CODE
	END

	INSERT INTO EDI_MASTER_DAMO (
		EDI_CODE,		DOC_TYPE,		DETAIL_TYPE,	DETAIL_NAME,	EDI_STATUS,			REF_CODE,
		RCV_TEAM_CODE,	APP_TYPE,		[SUBJECT],		CONTENTS,		FILE1,				FILE2,
		FILE3,			OFF_DOCUMENT,	JOIN_DATE,		OUT_DATE,		VAC_DAY,			PRICE,
		REAL_PRICE,		CURRENCY,		EXC_RATE,		PAY_BANK,		PAY_RECEIPT,		TERM_PAYMENT,
		NEW_CODE,		NEW_NAME,		NEW_TEAM_NAME,	NEW_DUTY_NAME,	NEW_POS_NAME,		PRO_CODE,
		MASTER_CODE,	PRO_TYPE,		RES_CODE,		AGT_CODE,		PAY_SEQ,			FOLDER_TYPE,
		SEC_PAY_ACCOUNT
	) VALUES (
		@EDI_CODE,		@DOC_TYPE,		@DETAIL_TYPE,	@DETAIL_NAME,	@EDI_STATUS,		@REF_CODE,
		@RCV_TEAM_CODE,	@APP_TYPE,		@SUBJECT,		@CONTENTS,		@FILE1,				@FILE2,
		@FILE3,			@OFF_DOCUMENT,	@JOIN_DATE,		@OUT_DATE,		@VAC_DAY,			@PRICE,
		@REAL_PRICE,	@CURRENCY,		@EXC_RATE,		@PAY_BANK,		@PAY_RECEIPT,		@TERM_PAYMENT,
		@NEW_CODE,		@NEW_NAME,		@NEW_TEAM_NAME,	@NEW_DUTY_NAME,	@NEW_POS_NAME,		@PRO_CODE,
		@MASTER_CODE,	@PRO_TYPE,		@RES_CODE,		@AGT_CODE,		@PAY_SEQ,			@FOLDER_TYPE,
		damo.dbo.enc_varchar('DIABLO', 'dbo.EDI_MASTER', 'PAY_ACCOUNT', @PAY_ACCOUNT)
	)
		
	INSERT INTO EDI_RESERVE
	SELECT @EDI_CODE, ID, DATA FROM [DBO].[FN_SPLIT] (@RES_CODE, ',')

	-- 행사지결 X && 영업팀 작성 시 김우현 부본부장님 참고 등록 (2018.01.08)
	--IF @DOC_TYPE <> 8 AND EXISTS(SELECT 1 FROM EMP_MASTER_damo A WITH(NOLOCK) INNER JOIN EMP_TEAM B WITH(NOLOCK) ON A.TEAM_CODE = B.TEAM_CODE WHERE A.EMP_CODE = @NEW_CODE AND B.TEAM_TYPE = 1)
	--BEGIN
	--	EXEC SP_DOC_REFERENCE_INSERT @EDI_CODE, '2009002', '김우현', @NEW_CODE, @NEW_NAME
	--END


END
GO
