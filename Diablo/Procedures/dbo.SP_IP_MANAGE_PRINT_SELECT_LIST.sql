USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_IP_MANAGE_PRINT_SELECT_LIST
■ DESCRIPTION				: 사내 IP관리
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	DECLARE @COUNT INT
	EXEC DBO.SP_IP_MANAGE_PRINT_SELECT_LIST 1, 20, @COUNT OUTPUT, '', 1	
	SELECT @COUNT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2014-04-11		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_IP_MANAGE_PRINT_SELECT_LIST]
 	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY	varchar(200),
	@ORDER_BY	int
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);
	DECLARE @PRINT_CODE VARCHAR(10)
	DECLARE @PRINT_NAME VARCHAR(20)
	DECLARE @IPADDRESS VARCHAR(15)
	DECLARE @EDI_CODE VARCHAR(10)

	SELECT
		@PRINT_CODE = DBO.FN_PARAM(@KEY, 'PrintCode'),
		@PRINT_NAME = DBO.FN_PARAM(@KEY, 'PrintName'),
		@IPADDRESS = DBO.FN_PARAM(@KEY, 'IPAddress'),
		@EDI_CODE = DBO.FN_PARAM(@KEY, 'EdiCode')


	SET @WHERE = '1 = 1'	
	IF ISNULL(@PRINT_CODE, '') <> ''
		SET @WHERE = @WHERE + ' AND A.PRINT_CODE = @PRINT_CODE';

	IF ISNULL(@PRINT_NAME, '') <> ''
		SET @WHERE = @WHERE + ' AND A.PRINT_NAME LIKE ''%'' + @PRINT_NAME + ''%''';

	IF ISNULL(@IPADDRESS, '') <> ''
		SET @WHERE = @WHERE + ' AND A.PC_IP LIKE ''%'' + @IPADDRESS + ''%''';

	IF ISNULL(@EDI_CODE, '') <> ''
		SET @WHERE = @WHERE + ' AND A.EDI_CODE = @EDI_CODE'

	SELECT @SORT_STRING = (  
		CASE @ORDER_BY  
			WHEN 1 THEN ' A.NEW_DATE DESC'
			WHEN 2 THEN ' A.NEW_DATE ASC'
			ELSE ' A.NEW_DATE DESC'
		END
	)

	SET @SQLSTRING = N'
	WITH LIST AS 
	(
		SELECT
			  PRINT_CODE
			, PRINT_NAME
			, DBO.XN_CUS_GET_IP_NUMBER(1, A.PRINT_CODE) AS [PC_IP]
			, EDI_CODE
		FROM PRINT_MASTER A
	)
	SELECT 
		@TOTAL_COUNT = COUNT(*)
	FROM LIST A WITH(NOLOCK)
	WHERE ' + @WHERE + ';

	WITH LIST AS 
	(
		SELECT 
			PRINT_CODE
			, PRINT_NAME
			, MODEL_NAME
			, POSITION
			, DBO.XN_CUS_GET_IP_NUMBER(1, A.PRINT_CODE) AS [PC_IP]
			, EDI_CODE
			, REMARK
			, NEW_DATE
		FROM PRINT_MASTER A
	)
	SELECT 
		PRINT_CODE
		, PRINT_NAME
		, MODEL_NAME
		, POSITION
		, PC_IP
		, EDI_CODE
		, REMARK
	FROM LIST A
	WHERE ' + @WHERE + '
	ORDER BY ' + @SORT_STRING + '
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY';
	 

	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@PRINT_CODE VARCHAR(10),
		@PRINT_NAME VARCHAR(20),
		@IPADDRESS VARCHAR(15),
		@EDI_CODE VARCHAR(10)';

	PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@PRINT_CODE,
		@PRINT_NAME,
		@IPADDRESS,
		@EDI_CODE
END
GO
