USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_MENU_SELECT_LIST
■ DESCRIPTION				: 메뉴정보 리스트 조회
■ INPUT PARAMETER			: 
	@PAGE_INDEX				: 페이징 번호
	@PAGE_SIZE				: 페이지 사이즈(ROW 갯수)
	@KEY					: 조회 Parameter
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT			: 총건수
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------

 ------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-24		곽병삼			최초생성
   2014-12-29		곽병삼			메뉴구분 조회조건 추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_MENU_SELECT_LIST]
--DECLARE
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@TOTAL_COUNT	INT OUTPUT,
	@KEY			VARCHAR(2000)

AS

SET NOCOUNT ON

	DECLARE
		@COLS_NAME		VARCHAR(50)='SORT',
		@SORT			VARCHAR(50)='DESC',
		@MENU_ID	VARCHAR(4),
		@MENU_NAME	VARCHAR(50),
		@MENU_TYPE	VARCHAR(2),
		@WHERE			NVARCHAR(4000),
		@SQL			NVARCHAR(4000),
		@BSQL			NVARCHAR(4000),
		@PARM			NVARCHAR(1000)

	SELECT
		@MENU_ID = Diablo.DBO.FN_PARAM(@KEY, 'MenuId'),
		@MENU_NAME = Diablo.DBO.FN_PARAM(@KEY, 'MenuName'),
		@MENU_TYPE = Diablo.DBO.FN_PARAM(@KEY, 'MenuType')

	SET @WHERE = '';

	IF @COLS_NAME IS NULL OR @COLS_NAME = ''
		SET @COLS_NAME = 'SORT'

	SET @COLS_NAME = 'MNU.' + @COLS_NAME
		
	IF @SORT IS NULL OR @SORT=''
		SET @SORT = 'DESC'

	IF ISNULL(@MENU_ID,'') <> ''
	BEGIN
		SET @WHERE += ' AND MNU.MENU_ID LIKE ''' + @MENU_ID + '%'''
	END

	IF ISNULL(@MENU_NAME,'') <> ''
	BEGIN
		SET @WHERE += ' AND MNU.MENU_NAME LIKE ''%' + @MENU_NAME + '%'''
	END

	IF ISNULL(@MENU_TYPE,'') <> ''
	BEGIN
		SET @WHERE += ' AND LEFT(MNU.MENU_ID,2) = ''' + @MENU_TYPE + ''''
	END

	SET @BSQL = '
		SELECT
			ROW_NUMBER() OVER(ORDER BY MNU.SORT ) AS RNO,
			MNU.MENU_ID,
			MNU.MENU_NAME,
			COD.MAIN_NAME AS MENU_LEVEL_NAME,
			MNU.MENU_LEVEL,
			MNU.SORT,
			MNU.UPPER_MENU_ID,
			MNU.MENU_URL,
			MNU.REMARK,
			' + @COLS_NAME + ' AS SORT_KEY
		FROM Sirens.cti.CTI_MENU MNU, CTI_CODE_MASTER COD
		WHERE 1=1 
		AND COD.CATEGORY = ''CTI002'' AND COD.USE_YN = ''Y''
		AND MNU.MENU_LEVEL = COD.MAIN_CODE '
		+ @WHERE

	SET @SQL=''
	SET @SQL = '	
		SELECT 
			MENU_ID,
			MENU_NAME,
			MENU_LEVEL,
			MENU_LEVEL_NAME,
			SORT,
			UPPER_MENU_ID,
			MENU_URL,
			REMARK
		FROM (' + @BSQL + ')T1 '
		

	EXECUTE(@SQL)

	SET @SQL = 'SELECT @TOTAL_COUNT = COUNT(*) FROM (' + @BSQL + ')T1'

	

	SET @PARM = N'@MENU_ID VARCHAR(4), @MENU_NAME VARCHAR(50), @TOTAL_COUNT INT OUTPUT'
	EXEC SP_EXECUTESQL @SQL, @PARM, @MENU_ID, @MENU_NAME, @TOTAL_COUNT OUTPUT

SET NOCOUNT OFF
GO
