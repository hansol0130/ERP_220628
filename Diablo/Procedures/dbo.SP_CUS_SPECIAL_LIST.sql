USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CUS_SPECIAL_LIST
■ DESCRIPTION				: 특수고객 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	DECLARE @COUNT INT
	EXEC DBO.SP_CUS_SPECIAL_LIST 1, 20, @COUNT OUTPUT, '', 1	
	SELECT @COUNT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-06-09		정지용			최초생성
   2019-08-08		김남훈			특수고객관리 이름 검색 추가
================================================================================================================*/ 
CREATE PROC [dbo].[SP_CUS_SPECIAL_LIST]
 	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY	varchar(200),
	@ORDER_BY	int
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);
	DECLARE @TEL1 VARCHAR(4)
	DECLARE @TEL2 VARCHAR(4)
	DECLARE @TEL3 VARCHAR(4)
	DECLARE @EMP_CODE CHAR(7)
	DECLARE @CUS_NO INT
	DECLARE @USE_YN CHAR(1)
	DECLARE @CUS_NAME VARCHAR(20)

	SELECT
		@TEL1 = DBO.FN_PARAM(@KEY, 'TelNumber1'),
		@TEL2 = DBO.FN_PARAM(@KEY, 'TelNumber2'),
		@TEL3 = DBO.FN_PARAM(@KEY, 'TelNumber3'),
		@EMP_CODE = DBO.FN_PARAM(@KEY, 'EmpCode'),
		@CUS_NO = DBO.FN_PARAM(@KEY, 'CusNo'),
		@USE_YN = DBO.FN_PARAM(@KEY, 'UseYN'),
		@CUS_NAME = DBO.FN_PARAM(@KEY, 'CusName')

	SET @WHERE = '1 = 1'	
	IF ISNULL(@TEL1, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.NO1 = @TEL1';
	END

	IF ISNULL(@TEL2, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.NO2 = @TEL2';
	END

	IF ISNULL(@TEL3, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.NO3 = @TEL3';
	END

	IF ISNULL(@EMP_CODE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND B.EMP_CODE = @EMP_CODE';
	END

	IF ISNULL(@CUS_NO, '') <> '' OR @CUS_NO <> 0
	BEGIN
		SET @WHERE = @WHERE + ' AND C.CUS_NO = @CUS_NO';
	END

	IF ISNULL(@USE_YN, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.USE_YN = @USE_YN';
	END

	IF ISNULL(@CUS_NAME, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND C.CUS_NAME LIKE + @CUS_NAME + ''%''';
	END


	SELECT @SORT_STRING = (  
		CASE @ORDER_BY  
			WHEN 1 THEN ' A.NEW_DATE DESC'
			WHEN 2 THEN ' A.NEW_DATE ASC'
			ELSE ' A.NEW_DATE DESC'
		END
	)

	SET @SQLSTRING = N'
	SELECT
		@TOTAL_COUNT = COUNT(1)
	FROM CUS_SPECIAL A WITH(NOLOCK)
	INNER JOIN EMP_MASTER B WITH(NOLOCK) ON A.CONNECT_CODE = B.EMP_CODE
	INNER JOIN CUS_CUSTOMER C WITH(NOLOCK) ON A.CUS_NO = C.CUS_NO
	WHERE ' + @WHERE + ';

	SELECT
	 A.SPC_NO, A.NO1 AS TEL_NUMBER1, A.NO2 AS TEL_NUMBER2, A.NO3 AS TEL_NUMBER3, A.CUS_NO, C.CUS_NAME, A.CONNECT_CODE AS EMP_CODE, B.KOR_NAME AS EMP_NAME,
	 A.REMARK, A.USE_YN, A.NEW_CODE, A.NEW_DATE
	FROM CUS_SPECIAL A WITH(NOLOCK)
	INNER JOIN EMP_MASTER B WITH(NOLOCK) ON A.CONNECT_CODE = B.EMP_CODE
	INNER JOIN CUS_CUSTOMER C WITH(NOLOCK) ON A.CUS_NO = C.CUS_NO
	WHERE ' + @WHERE + '
	ORDER BY ' + @SORT_STRING + '
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY';	 

	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@TEL1 VARCHAR(4),
		@TEL2 VARCHAR(4),
		@TEL3 VARCHAR(4),
		@EMP_CODE VARCHAR(7),
		@CUS_NO INT,
		@USE_YN CHAR(1),
		@CUS_NAME VARCHAR(20)';

	PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@TEL1,
		@TEL2,
		@TEL3,
		@EMP_CODE,
		@CUS_NO,
		@USE_YN,
		@CUS_NAME
END
GO
