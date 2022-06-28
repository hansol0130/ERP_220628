USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_CODE_MASTER_SELECT_LIST
■ DESCRIPTION				: 공통코드 리스트 조회
■ INPUT PARAMETER			: 
	@PAGE_INDEX				: 페이징 번호
	@PAGE_SIZE				: 페이지 사이즈(ROW 갯수)
	@TOTAL_COUNT			: 전체count
	@KEY					: 조회 Parameter
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT			: 총건수
■ EXEC						: 
	EXEC SP_CTI_CODE_MASTER_SELECT_LIST 1, 10,'',''

	CATEGORY CATEGORY_NAME                                      MAIN_CODE            MAIN_NAME                                          REFERENCE_CATEGORY REFERENCE_CODE       SORT   USE_YN REMARK                                                                                                                                                                                                   NEW_DATE                NEW_CODE EDT_DATE                EDT_CODE
-------- -------------------------------------------------- -------------------- -------------------------------------------------- ------------------ -------------------- ------ ------ -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------------------- -------- ----------------------- --------
CTI000   사용여부                                               Y                    Yes                                                NULL               NULL                 1      Y      NULL                                                                                                                                                                                                     2014-10-13 00:00:00.000 1234567  2014-12-30 22:27:52.183 2013069
CTI000   사용여부                                               N                    No                                                 NULL               NULL                 2      Y      NULL                                                                                                                                                                                                     2014-10-13 00:00:00.000 1234567  2014-12-30 22:27:52.183 2013069

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------

 ------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-24		곽병삼			최초생성
   2015-02-05		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CODE_MASTER_SELECT_LIST]
--DECLARE
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@TOTAL_COUNT	INT OUTPUT,
	@KEY			VARCHAR(2000)

AS

SET NOCOUNT ON

	DECLARE
		@COLS_NAME		VARCHAR(50)='CATEGORY',
		@SORT			VARCHAR(50)='DESC',
		@CATEGORY		VARCHAR(6),
		@USE_YN			VARCHAR(1),
		@WHERE			NVARCHAR(4000),
		@SQL			NVARCHAR(4000),
		@BSQL			NVARCHAR(4000),
		@PARM			NVARCHAR(1000)

	--SET @SDATE = '2014-11-01'
	--SET @EDATE = '2014-11-17'
	--SET @TEAM_CODE = '538'
	--SET @EMP_CODE = '2012010'
	--SET @CONSULT_TYPE = ''
	--SET @CONSULT_RESULT = ''
	--SET @CUS_NAME = ''
	--SET @CUS_TEL = ''

	SELECT
		@CATEGORY = Diablo.DBO.FN_PARAM(@KEY, 'Category'),
		@USE_YN = Diablo.DBO.FN_PARAM(@KEY, 'UseYn')

	SET @WHERE = '';

	IF @COLS_NAME IS NULL OR @COLS_NAME = ''
		SET @COLS_NAME = 'CATEGORY'
		
	IF @SORT IS NULL OR @SORT=''
		SET @SORT = 'DESC'

	IF ISNULL(@CATEGORY,'') <> ''
	BEGIN
		SET @WHERE += ' AND CATEGORY = ''' + @CATEGORY + ''''
	END

	IF ISNULL(@USE_YN,'') <> ''
	BEGIN
		SET @WHERE += ' AND USE_YN = ''' + @USE_YN + ''''
	END

	SET @BSQL = '
		SELECT
			ROW_NUMBER() OVER(ORDER BY CATEGORY, SORT ) AS RNO,
			CATEGORY,
			CATEGORY_NAME,
			MAIN_CODE,
			MAIN_NAME,
			REFERENCE_CATEGORY,
			REFERENCE_CODE,
			SORT,
			USE_YN,
			REMARK,
			NEW_DATE,
			NEW_CODE,
			EDT_DATE,
			EDT_CODE,
			' + @COLS_NAME + ' AS SORT_KEY
		FROM sirens.cti.CTI_CODE_MASTER
		WHERE 1=1 '
		+ @WHERE

	SET @SQL=''
	SET @SQL = '	
		SELECT 
			CATEGORY,
			CATEGORY_NAME,
			MAIN_CODE,
			MAIN_NAME,
			REFERENCE_CATEGORY,
			REFERENCE_CODE,
			SORT,
			USE_YN,
			REMARK,
			NEW_DATE,
			NEW_CODE,
			EDT_DATE,
			EDT_CODE
		FROM (' + @BSQL + ')T1 ORDER BY CATEGORY, SORT'


	EXECUTE(@SQL)

	SET @SQL = 'SELECT @TOTAL_COUNT = COUNT(*) FROM (' + @BSQL + ')T1'

	

	SET @PARM = N'@CATEGORY VARCHAR(6), @USE_YN VARCHAR(1), @TOTAL_COUNT INT OUTPUT'
	EXEC SP_EXECUTESQL @SQL, @PARM, @CATEGORY, @USE_YN, @TOTAL_COUNT OUTPUT

SET NOCOUNT OFF
GO
