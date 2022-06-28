USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ARG_INVOICE_LIST_SELECT
■ DESCRIPTION				: 정산 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	DECLARE @TOTAL_COUNT INT
	EXEC DBO.XP_ARG_INVOICE_LIST_SELECT 1, 100, @TOTAL_COUNT OUTPUT, 'ProductCode=&ArrangeStatus=&CfmStatus=&StartDate=&EndDate=&NewDate1=2013-10-10&NewDate2=2013-10-14&AgentName=&ArgSeqNo=&AgentCode=92685', 1

	SELECT @TOTAL_COUNT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-06-02		김완기			최초생성
   2014-01-14		김성호			쿼리수정
   2014-01-14		정지용			쿼리수정 (정산진행 / 정산완료 / 지급완료 / 지급불가 / 인보이스 만 보이겡)
   2014-04-07		김성호			스키마 개편에 맞게 재 생성
   2014-04-28		정지용			팀 / 사원 검색 추가
   2014-11-26		정지용			사용안함, 추가  == 부분 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_INVOICE_LIST_SELECT]
 	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY	varchar(200),
	@ORDER_BY	int
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);

	DECLARE @ARG_CODE VARCHAR(12)
	DECLARE @PRO_CODE VARCHAR(20)
	DECLARE @TITLE VARCHAR(200)
	DECLARE @ARG_TYPE INT
	DECLARE @ARG_STATUS INT
	DECLARE @START_DATE VARCHAR(10)
	DECLARE @END_DATE VARCHAR(10)
	DECLARE @AGT_CODE VARCHAR(10)
	DECLARE @AGT_NAME VARCHAR(50)
	DECLARE @SEARCH_TYPE CHAR(1)
	DECLARE @TEAM_CODE	VARCHAR(4)
	DECLARE @EMP_CODE	VARCHAR(7)

	SELECT
		@ARG_CODE = DBO.FN_PARAM(@KEY, 'ArrangeCode'),
		@PRO_CODE = DBO.FN_PARAM(@KEY, 'ProductCode'),
		@TITLE = DBO.FN_PARAM(@KEY, 'Title'),
		@ARG_TYPE = DBO.FN_PARAM(@KEY, 'ArrangeType'),
		@ARG_STATUS = DBO.FN_PARAM(@KEY, 'ArrangeStatus'),
		@START_DATE = DBO.FN_PARAM(@KEY, 'StartDate'),
		@END_DATE = DBO.FN_PARAM(@KEY, 'EndDate'),
		@AGT_CODE = DBO.FN_PARAM(@KEY, 'AgentCode'),
		@AGT_NAME = DBO.FN_PARAM(@KEY, 'AgentName'),
		@SEARCH_TYPE = DBO.FN_PARAM(@KEY, 'SearchType'),
		@TEAM_CODE = DBO.FN_PARAM(@KEY, 'TeamCode'),
		@EMP_CODE = DBO.FN_PARAM(@KEY, 'EmpCode')

	-- 정산페이지는 무조건 @ARG_TYPE = 4
	SET @WHERE = 'WHERE B.ARG_TYPE = @ARG_TYPE AND ARG_STATUS <> 8' -- 확취 제외 동호
	
	IF ISNULL(@PRO_CODE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.PRO_CODE LIKE @PRO_CODE + ''%'''
	END
	ELSE
	BEGIN
		IF ISNULL(@ARG_CODE, '') <> ''
			SET @WHERE = @WHERE + ' AND A.ARG_CODE = @ARG_CODE'

		IF ISNULL(@TITLE, '') <> ''
			SET @WHERE = @WHERE + ' AND B.TITLE LIKE ''%'' + @TITLE + ''%'''

		IF ISNULL(@ARG_STATUS, 0) > 0
			SET @WHERE = @WHERE + ' AND B.ARG_STATUS = @ARG_STATUS'


		IF ISNULL(@SEARCH_TYPE, '') = '1'
		BEGIN
			IF ISNULL(@START_DATE, '') <> ''
				SET @WHERE = @WHERE + ' AND CONVERT(VARCHAR(10), B.DEP_DATE, 120) >= @START_DATE'

			IF ISNULL(@END_DATE, '') <> ''
				SET @WHERE = @WHERE + ' AND CONVERT(VARCHAR(10), B.DEP_DATE, 120) <= @END_DATE'
		END
		ELSE IF ISNULL(@SEARCH_TYPE, '') = '2'
		BEGIN
			IF ISNULL(@START_DATE, '') <> ''
				SET @WHERE = @WHERE + ' AND CONVERT(VARCHAR(10), B.NEW_DATE, 120) >= @START_DATE'

			IF ISNULL(@END_DATE, '') <> ''
				SET @WHERE = @WHERE + ' AND CONVERT(VARCHAR(10), B.NEW_DATE, 120) <= @END_DATE'
		END


		IF ISNULL(@AGT_NAME, '') <> ''
			SET @WHERE = @WHERE + ' AND D.KOR_NAME LIKE ''%'' + @AGT_NAME + ''%'''
	END

	IF ISNULL(@EMP_CODE, '') <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND P.NEW_CODE = @EMP_CODE'
		END
	ELSE
		BEGIN
			IF ISNULL(@TEAM_CODE, '') <> ''
				BEGIN
					SET @WHERE = @WHERE + ' AND P.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE = @TEAM_CODE)'
				END
		END

	IF ISNULL(@AGT_CODE, '') <> '' 
		SET @WHERE = @WHERE + ' AND A.AGT_CODE = @AGT_CODE'

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = (  
		CASE @ORDER_BY  
			WHEN 1 THEN ' A.DEP_DATE DESC'
			WHEN 2 THEN ' A.PRICE_PER_ADT DESC'
			WHEN 3 THEN ' A.PRICE_TOTAL DESC'
			ELSE ' A.NEW_DATE DESC'
		END
	)
		
	SET @SQLSTRING = N'
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM ARG_MASTER A WITH(NOLOCK)
	INNER JOIN ARG_DETAIL B WITH(NOLOCK) ON A.ARG_CODE = B.ARG_CODE
	LEFT JOIN ARG_INVOICE C WITH(NOLOCK) ON B.ARG_CODE = C.ARG_CODE AND B.GRP_SEQ_NO = C.GRP_SEQ_NO
	INNER JOIN AGT_MASTER D WITH(NOLOCK) ON A.AGT_CODE = D.AGT_CODE
	LEFT OUTER JOIN PKG_DETAIL P WITH(NOLOCK) ON A.PRO_CODE = P.PRO_CODE
	' + @WHERE + '

	SELECT
		A.ARG_CODE
		, A.PRO_CODE
		, B.GRP_SEQ_NO
		, B.TITLE
		, B.ARG_STATUS
		, D.KOR_NAME AS [AGT_NAME]
		, B.DEP_DATE
		, B.ARR_DATE
		, C.CURRENCY
		, (SELECT COUNT(*) FROM ARG_CONNECT AA WITH(NOLOCK) WHERE AA.ARG_CODE = B.ARG_CODE AND AA.GRP_SEQ_NO = B.GRP_SEQ_NO) AS [CUS_COUNT]

		--사용안함, (SELECT SUM(ISNULL(AA.ADT_PRICE, 0)) FROM ARG_INVOICE_DETAIL AA WITH(NOLOCK) WHERE B.ARG_CODE = AA.ARG_CODE AND B.GRP_SEQ_NO = AA.GRP_SEQ_NO) AS [PRICE_PER_ADT]  
		--사용안함, (SELECT (SUM(ISNULL(AA.ADT_PRICE, 0)) * B.ADT_COUNT) + (SUM(ISNULL(AA.CHD_PRICE, 0)) * B.CHD_COUNT) + (SUM(ISNULL(AA.INF_PRICE, 0)) * B.INF_COUNT) FROM ARG_INVOICE_DETAIL AA WITH(NOLOCK) WHERE B.ARG_CODE = AA.ARG_CODE AND B.GRP_SEQ_NO = AA.GRP_SEQ_NO) AS [PRICE_TOTAL]

		, (SELECT SUM(AA.PRICE * AA.PERSONS)  FROM ARG_INVOICE_DETAIL AA WITH(NOLOCK) WHERE B.ARG_CODE = AA.ARG_CODE AND B.GRP_SEQ_NO = AA.GRP_SEQ_NO) AS [PRICE_TOTAL] --추가

--		, (SELECT CASE WHEN ISNULL(B.ADT_COUNT, 0) > 0 THEN ISNULL(SUM(AA.ADT_PRICE), 0) / B.ADT_COUNT ELSE ISNULL(SUM(AA.ADT_PRICE), 0) END FROM ARG_INVOICE_DETAIL AA WITH(NOLOCK) WHERE B.ARG_CODE = AA.ARG_CODE AND B.GRP_SEQ_NO = AA.GRP_SEQ_NO) AS PRICE_PER_ADT
--		, (SELECT ISNULL(SUM(AA.ADT_PRICE), 0) + ISNULL(SUM(AA.CHD_PRICE), 0) + ISNULL(SUM(AA.INF_PRICE), 0) FROM ARG_INVOICE_DETAIL AA WITH(NOLOCK) WHERE B.ARG_CODE = AA.ARG_CODE AND B.GRP_SEQ_NO = AA.GRP_SEQ_NO) AS PRICE_TOTAL
	FROM ARG_MASTER A WITH(NOLOCK)
	INNER JOIN ARG_DETAIL B WITH(NOLOCK) ON A.ARG_CODE = B.ARG_CODE
	LEFT JOIN ARG_INVOICE C WITH(NOLOCK) ON B.ARG_CODE = C.ARG_CODE AND B.GRP_SEQ_NO = C.GRP_SEQ_NO
	INNER JOIN AGT_MASTER D WITH(NOLOCK) ON A.AGT_CODE = D.AGT_CODE
	LEFT OUTER JOIN PKG_DETAIL P WITH(NOLOCK) ON A.PRO_CODE = P.PRO_CODE
	' + @WHERE + '
	ORDER BY '+ @SORT_STRING + '
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY'
			
	--PRINT @SQLSTRING

	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@ARG_CODE VARCHAR(12),
		@PRO_CODE VARCHAR(20),
		@TITLE VARCHAR(200),
		@AGT_NAME VARCHAR(50),
		@ARG_TYPE INT,
	    @ARG_STATUS INT,
		@START_DATE VARCHAR(10),
		@END_DATE VARCHAR(10),
		@AGT_CODE VARCHAR(10),
		@TEAM_CODE	VARCHAR(4),
		@EMP_CODE	VARCHAR(7)';


	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@ARG_CODE,
		@PRO_CODE,
		@TITLE,
		@AGT_NAME,
		@ARG_TYPE,
		@ARG_STATUS,
		@START_DATE,
		@END_DATE,
		@AGT_CODE,
		@TEAM_CODE,
		@EMP_CODE;
END 

/*
ALTER PROC [dbo].[XP_ARG_INVOICE_LIST_SELECT]
 	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY	varchar(200),
	@ORDER_BY	int
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);
	
	DECLARE @ARG_SEQ_NO INT
	DECLARE @PRO_CODE VARCHAR(20)
	DECLARE @ARG_DETAIL_STATUS INT
	DECLARE @CFM_STATUS VARCHAR(1)
	DECLARE @START_DATE VARCHAR(10)
	DECLARE @END_DATE VARCHAR(10)
	DECLARE @NEW_DATE1 VARCHAR(10)
	DECLARE @NEW_DATE2 VARCHAR(10)
	DECLARE @NEW_CODE VARCHAR(7)
	DECLARE @AGT_NAME VARCHAR(50)
	DECLARE @AGT_CODE VARCHAR(10)
	DECLARE @TEAM_CODE	VARCHAR(4)
	DECLARE @EMP_CODE	VARCHAR(7)

	SELECT
		@ARG_SEQ_NO = DBO.FN_PARAM(@KEY, 'ArgSeqNo'),
		@PRO_CODE = DBO.FN_PARAM(@KEY, 'ProductCode'),
		@ARG_DETAIL_STATUS = DBO.FN_PARAM(@KEY, 'ArrangeStatus'),
		@CFM_STATUS = DBO.FN_PARAM(@KEY, 'CfmStatus'),
		@START_DATE = DBO.FN_PARAM(@KEY, 'StartDate'),
		@END_DATE = DBO.FN_PARAM(@KEY, 'EndDate'), 
		@NEW_DATE1 = DBO.FN_PARAM(@KEY, 'NewDate1'),
		@NEW_DATE2 = DBO.FN_PARAM(@KEY, 'NewDate2'),
		@AGT_CODE = DBO.FN_PARAM(@KEY, 'AgentCode'),
		@AGT_NAME = DBO.FN_PARAM(@KEY, 'AgentName'),
		@TEAM_CODE = DBO.FN_PARAM(@KEY, 'TeamCode'),
		@EMP_CODE = DBO.FN_PARAM(@KEY, 'EmpCode')

	SET @WHERE = ''
	
	IF ISNULL(@AGT_CODE, 0) > 0
		BEGIN
			SET @WHERE = @WHERE + ' AND A.AGT_CODE = @AGT_CODE'
		END
	
	IF ISNULL(@ARG_SEQ_NO, 0) > 0
		BEGIN
			SET @WHERE = @WHERE + ' AND A.ARG_SEQ_NO = @ARG_SEQ_NO'
		END
	ELSE
		BEGIN
			IF ISNULL(@PRO_CODE, '') <> ''
				SET @WHERE = @WHERE + ' AND A.PRO_CODE LIKE @PRO_CODE + ''%'''

			--IF ISNULL(@ARG_DETAIL_STATUS, 0) >= 0 이동호 > 수정했음
			IF ISNULL(@ARG_DETAIL_STATUS, 0) > 0
				SET @WHERE = @WHERE + ' AND B.ARG_DETAIL_STATUS = @ARG_DETAIL_STATUS'

			IF ISNULL(@EMP_CODE, '') <> ''
				BEGIN
					SET @WHERE = @WHERE + ' AND B.CFM_CODE = @EMP_CODE'
				END
			ELSE
				BEGIN
					IF ISNULL(@TEAM_CODE, '') <> ''
						BEGIN
							SET @WHERE = @WHERE + ' AND B.CFM_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE = @TEAM_CODE)'
						END
				END

			IF ISNULL(@CFM_STATUS, '') <> ''
				IF @CFM_STATUS = 'Y'
					BEGIN
						SET @WHERE = @WHERE + ' AND ISNULL(B.CFM_CODE, '''') <> '''' '
					END
				ELSE IF @CFM_STATUS = 'N'
					BEGIN
						SET @WHERE = @WHERE + ' AND ISNULL(B.CFM_CODE, '''') = '''' '
					END

			IF ISNULL(@START_DATE, '') <> ''
				SET @WHERE = @WHERE + ' AND A.DEP_DATE >= @START_DATE'

			IF ISNULL(@END_DATE, '') <> ''
				SET @WHERE = @WHERE + ' AND A.ARR_DATE < DATEADD(d, 1, @END_DATE)'

			IF ISNULL(@NEW_DATE1, '') <> ''
				SET @WHERE = @WHERE + ' AND C.NEW_DATE >= @NEW_DATE1'

			IF ISNULL(@NEW_DATE2, '') <> ''
				SET @WHERE = @WHERE + ' AND C.NEW_DATE < DATEADD(d, 1, @NEW_DATE2)'

			IF ISNULL(@AGT_NAME, '') <> ''
				SET @WHERE = @WHERE + ' AND DBO.XN_COM_GET_TEAM_NAME(C.NEW_CODE) LIKE ''%'' + @AGT_NAME + ''%'''
		END

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = (  
		CASE @ORDER_BY  
			WHEN 1 THEN ' A.DEP_DATE DESC'
			WHEN 2 THEN ' A.PRICE_PER_ADT DESC'
			WHEN 3 THEN ' A.PRICE_TOTAL DESC'
			ELSE ' A.NEW_DATE DESC'
		END
	)

	
	SET @SQLSTRING = N'	
		  SELECT @TOTAL_COUNT = COUNT(A.ARG_SEQ_NO)
			FROM ARG_MASTER A WITH(NOLOCK) 
		   INNER JOIN ARG_DETAIL B WITH(NOLOCK) ON (A.ARG_SEQ_NO = B.ARG_SEQ_NO AND B.ARG_TYPE =''2'')
		   INNER JOIN ARG_INVOICE C WITH(NOLOCK) ON (A.ARG_SEQ_NO = C.ARG_SEQ_NO AND B.GRP_SEQ_NO = C.GRP_SEQ_NO)
		   WHERE A.ARG_SEQ_NO IS NOT NULL AND ARG_DETAIL_STATUS IN ( ''3'',''4'',''5'',''7'',''8'' ) ' + @WHERE + ';

		SELECT  A.*
		  FROM (SELECT A.ARG_SEQ_NO
					  ,A.AGT_CODE
					  ,A.PRO_CODE
					  ,A.RES_CODE
					  ,A.DEP_DATE
					  ,A.ARR_DATE
					  ,B.GRP_SEQ_NO
					  ,B.ARG_DETAIL_STATUS
					  ,B.ARG_TYPE
					  ,B.CFM_CODE
					  ,B.CFM_DATE
					  ,B.ADT_COUNT
					  ,B.CHD_COUNT
					  ,B.INF_COUNT
					  ,B.FOC_COUNT
					  ,C.NEW_DATE
					  ,C.NEW_CODE
					  ,DBO.XN_COM_GET_EMP_NAME(C.NEW_CODE) AS NEW_NAME
					  ,DBO.XN_COM_GET_TEAM_NAME(C.NEW_CODE) AS NEW_TEAM_NAME
					  ,(SELECT CASE WHEN ISNULL(B.ADT_COUNT, 0) > 0 THEN ISNULL(SUM(D.ADT_PRICE), 0) / B.ADT_COUNT ELSE ISNULL(SUM(D.ADT_PRICE), 0) END FROM ARG_INVOICE_DETAIL D WITH(NOLOCK) WHERE A.ARG_SEQ_NO = D.ARG_SEQ_NO AND B.GRP_SEQ_NO = D.GRP_SEQ_NO) AS PRICE_PER_ADT
					  ,(SELECT ISNULL(SUM(D.ADT_PRICE), 0) + ISNULL(SUM(D.CHD_PRICE), 0) + ISNULL(SUM(D.INF_PRICE), 0) FROM ARG_INVOICE_DETAIL D WITH(NOLOCK) WHERE A.ARG_SEQ_NO = D.ARG_SEQ_NO AND B.GRP_SEQ_NO = D.GRP_SEQ_NO) AS PRICE_TOTAL
					  ,CASE WHEN B.ARG_DETAIL_STATUS = ''4'' THEN DBO.XN_COM_GET_EMP_NAME(B.EDT_CODE) END AS INVOICE_CFM_NAME
					  ,CASE WHEN B.ARG_DETAIL_STATUS = ''4'' THEN B.EDT_DATE END AS INVOICE_CFM_DATE
			     FROM ARG_MASTER A WITH(NOLOCK) 
			    INNER JOIN ARG_DETAIL B WITH(NOLOCK) ON (A.ARG_SEQ_NO = B.ARG_SEQ_NO AND B.ARG_TYPE =''2'')
			    INNER JOIN ARG_INVOICE C WITH(NOLOCK) ON (A.ARG_SEQ_NO = C.ARG_SEQ_NO AND B.GRP_SEQ_NO = C.GRP_SEQ_NO)
			    WHERE A.ARG_SEQ_NO IS NOT NULL AND ARG_DETAIL_STATUS IN ( ''3'',''4'',''5'',''7'',''8'' ) ' + @WHERE + ') A 				
			ORDER BY '+ @SORT_STRING + '
			OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
			ROWS ONLY '
			
		PRINT @SQLSTRING

		SET @PARMDEFINITION = N'
			@PAGE_INDEX INT,
			@PAGE_SIZE INT,
	        @PRO_CODE VARCHAR(20),
		    @ARG_DETAIL_STATUS INT,
		    @CFM_STATUS VARCHAR(1),
		    @START_DATE VARCHAR(10),
		    @END_DATE VARCHAR(10),
		    @NEW_DATE1 VARCHAR(10),
		    @NEW_DATE2 VARCHAR(10),
			@AGT_CODE VARCHAR(10),
			@AGT_NAME VARCHAR(50),
			@ARG_SEQ_NO INT,
			@EMP_CODE	VARCHAR(7),
			@TEAM_CODE	VARCHAR(4),
			@TOTAL_COUNT INT OUTPUT';


		EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
			@PAGE_INDEX,
			@PAGE_SIZE,
			@PRO_CODE,
			@ARG_DETAIL_STATUS,
			@CFM_STATUS,
			@START_DATE,
			@END_DATE,
			@NEW_DATE1,
			@NEW_DATE2,
			@AGT_CODE,
			@AGT_NAME,
			@ARG_SEQ_NO,
			@EMP_CODE,
			@TEAM_CODE,
			@TOTAL_COUNT OUTPUT;
END 
*/



GO
