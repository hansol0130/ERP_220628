USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_MASTER_ANALYSIS_PARTNER_COUNT_SELECT
■ DESCRIPTION				: 검색_마스터별_동반자분석_행수
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- EXEC SP_MOV2_MASTER_ANALYSIS_PARTNER_COUNT_SELECT '2017-09-28', '2017-10-05', '', ''

■ MEMO						: 마스터별_동반자분석_행수
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-05		IBSOLUTION			최초생성
   2017-11-15		IBSOLUTION			추가조건 반영
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_MASTER_ANALYSIS_PARTNER_COUNT_SELECT]
	@START_DATE		VARCHAR(20),
	@END_DATE		VARCHAR(20),
	@MASTER_CODE	VARCHAR(20),
	@MASTER_NAME	VARCHAR(20)
AS
BEGIN

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE_CODE NVARCHAR(200), @WHERE_NAME NVARCHAR(200)

	SET @WHERE_CODE = '';
	SET @WHERE_NAME = '';

	IF ISNULL(@MASTER_CODE, '') <> ''
	BEGIN
		SET @WHERE_CODE = ' AND A.MASTER_CODE LIKE ''%' + @MASTER_CODE + '%'' ';
	END

	IF ISNULL(@MASTER_NAME, '') <> ''
	BEGIN
		SET @WHERE_NAME = ' AND B.MASTER_NAME LIKE ''%' + @MASTER_NAME + '%'' ';
	END

	SET @SQLSTRING = N'
		SELECT COUNT(*) ROW_CNT
		FROM (
			SELECT A.MASTER_CODE,B.MASTER_NAME,SUM(FAMILY) FAMILY,SUM(FRIEND) FRIEND,SUM(MEETING) MEETING,SUM(COUPLE) COUPLE,SUM(ALONE) ALONE
			FROM PKG_MASTER_PARTNER A WITH(NOLOCK)  LEFT JOIN  PKG_MASTER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE	
			WHERE A.NEW_DATE BETWEEN  CONVERT(DATETIME, @START_DATE + '' 00:00:00'') AND CONVERT(DATETIME, @END_DATE + '' 23:59:59'') '
			+ @WHERE_CODE + @WHERE_NAME + '
			GROUP BY A.MASTER_CODE,B.MASTER_NAME
		) B ';

	-- PRINT @SQLSTRING;

	SET @PARMDEFINITION = N'@START_DATE VARCHAR(20), @END_DATE VARCHAR(20)';
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @START_DATE, @END_DATE;
END           



GO
