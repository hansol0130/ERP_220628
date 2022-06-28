USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_SEND_COUNT_SELECT
■ DESCRIPTION				: 검색_큐레이션발송_목록_갯수
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- EXEC SP_MOV2_CURATION_SEND_COUNT_SELECT '2017-09-28', '2017-10-05', '', '', ''
■ MEMO						: 큐레이션발송_목록_갯수
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-05		IBSOLUTION			최초생성
   2017-11-15		IBSOLUTION			조건 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_SEND_COUNT_SELECT]
	@START_DATE				VARCHAR(20),
	@END_DATE				VARCHAR(20),
	@HIS_TYPE				VARCHAR(10),
	@HIS_TITLE				VARCHAR(20),
	@KOR_NAME				VARCHAR(20)
AS
BEGIN

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(1000);
	
	SET @WHERE = '';

	IF ISNULL(@HIS_TYPE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.HIS_TYPE = ''' + @HIS_TYPE + ''' ';
	END

	IF ISNULL(@HIS_TITLE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.HIS_TITLE LIKE ''%' + @HIS_TITLE + '%'' ';
	END

	IF ISNULL(@KOR_NAME, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND D.KOR_NAME LIKE ''%' + @KOR_NAME + '%'' ';
	END

	SET @SQLSTRING = N'
		SELECT COUNT(*) ROW_CNT
		FROM (
			SELECT A.*, D.KOR_NAME
			FROM cuve_history A  WITH(NOLOCK) LEFT JOIN  
			 (select B.CUR_NO,C.KOR_NAME from CUR_INFO B  WITH(NOLOCK) LEFT JOIN  EMP_MASTER C WITH(NOLOCK) ON B.NEW_CODE = C.EMP_CODE)
			 D ON A.CUR_NO = D.CUR_NO
			WHERE A.NEW_DATE BETWEEN CONVERT(DATETIME,@START_DATE + '' 00:00:00'') AND CONVERT(DATETIME,@END_DATE + '' 23:59:59'') '
				+ @WHERE + '
		) A'

	PRINT @SQLSTRING;

	SET @PARMDEFINITION = N'@START_DATE VARCHAR(20), @END_DATE VARCHAR(20)';
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @START_DATE, @END_DATE;

END           



GO
