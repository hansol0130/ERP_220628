USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Server					: 
■ Database					: DIABLO
■ USP_Name					: XP_AGT_SEARCH_LIST_SELECT
■ Description				: 거래처검색 리스트
■ Input Parameter			: 
		
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	DECLARE @PAGE_INDEX INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT, 
	@KEY		VARCHAR(400),
	@ORDER_BY	INT

	SELECT @PAGE_INDEX=1,@PAGE_SIZE=10,@KEY=N'AgentStatus=&AgentType=50&AgentName=&Manager=&AgentCode=&Register=&TelNumber1=&TelNumber2=&TelNumber3=&StartDate=&EndDate=',@ORDER_BY=2

	exec XP_AGT_SEARCH_LIST_SELECT @page_index, @page_size, @total_count output, @key, @order_by
	SELECT @TOTAL_COUNT
■ Author					: 이규식  
■ Date						: 2013-02-25
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-02-25		이규식			최초생성
	2013-03-08		김성호			SORT 조건 추가
	2013-01-06		박형만			인솔자,랜드사,대리점만검색되도록, 회원여부 검색조건추가	,정렬추가	
	2021-11-12		오준혁			국내거래처 추가(제휴사)
-------------------------------------------------------------------------------------------------*/ 

 CREATE PROCEDURE [dbo].[XP_AGT_SEARCH_LIST_SELECT] 
 ( 
 	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY	varchar(300),
	@ORDER_BY	int
) 
AS 
BEGIN 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);

	DECLARE @AGT_STATUS INT
	DECLARE @AGT_TYPE VARCHAR(2)
	DECLARE @AGT_NAME VARCHAR(50)
	DECLARE @MANAGER VARCHAR(20)
	DECLARE @AGT_CODE VARCHAR(10)
	DECLARE @AGT_REGISTER VARCHAR(10)
	DECLARE @NOR_TEL1 VARCHAR(6)
	DECLARE @NOR_TEL2 VARCHAR(5)
	DECLARE @NOR_TEL3 VARCHAR(4)
	DECLARE @START_DATE DATE
	DECLARE @END_DATE DATE
	DECLARE @MEMB_YN CHAR(1)
	DECLARE @AREA_CODE VARCHAR(25)

	SELECT
		@AGT_STATUS = DBO.FN_PARAM(@KEY, 'AgentStatus'),
		@AGT_TYPE = DBO.FN_PARAM(@KEY, 'AgentType'),
		@AGT_NAME = DBO.FN_PARAM(@KEY, 'AgentName'),
		@MANAGER = DBO.FN_PARAM(@KEY, 'Manager'),
		@AGT_CODE = DBO.FN_PARAM(@KEY, 'AgentCode'),
		@AGT_REGISTER = DBO.FN_PARAM(@KEY, 'Register'),
		@NOR_TEL1 = DBO.FN_PARAM(@KEY, 'TelNumber1'),
		@NOR_TEL2 = DBO.FN_PARAM(@KEY, 'TelNumber2'),
		@NOR_TEL3 = DBO.FN_PARAM(@KEY, 'TelNumber3'),
		@START_DATE = DBO.FN_PARAM(@KEY, 'StartDate'),
		@END_DATE = DBO.FN_PARAM(@KEY, 'EndDate'),
		@MEMB_YN = DBO.FN_PARAM(@KEY, 'MembYn'),
		@AREA_CODE = DBO.FN_PARAM(@KEY, 'Area_Code')
		
	SET @WHERE = ''

	IF ISNULL(@AGT_CODE, '') <> ''
		SET @WHERE = @WHERE + ' AND A.AGT_CODE = @AGT_CODE'
	ELSE IF ISNULL(@AGT_REGISTER, '') <> ''
		SET @WHERE = @WHERE + ' AND A.AGT_REGISTER = @AGT_REGISTER'
	ELSE 
	BEGIN

		IF ISNULL(@AGT_STATUS, 0) > 0
			SET @WHERE = @WHERE + ' AND A.SHOW_YN = CASE WHEN @AGT_STATUS = 1 THEN ''Y'' ELSE ''N'' END'

		IF ISNULL(@AGT_TYPE, '') <> ''
			SET @WHERE = @WHERE + ' AND A.AGT_TYPE_CODE = @AGT_TYPE'
		ELSE 
			SET @WHERE = @WHERE + ' AND A.AGT_TYPE_CODE IN ( ''12'' ,''30'',''50'', ''80''  ) '
		
		IF ISNULL(@MEMB_YN, 'N') = 'Y'	
			SET @WHERE = @WHERE + ' AND B.MEM_CODE  IS NOT NULL ' 

		IF ISNULL(@AGT_NAME, '') <> ''
			SET @WHERE = @WHERE + ' AND A.KOR_NAME LIKE ''%'' + @AGT_NAME + ''%'''

		IF ISNULL(@MANAGER, '') <> ''
			SET @WHERE = @WHERE + ' AND B.KOR_NAME = @MANAGER'

		
		IF @AGT_TYPE = '30'
		BEGIN
			IF ISNULL(@NOR_TEL2, '') <> ''
				SET @WHERE = @WHERE + ' AND B.HP_NUMBER1 = @NOR_TEL1 AND B.HP_NUMBER2 = @NOR_TEL2 AND B.HP_NUMBER3 = @NOR_TEL3'
		END
		ELSE
		BEGIN 
			IF ISNULL(@NOR_TEL2, '') <> ''
				SET @WHERE = @WHERE + ' AND A.NOR_TEL1 = @NOR_TEL1 AND A.NOR_TEL2 = @NOR_TEL2 AND A.NOR_TEL3 = @NOR_TEL3'
		END 

		IF @AGT_TYPE = '12'
		BEGIN
			IF ISNULL(@AREA_CODE, 'ALL') <> 'ALL'  AND ISNULL(@AREA_CODE, '') <> ''
				SET @WHERE = @WHERE + ' AND A.AREA_CODE = @AREA_CODE'
		END
				
		IF ISNULL(@START_DATE, '') <> ''
			SET @WHERE = @WHERE + ' AND A.NEW_DATE >= @START_DATE'

		IF ISNULL(@END_DATE, '') <> ''
			SET @WHERE = @WHERE + ' AND A.NEW_DATE < DATEADD(DAY, 1, @END_DATE)'

	END

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = (  
		CASE @ORDER_BY  
			WHEN 2 THEN ' A.NEW_DATE DESC'
			ELSE ' AGT_COM_NAME ASC'
		END
	)

	SET @SQLSTRING = N'
		SELECT @TOTAL_COUNT = COUNT(*)
		FROM AGT_MASTER A
		LEFT JOIN AGT_MEMBER B ON A.AGT_CODE= B.AGT_CODE AND B.MEM_TYPE = 9
		WHERE 1 = 1 ' + @WHERE + ';

		PRINT @TOTAL_COUNT;

		WITH LIST AS 
		(
			SELECT
				A.AGT_CODE , A.NEW_DATE , A.KOR_NAME AS AGT_COM_NAME , A.AREA_CODE 
			FROM AGT_MASTER A 
			LEFT JOIN AGT_MEMBER B ON B.AGT_CODE = A.AGT_CODE AND B.MEM_TYPE = 9
			WHERE 1=1 ' + @WHERE + '
			ORDER BY '+ @SORT_STRING + '
			OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
			ROWS ONLY
		)
		SELECT
			B.AGT_CODE,
			B.SHOW_YN,
			CASE WHEN B.SHOW_YN = ''Y'' THEN 1 ELSE 0 END AS AGT_STATUS,
			B.AGT_TYPE_CODE,			B.KOR_NAME,
			B.AGT_REGISTER,				C.KOR_NAME AS AGT_MGR_NAME,
			(CASE WHEN B.AGT_TYPE_CODE = ''30'' THEN HP_NUMBER1 ELSE B.NOR_TEL1 END) AS NOR_TEL1,
			(CASE WHEN B.AGT_TYPE_CODE = ''30'' THEN HP_NUMBER2 ELSE B.NOR_TEL2 END) AS NOR_TEL2,
			(CASE WHEN B.AGT_TYPE_CODE = ''30'' THEN HP_NUMBER3 ELSE B.NOR_TEL3 END) AS NOR_TEL3, 					
			C.EMAIL AS AGT_MGR_EMAIL,
			B.NEW_DATE,
			(CASE WHEN A.AREA_CODE =''123'' THEN ''부산'' WHEN  A.AREA_CODE =''122'' THEN ''본사'' ELSE ''전체'' END) AS AREA_CODE
		FROM LIST A
		INNER JOIN AGT_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
		LEFT JOIN AGT_MEMBER C WITH(NOLOCK) ON C.AGT_CODE = B.AGT_CODE AND C.MEM_TYPE = 9
		ORDER BY '+ @SORT_STRING ;




		--PRINT @SQLSTRING
		SET @PARMDEFINITION = N'
			@PAGE_INDEX INT,
			@PAGE_SIZE INT,
			@AGT_STATUS INT,
			@AGT_TYPE VARCHAR(2),
			@AGT_NAME VARCHAR(50),
			@MANAGER VARCHAR(20),
			@AGT_CODE VARCHAR(10),
			@AGT_REGISTER VARCHAR(10),
			@NOR_TEL1 VARCHAR(6),
			@NOR_TEL2 VARCHAR(5),
			@NOR_TEL3 VARCHAR(4),
			@START_DATE DATE,
			@END_DATE DATE,
			@AREA_CODE VARCHAR(25),
			@TOTAL_COUNT INT OUTPUT';


		EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
			@PAGE_INDEX,
			@PAGE_SIZE,
			@AGT_STATUS,
			@AGT_TYPE,
			@AGT_NAME,
			@MANAGER,
			@AGT_CODE,
			@AGT_REGISTER,
			@NOR_TEL1,
			@NOR_TEL2,
			@NOR_TEL3,
			@START_DATE,
			@END_DATE,
			@AREA_CODE,
			@TOTAL_COUNT OUTPUT;



END
GO
