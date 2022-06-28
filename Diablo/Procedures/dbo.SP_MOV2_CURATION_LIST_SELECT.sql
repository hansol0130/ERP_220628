USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_LIST_SELECT
■ DESCRIPTION				: 검색_큐레이션정보_목록_갯수
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- EXEC SP_MOV2_CURATION_LIST_SELECT '2017-09-28', '2017-10-05', '', '', '', '', '', ''

■ MEMO						: 검색_큐레이션정보_목록_갯수
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-05		IBSOLUTION			최초생성
   2017-11-15		IBSOLUTION			조건 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_LIST_SELECT]
	@START_DATE		VARCHAR(20),
	@END_DATE		VARCHAR(20),
	@CUR_TYPE		VARCHAR(10),
	@CUR_ITEM		VARCHAR(100),
	@CUR_TITLE		VARCHAR(100),
	@PUSH_YN		CHAR(1),
	@USE_YN			CHAR(1),
	@KOR_NAME		VARCHAR(20)
AS
BEGIN

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(1000);
	
	SET @WHERE = '';

	IF ISNULL(@CUR_TYPE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.CUR_TYPE = ''' + @CUR_TYPE + ''' ';
	END

	IF ISNULL(@CUR_ITEM, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.CUR_ITEM LIKE ''%' + @CUR_ITEM + '%'' ';
	END

	IF ISNULL(@CUR_TITLE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.CUR_TITLE LIKE ''%' + @CUR_TITLE + '%'' ';
	END

	IF ISNULL(@PUSH_YN, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.PUSH_YN = ''' + @PUSH_YN + ''' ';
	END

	IF ISNULL(@USE_YN, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.USE_YN = ''' + @USE_YN + ''' ';
	END

	IF ISNULL(@KOR_NAME, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND B.KOR_NAME LIKE ''%' + @KOR_NAME + '%'' ';
	END

	SET @SQLSTRING = N'
		SELECT COUNT(*) ROW_CNT
			FROM (
				SELECT A.*
					FROM CUR_INFO A  WITH(NOLOCK) LEFT JOIN  EMP_MASTER B WITH(NOLOCK) ON A.NEW_CODE = B.EMP_CODE
					WHERE A.NEW_DATE BETWEEN CONVERT(DATETIME, @START_DATE + '' 00:00:00'') AND CONVERT(DATETIME, @END_DATE + '' 23:59:59'') '
					+ @WHERE + '
			) A'

	PRINT @SQLSTRING;

	SET @PARMDEFINITION = N'@START_DATE VARCHAR(20), @END_DATE VARCHAR(20)';
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @START_DATE, @END_DATE;

END           



GO
