USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_BTE_STS_RES_CUSTOMER_LIST
■ DESCRIPTION				: 복지몰 예약 리스트 검색
■ INPUT PARAMETER			: 
	@START_DATE				: 시작일자
	@END_DATE				: 종료일자
	@SEARCH_TYPE			: 검색구분
	@AGT_CODE				: 거래처코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_BTE_STS_RES_CUSTOMER_LIST '2016-06-01', '2016-06-02', 1, ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-08-24		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_BTE_STS_RES_CUSTOMER_LIST]
	@START_DATE		DATE,
	@END_DATE		DATE,
	@SEARCH_TYPE	INT,	-- 1: 출발일, 2: 예약일
	@AGT_CODE		VARCHAR(10)
AS 
BEGIN

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @INNER_TABLE NVARCHAR(1000), @WHERE NVARCHAR(4000);

	-- 날짜
	IF @SEARCH_TYPE = 1 
	BEGIN
		SET @WHERE = N'WHERE A.DEP_DATE >= @START_DATE AND A.DEP_DATE < @END_DATE'
	END
	ELSE
	BEGIN
		SET @WHERE = N'WHERE A.NEW_DATE >= @START_DATE AND A.NEW_DATE < @END_DATE'
	END

	-- 거래처
	IF LEN(@AGT_CODE) > 0
	BEGIN
		SET @WHERE = @WHERE + N' AND A.SALE_COM_CODE = @AGT_CODE' 
		SET @INNER_TABLE = N'INNER JOIN PUB_REGION B ON A.SIGN_CODE = B.SIGN'
	END
	ELSE
	BEGIN
		SET @INNER_TABLE = N'INNER JOIN PUB_REGION B ON A.SIGN_CODE = B.SIGN'
		SET @INNER_TABLE = N'LEFT JOIN AGT_MASTER B ON A.SALE_COM_CODE = B.AGT_CODE'
	END

	-- 복지몰만
	SET @WHERE = @WHERE + N' AND A.PROVIDER = 35';

	SET @SQLSTRING = N'
	WITH RES_LIST AS
	(
		SELECT A.RES_CODE, A.RES_STATE, B.SIGN_CODE, A.SALE_COM_CODE, DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) AS [TOTAL_PRICE]
		FROM RES_MASTER_damo A WITH(NOLOCK)
		INNER JOIN PKG_MASTER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
		' + @WHERE + N'
	)
	SELECT B.KOR_NAME, SUM(A.TOTAL_PRICE) AS [TOTAL_PRICE]
		, COUNT(*) AS [TOTAL_RES_COUNT]
		, SUM(CASE WHEN A.RES_STATE <= 7 THEN 1 ELSE 0 END) AS [REAL_RES_COUNT]
		, SUM(CASE WHEN A.RES_STATE > 7 THEN 1 ELSE 0 END) AS [CXL_RES_COUNT]
	FROM RES_LIST A
	' + @INNER_TABLE + N'
	GROUP BY B.KOR_NAME'

	SET @PARMDEFINITION = N'
		@START_DATE DATE,
		@END_DATE DATE,
		@AGT_CODE VARCHAR(10)';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@START_DATE,
		@END_DATE,
		@AGT_CODE;

END 

GO
