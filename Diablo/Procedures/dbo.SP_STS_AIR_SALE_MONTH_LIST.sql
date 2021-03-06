USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_STS_AIR_SALE_MONTH_LIST
■ DESCRIPTION				: 항공 월별 판매실적 리스트
■ INPUT PARAMETER			: 
	@SELECT_TYPE	INT		: 구분 (0: 항공, 1: 판매자, 2: 부서)
	@COMPANY_TYPE	INT		: 지점구분 (0: 전체, 1: 본사, 2: 부산)
	@PRICE_TYPE		INT		: 금액타입 (1: NET+TAX, 2: NET)
	@REGION_TYPE	CHAR(1) : 1: 해외, 2: 국내
	@YEAR	VARCHAR(4)		: 기준 년
	@MONTH	VARCHAR(2)		: 기준 월
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_STS_AIR_SALE_MONTH_LIST 0, 0, 1, 1, '2018', '09', 'oz', '', ''


	exec SP_STS_AIR_SALE_MONTH_LIST @COMPANY=0,@PRICE_TYPE=1,@REGION_TYPE=NULL,@SELECT_TYPE=2,@YEAR=N'2017',@MONTH=N'10',@AIRLINE_CODE='TK',@CLASS=NULL,@ROUTING=NULL

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-10-11		김성호			최초생성
   2015-11-25		김성호			국내/국외구분 추가
   2017-08-01		김성호			항공사, 클래스, 구간 조건 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_STS_AIR_SALE_MONTH_LIST]
	@SELECT_TYPE	INT,
	@COMPANY		INT,
	@PRICE_TYPE		INT,
	@REGION_TYPE	VARCHAR(1),
	@YEAR			VARCHAR(4),
	@MONTH			VARCHAR(2),
	@AIRLINE_CODE	VARCHAR(2),
	@CLASS			VARCHAR(20),
	@ROUTING		VARCHAR(20)
AS  
BEGIN  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @STAND_DATE DATETIME, @WHERE1 NVARCHAR(100), @WHERE2 NVARCHAR(100), @WHERE3 NVARCHAR(100), @WHERE_COMPANY NVARCHAR(1000)

	-- 기준월
	SET @STAND_DATE = CONVERT(DATETIME, @YEAR + '-' + @MONTH + '-01')

	-- WHERE 조건 만들기
	IF @SELECT_TYPE = 0
	BEGIN
		SELECT	@WHERE1 = '(SELECT KOR_NAME FROM PUB_AIRLINE AA WITH(NOLOCK) WHERE AA.AIRLINE_CODE = A.TYPE_CODE)',
				@WHERE2 = 'A.AIRLINE_CODE',
				@WHERE3 = '1 DESC, 2, 3'
	END
	ELSE IF @SELECT_TYPE = 1
	BEGIN
		SELECT	@WHERE1 = '(SELECT KOR_NAME FROM EMP_MASTER AA WITH(NOLOCK) WHERE AA.EMP_CODE = A.TYPE_CODE)',
				@WHERE2 = 'A.SALE_CODE',
				@WHERE3 = '2,1 DESC,3'
	END
	ELSE IF @SELECT_TYPE = 2
	BEGIN
		SELECT	@WHERE1 = '(SELECT TEAM_NAME FROM EMP_TEAM AA WITH(NOLOCK) WHERE AA.TEAM_CODE = A.TYPE_CODE)',
				@WHERE2 = 'DBO.FN_CUS_GET_EMP_TEAM_CODE(A.SALE_CODE)',
				@WHERE3 = '2,1 DESC,3'
	END

	IF @COMPANY > 0
		SET @WHERE_COMPANY = ' AND A.COMPANY = @COMPANY'
	ELSE
		SET @WHERE_COMPANY = ''

	IF @REGION_TYPE = '1'
		SET @WHERE_COMPANY = @WHERE_COMPANY + ' AND A.GDS <= 100'
	ELSE IF @REGION_TYPE = '2'
		SET @WHERE_COMPANY = @WHERE_COMPANY + ' AND A.GDS > 100'

	IF LEN(@AIRLINE_CODE) > 0
	BEGIN
		SET @WHERE_COMPANY = @WHERE_COMPANY + ' AND A.AIRLINE_CODE = @AIRLINE_CODE'
	END

	IF LEN(@CLASS) > 0
	BEGIN
		DECLARE @I INT = 1, @T_CLASS VARCHAR(50) = ''

		SET @CLASS = REPLACE(@CLASS, ',', '')
		WHILE (@I <= LEN(@CLASS))
		BEGIN
			PRINT SUBSTRING(@CLASS, @I, 1)
			SET @T_CLASS = @T_CLASS + ',' + SUBSTRING(@CLASS, @I, 1)
			SET @I = @I + 1
		END

		SET @WHERE_COMPANY = @WHERE_COMPANY + ' AND A.AIR_CLASS IN (SELECT Data FROM FN_SPLIT(''' + @T_CLASS + ''', '','') WHERE Data <> '''')'
	END

	IF LEN(@ROUTING) > 0
	BEGIN
		SET @WHERE_COMPANY = @WHERE_COMPANY + ' AND A.ROUTING LIKE ''%' + @ROUTING + '%'''
	END

	SET @SQLSTRING = N'
	WITH LIST AS
	(
		SELECT
			' + @WHERE2 + N' AS [TYPE_CODE],
			SUM(CASE @PRICE_TYPE WHEN 1 THEN (ISNULL(NET_PRICE, 0) + ISNULL(TAX_PRICE, 0)) ELSE ISNULL(NET_PRICE, 0) END) AS TOTAL,
			AIRLINE_CODE,
			SUM(ISNULL(COMM_PRICE, 0)) AS COMM_PRICE,
			COUNT(*) AS TICKET_COUNT,
			SUM(ISNULL(FARE, 0)) AS FARE_PRICE,
			SUM(ISNULL(NET_PRICE, 0)) AS NET_PRICE,
			SUM(ISNULL(TAX_PRICE, 0)) AS TAX_PRICE,
			SUM(ISNULL(NET_PRICE, 0) + ISNULL(QUE_PRICE, 0)) AS QUE_PRICE,
			SUM(ISNULL(CARD_PRICE, 0)) AS CARD_PRICE,
			SUM(ISNULL(CASH_PRICE, 0)) AS CASH_PRICE
		FROM (
			-- 지난달 출발, 이번달 도착
			SELECT A.*
			FROM DSR_TICKET A WITH(NOLOCK)
			WHERE A.START_DATE >= DATEADD(MONTH, -6, @STAND_DATE) AND A.START_DATE < @STAND_DATE AND A.END_DATE >= @STAND_DATE AND A.END_DATE < DATEADD(MONTH, 1, @STAND_DATE)
				AND A.CONJ_YN = ''N'' AND A.TICKET_STATUS = 1' + @WHERE_COMPANY + N'
			UNION ALL
			-- 이번달 출발, 다음달 도착
			SELECT A.*
			FROM DSR_TICKET A WITH(NOLOCK)
			WHERE A.START_DATE >= @STAND_DATE AND A.START_DATE < DATEADD(MONTH, 1, @STAND_DATE) AND A.END_DATE >= DATEADD(MONTH, 1, @STAND_DATE) AND A.END_DATE < DATEADD(MONTH, 7, @STAND_DATE)
				AND A.CONJ_YN = ''N'' AND A.TICKET_STATUS = 1' + @WHERE_COMPANY + N'
			UNION ALL
			-- 이번달 출,도착
			SELECT A.*
			FROM DSR_TICKET A WITH(NOLOCK)
			CROSS JOIN (SELECT ''1'' AS [FLAG] UNION ALL SELECT ''2'') B
			WHERE A.START_DATE >= @STAND_DATE AND A.START_DATE < DATEADD(MONTH, 1, @STAND_DATE) AND A.END_DATE >= @STAND_DATE AND A.END_DATE < DATEADD(MONTH, 1, @STAND_DATE)
				AND A.CONJ_YN = ''N'' AND A.TICKET_STATUS = 1' + @WHERE_COMPANY + N'
		) A
		GROUP BY ' + @WHERE2 + N', AIRLINE_CODE
	)
	SELECT
		(SELECT (A.TOTAL / SUM(AA.TOTAL) * 100) FROM LIST AA) AS [SHARE],
		' + @WHERE1 + N' AS [TYPE_NAME],
		A.AIRLINE_CODE,
		A.TYPE_CODE,
		A.TOTAL / 2 AS [TOTAL],
		A.COMM_PRICE / 2 AS [COMM_PRICE],
		A.TICKET_COUNT / 2 AS [TICKET_COUNT],
		A.FARE_PRICE / 2 AS [FARE_PRICE],
		A.NET_PRICE / 2 AS [NET_PRICE],
		A.TAX_PRICE / 2 AS [TAX_PRICE],
		A.QUE_PRICE / 2 AS [QUE_PRICE],
		A.CARD_PRICE / 2 AS [CARD_PRICE],
		A.CASH_PRICE / 2 AS [CASH_PRICE]
	FROM LIST A
	ORDER BY ' + @WHERE3 + N' DESC;'

	SET @PARMDEFINITION = N'
		@STAND_DATE DATETIME, 
		@COMPANY INT, 
		@PRICE_TYPE INT,
		@AIRLINE_CODE VARCHAR(2),
		@CLASS VARCHAR(20),
		@ROUTING VARCHAR(20)';

	PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION
		, @STAND_DATE
		, @COMPANY
		, @PRICE_TYPE
		, @AIRLINE_CODE
		, @CLASS
		, @ROUTING;

END

GO
