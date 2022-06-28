USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_BBS_AGT_TOURGUIDEBOARD_LIST_SELECT
■ DESCRIPTION				: 대외업무관리 인솔자게시판 리스트 검색
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@KEY		VARCHAR(400): 검색 키
	@ORDER_BY	INT			: 정렬 순서
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 리스트 수       
■ EXEC						: 
	DECLARE @PAGE_INDEX INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT, 
	@KEY		VARCHAR(400)

	SELECT @PAGE_INDEX=1,@PAGE_SIZE=10,@KEY=N'SearchType=1&SearchText=123'

	exec XP_BBS_AGT_TOURGUIDEBOARD_LIST_SELECT @page_index, @page_size, @key, @total_count output
	SELECT @TOTAL_COUNT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-12-31		이명훈			최초생성
================================================================================================================*/ 

CREATE PROC [dbo].[XP_BBS_AGT_TOURGUIDEBOARD_LIST_SELECT]
(
	@PAGE_INDEX  INT,
	@PAGE_SIZE	 INT,
	@KEY		 VARCHAR(400),
	@TOTAL_COUNT INT OUTPUT
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);
	
	DECLARE
		@MASTER_SEQ		INT,
		@SEARCH_TYPE	CHAR(1),		-- 1: 제목, 2: 제목+내용, 3: 작성자
		@SEARCH_TEXT	VARCHAR(100)	-- 검색어

	SELECT
		@MASTER_SEQ = DBO.FN_PARAM(@KEY, 'masterSeq'),
		@SEARCH_TYPE = DBO.FN_PARAM(@KEY, 'SearchType'), 
		@SEARCH_TEXT = DBO.FN_PARAM(@KEY, 'SearchText')

	SET @WHERE = 'WHERE MASTER_SEQ = @MASTER_SEQ AND DEL_YN = ''N'' AND NOTICE_YN = ''N'''

	IF ISNULL(@SEARCH_TEXT, '') <> ''
	BEGIN
		IF @SEARCH_TYPE = '1'		-- 제목
		BEGIN
			SET @WHERE = @WHERE + ' AND SUBJECT LIKE ''%'' + @SEARCH_TEXT + ''%'''
		END
		ELSE IF @SEARCH_TYPE = '2'		-- 제목+내용
		BEGIN
			SET @WHERE = @WHERE + ' AND ((SUBJECT LIKE ''%'' + @SEARCH_TEXT + ''%'') OR (CONTENTS LIKE ''%'' + @SEARCH_TEXT + ''%''))'
		END
		ELSE IF @SEARCH_TYPE = '3'		-- 작성자
		BEGIN
			SET @WHERE = @WHERE + ' AND NEW_NAME LIKE ''%'' + @SEARCH_TEXT + ''%'''
		END
	END
		
	SET @SQLSTRING = N'
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM BBS_DETAIL
	WHERE MASTER_SEQ = @MASTER_SEQ
		AND DEL_YN = ''N'';


	SELECT *
	FROM BBS_DETAIL
	WHERE MASTER_SEQ = @MASTER_SEQ
		AND NOTICE_YN = ''Y''
		AND DEL_YN = ''N''
	UNION ALL
	SELECT *
	FROM BBS_DETAIL
	' + @WHERE + '
	ORDER BY NOTICE_YN DESC, BBS_SEQ DESC
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY
	'

	SET @PARMDEFINITION = N'
		@PAGE_INDEX     INT,
		@PAGE_SIZE      INT,
		@MASTER_SEQ		INT,
		@SEARCH_TEXT	VARCHAR(100),
		@TOTAL_COUNT    INT OUTPUT';

	PRINT @SQLSTRING
		

	EXEC SP_EXECUTESQL @SQLSTRING,@PARMDEFINITION,
		@PAGE_INDEX,
		@PAGE_SIZE,
		@MASTER_SEQ,
		@SEARCH_TEXT,
		@TOTAL_COUNT OUTPUT;

END
GO
