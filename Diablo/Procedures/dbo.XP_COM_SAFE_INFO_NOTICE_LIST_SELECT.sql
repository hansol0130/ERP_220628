USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_SAFE_INFO_NOTICE_LIST_SELECT
■ DESCRIPTION				: 게시물 검색
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@KEY		VARCHAR(400): 검색 키
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 게시물 수       
■ EXEC						: 

	DECLARE @PAGE_INDEX INT, @PAGE_SIZE  INT, @TOTAL_COUNT INT, @KEY VARCHAR(400)

	-- SearchType: 제목내용 = 1, 제목 = 2, 내용 = 3, 작성자 = 4
	SELECT @PAGE_INDEX=1,@PAGE_SIZE=30,@KEY=N'SearchType=1&SearchText=소아마비&NationCode=LAO'

	exec XP_COM_SAFE_INFO_NOTICE_LIST_SELECT @page_index, @page_size, @total_count output, @key
	SELECT @TOTAL_COUNT

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-25		저스트고이유라
   2016-02-11		김성호			순번 전체 게시물 기준으로 변경 및 SP 수정
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_COM_SAFE_INFO_NOTICE_LIST_SELECT]
(
	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY		VARCHAR(400)
)

AS  
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(4000)
	DECLARE @SEARCH_TYPE VARCHAR(1), @SEARCH_TEXT VARCHAR(100), @NATION_CODE VARCHAR(10);

	SELECT
		@SEARCH_TYPE = DBO.FN_PARAM(@KEY, 'SearchType'),
		@SEARCH_TEXT = DBO.FN_PARAM(@KEY, 'SearchText'),
		@NATION_CODE= DBO.FN_PARAM(@KEY, 'NationCode'),
		@WHERE = ' WHERE 1 = 1 '


	IF (@SEARCH_TYPE <> '' AND @SEARCH_TEXT <> '')
	BEGIN
		-- 제목내용 = 1, 제목 = 2, 내용 = 3, 국가코드 = 4
		SET @WHERE = @WHERE +  (
			CASE @SEARCH_TYPE
				WHEN '1' THEN ' AND (A.CONTENTS LIKE ''%'' + @SEARCH_TEXT + ''%'' OR A.TITLE LIKE ''%'' + @SEARCH_TEXT + ''%'') '
				WHEN '2' THEN ' AND A.TITLE LIKE ''%'' + @SEARCH_TEXT + ''%'' '
				WHEN '3' THEN ' AND A.CONTENTS LIKE ''%'' + @SEARCH_TEXT + ''%'' '
				ELSE ' AND A.TITLE LIKE ''%'' + @SEARCH_TEXT + ''%'' '
			END
		)
	END

	IF LEN(@NATION_CODE) > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND (A.NATION_CODE LIKE ''%'' + @NATION_CODE + ''%''   OR A.NATION_CODE IS NULL)  '
	END

	SET @SQLSTRING = N'
	-- 전체 게시물 수
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM SAFE_INFO_COUNTRY_NOTICE A WITH(NOLOCK)
	' + @WHERE + N';

	WITH LIST AS
	(
		SELECT A.ID
			, ROW_NUMBER() OVER (ORDER BY WRT_DT, ID) AS [ROWNUMBER]
		FROM SAFE_INFO_COUNTRY_NOTICE A WITH(NOLOCK)
		' + @WHERE + N'
		ORDER BY WRT_DT DESC, ID DESC
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
		ROWS ONLY
	)
	SELECT
		--RANK() OVER ( ORDER BY A.ID ASC ) as SORT, 
		Z.ROWNUMBER AS [SORT],
		A.ID,				A.NATION_CODE, 
		A.TITLE,			A.CONTENTS_HTML,	A.CONTENTS,			A.FILE_URL,			A.WRT_DT,
		A.NEW_DATE,	        A.SHOW_COUNT,		(SELECT D.KOR_NAME FROM PUB_REGION D WHERE C.REGION_CODE = D.REGION_CODE) AS REGION_NAME, 
		B.SAFE_KOR_NAME AS NATION_NAME
	FROM LIST Z
	INNER JOIN SAFE_INFO_COUNTRY_NOTICE A WITH(NOLOCK) ON Z.ID = A.ID	
	LEFT JOIN SAFE_INFO_NATION_CATEGORY_MAP B ON A.NATION_CODE = B.SAFE_NATION_CODE  LEFT JOIN PUB_NATION C ON B.NATION_CODE = C.NATION_CODE
	ORDER BY  WRT_DT DESC, ID DESC'

	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@SEARCH_TEXT VARCHAR(100),
		@NATION_CODE VARCHAR(10)';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@SEARCH_TEXT,
		@NATION_CODE;
END


GO
