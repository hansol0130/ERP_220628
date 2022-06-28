USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PRI_NOTE_LIST_SELECT
■ DESCRIPTION				: 대외업무시스템 사내메일 검색
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@KEY		VARCHAR(400): 검색 키
	@ORDER_BY	INT			: 정렬 순서
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 메일 수       
■ EXEC						: 
	DECLARE @PAGE_INDEX INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT, 
	@KEY		VARCHAR(400),
	@ORDER_BY	INT

	SELECT @PAGE_INDEX=1,@PAGE_SIZE=30,@KEY=N'EmpCode=A130001&ListType=2&SearchType=2&SearchText=이',@ORDER_BY=1

	exec XP_PRI_NOTE_LIST_SELECT @page_index, @page_size, @total_count output, @key, @order_by
	SELECT @TOTAL_COUNT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-02-19		김성호			최초생성
   2013-06-10		김성호			WITH(NOLOCK) 추가
   2021-06-16		오준혁			튜닝
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_PRI_NOTE_LIST_SELECT]
(
	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY		VARCHAR(400),
	@ORDER_BY	INT
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @INNER_TABLE NVARCHAR(1000), @WHERE NVARCHAR(4000), @SORT_STRING VARCHAR(100);

	DECLARE
		@EMP_CODE	CHAR(7),
		@LIST_TYPE	CHAR(1),		-- 1: 받은메일함, 2: 보낸메일함
		@SEARCH_TYPE   CHAR(1),		-- 1: 작성자, 2: 수신자, 3: 제목, 4: 내용
		@SEARCH_TEXT VARCHAR(100),	-- 검색어
		@JUSUK	VARCHAR(2),
		@SUB	VARCHAR(100)

	SELECT
		@EMP_CODE = DBO.FN_PARAM(@KEY, 'EmpCode'),
		@LIST_TYPE = DBO.FN_PARAM(@KEY, 'ListType'),
		@SEARCH_TYPE = DBO.FN_PARAM(@KEY, 'SearchType'), 
		@SEARCH_TEXT = DBO.FN_PARAM(@KEY, 'SearchText'),
		@INNER_TABLE = '',
		@JUSUK = '',
		@SUB = ''


	-- WHERE 조건 만들기
	IF @LIST_TYPE = '1'
	BEGIN
		SET @INNER_TABLE = 'INNER JOIN PRI_NOTE_RECEIPT B WITH(NOLOCK) ON A.NOTE_SEQ_NO = B.NOTE_SEQ_NO'
		SET @WHERE = 'WHERE B.EMP_CODE = @EMP_CODE AND B.RCV_DEL_YN = ''N'''
	END
	ELSE
	BEGIN
		--SET @JUSUK = '--'
		--SET @INNER_TABLE = ''
		--SET @WHERE = 'WHERE A.NEW_CODE = @EMP_CODE AND A.DEL_YN = ''N'''
		SET @INNER_TABLE = 'INNER JOIN PRI_NOTE_RECEIPT B WITH(NOLOCK) ON A.NOTE_SEQ_NO = B.NOTE_SEQ_NO'
		SET @SUB = ' AND Z.RCV_SEQ_NO = B.RCV_SEQ_NO'
		SET @WHERE = 'WHERE A.NEW_CODE = @EMP_CODE AND B.SEND_DEL_YN = ''N'' AND A.DEL_YN = ''N'''
	END

	IF ISNULL(@SEARCH_TEXT, '') <> ''
	BEGIN

		IF @SEARCH_TYPE = '1'		-- 작성자
			SET @WHERE = @WHERE + ' AND A.NEW_CODE IN (SELECT EMP_CODE FROM XN_GET_EMP_CODE_BY_NAME(@SEARCH_TEXT))'
		ELSE IF @SEARCH_TYPE = '2'	-- 수신자
			SET @WHERE = @WHERE + ' AND B.EMP_CODE IN (SELECT EMP_CODE FROM XN_GET_EMP_CODE_BY_NAME(@SEARCH_TEXT))'
		ELSE IF @SEARCH_TYPE = '3'	-- 제목
			SET @WHERE = @WHERE + ' AND A.SUBJECT LIKE ''%'' + @SEARCH_TEXT + ''%'''
		ELSE IF @SEARCH_TYPE = '4'	-- 내용
			SET @WHERE = @WHERE + ' AND A.CONTENTS LIKE ''%'' + @SEARCH_TEXT + ''%'''
	END

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = (  
		CASE @ORDER_BY  
			WHEN 1 THEN ('A.NOTE_SEQ_NO DESC' + @JUSUK + ', B.RCV_SEQ_NO')
		END
	)

	SET @SQLSTRING = N'

	SELECT
	(
		-- 읽지 않은 받은 메일
		SELECT COUNT(*) FROM PRI_NOTE_RECEIPT A WITH(NOLOCK)
		WHERE A.EMP_CODE = @EMP_CODE AND A.RCV_DEL_YN = ''N'' AND A.CONFIRM_YN = ''N''
	) AS [RECEIVE_NO_READ_COUNT], 
	(
		-- 읽히지 않은 보낸 메일
		SELECT COUNT(*) FROM PRI_NOTE_RECEIPT A WITH(NOLOCK)
		INNER LOOP JOIN PRI_NOTE B WITH(NOLOCK) ON A.NOTE_SEQ_NO = B.NOTE_SEQ_NO
		WHERE B.NEW_CODE = @EMP_CODE AND A.CONFIRM_YN = ''N'' AND B.DEL_YN = ''N''
	) AS [SEND_NO_READ_COUNT];

	SELECT @TOTAL_COUNT = COUNT(*)
	FROM PRI_NOTE A WITH(NOLOCK)
	' + @INNER_TABLE + '
	' + @WHERE + ';

	WITH LIST AS
	(
		SELECT A.NOTE_SEQ_NO' + @JUSUK + ', B.RCV_SEQ_NO
		FROM PRI_NOTE A WITH(NOLOCK)
		' + @INNER_TABLE + '
		' + @WHERE + '
		ORDER BY ' + @SORT_STRING + '
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
		ROWS ONLY
	)
	SELECT A.NOTE_SEQ_NO, A.SUBJECT, A.NEW_DATE, A.NEW_CODE
		, DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS [NEW_NAME]
		, DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS [NEW_TEAM_NAME]
		, DBO.XN_COM_GET_COM_TYPE(A.NEW_CODE) AS [NEW_COM_TYPE]
		, (CASE WHEN EXISTS(SELECT 1 FROM PRI_NOTE_ATTACH AA WITH(NOLOCK) WHERE AA.NOTE_SEQ_NO = A.NOTE_SEQ_NO) THEN ''Y'' ELSE ''N'' END) AS [ATTACH_YN]

		' + @JUSUK + ', B.RCV_SEQ_NO, B.RCV_TYPE, B.CONFIRM_YN, B.CONFIRM_DATE, B.EMP_CODE
		' + @JUSUK + ', DBO.XN_COM_GET_EMP_NAME(B.EMP_CODE) AS [EMP_NAME]
		' + @JUSUK + ', DBO.XN_COM_GET_TEAM_NAME(B.EMP_CODE) AS [EMP_TEAM_NAME]
		' + @JUSUK + ', DBO.XN_COM_GET_COM_TYPE(B.EMP_CODE) AS [EMP_COM_TYPE]
	FROM LIST Z
	INNER LOOP JOIN PRI_NOTE A WITH(NOLOCK) ON A.NOTE_SEQ_NO = Z.NOTE_SEQ_NO
	' + @INNER_TABLE + @SUB + '
	' + @WHERE

	SET @PARMDEFINITION = N'@PAGE_INDEX  INT, @PAGE_SIZE  INT, @TOTAL_COUNT INT OUTPUT, @EMP_CODE CHAR(7), @SEARCH_TEXT VARCHAR(100)';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @PAGE_INDEX, @PAGE_SIZE, @TOTAL_COUNT OUTPUT, @EMP_CODE, @SEARCH_TEXT;

END


GO
