USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_DOC_EXPENSE_RCV_LIST_UPDATE
■ DESCRIPTION				: 전자결재 미처리문서 일괄 처리
■ INPUT PARAMETER			: 
	@EDI_CODE_LIST			: 전자결재 문서코드 (ex 1501076726,1412052437,1411052196)
	@EDI_STATUS				: 전자결재 문서 상태 값 (1: 진행, 2: 취소, 3: 완료)
	@RCV_CODE				: 처리자 사원코드
	@RCV_DATE				: 처리 일시
	@PAY_TYPE				: 환불 계정 구분 (0: 은행, 3: PG신용카드, 13: ARS)
	@PAY_SUB_TYPE			: 거래처코드|X (은행: X 계좌순번, PG신용카드 X 수수료)

■ EXEC						: 

	exec dbo.SP_DOC_EXPENSE_RCV_LIST_UPDATE '', '', '', null, '', '', ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2008-05-06		김성호			최초생성
   2015-02-05		김성호			환불지결 자동 등록을 위해 수정
   2015-04-28		김성호			문서코드가 1개일때 생성 PAY_SEQ 리턴
   2016-10-13		김성호			MAIL_ID 수동 입력
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_DOC_EXPENSE_RCV_LIST_UPDATE]
	@EDI_CODE_LIST	VARCHAR(8000),
	@EDI_STATUS		CHAR(1),
	@RCV_CODE		CHAR(7),
	@RCV_DATE		DATETIME,
	@PAY_TYPE		VARCHAR(5),
	@PAY_SUB_TYPE	VARCHAR(20),
	@MAIL_ID		VARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @EMP_LIST VARCHAR(1000);

	SET @SQLSTRING = N'
	UPDATE EDI_MASTER_DAMO SET
		EDI_STATUS = @EDI_STATUS,	RCV_CODE = @RCV_CODE,	RCV_YN = ''Y'',
		RCV_REMARK = ''일괄처리'',	RCV_DATE = @RCV_DATE
	WHERE EDI_CODE IN (SELECT Data FROM FN_SPLIT(@EDI_CODE_LIST, '',''));

	-- 작성자 추출
	SELECT @EMP_LIST = STUFF(
		(SELECT '','' + A.NEW_CODE AS [text()] FROM EDI_MASTER_DAMO A WITH(NOLOCK) WHERE A.EDI_CODE IN (SELECT Data FROM FN_SPLIT(@EDI_CODE_LIST, '','')) FOR XML PATH('''')),
		1, 1, ''''
	)
	-- 사내메일 발송
	EXEC dbo.SP_NOTE_INSERT @EMP_LIST, 0, '''', '''', ''[문서]가 일괄처리되었습니다.'', ''[문서]가 일괄처리되었습니다'', @RCV_CODE

	-- 환불계정 코드가 존재하면 환불 등록을 한다.
	IF @PAY_TYPE <> ''''
	BEGIN
		DECLARE @PAY_SEQ INT, @MCH_SEQ INT

		EXEC dbo.SP_DOC_REFUND_LIST_INSERT @EDI_CODE_LIST, @RCV_CODE, @RCV_DATE, @PAY_TYPE, @PAY_SUB_TYPE, @MAIL_ID, @PAY_SEQ OUTPUT, @MCH_SEQ OUTPUT
	END';

	SET @PARMDEFINITION = N'
		@EDI_CODE_LIST	VARCHAR(8000),
		@EDI_STATUS		CHAR(1),
		@RCV_CODE		CHAR(7),
		@RCV_DATE		DATETIME,
		@EMP_LIST		VARCHAR(1000),
		@PAY_TYPE		VARCHAR(5),
		@PAY_SUB_TYPE	VARCHAR(20),
		@MAIL_ID		VARCHAR(8)';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@EDI_CODE_LIST,
		@EDI_STATUS,
		@RCV_CODE,
		@RCV_DATE,
		@EMP_LIST,
		@PAY_TYPE,
		@PAY_SUB_TYPE,
		@MAIL_ID;

	--DECLARE @QUERY VARCHAR(8000)--, @EMP_LIST VARCHAR(100)

	--SET @QUERY = '
	--UPDATE EDI_MASTER_DAMO SET
	--	EDI_STATUS = ''' + @EDI_STATUS + ''',	RCV_CODE = ''' + @RCV_CODE + ''',	RCV_YN = ''Y'',
	--	RCV_REMARK = ''일괄처리'',	RCV_DATE = ''' + CONVERT(VARCHAR(50), @RCV_DATE, 120) + '''
	--WHERE EDI_CODE IN (' + @EDI_CODE_LIST + ')'

	--EXEC (@QUERY)
	----PRINT (@QUERY)

	--set @QUERY = '
	--DECLARE @EMP_LIST VARCHAR(100)
	--SELECT @EMP_LIST = STUFF((SELECT '','' + NEW_CODE AS [text()] 
	--FROM EDI_MASTER_DAMO WHERE EDI_CODE IN (' + @EDI_CODE_LIST + ') FOR XML PATH('''') ), 1, 1, '''')

	--EXEC SP_NOTE_INSERT @EMP_LIST, 0, '''', '''', ''[문서]가 일괄처리되었습니다.'', ''[문서]가 일괄처리되었습니다'', ''' + @RCV_CODE + ''''

	--EXEC (@QUERY)

END
GO
