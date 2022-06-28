USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_BBS_AGT_FREE_BOARD_LIST_SELECT
■ DESCRIPTION				: 대외업무관리 자유게시판 리스트 검색
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

	SELECT @PAGE_INDEX=1,@PAGE_SIZE=10,@KEY=N'MasterSeq=10000&EmpCode=A130001&ComType=&AgtCode=&SearchType=1&SearchText=&IsNotice=Y',@ORDER_BY=1

	exec XP_BBS_AGT_FREE_BOARD_LIST_SELECT @page_index, @page_size, @total_count output, @key, @order_by
	SELECT @TOTAL_COUNT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-02-25		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_BBS_AGT_FREE_BOARD_LIST_SELECT]
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
	DECLARE @WHERE NVARCHAR(4000), @NOTICE_WHERE NVARCHAR(1000), @SORT_STRING VARCHAR(100);

	DECLARE
		@MASTER_SEQ		INT,
		@EMP_CODE		CHAR(7),
		@AGT_CODE		VARCHAR(10),
		@COM_TYPE		INT,
		@SEARCH_TYPE	CHAR(1),		-- 1: 회사명, 2: 제목, 3: 제목+내용, 4: 작성자
		@SEARCH_TEXT	VARCHAR(100),	-- 검색어
		@NOTICE_YN		VARCHAR(1),
		@SIGN			CHAR(1)			-- 부등호

	SELECT
		@MASTER_SEQ = DBO.FN_PARAM(@KEY, 'MasterSeq'),
		@EMP_CODE = DBO.FN_PARAM(@KEY, 'EmpCode'),
		@AGT_CODE = DBO.FN_PARAM(@KEY, 'AgtCode'), 
		@COM_TYPE = DBO.FN_PARAM(@KEY, 'ComType'), 
		@SEARCH_TYPE = DBO.FN_PARAM(@KEY, 'SearchType'), 
		@SEARCH_TEXT = DBO.FN_PARAM(@KEY, 'SearchText'),
		@NOTICE_YN = DBO.FN_PARAM(@KEY, 'IsNotice'),
		@SIGN = '='

	IF @MASTER_SEQ = 10000
	BEGIN
		SET @SIGN = '>';
	END
	ELSE
	BEGIN
		SELECT @MASTER_SEQ = MASTER_SEQ FROM BBS_MASTER_AGT_LINK WHERE AGT_CODE IN (SELECT AGT_CODE FROM AGT_MEMBER WHERE MEM_CODE = @EMP_CODE)
	END
	
	-- WHERE 조건 만들기
	IF @NOTICE_YN = 'Y'
	BEGIN
		SET @NOTICE_WHERE = N'WHERE A.MASTER_SEQ ' + @SIGN + ' @MASTER_SEQ AND A.DEL_YN = ''N'' AND A.NOTICE_YN = ''Y''
			AND (
				DBO.XN_COM_GET_VGL_YN(@EMP_CODE) = ''Y'' OR
				EXISTS(SELECT 1 FROM BBS_DETAIL_VIEW AA WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BBS_SEQ = A.BBS_SEQ AND AA.COM_TYPE = DBO.XN_COM_GET_COM_TYPE(@EMP_CODE))
			)'

		SET @WHERE = 'WHERE A.MASTER_SEQ ' + @SIGN + ' @MASTER_SEQ AND A.DEL_YN = ''N'' AND A.NOTICE_YN = ''N''
			AND (
				DBO.XN_COM_GET_VGL_YN(@EMP_CODE) = ''Y'' OR
				EXISTS(SELECT 1 FROM BBS_DETAIL_VIEW AA WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BBS_SEQ = A.BBS_SEQ AND AA.COM_TYPE = DBO.XN_COM_GET_COM_TYPE(@EMP_CODE))
			)'
		SET @SORT_STRING = 'A.NOTICE_YN DESC, '
	END
	ELSE
	BEGIN
		SET @NOTICE_WHERE = N'WHERE 1 <> 1'
		SET @WHERE = 'WHERE A.MASTER_SEQ ' + @SIGN + ' @MASTER_SEQ AND A.DEL_YN = ''N''
			AND (
				DBO.XN_COM_GET_VGL_YN(@EMP_CODE) = ''Y'' OR
				EXISTS(SELECT 1 FROM BBS_DETAIL_VIEW AA WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BBS_SEQ = A.BBS_SEQ AND AA.COM_TYPE = DBO.XN_COM_GET_COM_TYPE(@EMP_CODE))
			)'
		SET @SORT_STRING = ''
	END

	IF ISNULL(@AGT_CODE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + N'
		 AND EXISTS(SELECT 1 FROM BBS_DETAIL_VIEW AA WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BBS_SEQ = A.BBS_SEQ AND AA.COM_TYPE IN (SELECT AGT_TYPE_CODE FROM AGT_MASTER BB WHERE BB.AGT_CODE = @AGT_CODE))'
	END
	ELSE IF ISNULL(@COM_TYPE, 0) <> 0
	BEGIN
		SET @WHERE = @WHERE + N'
		 AND EXISTS(SELECT 1 FROM BBS_DETAIL_VIEW AA WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BBS_SEQ = A.BBS_SEQ AND AA.COM_TYPE = @COM_TYPE)'
	END

	IF ISNULL(@SEARCH_TEXT, '') <> ''
	BEGIN
		IF @SEARCH_TYPE = '1'		-- 제목
		BEGIN
			SET @WHERE = @WHERE + ' AND A.SUBJECT LIKE ''%'' + @SEARCH_TEXT + ''%'''
		END
		ELSE IF @SEARCH_TYPE = '2'		-- 제목+내용
		BEGIN
			SET @WHERE = @WHERE + ' AND ((A.SUBJECT LIKE ''%'' + @SEARCH_TEXT + ''%'') OR (A.CONTENTS LIKE ''%'' + @SEARCH_TEXT + ''%''))'
		END
		ELSE IF @SEARCH_TYPE = '3'		-- 작성자
		BEGIN
			SET @WHERE = @WHERE + ' AND A.NEW_NAME LIKE ''%'' + @SEARCH_TEXT + ''%'''
		END
	END

	-- SORT 조건 만들기
	SELECT @SORT_STRING = @SORT_STRING + (  
		CASE @ORDER_BY  
			WHEN 1 THEN ' A.BBS_SEQ DESC'
		END
	)

	SET @SQLSTRING = N'
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM BBS_DETAIL A
	' + @WHERE + ';

	WITH LIST AS
	(
		SELECT A.NOTICE_YN, A.MASTER_SEQ, A.BBS_SEQ
		FROM BBS_DETAIL A
		' + @WHERE + '
		ORDER BY ' + @SORT_STRING + '
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
		ROWS ONLY
	)
	SELECT A.*
		, DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS [AGT_NAME]
		, DBO.XN_COM_GET_COM_TYPE(A.NEW_CODE) AS [COM_TYPE]
		, R.TEAM_NAME AS CATEGORY_GROUP_NAME
	FROM (
		SELECT * FROM LIST
		UNION ALL
		SELECT A.NOTICE_YN, A.MASTER_SEQ, A.BBS_SEQ
		FROM BBS_DETAIL A
		' + @NOTICE_WHERE + '
	) Z
	INNER JOIN BBS_DETAIL A ON A.MASTER_SEQ = Z.MASTER_SEQ AND A.BBS_SEQ = Z.BBS_SEQ
	 LEFT OUTER JOIN dbo.EMP_TEAM R  ON A.CATEGORY_GROUP = R.TEAM_CODE
	ORDER BY ' + @SORT_STRING + '
	'
		
	SET @PARMDEFINITION = N'
		@PAGE_INDEX  INT,
		@PAGE_SIZE  INT,
		@TOTAL_COUNT INT OUTPUT,
		@MASTER_SEQ		INT,
		@EMP_CODE		CHAR(7),
		@AGT_CODE		VARCHAR(10),
		@COM_TYPE		INT,
		@SEARCH_TEXT	VARCHAR(100)';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@MASTER_SEQ,
		@EMP_CODE,
		@AGT_CODE,
		@COM_TYPE,
		@SEARCH_TEXT;

END




GO