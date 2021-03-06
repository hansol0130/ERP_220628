USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BTMS_ERP_AIR_RESV_LIST
■ DESCRIPTION				: BTMS ERP 항공예약현황
■ INPUT PARAMETER			: 
	
■ OUTPUT PARAMETER			: 
■ EXEC		
	EXEC DBO.XP_COM_BTMS_ERP_AIR_RESV_LIST '0', 'RESV', '', '', '', '', 'RES_NAME', '', '', 'TTL_DATE', '2016-01-01', '2016-12-30', '', '', '', ''
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE					AUTHOR				DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-05-01		저스트고강태영			최초 생성
   2016-05-13		저스트고이유라			기간조건 비활성 조건 추가
   2016-05-27		정지용					BT_STATE 삭제
   2016-10-12		저스트고이유라			발권시한 ORDERBY A테이블기준 -> B테이블기준(에러수정)
   2017-04-03		박형만			공항,도시,국가 정보 LEFT JOIN 으로 변경 
   2018-07-16		박형만			PAY_STATE 버그 수정 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BTMS_ERP_AIR_RESV_LIST]
	@APPROVAL_STATE		VARCHAR(1),
	@SEARCH_OPTION		VARCHAR(5),
	@SEARCH_OPTION_TEXT VARCHAR(100),
	@RES_STATE			VARCHAR(1),
	@AIR_GDS			INT,
	@PNR_CODE			VARCHAR(50),
	@SEARCH_TYPE		VARCHAR(15),
	@SEARCH_TYPE_TEXT	VARCHAR(20),
	@AGT_CODE			VARCHAR(10),
	@PERIOD_TYPE		VARCHAR(15),
	@START_DATE			VARCHAR(20),
	@END_DATE			VARCHAR(20),
	@REGION_CODE		VARCHAR(5),
	@PAY_LATER_YN		VARCHAR(1),
	@NEW_CODE			VARCHAR(10),
	@PAY_STATE			VARCHAR(1)
AS 
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(4000), @WHERE2 NVARCHAR(1000), @SORT_STRING VARCHAR(100);
	
	SELECT @WHERE = 'WHERE 1 = 1'
	SELECT @WHERE2 = 'WHERE 1 = 1'
	
	--WHERE
	IF (@APPROVAL_STATE <> '')
	BEGIN
		SET @WHERE = @WHERE + ' AND CBM.APPROVAL_STATE = @APPROVAL_STATE '
	END

	IF(@SEARCH_OPTION <> '')
	BEGIN
		IF(@SEARCH_OPTION='BT' AND @SEARCH_OPTION_TEXT <> '')
		BEGIN
			SET @WHERE = @WHERE + ' AND CBD.BT_CODE = @SEARCH_OPTION_TEXT '
		END
		
		IF(@SEARCH_OPTION='RESV' AND @SEARCH_OPTION_TEXT <> '')
		BEGIN
			SET @WHERE = @WHERE + ' AND A.RES_CODE = @SEARCH_OPTION_TEXT '
		END

		IF(@SEARCH_OPTION='PRO' AND @SEARCH_OPTION_TEXT <> '')
		BEGIN
			SET @WHERE = @WHERE + ' AND A.PRO_CODE = @SEARCH_OPTION_TEXT '
		END
	END

	IF(@RES_STATE <> '')
	BEGIN
		SET @WHERE = @WHERE + ' AND A.RES_STATE = @RES_STATE '
	END

	IF(@AIR_GDS <> '')
	BEGIN
		SET @WHERE = @WHERE + ' AND B.AIR_GDS = @AIR_GDS '
	END

	IF(@PNR_CODE <> '')
	BEGIN
		SET @WHERE = @WHERE + ' AND B.PNR_CODE1 = @PNR_CODE '
	END

	IF(@SEARCH_TYPE <> '')
	BEGIN
		IF(@SEARCH_TYPE='RES_NAME' AND @SEARCH_TYPE_TEXT <> '')
		BEGIN
			SET @WHERE = @WHERE + ' AND A.RES_NAME LIKE ''%'' + @SEARCH_TYPE_TEXT + ''%'' '
		END
		
		IF(@SEARCH_TYPE='CUS_NAME' AND @SEARCH_TYPE_TEXT <> '')
		BEGIN
			SET @WHERE = @WHERE + ' AND H.CUS_NAME LIKE ''%'' + @SEARCH_TYPE_TEXT + ''%'' '
		END

		IF(@SEARCH_TYPE='AIRLINE_CODE' AND @SEARCH_TYPE_TEXT <> '')
		BEGIN
			SET @WHERE = @WHERE + ' AND B.AIRLINE_CODE = @SEARCH_TYPE_TEXT '
		END
	END

	IF(@AGT_CODE <> '')
	BEGIN
		SET @WHERE = @WHERE + ' AND CBM.AGT_CODE = @AGT_CODE '
	END

	IF(@PERIOD_TYPE <> '' AND @SEARCH_OPTION_TEXT = '' AND @SEARCH_TYPE_TEXT = '' AND @PNR_CODE = '')
	BEGIN
		IF(@PERIOD_TYPE='NEW_DATE' AND @START_DATE <> '' AND @END_DATE <> '')
		BEGIN
			SET @WHERE = @WHERE + ' AND A.NEW_DATE >= CONVERT(DATETIME, @START_DATE) AND A.NEW_DATE < DATEADD(D, 1, CONVERT(DATETIME, @END_DATE)) '
		END
		
		IF(@PERIOD_TYPE='DEP_DATE' AND @START_DATE <> '' AND @END_DATE <> '')
		BEGIN
			SET @WHERE = @WHERE + ' AND A.DEP_DATE >= CONVERT(DATETIME, @START_DATE) AND A.DEP_DATE < DATEADD(D, 1, CONVERT(DATETIME, @END_DATE)) '
		END

		IF(@PERIOD_TYPE='ARR_DATE' AND @START_DATE <> '' AND @END_DATE <> '')
		BEGIN
			SET @WHERE = @WHERE + ' AND A.ARR_DATE >= CONVERT(DATETIME, @START_DATE) AND A.ARR_DATE < DATEADD(D, 1, CONVERT(DATETIME, @END_DATE)) '
		END

		IF(@PERIOD_TYPE='LAST_PAY_DATE' AND @START_DATE <> '' AND @END_DATE <> '')
		BEGIN
			SET @WHERE = @WHERE + ' AND A.LAST_PAY_DATE >= CONVERT(DATETIME, @START_DATE) AND A.LAST_PAY_DATE < DATEADD(D, 1, CONVERT(DATETIME, @END_DATE)) '
		END

		IF(@PERIOD_TYPE='TTL_DATE' AND @START_DATE <> '' AND @END_DATE <> '')
		BEGIN
			SET @WHERE = @WHERE + ' AND B.TTL_DATE >= CONVERT(DATETIME, @START_DATE) AND B.TTL_DATE < DATEADD(D, 1, CONVERT(DATETIME, @END_DATE)) '
		END
	END

	IF(@REGION_CODE <> '')
	BEGIN
		SET @WHERE = @WHERE + ' AND E.REGION_CODE = @REGION_CODE '
	END

	IF(@PAY_LATER_YN <> '')
	BEGIN
		SET @WHERE = @WHERE + ' AND AM.PAY_LATER_YN = ''Y'' '
	END

	IF(@NEW_CODE <> '')
	BEGIN
		SET @WHERE = @WHERE + ' AND A.NEW_CODE = @NEW_CODE '
	END


	-- WHERE2
	IF(@PAY_STATE <> '')
	BEGIN
		SET @WHERE2 = @WHERE2 + ' AND (CASE WHEN A.PAY_PRICE = 0 THEN 0 WHEN A.TOTAL_PRICE > A.PAY_PRICE THEN 1 WHEN A.TOTAL_PRICE = A.PAY_PRICE THEN 2 ELSE 3 END) = @PAY_STATE '
	END


	-- SORT 조건 만들기  
	SELECT @SORT_STRING = (  
		CASE @PERIOD_TYPE
			WHEN 'NEW_DATE' THEN 'A.NEW_DATE DESC'
			WHEN 'DEP_DATE' THEN 'A.DEP_DATE ASC'
			WHEN 'ARR_DATE' THEN 'A.ARR_DATE ASC'
			WHEN 'LAST_PAY_DATE' THEN 'A.LAST_PAY_DATE ASC'
			WHEN 'TTL_DATE' THEN 'A.TTL_DATE ASC'
		END
	)

	SET @SQLSTRING = N'
		-- 리스트 조회
		WITH DOCUMENTLIST AS
		(
			SELECT DISTINCT
				CBD.BT_CODE,				--출장번호
				CBM.APPROVAL_STATE,			--승인상태
				A.RES_CODE,					--예약코드
				A.RES_STATE,				--예약상태
				CBM.AGT_CODE,				--거래처코드
				AM.KOR_NAME AS AGT_NAME,	--거래처명
				A.CUS_NO,					--예약자코드
				A.RES_NAME,					--예약자명
				CP.POS_NAME,				--예약자직급
				CT.TEAM_NAME,				--예약자부서명
				A.NEW_DATE,					--생성일
				B.PNR_CODE1 AS PNR_CODE,	--PNR코드1
		        B.PNR_CODE2,				--PNR코드2
				B.AIR_PRO_TYPE,				--세부상품구분
				B.AIRLINE_CODE,				--항공사코드
				E.REGION_CODE,				--지역코드
				E.KOR_NAME AS REGION_NAME,	--지역명
				G.CITY_CODE,				--도시코드
				B.AIR_GDS,					--항공GDS
				A.RES_TYPE,					--예약타입
				A.DEP_DATE,					--출발일
				A.ARR_DATE,					--출발일
				A.NEW_CODE,					--생성자
				(SELECT KOR_NAME FROM EMP_MASTER WITH(NOLOCK) WHERE EMP_CODE = A.NEW_CODE) AS NEW_NAME,	--생성자명(담당자)
				B.FARE_CODE,				--항공요금코드
				A.SYSTEM_TYPE,				--예약타입구분(온라인,오프라인 1,3=온라인/2=오프라인)
				A.PRO_TYPE,					--상품타입
				A.LAST_PAY_DATE,			--결제시한
				B.TTL_DATE,					--발권시한
				A.PRO_CODE,					--행사코드
				A.PRO_NAME,					--행사명
				ISNULL(AM.PAY_LATER_YN, ''N'') AS PAY_LATER_YN,	--후불업체
				CBD.PAY_LATER_DATE,			--후불날짜
				(SELECT SUM(CASE WHEN ISNULL(SEAT_STATUS,'''') NOT IN (''OS'',''HK'') THEN 1 ELSE 0 END) FROM RES_SEGMENT WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE) AS SEAT_NO_COUNT,
				DBO.FN_RES_GET_RES_COUNT(A.RES_CODE)  AS RES_COUNT, --출장인원
				(SELECT SUM(CASE
					WHEN SEAT_STATUS = ''HK'' THEN 1
					WHEN SEAT_STATUS = ''DS'' THEN 1
					WHEN SEAT_STATUS = ''QQ'' THEN 1
					ELSE 0 END) - COUNT(*) FROM RES_SEGMENT WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE ) AS HK_COUNT,
				DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) AS TOTAL_PRICE,	--결제금액
				dbo.FN_RES_GET_PAY_PRICE(A.RES_CODE) AS PAY_PRICE
			FROM COM_BIZTRIP_MASTER CBM WITH(NOLOCK)
			LEFT JOIN COM_BIZTRIP_DETAIL CBD WITH(NOLOCK) ON CBD.BT_CODE = CBM.BT_CODE
			LEFT JOIN RES_MASTER_damo A WITH(NOLOCK) ON CBD.RES_CODE = A.RES_CODE AND CBD.BT_CODE = CBM.BT_CODE
			INNER JOIN RES_AIR_DETAIL B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
			LEFT JOIN PUB_AIRPORT G WITH(NOLOCK) ON G.AIRPORT_CODE = B.DEP_ARR_AIRPORT_CODE
			LEFT JOIN PUB_CITY C WITH(NOLOCK) ON G.CITY_CODE = C.CITY_CODE
			LEFT JOIN PUB_NATION E WITH(NOLOCK) ON C.NATION_CODE = E.NATION_CODE
			LEFT JOIN PUB_REGION F WITH(NOLOCK) ON E.REGION_CODE = F.REGION_CODE
			LEFT JOIN RES_CUSTOMER_damo H WITH(NOLOCK) ON A.RES_CODE = H.RES_CODE
			LEFT JOIN COM_EMPLOYEE_MATCHING CEM WITH(NOLOCK) ON A.CUS_NO = CEM.CUS_NO AND CEM.AGT_CODE = CBM.AGT_CODE
			LEFT JOIN COM_EMPLOYEE CE WITH(NOLOCK) ON CEM.EMP_SEQ = CE.EMP_SEQ AND CEM.AGT_CODE = CE.AGT_CODE
			LEFT JOIN COM_POSITION CP WITH(NOLOCK) ON CE.POS_SEQ = CP.POS_SEQ AND CP.AGT_CODE = CEM.AGT_CODE
			LEFT JOIN AGT_MASTER AM WITH(NOLOCK) ON AM.AGT_CODE = CBM.AGT_CODE
			LEFT JOIN COM_TEAM CT WITH(NOLOCK) ON CT.AGT_CODE = CBM.AGT_CODE AND CT.TEAM_SEQ = CE.TEAM_SEQ
			' + @WHERE + N'
		)
		SELECT DISTINCT
			A.*,
			(CASE WHEN A.SEAT_NO_COUNT > 0 THEN ''N'' ELSE ''Y'' END) AS SEAT_YN,
			(CASE WHEN A.PAY_PRICE = 0 THEN 0    --미납
				   WHEN A.TOTAL_PRICE > A.PAY_PRICE THEN 1   --부분납
				   WHEN A.TOTAL_PRICE = A.PAY_PRICE THEN 2   --완납
				   ELSE 3 END) AS PAY_STATE
		FROM DOCUMENTLIST A
		' + @WHERE2 + N'
		ORDER BY ' + @SORT_STRING
		
		

	SET @PARMDEFINITION = N'
		@APPROVAL_STATE		VARCHAR(1),
		@SEARCH_OPTION		VARCHAR(5),
		@SEARCH_OPTION_TEXT VARCHAR(100),
		@RES_STATE			VARCHAR(1),
		@AIR_GDS			INT,
		@PNR_CODE			VARCHAR(50),
		@SEARCH_TYPE		VARCHAR(15),
		@SEARCH_TYPE_TEXT	VARCHAR(20),
		@AGT_CODE			VARCHAR(10),
		@PERIOD_TYPE		VARCHAR(15),
		@START_DATE			VARCHAR(20),
		@END_DATE			VARCHAR(20),
		@REGION_CODE		VARCHAR(5),
		@PAY_LATER_YN		VARCHAR(1),
		@NEW_CODE			VARCHAR(10),
		@PAY_STATE			INT';

	PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@APPROVAL_STATE,
		@SEARCH_OPTION,
		@SEARCH_OPTION_TEXT,
		@RES_STATE,
		@AIR_GDS,
		@PNR_CODE,
		@SEARCH_TYPE,
		@SEARCH_TYPE_TEXT,
		@AGT_CODE,
		@PERIOD_TYPE,
		@START_DATE,
		@END_DATE,
		@REGION_CODE,
		@PAY_LATER_YN,
		@NEW_CODE,
		@PAY_STATE;

END


GO
