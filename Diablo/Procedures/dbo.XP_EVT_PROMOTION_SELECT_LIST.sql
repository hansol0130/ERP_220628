USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_EVT_PROMOTION_SELECT_LIST
■ DESCRIPTION				: 프로모션 이벤트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	declare @p5 int
	set @p5=NULL
	exec XP_EVT_PROMOTION_SELECT_LIST @PAGE_INDEX=1,@PAGE_SIZE=20,@KEY=N'secSeq=11&searchWord=&delYN=',@ORDER_BY=0,@TOTAL_COUNT=@p5 output
	select @p5
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2017-04-28		정지용			최초생성
   2018-08-13		박형만			이벤트 상품 코드 추가 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_EVT_PROMOTION_SELECT_LIST]
 	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY	varchar(200),
	@ORDER_BY	int
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);
	DECLARE @SEC_SEQ INT;	
	DECLARE @SEARCH_WORD VARCHAR(50);
	DECLARE @START_DATE VARCHAR(10);
	DECLARE @END_DATE VARCHAR(10);
	DECLARE @DEL_YN CHAR(1);
	DECLARE @CUS_NAME VARCHAR(20);
	DECLARE @HP_NUMBER VARCHAR(11);

	SELECT
		@SEC_SEQ = DBO.FN_PARAM(@KEY, 'secSeq'),
		@SEARCH_WORD = DBO.FN_PARAM(@KEY, 'searchWord'),
		@START_DATE = DBO.FN_PARAM(@KEY, 'startDate'),
		@END_DATE = DBO.FN_PARAM(@KEY, 'endDate'),
		@DEL_YN = DBO.FN_PARAM(@KEY, 'delYN'),
		@CUS_NAME = DBO.FN_PARAM(@KEY, 'cusName'),
		@HP_NUMBER = DBO.FN_PARAM(@KEY, 'hpNumber');

	SET @WHERE = ' A.SEC_SEQ = @SEC_SEQ';
	IF @SEARCH_WORD <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND (CUS_NAME LIKE ''%'' + @SEARCH_WORD + ''%'' OR CONTENTS LIKE ''%'' + @SEARCH_WORD + ''%'')';
	END
	IF ISNULL(@DEL_YN, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND B.DEL_YN = @DEL_YN';
	END
	IF ISNULL(@CUS_NAME, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND B.CUS_NAME LIKE @CUS_NAME + ''%''';
	END
	IF ISNULL(@HP_NUMBER, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND (B.NOR_TEL1 + B.NOR_TEL2 + NOR_TEL3) LIKE @HP_NUMBER + ''%''';
	END
	IF ISNULL(@START_DATE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND B.NEW_DATE >= @START_DATE + '' 00:00:00'''; 
	END 
	IF ISNULL(@END_DATE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND B.NEW_DATE <= @END_DATE + '' 23:59:59''';
	END

	SELECT @SORT_STRING = (  
		CASE @ORDER_BY  
			WHEN 1 THEN ' ISNULL(B.RC_CNT, 0) DESC'
			WHEN 2 THEN ' DEL_YN DESC, A.NEW_DATE DESC'
			WHEN 3 THEN ' DEL_YN DESC, A.CUS_NO ASC , A.NEW_DATE DESC'
			ELSE ' A.NEW_DATE DESC'
		END
	)
	-- 특정글 예외처리
	/*
	IF ISNULL(@ORDER_BY, '')  = 1 
	BEGIN
		SET @WHERE = @WHERE + ' AND B.SEQ_NO NOT IN (388)'
	END
	*/
	SET @SQLSTRING = N'
	SELECT
		@TOTAL_COUNT = COUNT(*)
	FROM EVT_PROMOTION_MASTER A WITH(NOLOCK)
	INNER JOIN EVT_PROMOTION_DETAIL B WITH(NOLOCK) ON A.SEC_SEQ = B.SEC_SEQ
	WHERE ' + @WHERE + ';

	WITH LIST AS 
	(
		SELECT
			B.SEC_SEQ,
			B.SEQ_NO,
			B.CUS_NO,
			B.CUS_NAME,
			B.NOR_TEL1,
			B.NOR_TEL2,
			B.NOR_TEL3,
			B.CONTENTS,
			B.DEL_YN,
			B.NEW_DATE,			
			B.PRO_CODE
		FROM EVT_PROMOTION_MASTER A WITH(NOLOCK)
		INNER JOIN EVT_PROMOTION_DETAIL B ON A.SEC_SEQ = B.SEC_SEQ
		
		WHERE ' + @WHERE + '
	)
	SELECT 
		A.SEC_SEQ,
		A.SEQ_NO,
		A.CUS_NO,
		A.CUS_NAME,
		A.NOR_TEL1,
		A.NOR_TEL2,
		A.NOR_TEL3,
		A.CONTENTS,
		A.NEW_DATE,
		A.DEL_YN,
		A.PRO_CODE,
		ISNULL(B.RC_CNT, 0) AS RC_CNT
	FROM LIST A	
	LEFT JOIN (
		SELECT SEC_SEQ, SEQ_NO, COUNT(1) AS RC_CNT FROM EVT_PROMOTION_DETAIL_RECOMMENDED WITH(NOLOCK) GROUP BY SEC_SEQ, SEQ_NO
	) B ON A.SEC_SEQ = B.SEC_SEQ AND A.SEQ_NO = B.SEQ_NO
	ORDER BY ' + @SORT_STRING + '
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY';
	--PRINT @SQLSTRING;
	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@SEARCH_WORD VARCHAR(50),
		@SEC_SEQ INT,
		@START_DATE VARCHAR(10),
		@END_DATE VARCHAR(10),
		@DEL_YN CHAR(1),
		@CUS_NAME VARCHAR(20),
		@HP_NUMBER VARCHAR(11)'

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@SEARCH_WORD,
		@SEC_SEQ,
		@START_DATE,
		@END_DATE,
		@DEL_YN,
		@CUS_NAME,
		@HP_NUMBER
END
GO
