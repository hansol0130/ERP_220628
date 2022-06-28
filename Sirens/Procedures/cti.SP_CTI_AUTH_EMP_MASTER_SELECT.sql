USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_AUTH_EMP_MASTER_SELECT
■ DESCRIPTION				: 사용자 권한 마스터 목록
■ INPUT PARAMETER			: 
	@PAGE_INDEX				: 페이징 번호
	@PAGE_SIZE				: 페이지 사이즈(ROW 갯수)
	@TOTAL_COUNT			: 전체 row count
	@KEY					: 검색조건
	
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_AUTH_EMP_MASTER_SELECT 1,10,'',''

	RNO                  TEAM_CODE TEAM_NAME                                          EMP_CODE KOR_NAME             POS_TYPE    INNER_NUMBER3 CTI_USE_YN ACCESS_YN
-------------------- --------- -------------------------------------------------- -------- -------------------- ----------- ------------- ---------- ---------
1                    529       시스템개발                                              9999999  시스템관리자               1           2593          사용         Y
2                    540       고객지원                                               9999990  공항서비스                1                         미사용        N

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------

 ------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-18		홍영택			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_AUTH_EMP_MASTER_SELECT]
--DECLARE
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@TOTAL_COUNT	INT OUTPUT,
	@KEY			VARCHAR(200)

AS

SET NOCOUNT ON

	DECLARE
		@COLS_NAME			VARCHAR(50)=' A.EMP_CODE',
		@SORT				VARCHAR(50)='DESC',
		@TEAM_CODE	VARCHAR(3),
		@EMP_CODE	VARCHAR(7),
		@WHERE NVARCHAR(4000),
		@SQL NVARCHAR(4000),
		@BSQL NVARCHAR(4000),
		@PARM NVARCHAR(1000)

	--SET @TEAM_CODE = '538'
	--SET @EMP_CODE = '2012010'


	SELECT
		@TEAM_CODE = Diablo.DBO.FN_PARAM(@KEY, 'TeamCode'),
		@EMP_CODE = Diablo.DBO.FN_PARAM(@KEY, 'EmpCode');

	SET @WHERE = '';

	IF @COLS_NAME IS NULL OR @COLS_NAME = ''
		SET @COLS_NAME = 'A.EMP_CODE'
		
	IF @SORT IS NULL OR @SORT=''
		SET @SORT = 'DESC'

	IF ISNULL(@TEAM_CODE,'') <> ''
	BEGIN
		SET @WHERE += '  AND A.TEAM_CODE =  ''' + @TEAM_CODE + ''''
	END

	IF ISNULL(@EMP_CODE,'') <> ''
	BEGIN
		SET @WHERE += ' AND A.EMP_CODE =  ''' + @EMP_CODE + ''''
	END

	SET @BSQL = '
   SELECT 
        ROW_NUMBER() OVER(ORDER BY ' + @COLS_NAME + ' ' + @SORT + ' ) AS RNO
          , A.TEAM_CODE
          ,(SELECT B.TEAM_NAME FROM Diablo.dbo.EMP_TEAM  B WHERE B.TEAM_CODE = A.TEAM_CODE) AS TEAM_NAME
          , A.EMP_CODE
          , A.KOR_NAME
          , A.POS_TYPE
          , A.INNER_NUMBER3
          , CASE WHEN A.CTI_USE_YN = ''Y'' THEN ''사용'' ELSE ''미사용'' END  AS CTI_USE_YN
          , C.ACCESS_YN
          , 	' + @COLS_NAME + ' AS SORT_KEY
      FROM Diablo.dbo.EMP_MASTER A LEFT OUTER JOIN Sirens.cti.CTI_AUTH_ACCESS C ON A.EMP_CODE = C.EMP_CODE
      WHERE  A.WORK_TYPE = ''1'''
     	+ @WHERE + ''

	EXECUTE(@SQL)

	SET @SQL=''
	SET @SQL = '	
		SELECT 
			RNO,
			TEAM_CODE,
			TEAM_NAME,
			EMP_CODE,
			KOR_NAME,
			POS_TYPE,
			INNER_NUMBER3,
			CTI_USE_YN,
			ACCESS_YN
		FROM (' + @BSQL + ')T1
		WHERE RNO>=' + CONVERT(VARCHAR(100),(( @PAGE_INDEX-1 )*@PAGE_SIZE)+1) + '	and RNO<=' + CONVERT(VARCHAR(100),@PAGE_INDEX*@PAGE_SIZE)

	EXECUTE(@SQL)

	SET @SQL = 'SELECT @TOTAL_COUNT = COUNT(*) FROM (' + @BSQL + ')T1'

	

	SET @PARM = N'@TEAM_CODE VARCHAR(3), @EMP_CODE VARCHAR(7), @TOTAL_COUNT INT OUTPUT'
	EXEC SP_EXECUTESQL @SQL, @PARM, @TEAM_CODE, @EMP_CODE, @TOTAL_COUNT OUTPUT

SET NOCOUNT OFF
GO
