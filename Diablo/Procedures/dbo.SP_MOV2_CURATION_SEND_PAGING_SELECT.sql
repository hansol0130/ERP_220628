USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_SEND_PAGING_SELECT
■ DESCRIPTION				: 검색_큐레이션발송_목록_페이징
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- EXEC SP_MOV2_CURATION_SEND_PAGING_SELECT '2017-09-28' '2017-10-05', 1, 10, '', '', ''
■ MEMO						: 큐레이션발송_목록_페이징
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-05		IBSOLUTION			최초생성
   2017-11-15		IBSOLUTION			조건 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_SEND_PAGING_SELECT]
	@START_DATE				VARCHAR(20),
	@END_DATE				VARCHAR(20),
	@FROM					INT,
	@TO						INT,
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
		SELECT * FROM
		(
			SELECT A.*,ROW_NUMBER() OVER (ORDER BY A.NEW_DATE DESC) AS NUM
			FROM (
				SELECT A.*, D.KOR_NAME,
				(SELECT COUNT(*) FROM CUVE WHERE HIS_NO = A.HIS_NO AND SEND_DATE IS NOT NULL) SEND_CNT,
				(SELECT COUNT(*) FROM CUVE WHERE HIS_NO = A.HIS_NO AND RCV_DATE IS NOT NULL) RCV_CNT,
				(SELECT COUNT(*)  FROM CUVE WHERE HIS_NO = A.HIS_NO AND CONFIRM_DATE IS NOT NULL) CONFIRM_CNT
				FROM CUVE_HISTORY A  WITH(NOLOCK) LEFT JOIN  
				 (SELECT B.CUR_NO,C.KOR_NAME FROM CUR_INFO B  WITH(NOLOCK) LEFT JOIN  EMP_MASTER C WITH(NOLOCK) ON B.NEW_CODE = C.EMP_CODE)
				 D ON A.CUR_NO = D.CUR_NO
				WHERE A.NEW_DATE BETWEEN CONVERT(DATETIME,@START_DATE + '' 00:00:00'') AND CONVERT(DATETIME,@END_DATE + '' 23:59:59'') '
				+ @WHERE + '
			) A
		) A
		WHERE A.NUM BETWEEN @FROM AND @TO '

	PRINT @SQLSTRING;

	SET @PARMDEFINITION = N'@START_DATE VARCHAR(20), @END_DATE VARCHAR(20), @FROM INT, @TO INT';
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @START_DATE, @END_DATE, @FROM, @TO;

END           



GO
