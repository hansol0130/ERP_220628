USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_IP_MANAGE_SEARCH_LIST
■ DESCRIPTION				: 사내 IP관리 아이피 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
declare @p5 int
set @p5=19
exec SP_IP_MANAGE_SEARCH_LIST @PAGE_INDEX=1,@PAGE_SIZE=20,@KEY=N'searchtype=1&IPType=0&IPCode=0&IPNumber=454545',@ORDER_BY=0,@TOTAL_COUNT=@p5 output
select @p5
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2014-04-21		정지용			최초생성
   2014-05-15		정지용			재직중인 직원만 조회가능
================================================================================================================*/ 
CREATE PROC [dbo].[SP_IP_MANAGE_SEARCH_LIST]
 	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY	varchar(200),
	@ORDER_BY	int
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);
	DECLARE @IPADDRESS VARCHAR(15)
	DECLARE @SEARCH_TYPE CHAR(1)
	DECLARE @IP_TYPE INT

	SELECT
		@IPADDRESS = DBO.FN_PARAM(@KEY, 'IPNumber'),
		@SEARCH_TYPE = DBO.FN_PARAM(@KEY, 'searchtype'),
		@IP_TYPE = DBO.FN_PARAM(@KEY, 'IPType')


	SET @WHERE = '((B.WORK_TYPE = 1 AND B.EMP_CODE IS NOT NULL) OR (B.EMP_CODE IS NULL))'	
	IF @SEARCH_TYPE = '1'
	BEGIN
		IF ISNULL(@IPADDRESS, '') <> ''
			SET @WHERE = @WHERE + ' AND IP_TYPE = ''1'' AND IP_NUMBER LIKE ''%'' + @IPADDRESS + ''%'''
	END 
	ELSE IF @SEARCH_TYPE = '2'
	BEGIN
		IF ISNULL(@IPADDRESS, '') <> ''
			SET @WHERE = @WHERE + ' AND IP_TYPE = ''2'' AND IP_NUMBER LIKE''%'' + @IPADDRESS + ''%'''
	END
	
	IF ISNULL(@IP_TYPE, '') <> ''
		SET @WHERE = @WHERE + ' AND IP_TYPE = @IP_TYPE'

	SELECT @SORT_STRING = (  
		CASE @ORDER_BY  
			WHEN 1 THEN ' IP_NUMBER ASC'
			WHEN 2 THEN ' IP_NUMBER DESC'
			ELSE ' IP_NUMBER DESC'
		END
	)

	SET @SQLSTRING = N'
	SELECT 
		@TOTAL_COUNT = COUNT(1) 
	FROM IP_MASTER A WITH(NOLOCK)
	LEFT OUTER JOIN EMP_MASTER B WITH(NOLOCK) on A.CONNECT_CODE = B.EMP_CODE
	WHERE ' + @WHERE + ';

	SELECT 
		IP_TYPE
		, IP_CODE
		, CONNECT_CODE
		, IP_NUMBER AS [PC_IP]
	FROM IP_MASTER A WITH(NOLOCK)
	LEFT OUTER JOIN EMP_MASTER B WITH(NOLOCK) on A.CONNECT_CODE = B.EMP_CODE
	WHERE ' + @WHERE + '
	ORDER BY ' + @SORT_STRING + '
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY';
	 

	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@IPADDRESS VARCHAR(15),
		@SEARCH_TYPE CHAR(1),
		@IP_TYPE INT';

	PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@IPADDRESS,
		@SEARCH_TYPE,
		@IP_TYPE
END
GO
