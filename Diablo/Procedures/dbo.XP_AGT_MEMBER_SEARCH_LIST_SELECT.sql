USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Server					: 
■ Database					: DIABLO
■ USP_Name					: XP_AGT_MEMBER_SEARCH_LIST_SELECT
■ Description				: 거래처 직원검색 리스트
■ Input Parameter			: 
		
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	DECLARE @PAGE_INDEX INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT, 
	@KEY		VARCHAR(400),
	@ORDER_BY	INT

	SELECT @PAGE_INDEX=1,@PAGE_SIZE=20,@KEY=N'AgentType=&MemberType=&AgentName=참좋은&MemberName=&MemberCode=&TelNumber1=&TelNumber2=&TelNumber3=&HpNumber1=&HpNumber2=&HpNumber3=&Email=&StartDate=&EndDate=',@ORDER_BY=3

	exec XP_AGT_MEMBER_SEARCH_LIST_SELECT @page_index, @page_size, @total_count output, @key, @order_by
	SELECT @TOTAL_COUNT
■ Author					: 이규식  
■ Date						: 2013-02-25
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-02-28		이규식			최초생성  
	2013-03-07		김성호			전화번호 별칭 수정
	2013-03-08		김성호			SORT 조건 추가
	2013-06-10		김성호			WITH(NOLOCK) 추가
-------------------------------------------------------------------------------------------------*/ 

 CREATE PROCEDURE [dbo].[XP_AGT_MEMBER_SEARCH_LIST_SELECT] 
 ( 
 	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY	varchar(200),
	@ORDER_BY	int
) 
AS 
BEGIN 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);

	DECLARE @WORK_TYPE INT
	DECLARE @AGT_TYPE VARCHAR(2)
	DECLARE @MEM_TYPE VARCHAR(2) -- 수정
	DECLARE @AGT_NAME VARCHAR(100)
	DECLARE @MEM_NAME VARCHAR(20)
	DECLARE @MEM_CODE VARCHAR(7)
	DECLARE @NOR_TEL1 VARCHAR(6)
	DECLARE @NOR_TEL2 VARCHAR(5)
	DECLARE @NOR_TEL3 VARCHAR(4)
	DECLARE @HP_NUMBER1 VARCHAR(6)
	DECLARE @HP_NUMBER2 VARCHAR(5)
	DECLARE @HP_NUMBER3 VARCHAR(4)
	DECLARE @EMAIL VARCHAR(40)
	DECLARE @START_DATE DATE
	DECLARE @END_DATE DATE
	
	SELECT
		@WORK_TYPE = DBO.FN_PARAM(@KEY, 'WorkType'),
		@AGT_TYPE = DBO.FN_PARAM(@KEY, 'AgentType'),
		@MEM_TYPE = DBO.FN_PARAM(@KEY, 'MemberType'),
		@AGT_NAME = DBO.FN_PARAM(@KEY, 'AgentName'),
		@MEM_NAME = DBO.FN_PARAM(@KEY, 'MemberName'),
		@MEM_CODE = DBO.FN_PARAM(@KEY, 'MemberCode'),
		@NOR_TEL1 = DBO.FN_PARAM(@KEY, 'TelNumber1'),
		@NOR_TEL2 = DBO.FN_PARAM(@KEY, 'TelNumber2'),
		@NOR_TEL3 = DBO.FN_PARAM(@KEY, 'TelNumber3'),
		@HP_NUMBER1 = DBO.FN_PARAM(@KEY, 'HpNumber1'),
		@HP_NUMBER2 = DBO.FN_PARAM(@KEY, 'HpNumber2'),
		@HP_NUMBER3 = DBO.FN_PARAM(@KEY, 'HpNumber3'),
		@EMAIL = DBO.FN_PARAM(@KEY, 'Email'),
		@START_DATE = DBO.FN_PARAM(@KEY, 'StartDate'),
		@END_DATE = DBO.FN_PARAM(@KEY, 'EndDate')
		
	SET @WHERE = ''

	IF ISNULL(@MEM_CODE, '') <> ''
		SET @WHERE = @WHERE + ' AND A.MEM_CODE = @MEM_CODE'
	ELSE IF ISNULL(@MEM_NAME, '') <> ''
		SET @WHERE = @WHERE + ' AND A.KOR_NAME = @MEM_NAME'
	ELSE IF ISNULL(@AGT_NAME, '') <> ''
			SET @WHERE = @WHERE + ' AND B.KOR_NAME LIKE ''%'' + @AGT_NAME + ''%'''
	ELSE IF ISNULL(@NOR_TEL2, '') <> ''
			SET @WHERE = @WHERE + ' AND A.TEL_NUMBER1 = @NOR_TEL1 AND A.TEL_NUMBER2 = @NOR_TEL2 AND A.TEL_NUMBER3 = @NOR_TEL3'
	ELSE IF ISNULL(@HP_NUMBER2, '') <> ''
			SET @WHERE = @WHERE + ' AND A.HP_NUMBER1 = @HP_NUMBER1 AND A.HP_NUMBER2 = @HP_NUMBER2 AND A.HP_NUMBER3 = @HP_NUMBER3'
	ELSE 
	BEGIN
		IF ISNULL(@WORK_TYPE, 0) > 0
			SET @WHERE = @WHERE + ' AND A.WORK_TYPE = @WORK_TYPE'

		IF ISNULL(@AGT_TYPE, '') <> ''
			SET @WHERE = @WHERE + ' AND B.AGT_TYPE_CODE = @AGT_TYPE'

		IF ISNULL(@MEM_TYPE, '') > '' -- 수정
			SET @WHERE = @WHERE + ' AND A.MEM_TYPE = @MEM_TYPE'

		IF ISNULL(@EMAIL, '') <> ''
			SET @WHERE = @WHERE + ' AND A.EMAIL = @EMAIL'


		IF ISNULL(@START_DATE, '') <> ''
			SET @WHERE = @WHERE + ' AND A.NEW_DATE >= @START_DATE'

		IF ISNULL(@END_DATE, '') <> ''
			SET @WHERE = @WHERE + ' AND A.NEW_DATE < DATEADD(DAY, 1, @END_DATE)'
	END

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = (  
		CASE @ORDER_BY  
			WHEN 2 THEN ' A.KOR_NAME ASC'
			WHEN 3 THEN ' A.NEW_DATE DESC'
			ELSE ' B.KOR_NAME ASC'
		END
	)

	SET @SQLSTRING = N'
		SELECT @TOTAL_COUNT = COUNT(*)
		FROM AGT_MEMBER A WITH(NOLOCK)
		INNER JOIN AGT_MASTER B WITH(NOLOCK) ON B.AGT_CODE = A.AGT_CODE
		WHERE 1 = 1 ' + @WHERE + ';

		WITH LIST AS 
		(
			SELECT
				A.MEM_CODE
			FROM AGT_MEMBER A WITH(NOLOCK)
			INNER JOIN AGT_MASTER B WITH(NOLOCK) ON B.AGT_CODE = A.AGT_CODE
			WHERE 1=1 ' + @WHERE + '
			ORDER BY '+ @SORT_STRING + '
			OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
			ROWS ONLY
		)
		SELECT
			A.WORK_TYPE,
			A.MEM_CODE,
			A.KOR_NAME ,
			B.AGT_TYPE_CODE,
			B.KOR_NAME AS AGT_NAME,
			A.MEM_TYPE,
			--A.NOR_TEL1 AS [TEL_NUMBER1],
			--A.NOR_TEL2 AS [TEL_NUMBER2],
			--A.NOR_TEL3 AS [TEL_NUMBER3],
			A.TEL_NUMBER1 AS [TEL_NUMBER1],
			A.TEL_NUMBER2 AS [TEL_NUMBER2],
			A.TEL_NUMBER3 AS [TEL_NUMBER3],
			A.HP_NUMBER1,
			A.HP_NUMBER2,
			A.HP_NUMBER3,
			A.EMAIL,
			A.NEW_DATE
		FROM LIST Z
		INNER JOIN AGT_MEMBER A WITH(NOLOCK) ON Z.MEM_CODE = A.MEM_CODE
		INNER JOIN AGT_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
		ORDER BY '+ @SORT_STRING

		SET @PARMDEFINITION = N'
			@PAGE_INDEX INT,
			@PAGE_SIZE INT,
			@WORK_TYPE INT,
			@AGT_TYPE VARCHAR(2),
			@MEM_TYPE INT,
			@AGT_NAME VARCHAR(100),
			@MEM_NAME VARCHAR(20),
			@MEM_CODE VARCHAR(7),
			@NOR_TEL1 VARCHAR(6),
			@NOR_TEL2 VARCHAR(5),
			@NOR_TEL3 VARCHAR(4),
			@HP_NUMBER1 VARCHAR(6),
			@HP_NUMBER2 VARCHAR(5),
			@HP_NUMBER3 VARCHAR(4),
			@EMAIL VARCHAR(40),
			@START_DATE DATE,
			@END_DATE DATE,
			@TOTAL_COUNT INT OUTPUT';

		--print @SQLSTRING

		EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
			@PAGE_INDEX,
			@PAGE_SIZE,
			@WORK_TYPE,
			@AGT_TYPE,
			@MEM_TYPE,
			@AGT_NAME,
			@MEM_NAME,
			@MEM_CODE,
			@NOR_TEL1,
			@NOR_TEL2,
			@NOR_TEL3,
			@HP_NUMBER1,
			@HP_NUMBER2,
			@HP_NUMBER3,
			@EMAIL,
			@START_DATE,
			@END_DATE,
			@TOTAL_COUNT OUTPUT;

END


GO
