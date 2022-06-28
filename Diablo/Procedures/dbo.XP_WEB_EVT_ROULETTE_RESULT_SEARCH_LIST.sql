USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_WEB_EVT_ROULETTE_RESULT_SEARCH_LIST
■ DESCRIPTION				: 룰렛 이벤트 당첨내역 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
declare @p5 int
set @p5=4
exec XP_WEB_EVT_ROULETTE_RESULT_SEARCH_LIST @PAGE_INDEX=1,@PAGE_SIZE=9999,@KEY=N'CusNo=15',@ORDER_BY=0,@TOTAL_COUNT=@p5 output
select @p5
SELECT * FROM EVT_ROULETTE_GIFTICON_LOG
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-05-16		정지용
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_EVT_ROULETTE_RESULT_SEARCH_LIST]
 	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY	varchar(200),
	@ORDER_BY	int
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	
	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);

	DECLARE @CUS_NO INT
	DECLARE @START_DATE VARCHAR(10)
	DECLARE @END_DATE VARCHAR(10)

	SELECT
		@CUS_NO = DBO.FN_PARAM(@KEY, 'CusNo'),
		@START_DATE = DBO.FN_PARAM(@KEY, 'StartDate'),
		@END_DATE = DBO.FN_PARAM(@KEY, 'EndDate')

	SET @WHERE = 'COP_USE_YN = ''Y'''	
	IF ISNULL(@CUS_NO, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.CUS_CODE = @CUS_NO'
	END

	IF ISNULL(@START_DATE, '') <> '' AND ISNULL(@END_DATE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND (CONVERT(VARCHAR(10), A.EDT_DATE, 23) >= @START_DATE AND CONVERT(VARCHAR(10), A.EDT_DATE, 23) <= @END_DATE)'
	END

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = (  
		CASE @ORDER_BY  
			WHEN 1 THEN ' A.NEW_DATE DESC'
			ELSE ' A.EDT_DATE DESC'
		END
	)

	SET @SQLSTRING = N'
	SELECT 
		@TOTAL_COUNT = COUNT(1)
	FROM EVT_ROULETTE A WITH(NOLOCK)
	INNER JOIN CUS_MEMBER B WITH(NOLOCK) ON A.CUS_CODE = B.CUS_NO
	WHERE ' + @WHERE + ';

	SELECT 
		A.CUS_CODE AS CUS_NO, B.CUS_ID, B.CUS_NAME, B.EMAIL, B.NOR_TEL1, B.NOR_TEL2, B.NOR_TEL3, C.TEL_NUMBER AS GIFTI_TELNUMBER,
		A.EVT_RESULT, A.EVT_PRODUCT, A.EDT_DATE
	FROM EVT_ROULETTE A WITH(NOLOCK)
	INNER JOIN CUS_MEMBER B WITH(NOLOCK) ON A.CUS_CODE = B.CUS_NO
	LEFT JOIN EVT_ROULETTE_GIFTICON_LOG C WITH(NOLOCK) ON A.EVT_ROU_SEQ = C.EVT_ROU_SEQ AND C.LOG_TYPE = 0
	WHERE ' + @WHERE + '
	ORDER BY ' + @SORT_STRING + '
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY';

	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@CUS_NO INT,
		@START_DATE VARCHAR(10),
		@END_DATE VARCHAR(10)';

	PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@CUS_NO,
		@START_DATE,
		@END_DATE;
END
GO
