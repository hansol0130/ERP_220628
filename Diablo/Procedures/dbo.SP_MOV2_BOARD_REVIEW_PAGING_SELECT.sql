USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [[SP_MOV2_BOARD_PAGING_SELECT]]
■ DESCRIPTION				: VR 동영상 링크 정보 조회
■ INPUT PARAMETER			: @VR_NO@VR_NAME @VR_DESC @VR_CREATOR @nowPage	
■ EXEC						: 	
    -- [[SP_MOV2_BOARD_REVIEW_PAGING_SELECT]] 	 		

DECLARE @TOTAL_COUNT INT
EXEC SP_MOV2_BOARD_REVIEW_PAGING_SELECT 1, '', 0, NULL, 'N', 'N', 1, 200, NULL, NULL, NULL, @TOTAL_COUNT OUT
SELECT @TOTAL_COUNT
■ MEMO						:	VR 동영상 링크 정보 조회.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY             		      
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26		아이비솔루션				최초생성
   2017-09-21		정지용					@MASTER_CODE 추가
   2017-10-10		김성호					동적쿼리 변환
   2017-10-12		정지용					본인글 조회시 답변글도 같이 조회되도록 수정
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_BOARD_REVIEW_PAGING_SELECT]

	-- Add the parameters for the stored procedure here
	@MASTER_SEQ			INT,
	@SEARCH_TEXT		VARCHAR(50),
	@CATEGORY_SEQ		INT,
	@REGION_NAME		VARCHAR(20),
	@DEL_YN				VARCHAR(2),
	@NOTICE_YN			VARCHAR(2),
	@nowPage			INT,
    @pageSize			INT,
	@CUSTOMER_NO		INT,
	@FLAG				INT,
	@MASTER_CODE		VARCHAR(20) = NULL,
	@TOTAL_COUNT		INT OUT
AS
BEGIN

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(4000), @NOTICE_WHERE NVARCHAR(1000), @SORT_STRING VARCHAR(50);

	IF @NOTICE_YN = 'Y'
	BEGIN
		SELECT
			@WHERE = 'WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.NOTICE_YN = ''N''',
			@NOTICE_WHERE = 'WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.NOTICE_YN = ''Y'' AND A.LEVEL = 0',
			@SORT_STRING = 'A.NOTICE_YN DESC, '
	END
	ELSE
	BEGIN
		SELECT
			@WHERE = 'WHERE A.MASTER_SEQ = @MASTER_SEQ',
			@NOTICE_WHERE = 'WHERE 1 <> 1',
			@SORT_STRING = ''
	END

	IF @DEL_YN <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.DEL_YN = @DEL_YN AND (A.LEVEL = 0 OR EXISTS(SELECT 1 FROM HBS_DETAIL AA WITH(NOLOCK) WHERE AA.MASTER_SEQ = @MASTER_SEQ AND AA.BOARD_SEQ = A.PARENT_SEQ AND AA.DEL_YN = @DEL_YN))'
		SET @NOTICE_WHERE = @NOTICE_WHERE + ' AND A.DEL_YN = @DEL_YN AND (A.LEVEL = 0 OR EXISTS(SELECT 1 FROM HBS_DETAIL AA WITH(NOLOCK) WHERE AA.MASTER_SEQ = @MASTER_SEQ AND AA.BOARD_SEQ = A.PARENT_SEQ AND AA.DEL_YN = @DEL_YN))'
	END

	IF @CATEGORY_SEQ > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND A.CATEGORY_SEQ = @CATEGORY_SEQ'
	END

	IF @MASTER_CODE <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.MASTER_CODE = @MASTER_CODE'
	END

	IF @REGION_NAME <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND REGION_NAME = @REGION_NAME'
	END

	IF (@SEARCH_TEXT <> '')
	BEGIN
		IF (CHARINDEX(' ', @SEARCH_TEXT) > 0)
			SELECT @SEARCH_TEXT = STUFF((SELECT (' AND "' + Data + '"') AS [text()] FROM [dbo].[FN_SPLIT](@SEARCH_TEXT, ' ') FOR XML PATH('')), 1, 5, '')

		SET @WHERE = @WHERE + (' AND (
									CONTAINS((A.CONTENTS, A.SUBJECT), @SEARCH_TEXT) OR CONTAINS(A.SUBJECT, @SEARCH_TEXT) OR 
									CONTAINS(A.CONTENTS, @SEARCH_TEXT) OR 
									A.NEW_CODE IN (SELECT CUS_NO FROM CUS_CUSTOMER_DAMO AA WHERE AA.CUS_NAME LIKE @SEARCH_TEXT + ''%''))')
	END

	IF (@CUSTOMER_NO > 0)
	BEGIN
		--SET @WHERE = @WHERE + ' AND NEW_CODE = @CUSTOMER_NO'
		SET @WHERE  = @WHERE + ' AND ((NEW_CODE = @CUSTOMER_NO AND COMPLETE_YN = ''N'') OR (PARENT_SEQ IN ( SELECT PARENT_SEQ FROM HBS_DETAIL WITH(NOLOCK) WHERE MASTER_SEQ = @MASTER_SEQ AND NEW_CODE = @CUSTOMER_NO AND DEL_YN = ''N'' AND NOTICE_YN = ''N'' )))'
	END

	-- SORT 조건 만들기  
	SET @SORT_STRING = @SORT_STRING + ' A.PARENT_SEQ DESC, A.LEVEL ASC'


	SET @SQLSTRING = N'
	-- 전체 게시물 수
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM HBS_DETAIL A WITH(NOLOCK)
	' + @WHERE + N';

	WITH LIST AS
	(
		SELECT A.NOTICE_YN, A.MASTER_SEQ, A.BOARD_SEQ
		FROM HBS_DETAIL A WITH(NOLOCK)
		' + @WHERE + N'
		ORDER BY ' + @SORT_STRING + '
		OFFSET ((@NOWPAGE - 1) * @PAGESIZE) ROWS FETCH NEXT @PAGESIZE
		ROWS ONLY
	)
	SELECT
		A.NOTICE_YN,		A.MASTER_SEQ,		A.BOARD_SEQ,		A.SUBJECT,			A.SHOW_COUNT,	
		A.PARENT_SEQ,		A.LEVEL,			A.STEP,				A.COMPLETE_YN,		A.EDIT_PASS,
		A.LOCK_YN,			A.MASTER_CODE,		A.REGION_NAME,		--A.NICKNAME,
		A.NEW_DATE,			A.DEL_YN,			A.NEW_CODE AS [CUS_NO],					A.NEW_CODE,		
		A.CATEGORY_SEQ,		A.CONTENTS,			A.EMP_CODE,			B.CATEGORY_NAME,
		--dbo.FN_CUS_GET_CUS_NAME(A.NEW_CODE) AS [NICKNAME],
		(CASE WHEN A.EMP_CODE IS NULL THEN DBO.FN_CUS_GET_CUS_NAME(A.NEW_CODE) ELSE DBO.FN_CUS_GET_EMP_NAME(A.EMP_CODE) END) AS [NICKNAME],
		--(SELECT COUNT(*) FROM HBS_COMMENT WITH(NOLOCK) WHERE MASTER_SEQ = A.MASTER_SEQ AND BOARD_SEQ = A.BOARD_SEQ AND DEL_YN = ''N'') AS COMMENT_COUNT,
		(SELECT COUNT(*) FROM HBS_FILE WITH(NOLOCK) WHERE MASTER_SEQ = A.MASTER_SEQ AND BOARD_SEQ = A.BOARD_SEQ) AS FILE_COUNT		
	FROM (
		SELECT * FROM LIST
		UNION ALL
		SELECT A.NOTICE_YN, A.MASTER_SEQ, A.BOARD_SEQ
		FROM HBS_DETAIL A WITH(NOLOCK)
		' + @NOTICE_WHERE + ' 
	) Z
	INNER JOIN HBS_DETAIL A WITH(NOLOCK) ON Z.MASTER_SEQ = A.MASTER_SEQ AND Z.BOARD_SEQ = A.BOARD_SEQ		
	LEFT JOIN HBS_CATEGORY B WITH(NOLOCK) ON A.MASTER_SEQ = B.MASTER_SEQ AND A.CATEGORY_SEQ = B.CATEGORY_SEQ
	ORDER BY ' + @SORT_STRING

	SET @PARMDEFINITION = N'
		@NOWPAGE INT,
		@PAGESIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@MASTER_SEQ INT,
		@CATEGORY_SEQ INT,
		@REGION_NAME VARCHAR(30),
		@MASTER_CODE VARCHAR(10),
		@SEARCH_TEXT VARCHAR(100),
		@DEL_YN VARCHAR(1),
		@CUSTOMER_NO INT';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@NOWPAGE,
		@PAGESIZE,
		@TOTAL_COUNT OUTPUT,
		@MASTER_SEQ,
		@CATEGORY_SEQ,
		@REGION_NAME,
		@MASTER_CODE,
		@SEARCH_TEXT,
		@DEL_YN,
		@CUSTOMER_NO;

/*
    DECLARE @Start    INT=((@nowPage-1)*@pageSize)

			SELECT 
				A.MASTER_SEQ
				,A.BOARD_SEQ
				,A.CATEGORY_SEQ
				,B.CATEGORY_NAME
				--,A.NICKNAME
				,(CASE WHEN A.EMP_CODE IS NULL THEN DBO.FN_CUS_GET_CUS_NAME(A.NEW_CODE) ELSE DBO.FN_CUS_GET_EMP_NAME(A.EMP_CODE) END) AS NICKNAME
				,A.EDIT_PASS
				,A.REGION_NAME
				,A.NEW_CODE
				,A.COMPLETE_YN
				,A.SUBJECT
				,A.CONTENTS
				,A.PARENT_SEQ
				,A.LEVEL
				,A.NEW_DATE
				,A.MASTER_CODE
				,CONCAT(A.[SUBJECT],A.CONTENTS) AS FULLNAME
		FROM  HBS_DETAIL AS A
		LEFT JOIN HBS_CATEGORY AS B ON A.CATEGORY_SEQ =B.CATEGORY_SEQ AND A.MASTER_SEQ=B.MASTER_SEQ
		WHERE A.MASTER_SEQ=@MASTER_SEQ
		AND (@DEL_YN IS NULL OR @DEL_YN='' OR A.DEL_YN=@DEL_YN)
		AND (@MASTER_CODE IS NULL OR @MASTER_CODE = '' OR A.MASTER_CODE = @MASTER_CODE)
		AND (@NOTICE_YN IS NULL OR @NOTICE_YN='' OR A.NOTICE_YN=@NOTICE_YN)
		AND (@CUSTOMER_NO IS NULL OR @CUSTOMER_NO='' OR A.NEW_CODE=@CUSTOMER_NO)
		AND (@CATEGORY_SEQ IS NULL OR @CATEGORY_SEQ='' OR A.CATEGORY_SEQ=@CATEGORY_SEQ)
		AND (@REGION_NAME IS NULL OR @REGION_NAME='' OR A.REGION_NAME=@REGION_NAME)
		AND (@SEARCH_TEXT IS NULL OR @SEARCH_TEXT=''
			OR (
				A.[SUBJECT] LIKE '%'+@SEARCH_TEXT+'%' 
				OR A.CONTENTS LIKE '%'+@SEARCH_TEXT+'%'
				OR (SELECT CUS_NAME FROM CUS_CUSTOMER_DAMO WITH(NOLOCK) WHERE CUS_NO = A.NEW_CODE) LIKE '%'+@SEARCH_TEXT+'%'
				OR (SELECT KOR_NAME FROM EMP_MASTER_damo WITH(NOLOCK) WHERE EMP_CODE = A.EMP_CODE) LIKE '%'+@SEARCH_TEXT+'%'
				)
			)
		ORDER BY A.PARENT_SEQ DESC, A.LEVEL ASC
		OFFSET @Start ROWS
		FETCH NEXT @pageSize ROWS ONLY


		SELECT @TOTAL_COUNT=COUNT(*) 
		FROM  HBS_DETAIL AS A
		WHERE A.MASTER_SEQ=@MASTER_SEQ
		AND (@DEL_YN IS NULL OR @DEL_YN='' OR A.DEL_YN=@DEL_YN)
		AND (@MASTER_CODE IS NULL OR @MASTER_CODE = '' OR A.MASTER_CODE = @MASTER_CODE)
		AND (@NOTICE_YN IS NULL OR @NOTICE_YN='' OR A.NOTICE_YN=@NOTICE_YN)
		AND (@CUSTOMER_NO IS NULL OR @CUSTOMER_NO='' OR A.NEW_CODE=@CUSTOMER_NO)
		AND (@CATEGORY_SEQ IS NULL OR @CATEGORY_SEQ='' OR A.CATEGORY_SEQ=@CATEGORY_SEQ)
		AND (@REGION_NAME IS NULL OR @REGION_NAME='' OR A.REGION_NAME=@REGION_NAME)
		AND (@SEARCH_TEXT IS NULL OR @SEARCH_TEXT='' OR CASE  ISNULL(@FLAG,1) WHEN 1 THEN CONCAT(A.[SUBJECT],A.CONTENTS) 
																							WHEN 2 THEN A.[SUBJECT]
																							WHEN 3 THEN A.CONTENTS
																							WHEN 4 THEN A.NICKNAME 
																							ELSE A.SUBJECT END LIKE '%'+@SEARCH_TEXT+'%')
*/
END
GO
