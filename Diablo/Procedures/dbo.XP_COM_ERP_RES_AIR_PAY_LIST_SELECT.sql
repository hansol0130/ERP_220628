USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_ERP_RES_AIR_PAY_LIST_SELECT
■ DESCRIPTION				: BTMS ERP 항공 예약 미수현황 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 

	EXEC XP_COM_ERP_RES_AIR_PAY_LIST_SELECT NULL, NULL, 1, '2016-04-01', '2016-06-01', NULL, NULL, NULL, NULL, NULL, NULL
	exec XP_COM_ERP_RES_AIR_PAY_LIST_SELECT @RES_STATE=10,@AGT_CODE='',@SEARCH_DATE_TYPE=3,
	@START_DATE='2016-02-03 00:00:00',@END_DATE='2016-06-24 00:00:00',@AIR_GDS=0,@SET_STATE=0,@PAY_STATE=9,@PAY_LATER_COM_YN=NULL,@PAY_LATER_YN=NULL,@EMP_CODE=''

■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-27		김성호			최초생성
   2016-05-03		박형만			전체 조건 추가 
   2016-05-23		박형만			후불업체여부,후불처리여부 나누어서 처리
   2016-05-25		김성호			@SEARCH_DATE_TYPE 3: 결제일 조건 추가
   2016-06-02		박형만			출발일,도착일 검색시 각각 날짜 빠른순 정렬(결제일은 출발일빠른순)
   2016-10-05		박형만			END_DATE 날짜 +1 
   2016-11-10		박형만			타임아웃안생기도록 CXL_YN 조건 추가 , INDEX HINT 추가 
   2017-01-02		박형만			결제일 NEW_DATE 가 아닌 PAY_DATE 로 
================================================================================================================*/ 
 CREATE PROC [dbo].[XP_COM_ERP_RES_AIR_PAY_LIST_SELECT]
	@RES_STATE			INT,				/* public enum ReserveStateEnum { 접수 = 0, 담당자확인중, 예약확정, 결제중, 결제완료, 출발완료, 해피콜, 환불, 이동, 취소, 전체 = 10 } */
	@AGT_CODE			VARCHAR(10),
	@SEARCH_DATE_TYPE	INT,				/* 1: 출발일, 2: 도착일, 3: 결제일 추가 */
	@START_DATE			DATETIME,
	@END_DATE			DATETIME,
	@AIR_GDS			INT,				/* public enum GdsEnum { 전체 = 0, TOPAS = 1, ABACUS, GALILEO, WORLDSPAN, AMADEUS, AIRBUSAN = 100, AMADEUS국내 = 101, ABACUS국내 = 102, 진에어 = 103, 티웨이 = 104 , AIRBUSAN국내 = 105 } */
	@SET_STATE			INT,				/* public enum SetStateEnum { 정산진행중, 결제진행중, 정산완료, 재정산, 미정산 = 9 }; */
	@PAY_STATE			INT,				/* public enum PayStateEnum { 미납, 부분납, 완납, 과납, 전체 = 9 } */
	@PAY_LATER_COM_YN	VARCHAR(1),			--후불업체만
	@PAY_LATER_YN		VARCHAR(1),			--후불처리만
	@EMP_CODE			VARCHAR(10)			/* 담당자 사번 */
AS 
BEGIN

	DECLARE @SQLSTRING NVARCHAR(MAX) = '', @PARMDEFINITION NVARCHAR(4000), @WHERE1 NVARCHAR(4000) = '', @WHERE2 NVARCHAR(4000) = '', @ORDERBY NVARCHAR(4000) ='';;

	IF LEN(@AGT_CODE) > 0
	BEGIN
		SET @WHERE1 = @WHERE1 + ' AND B.AGT_CODE = @AGT_CODE'
	END

	IF @SEARCH_DATE_TYPE = 1
	BEGIN
		SET @WHERE1 = @WHERE1 + ' AND A.DEP_DATE >= @START_DATE AND A.DEP_DATE < DATEADD(D,1,@END_DATE)'
		SET @ORDERBY = @ORDERBY + 'ORDER BY A.DEP_DATE'
	END
	ELSE IF @SEARCH_DATE_TYPE = 2
	BEGIN
		SET @WHERE1 = @WHERE1 + ' AND A.ARR_DATE >= @START_DATE AND A.ARR_DATE < DATEADD(D,1,@END_DATE)'
		SET @ORDERBY = @ORDERBY + 'ORDER BY A.ARR_DATE'
	END
	ELSE IF @SEARCH_DATE_TYPE = 3
	BEGIN
		--SET @WHERE1 = @WHERE1 + ' AND A.RES_CODE IN (SELECT RES_CODE FROM PAY_MATCHING AA WITH(INDEX = IDX_PAY_MATCHING_1, NOLOCK) WHERE AA.RES_CODE = A.RES_CODE AND AA.NEW_DATE >= @START_DATE AND AA.NEW_DATE < DATEADD(D,1,@END_DATE) AND AA.CXL_YN = ''N'' )'
		SET @WHERE1 = @WHERE1 + ' AND A.RES_CODE IN (
SELECT AA.RES_CODE FROM PAY_MATCHING AA WITH(INDEX = IDX_PAY_MATCHING_1, NOLOCK) 
	INNER JOIN PAY_MASTER_DAMO BB WITH(INDEX= PK_PAY_MASTER ,NOLOCK) ON AA.PAY_SEQ = BB.PAY_SEQ 
WHERE AA.RES_CODE = A.RES_CODE 
AND AA.CXL_YN = ''N''
AND BB.PAY_DATE >= @START_DATE 
AND BB.PAY_DATE < DATEADD(D,1,@END_DATE) 
)'
		SET @ORDERBY = @ORDERBY + 'ORDER BY A.DEP_DATE' 
	END

	IF @RES_STATE IS NOT NULL AND @RES_STATE <> 10 
	BEGIN
		SET @WHERE1 = @WHERE1 + ' AND A.RES_STATE = @RES_STATE'
	END

	IF @AIR_GDS IS NOT NULL  AND @AIR_GDS <> 0 
	BEGIN
		SET @WHERE1 = @WHERE1 + ' AND C.AIR_GDS = @AIR_GDS'
	END

	IF @SET_STATE IS NOT NULL
	BEGIN
		IF @SET_STATE = 1  --정산진행중
		BEGIN 
			SET @WHERE1 = @WHERE1 + ' AND D.SET_STATE = 0 '
		END 
		ELSE IF @SET_STATE = 2 --미정산
		BEGIN 
			SET @WHERE1 = @WHERE1 + ' AND D.PRO_CODE IS NULL '
		END 
		ELSE IF @SET_STATE = 3 --재정산
		BEGIN 
			SET @WHERE1 = @WHERE1 + ' AND D.SET_STATE = 3  '
		END 
		ELSE IF @SET_STATE = 4 --정산완료
		BEGIN 
			SET @WHERE1 = @WHERE1 + ' AND D.SET_STATE = 2 '
		END 
	END

	IF LEN(@EMP_CODE) > 0
	BEGIN
		SET @WHERE1 = @WHERE1 + ' AND A.NEW_CODE = @EMP_CODE'
	END

	IF LEN(@PAY_LATER_COM_YN) > 0
	BEGIN
		SET @WHERE1 = @WHERE1 + ' AND E.PAY_LATER_YN = ''Y'''
	END

	IF LEN(@PAY_LATER_YN) > 0
	BEGIN
		SET @WHERE1 = @WHERE1 + ' AND B.PAY_LATER_DATE IS NOT NULL '
	END

	IF @PAY_STATE IS NOT NULL AND @PAY_STATE <> 9 
	BEGIN
		SET @WHERE2 = 'WHERE Y.PAY_STATE = @PAY_STATE'
	END

	--IF @WHERE1 <> ''
	--BEGIN
	--	SET @WHERE1 = ('WHERE ' + SUBSTRING(@WHERE1, 5, 10000))
	--END

	SET @SQLSTRING = @SQLSTRING + CONVERT(NVARCHAR(MAX), N'
		WITH CODE_LIST AS
		(
			SELECT A.RES_CODE, D.SET_STATE
			FROM RES_MASTER_damo A WITH(NOLOCK)
			INNER JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE 
			LEFT JOIN RES_AIR_DETAIL C WITH(NOLOCK) ON A.RES_CODE = C.RES_CODE
			LEFT JOIN SET_MASTER D WITH(NOLOCK) ON A.PRO_CODE = D.PRO_CODE
			LEFT JOIN AGT_MASTER E WITH(NOLOCK) ON A.SALE_COM_CODE = E.AGT_CODE

			WHERE B.PRO_DETAIL_TYPE = 2 --항공 
			' + @WHERE1 + N'
			GROUP BY A.RES_CODE, D.SET_STATE
		)
		, PRICE_LIST AS
		(
			SELECT A.RES_CODE, A.TOTAL_PRICE, A.PAY_PRICE, A.CHG_PRICE, (A.TOTAL_PRICE - A.PAY_PRICE) AS [REST_PRICE]
				, (
					CASE
						WHEN A.PAY_PRICE = 0 THEN 0					-- 미납
						WHEN A.TOTAL_PRICE > A.PAY_PRICE THEN 1		-- 부분납
						WHEN A.TOTAL_PRICE = A.PAY_PRICE THEN 2		-- 완납
						WHEN A.TOTAL_PRICE < A.PAY_PRICE THEN 3		-- 과납
					END) AS [PAY_STATE]
			FROM (
				SELECT Z.RES_CODE
					, DBO.FN_RES_GET_TOTAL_PRICE(Z.RES_CODE) AS [TOTAL_PRICE]
					, DBO.FN_RES_GET_PAY_PRICE(Z.RES_CODE) AS [PAY_PRICE]
					, DBO.FN_RES_GET_CHANGE_PRICE(Z.RES_CODE) AS [CHG_PRICE]
				FROM CODE_LIST Z
			) A
		)
		, CUS_LIST AS
		(
			SELECT A.RES_CODE, COUNT(*) AS [RES_CUS_COUNT]
			FROM CODE_LIST Z
			INNER JOIN RES_MASTER_damo A WITH(NOLOCK) ON Z.RES_CODE = A.RES_CODE
			INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
			WHERE A.RES_STATE <= 7 AND B.RES_STATE IN (0, 3, 4)
			GROUP BY A.RES_CODE
		)
		SELECT Z.RES_CODE, A.RES_STATE, A.DEP_DATE, A.ARR_DATE, A.RES_NAME, B.AGT_CODE, B.AGT_NAME AS [SALE_COM_NAME], A.NEW_CODE, C.KOR_NAME AS [NEW_NAME]
			, Y.TOTAL_PRICE, Y.PAY_PRICE, Y.REST_PRICE, Y.CHG_PRICE, Y.PAY_STATE, ISNULL(Z.SET_STATE, 9) AS [SET_STATE], E.AIR_GDS, E.AIR_GDS2, X.RES_CUS_COUNT
			, B.PAY_LATER_YN AS COM_PAY_LATER_YN 
			, (CASE WHEN D.PAY_LATER_EMP_SEQ > 0 THEN ''Y'' ELSE ''N'' END) AS [PAY_LATER_YN]
		FROM CODE_LIST Z
		INNER JOIN PRICE_LIST Y ON Z.RES_CODE = Y.RES_CODE
		INNER JOIN CUS_LIST X ON Z.RES_CODE = X.RES_CODE
		INNER JOIN RES_MASTER_damo A WITH(NOLOCK) ON Z.RES_CODE = A.RES_CODE
		LEFT JOIN AGT_MASTER B WITH(NOLOCK) ON A.SALE_COM_CODE = B.AGT_CODE
		LEFT JOIN EMP_MASTER C WITH(NOLOCK) ON A.NEW_CODE = C.EMP_CODE
		LEFT JOIN COM_BIZTRIP_DETAIL D WITH(NOLOCK) ON A.SALE_COM_CODE = D.AGT_CODE AND A.RES_CODE = D.RES_CODE
		LEFT JOIN RES_AIR_DETAIL E WITH(NOLOCK) ON A.RES_CODE = E.RES_CODE
		' + @WHERE2 + N'
		'+ @ORDERBY + N'
		;') + CONVERT(NVARCHAR(MAX), N'

		WITH CODE_LIST AS
		(
			SELECT A.RES_CODE, D.SET_STATE
			FROM RES_MASTER_damo A WITH(NOLOCK)
			INNER JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
			LEFT JOIN RES_AIR_DETAIL C WITH(NOLOCK) ON A.RES_CODE = C.RES_CODE
			LEFT JOIN SET_MASTER D WITH(NOLOCK) ON A.PRO_CODE = D.PRO_CODE
			LEFT JOIN AGT_MASTER E WITH(NOLOCK) ON A.SALE_COM_CODE = E.AGT_CODE
			WHERE B.PRO_DETAIL_TYPE = 2 --항공 
			' + @WHERE1 + N'
			GROUP BY A.RES_CODE, D.SET_STATE
		)
		, PRICE_LIST AS
		(
			SELECT A.RES_CODE, A.TOTAL_PRICE, A.PAY_PRICE, A.CHG_PRICE, (A.TOTAL_PRICE - A.PAY_PRICE) AS [REST_PRICE]
				, (
					CASE
						WHEN A.PAY_PRICE = 0 THEN 0					-- 미납
						WHEN A.TOTAL_PRICE > A.PAY_PRICE THEN 1		-- 부분납
						WHEN A.TOTAL_PRICE = A.PAY_PRICE THEN 2		-- 완납
						WHEN A.TOTAL_PRICE < A.PAY_PRICE THEN 3		-- 과납
					END) AS [PAY_STATE]
			FROM (
				SELECT Z.RES_CODE
					, DBO.FN_RES_GET_TOTAL_PRICE(Z.RES_CODE) AS [TOTAL_PRICE]
					, DBO.FN_RES_GET_PAY_PRICE(Z.RES_CODE) AS [PAY_PRICE]
					, DBO.FN_RES_GET_CHANGE_PRICE(Z.RES_CODE) AS [CHG_PRICE]
				FROM CODE_LIST Z
			) A
		)
		, CUS_LIST AS
		(
			SELECT A.RES_CODE, COUNT(*) AS [RES_CUS_COUNT]
			FROM CODE_LIST Z
			INNER JOIN RES_MASTER_damo A WITH(NOLOCK) ON Z.RES_CODE = A.RES_CODE
			INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
			WHERE A.RES_STATE <= 7 AND B.RES_STATE IN (0, 3, 4)
			GROUP BY A.RES_CODE
		)
		SELECT A.AIR_GDS
			, COUNT(*) AS [RES_COUNT]
			, SUM(X.RES_CUS_COUNT) AS [RES_CUS_COUNT]
			, SUM(Y.TOTAL_PRICE) AS [TOTAL_PRICE]
			, SUM(Y.PAY_PRICE) AS [PAY_PRICE]
			, SUM(Y.REST_PRICE) AS [REST_PRICE]
			, SUM(Y.CHG_PRICE) AS [CHG_PRICE]
		FROM CODE_LIST Z
		INNER JOIN PRICE_LIST Y ON Z.RES_CODE = Y.RES_CODE
		INNER JOIN CUS_LIST X ON Z.RES_CODE = X.RES_CODE
		INNER JOIN RES_AIR_DETAIL A ON Z.RES_CODE = A.RES_CODE
		' + @WHERE2 + N'
		GROUP BY A.AIR_GDS')

		SET @PARMDEFINITION = N'
		@RES_STATE			INT,
		@AGT_CODE			VARCHAR(10),
		@SEARCH_DATE_TYPE	INT,
		@START_DATE			DATETIME,
		@END_DATE			DATETIME,
		@AIR_GDS			INT,
		@SET_STATE			INT,
		@PAY_STATE			INT,
		@PAY_LATER_YN		VARCHAR(1),
		@EMP_CODE			VARCHAR(10)';
	  
	--PRINT @SQLSTRING

   EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@RES_STATE,
		@AGT_CODE,
		@SEARCH_DATE_TYPE,
		@START_DATE,
		@END_DATE,
		@AIR_GDS,
		@SET_STATE,
		@PAY_STATE,
		@PAY_LATER_YN,
		@EMP_CODE;

END 
GO
