USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PUB_JOINT_PROMOTION_MASTER_SELECT_LIST
■ DESCRIPTION				: 공동기획전 관리 마스터 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
declare @p5 int
set @p5=4
exec SP_PUB_JOINT_PROMOTION_MASTER_SELECT_LIST @PAGE_INDEX=1,@PAGE_SIZE=9999,@KEY=N'',@ORDER_BY=0,@TOTAL_COUNT=@p5 output
select @p5
SELECT * FROM PUB_JOINT_MASTER;
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-10-10		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PUB_JOINT_PROMOTION_MASTER_SELECT_LIST]
 	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY	varchar(200),
	@ORDER_BY	int
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	
	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);

	DECLARE @TYPE CHAR(1)	
	DECLARE @SEARCH_TYPE INT
	DECLARE @SEARCH_TEXT VARCHAR(100)
	
	SELECT
		@TYPE = DBO.FN_PARAM(@KEY, 'Type'),		
		@SEARCH_TYPE = DBO.FN_PARAM(@KEY, 'SearchType'),
		@SEARCH_TEXT = DBO.FN_PARAM(@KEY, 'SearchText')

	SET @WHERE = '1 = 1'	
	IF ISNULL(@TYPE, '') <> ''
	BEGIN	
		SET @WHERE = @WHERE + ' AND A.TYPE = @TYPE'
	END

	IF @SEARCH_TYPE  = 1
	BEGIN
		IF ISNULL(@SEARCH_TEXT, '') <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND A.SUBJECT LIKE ''%'' + @SEARCH_TEXT + ''%''';
		END
	END

	SET @SQLSTRING = N'
	SELECT 
		@TOTAL_COUNT = COUNT(1)
	FROM PUB_JOINT_MASTER A WITH(NOLOCK)
	WHERE ' + @WHERE + ';

	SELECT 
		A.JOINT_SEQ, A.TYPE, A.SUBJECT, A.START_DATE, A.END_DATE, A.VIEW_YN, A.TOP_URL, A.MENU_VIEW_YN, A.MENU_STYLE, A.LIST_VIEW_YN,
		A.LIST_COUNT, A.READ_COUNT, A.NEW_DATE, A.NEW_CODE, A.EDT_DATE, A.EDT_CODE
	FROM PUB_JOINT_MASTER A WITH(NOLOCK)
	WHERE ' + @WHERE + '
	ORDER BY NEW_DATE DESC
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY';

	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@TYPE INT,
		@SEARCH_TYPE INT,
		@SEARCH_TEXT VARCHAR(100)';

	PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@TYPE,
		@SEARCH_TYPE,
		@SEARCH_TEXT;
END

GO
