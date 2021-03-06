USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ Server					: 
■ Database					: DIABLO
■ USP_Name					: XP_HBS_SEARCH_LIST
■ Description				: 홈페이지 게시판 검색.
■ Input Parameter			: 
		@PAGE_INDEX			: 페이지 번호
		@PAGE_SIZE			: 페이지 사이즈
		@MASTER_SEQ			: 마스터 순번
		@CATEGORY_SEQ		: 카테고리 순번
		@MASTER_CODE		: 상품 마스터코드
		@REGION_NAME		: 지역명
		@FILTER_TYPE		: 검색구분 (1: 제목내용, 2: 제목, 3: 내용, 4: 작성자)
		@SEARCH_TEXT		: 검색어
		@NEW_CODE			: 작성자코드
		@BOARD_TYPE			: 보드종류
		@DEL_YN				: 삭제유무 (삭제 시 Y)
■ Output Parameter			:                  
		@TOTAL_COUNT		: 전체 게시물 수
■ Output Value				: 조건에 맞는 게시물 결과
■ Exec						: 

DECLARE @TOTAL_COUNT INT
EXEC SP_WEB_SEARCH_LIST_TEST @PAGE_INDEX=10, @PAGE_SIZE=15, @MASTER_SEQ=1, @CATEGORY_SEQ='', @MASTER_CODE='', @REGION_NAME='', @FILTER_TYPE=1, @SEARCH_TEXT='참좋은', @NEW_CODE='', @BOARD_TYPE=1, @DEL_YN='N', @TOTAL_COUNT=@TOTAL_COUNT OUTPUT
SELECT @TOTAL_COUNT

■ Author					: 김성호
■ Date						: 2012-12-26
■ Memo						: 
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
	Date			Author			Description           
------------------------------------------------------------------------------------------------------------------
	2012-12-26		김성호			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_HBS_SEARCH_LIST]
	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY	varchar(200),
	@order_by	int
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);
	declare @MASTER_SEQ INT,
	@CATEGORY_SEQ INT,
	@MASTER_CODE VARCHAR(10),
	@REGION_NAME VARCHAR(20),
	@FILTER_TYPE INT,
	@SEARCH_TEXT VARCHAR(100),
	@NEW_CODE INT,
	@BOARD_TYPE INT,
	@DEL_YN CHAR(1)

	select @MASTER_SEQ = dbo.FN_PARAM(@key, 'masterseq'), @CATEGORY_SEQ = dbo.fn_param(@key, 'categoryseq'), @REGION_NAME = dbo.fn_param(@key, 'regionname')


	--select dbo.FN_PARAM('aaa=bbb&ccc=ddd', 'ccc')

	SET @WHERE = ''

	IF @CATEGORY_SEQ > 0
		SET @WHERE = @WHERE + ' AND A.CATEGORY_SEQ = @CATEGORY_SEQ'

	IF ISNULL(@MASTER_CODE, '') <> ''
		SET @WHERE = @WHERE + ' AND A.MASTER_CODE = @MASTER_CODE'

	IF @NEW_CODE > 0
		SET @WHERE = @WHERE + ' AND A.NEW_CODE = @NEW_CODE'

	IF ISNULL(@REGION_NAME, '') <> ''
		SET @WHERE = @WHERE + ' AND A.REGION_NAME = @REGION_NAME'

	IF ISNULL(@DEL_YN, '') <> ''
		SET @WHERE = @WHERE + ' AND A.DEL_YN = @DEL_YN'

	IF ISNULL(@SEARCH_TEXT, '') <> ''
	BEGIN
		IF @FILTER_TYPE = 1		-- 제목내용
			SET @WHERE = @WHERE + ' AND (CONTAINS(A.CONTENTS, @SEARCH_TEXT) OR CONTAINS(A.SUBJECT, @SEARCH_TEXT))'
		IF @FILTER_TYPE = 2		-- 제목
			SET @WHERE = @WHERE + ' AND CONTAINS(A.SUBJECT, @SEARCH_TEXT)'
		IF @FILTER_TYPE = 3		-- 내용
			SET @WHERE = @WHERE + ' AND CONTAINS(A.CONTENTS, @SEARCH_TEXT)'
		IF @FILTER_TYPE = 4		-- 작성자
			SET @WHERE = @WHERE + ' AND (A.NEW_CODE IN (SELECT CUS_NO FROM CUS_CUSTOMER_DAMO AA WHERE AA.CUS_NAME LIKE @SEARCH_TEXT + ''%'') OR EMP_CODE IN (SELECT EMP_CODE FROM EMP_MASTER BB WHERE BB.KOR_NAME LIKE @SEARCH_TEXT + ''%''))'
		ELSE
			SET @WHERE = @WHERE + ' AND CONTAINS(A.SUBJECT, @SEARCH_TEXT)'
	END

	-- 페이징을 위한 게시물 총 갯수와 해당 인덱스의 리스트 각각 검색
	SET @SQLSTRING = N'

	SELECT @TOTAL_COUNT = COUNT(*)
	FROM HBS_DETAIL A
	WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.NOTICE_YN = ''N''
	' + @WHERE + ';

	PRINT @TOTAL_COUNT;

	WITH LIST AS
	(
		SELECT A.MASTER_SEQ, A.BOARD_SEQ
		FROM HBS_DETAIL A
		WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.NOTICE_YN = ''N''
		' + @WHERE + '
		ORDER BY A.PARENT_SEQ DESC, A.LEVEL ASC
		OFFSET (@PAGE_INDEX-1)*@PAGE_SIZE ROWS FETCH NEXT @PAGE_SIZE
		ROWS ONLY
	)
	SELECT *
	FROM LIST A
	INNER JOIN HBS_DETAIL B ON A.MASTER_SEQ = B.MASTER_SEQ AND A.BOARD_SEQ = B.BOARD_SEQ;
	'

	SET @PARMDEFINITION = N'
		@PAGE_INDEX  INT,
		@PAGE_SIZE  INT,
		@MASTER_SEQ INT,
		@CATEGORY_SEQ INT,
		@MASTER_CODE VARCHAR(10),
		@REGION_NAME VARCHAR(20),
		@FILTER_TYPE INT,
		@SEARCH_TEXT VARCHAR(100),
		@NEW_CODE INT,
		@BOARD_TYPE INT,
		@DEL_YN CHAR(1),
		@TOTAL_COUNT INT OUTPUT';  

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PAGE_INDEX,
		@PAGE_SIZE,
		@MASTER_SEQ,
		@CATEGORY_SEQ,
		@MASTER_CODE,
		@REGION_NAME,
		@FILTER_TYPE,
		@SEARCH_TEXT,
		@NEW_CODE,
		@BOARD_TYPE,
		@DEL_YN,
		@TOTAL_COUNT OUTPUT;
END

GO
