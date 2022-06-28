USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_BBS_MASTER_LIST
■ DESCRIPTION				: 게시물 마스터 정보 리스트
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@KEY		VARCHAR(400): 검색 키
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 게시물 수       
■ EXEC						: 
	DECLARE @PAGE_INDEX INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT,
	@KEY VARCHAR(400)

	SELECT @PAGE_INDEX=1,@PAGE_SIZE=30

	exec SP_BBS_MASTER_LIST @page_index, @page_size, @total_count output, @key
	SELECT @TOTAL_COUNT

declare @p4 int
set @p4=342
exec SP_BBS_MASTER_LIST @PAGE_INDEX=1,@PAGE_SIZE=20,@KEY=N'SearchType=2&SearchText=테스트',@TOTAL_COUNT=@p4 output
select @p4
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-03-13		정지용			최초생성
   2021-06-01		홍종우			게시판 검색 시 내부 외부 선택 기능 추가
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[SP_BBS_MASTER_LIST]
(
	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY		VARCHAR(400)
)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000)
	DECLARE @PARMDEFINITION NVARCHAR(1000)
	DECLARE @WHERE NVARCHAR(4000)
	DECLARE @SEARCH_TEXT VARCHAR(100)
	DECLARE @SEARCH_TYPE VARCHAR(1)
	DECLARE @INANDOUT VARCHAR(1)

	SELECT
		@SEARCH_TYPE = DBO.FN_PARAM(@KEY, 'SEARCHTYPE'),
		@SEARCH_TEXT = DBO.FN_PARAM(@KEY, 'SEARCHTEXT'),
		@INANDOUT = DBO.FN_PARAM(@KEY, 'INANDOUT')
	PRINT @INANDOUT

	SET @WHERE  = 'WHERE 1=1'
	IF (@SEARCH_TYPE <> '' AND @SEARCH_TEXT <> '')
	BEGIN
		IF @SEARCH_TYPE = '1'
		BEGIN
			SET @WHERE = @WHERE + ' AND A.MASTER_SEQ = @SEARCH_TEXT';
		END
		ELSE IF @SEARCH_TYPE = '2'
		BEGIN
			SET @WHERE = @WHERE + ' AND A.MASTER_SUBJECT LIKE ''%'' + @SEARCH_TEXT + ''%'' '
		END
	END
	IF (@INANDOUT = 'O')
	BEGIN
		SET @WHERE = @WHERE + ' AND A.MASTER_SEQ > 1000'
	END
	ELSE
	BEGIN
		SET @WHERE = @WHERE + ' AND A.MASTER_SEQ <= 1000'
	END	
	
	PRINT @WHERE
	SET @SQLSTRING = N'SELECT @TOTAL_COUNT = COUNT(1) FROM BBS_MASTER A WITH(NOLOCK)' + @WHERE + N';
	
	WITH LIST AS
	(
		SELECT 
			*,
			(SELECT PUB_VALUE FROM COD_PUBLIC B WITH(NOLOCK) WHERE B.PUB_TYPE=''BOD.TYPE'' AND B.PUB_CODE= A.MASTER_SEQ) AS MENU_CODE
		FROM BBS_MASTER A WITH(NOLOCK)
		' + @WHERE + N'
		ORDER BY MASTER_SEQ DESC
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
		ROWS ONLY
	)
	SELECT 
		MASTER_SEQ, MASTER_TYPE, MASTER_ATTR, MASTER_SUBJECT, FILE_COUNT, FILE_MAXSIZE, NOTICE_YN, SHOW_COUNT, HISTORY_YN,
		COMMENT_YN, USE_YN, REALNAME_YN, CATEGORY_GROUP, LIST_SHOW_TYPE, ICON_YN, TEAM_CODE, SCOPE_YN, MANAGER_YN, MENU_CODE,
		NEW_CODE, NEW_DATE, EDT_CODE, EDT_DATE
	FROM LIST C 
	ORDER BY C.MASTER_SEQ DESC'

	--print @SQLSTRING

	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@KEY VARCHAR(400),
		@SEARCH_TEXT VARCHAR(100),
		@TOTAL_COUNT INT OUTPUT';

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
			@PAGE_INDEX,
			@PAGE_SIZE,
			@KEY, 
			@SEARCH_TEXT,
			@TOTAL_COUNT OUTPUT;
END
GO
