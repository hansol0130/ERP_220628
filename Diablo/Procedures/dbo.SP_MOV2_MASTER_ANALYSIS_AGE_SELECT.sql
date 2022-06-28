USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_MASTER_ANALYSIS_AGE_SELECT
■ DESCRIPTION				: 검색_마스터별_연령대분석
■ INPUT PARAMETER			: 
■ EXEC						: 
    -- EXEC SP_MOV2_MASTER_ANALYSIS_AGE_SELECT '2017-09-28', '2017-10-05', 1, 10, '', '', 0, ''

■ MEMO						: 마스터별_연령대분석
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-05		IBSOLUTION			최초생성
   2017-11-15		IBSOLUTION			추가조건 반영
   2017-11-20		IBSOLUTION			정렬조건 반영
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_MASTER_ANALYSIS_AGE_SELECT]
	@START_DATE		VARCHAR(20),
	@END_DATE		VARCHAR(20),
	@FROM			INT,
	@TO				INT,
	@MASTER_CODE	VARCHAR(20),
	@MASTER_NAME	VARCHAR(20),
	@ORDER_TYPE		INT,
	@ORDER_METHOD	VARCHAR(10)
AS
BEGIN

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE_CODE NVARCHAR(200), @WHERE_NAME NVARCHAR(200), @SORT_STRING NVARCHAR(200)

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

	IF ISNULL(@ORDER_METHOD, '') = ''
	BEGIN
		SET @ORDER_METHOD = 'DESC';
	END
		

	SELECT @SORT_STRING = (
		CASE @ORDER_TYPE
			WHEN 1 THEN 'A.AGE0 ' + @ORDER_METHOD + ', A.MASTER_CODE'
			WHEN 2 THEN 'A.AGE10 ' + @ORDER_METHOD + ', A.MASTER_CODE'
			WHEN 3 THEN 'A.AGE20 ' + @ORDER_METHOD + ', A.MASTER_CODE'
			WHEN 4 THEN 'A.AGE30 ' + @ORDER_METHOD + ', A.MASTER_CODE'
			WHEN 5 THEN 'A.AGE40 ' + @ORDER_METHOD + ', A.MASTER_CODE'
			WHEN 6 THEN 'A.AGE50 ' + @ORDER_METHOD + ', A.MASTER_CODE'
			WHEN 7 THEN 'A.AGE60 ' + @ORDER_METHOD + ', A.MASTER_CODE'
			WHEN 8 THEN 'A.AGE70 ' + @ORDER_METHOD + ', A.MASTER_CODE'
			WHEN 9 THEN 'A.AGE80 ' + @ORDER_METHOD + ', A.MASTER_CODE'
			WHEN 10 THEN 'A.MASTER_NAME ' + @ORDER_METHOD + ', A.MASTER_CODE'
			ELSE 'A.MASTER_CODE ' + @ORDER_METHOD
		END
	)

	SET @SQLSTRING = N'
		SELECT * FROM
		(
			SELECT A.*,ROW_NUMBER() OVER (ORDER BY ' + @SORT_STRING + ') AS NUM
			FROM (
				SELECT A.MASTER_CODE,B.MASTER_NAME,SUM(AGE0) AGE0,SUM(AGE10) AGE10,SUM(AGE20) AGE20,SUM(AGE30) AGE30,SUM(AGE40) AGE40,
				SUM(AGE50) AGE50,SUM(AGE60) AGE60,SUM(AGE70) AGE70,SUM(AGE80) AGE80
				FROM PKG_MASTER_AGE A WITH(NOLOCK)  LEFT JOIN  PKG_MASTER B WITH(NOLOCK)
											ON A.MASTER_CODE = B.MASTER_CODE	
				WHERE A.NEW_DATE BETWEEN  CONVERT(DATETIME, @START_DATE + '' 00:00:00'') AND CONVERT(DATETIME, @END_DATE + '' 23:59:59'') '
				+ @WHERE_CODE + @WHERE_NAME + '
				GROUP BY A.MASTER_CODE,B.MASTER_NAME
			) A
		) A
		WHERE A.NUM BETWEEN @FROM AND @TO';
	
	PRINT @SQLSTRING;

	SET @PARMDEFINITION = N'@START_DATE VARCHAR(20), @END_DATE VARCHAR(20), @FROM INT, @TO INT';
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @START_DATE, @END_DATE, @FROM, @TO;

END           



GO
