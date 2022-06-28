USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_DOC_PROCESS_LIST_SELECT
■ DESCRIPTION				: 처리문서 리스트 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.SP_DOC_PROCESS_LIST_SELECT '419', 0, 0, '', '2018-01-11', '2018-01-11', ''
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-01-11		김성호			최초생성 (SP 변환)
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_DOC_PROCESS_LIST_SELECT]
	@RCV_TEAM_CODE	CHAR(3), 
	@DOC_TYPE		INT, 
	@DETAIL_TYPE	INT, 
	@AGT_CODE		VARCHAR(10),
	@START_DATE		DATETIME,
	@END_DATE		DATETIME,
	@SLIP_TYPE		VARCHAR(1)	--(""=전체 ,"1"=미생성 ,"2"=생성 )
AS
BEGIN

	DECLARE
		@SQLSTRING		NVARCHAR(MAX), 
		@PARMDEFINITION	NVARCHAR(1000), 
		@WHERE			NVARCHAR(1000) = '',
		@WHERE_DATE		NVARCHAR(100) = '',
		@GROUP_CODE		NVARCHAR(50);

	-- 하위팀 조회 --------------------------------------------------------------------------------------------------------------
	SELECT @GROUP_CODE = ISNULL(STUFF((
		SELECT (', ' + TEAM_CODE) AS [text()]
		FROM EMP_GROUP_DETAIL A WITH(NOLOCK)
		WHERE A.GROUP_CODE IN (SELECT GROUP_CODE FROM EMP_GROUP_DETAIL AA WITH(NOLOCK) WHERE AA.TEAM_CODE = @RCV_TEAM_CODE)
		FOR XML PATH('')
		), 1, 2, ''), @RCV_TEAM_CODE);
	
	-- 개발팀 예외처리
	IF @RCV_TEAM_CODE = '529'
	BEGIN
		SET @GROUP_CODE = '521'
	END

	SET @END_DATE = DATEADD(D, 1, @END_DATE);
	----------------------------------------------------------------------------------------------------------------------------

	SET @WHERE = 'WHERE A.EDI_STATUS = ''3'' AND A.RCV_YN = ''Y'' AND A.RCV_TEAM_CODE IN (SELECT DATA FROM DBO.FN_SPLIT(@GROUP_CODE, '','')) AND A.RCV_DATE >= @START_DATE AND A.RCV_DATE < @END_DATE '

	IF @DOC_TYPE > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND A.DOC_TYPE = @DOC_TYPE '
	END

	IF @DETAIL_TYPE > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND A.DETAIL_TYPE = @DETAIL_TYPE '
	END

	IF LEN(@AGT_CODE) > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND A.AGT_CODE = @AGT_CODE '
	END

	IF @SLIP_TYPE = '1'
	BEGIN
		SET @WHERE = @WHERE + ' AND EXISTS ( SELECT P.EDI_CODE FROM ACC_PUM_SLIP P WITH(NOLOCK) WHERE P.EDI_CODE =  A.EDI_CODE ) '
	END
	ELSE IF @SLIP_TYPE = '2'
	BEGIN
		SET @WHERE = @WHERE + ' AND NOT EXISTS ( SELECT P.EDI_CODE FROM ACC_PUM_SLIP P WITH(NOLOCK) WHERE P.EDI_CODE =  A.EDI_CODE ) '
	END


	SET @SQLSTRING = '
	SELECT A.EDI_CODE, A.DOC_TYPE, A.DETAIL_TYPE, A.NEW_TEAM_NAME,  A.NEW_NAME, A.[SUBJECT], A.PRICE, A.REAL_PRICE, A.PAY_BANK
		, damo.dbo.dec_varchar(''DIABLO'', ''dbo.EDI_MASTER'', ''PAY_ACCOUNT'', A.SEC_PAY_ACCOUNT) AS PAY_ACCOUNT
		, A.PAY_RECEIPT, A.TERM_PAYMENT, A.PRO_CODE, A.RCV_DATE, A.EDI_STATUS, Z.KOR_NAME AS [AGT_NAME]
		, (SELECT DEP_DATE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = A.PRO_CODE) AS [DEP_DATE]
		, (SELECT NEW_DATE FROM EDI_APPROVAL WITH(NOLOCK) WHERE EDI_CODE = A.EDI_CODE AND SEQ_NO = 1) AS [NEW_DATE]
		, STUFF((
			SELECT (''|'' + NEW_NAME + ''§'' + COMMENT) AS [text()] 
			FROM EDI_COMMENT WITH(NOLOCK) 
			WHERE EDI_CODE = A.EDI_CODE AND NEW_CODE IN (
				SELECT EMP_CODE 
				FROM EMP_MASTER WHERE 
				TEAM_CODE IN (SELECT DATA FROM DBO.FN_SPLIT(@GROUP_CODE, '',''))
			) FOR XML PATH('''') ), 1, 1, '''') AS [COMMENT_INFO]
	FROM EDI_MASTER_DAMO A WITH(NOLOCK)
	LEFT JOIN AGT_MASTER Z WITH(NOLOCK) ON A.AGT_CODE = Z.AGT_CODE
	' + @WHERE + '
	ORDER BY ISNULL(Z.KOR_NAME, ''zzz''), A.EDI_CODE'


	SET @PARMDEFINITION = N'
		@GROUP_CODE NVARCHAR(50),
		@DOC_TYPE INT,
		@DETAIL_TYPE INT,
		@AGT_CODE VARCHAR(10),
		@START_DATE DATETIME,
		@END_DATE DATETIME,
		@SLIP_TYPE VARCHAR(1)';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@GROUP_CODE,
		@DOC_TYPE,
		@DETAIL_TYPE,
		@AGT_CODE,
		@START_DATE,
		@END_DATE,
		@SLIP_TYPE;
	

END
GO
