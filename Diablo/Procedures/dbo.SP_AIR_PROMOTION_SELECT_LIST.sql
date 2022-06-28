USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_AIR_PROMOTION_SELECT_LIST
■ DESCRIPTION				: 항공 프로모션 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	declare @p5 int
	set @p5=4
	exec SP_AIR_PROMOTION_SELECT_LIST @PAGE_INDEX=1,@PAGE_SIZE=9999,@KEY=N'Title=',@ORDER_BY=0,@TOTAL_COUNT=@p5 output
	select @p5
	SELECT * FROM AIR_PROMOTION
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2017-02-10			정지용			최초생성
2017-08-25			정지용			프로모션 제한날짜 필드 추가
2019-07-23			박형만			최소적용 인원 추가 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_AIR_PROMOTION_SELECT_LIST]	
 	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY	varchar(200),
	@ORDER_BY	int
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	
	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);

	DECLARE @TITLE VARCHAR(100);
	DECLARE @START_DATE VARCHAR(10);
	DECLARE @END_DATE VARCHAR(10);
	DECLARE @USE_YN CHAR(1)

	SELECT
		@TITLE = DBO.FN_PARAM(@KEY, 'Title'),
		@USE_YN = DBO.FN_PARAM(@KEY, 'UseYN'),
		@START_DATE = DBO.FN_PARAM(@KEY, 'StartDate'),
		@END_DATE = DBO.FN_PARAM(@KEY, 'EndDate')

	SET @WHERE = '1 = 1'	
	IF ISNULL(@TITLE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.TITLE LIKE ''%'' + @TITLE + ''%'''
	END
	
	IF ISNULL(@USE_YN, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND USE_YN = @USE_YN'
	END

	IF ISNULL(@START_DATE, '') <> '' AND ISNULL(@END_DATE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.SDATE >= @START_DATE + '' 00:00:00'' AND A.EDATE <= @END_DATE + '' 23:59:59'''
	END

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = (  
		CASE @ORDER_BY  
			WHEN 1 THEN ' A.EDT_DATE DESC'
			ELSE ' A.SEQ_NO DESC'
		END
	)
	
	SET @SQLSTRING = N'
	SELECT 
		@TOTAL_COUNT = COUNT(1)
	FROM AIR_PROMOTION A WITH(NOLOCK)
	WHERE ' + @WHERE + ';

	SELECT 
		A.SEQ_NO, A.TITLE, A.USE_YN, A.AIRLINE_CODE, A.AIRPORT_CODE, CLASS, 
		SALE_PRICE, SALE_COMM_RATE, A.SDATE, A.EDATE, DEP_SDATE, DEP_EDATE, LIMITED_DATE,
		A.NEW_DATE, A.NEW_CODE, A.EDT_DATE, A.EDT_CODE , A.MIN_PAX_COUNT 
	FROM AIR_PROMOTION A WITH(NOLOCK)
	WHERE ' + @WHERE + '
	ORDER BY ' + @SORT_STRING + '
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY';

	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@TITLE VARCHAR(100),
		@USE_YN CHAR(1),
		@START_DATE VARCHAR(10),
		@END_DATE VARCHAR(10)';

	PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@TITLE,
		@USE_YN,
		@START_DATE,
		@END_DATE;
END

GO
