USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
/*================================================================================================================
■ USP_NAME					: XP_COM_STS_DSR_REFUND_LIST_SELECT
■ DESCRIPTION				: BTMS DSR 환불 리스트 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

   EXEC DBO.XP_COM_STS_DSR_REFUND_LIST_SELECT '', '', '', '2016-09-01', '2016-09-28', 0, 0, '', 'C'

■ MEMO                  : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR		DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2016-05-19		김성호		최초생성
	2016-06-15		이유라		ROUTE_TYPE추가 - 국제선/국내선 구분 (ERP용)
	2016-09-29		이유라		환불일 외 출발일 조회 추가 (@DATE_TYPE 추가로 구분)
	2016-11-29		이유라		TASF계산식 테이블 조인 -> SUM 으로 변경
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_STS_DSR_REFUND_LIST_SELECT]
	@AGT_CODE			VARCHAR(10),
	@TICKET				VARCHAR(10),
	@RES_CODE			VARCHAR(12),
	@START_DATE			DATE,
	@END_DATE			DATE,
	@TEAM_SEQ			INT,				/* 거래처 팀 */
	@EMP_SEQ			INT,
	@ROUTE_TYPE			VARCHAR(1),
	@DATE_TYPE			VARCHAR(1)
AS 
BEGIN

	DECLARE @SQLSTRING NVARCHAR(MAX) = '', @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(MAX) = '', @ORDERBY NVARCHAR(100) = ' A.CUS_DATE';

	IF LEN(@TICKET) > 0
	BEGIN
		SET @WHERE = ' AND A.TICKET = @TICKET'
	END
	ELSE IF LEN(@RES_CODE) > 0
	BEGIN
		SET @WHERE = ' AND B.RES_CODE = @RES_CODE'
	END
	ELSE
	BEGIN

		IF @START_DATE IS NOT NULL AND @END_DATE IS NOT NULL
		BEGIN 
			IF @DATE_TYPE = 'C'
			BEGIN
				SET @WHERE = @WHERE + ' AND A.CUS_DATE >= @START_DATE AND A.CUS_DATE < DATEADD(DAY, 1, CONVERT(DATETIME, @END_DATE, 121)) '	
				SET @ORDERBY = ' A.CUS_DATE '
			END
			IF @DATE_TYPE = 'S'
			BEGIN
				SET @WHERE = @WHERE + ' AND B.START_DATE >= @START_DATE AND B.START_DATE < DATEADD(DAY, 1, CONVERT(DATETIME, @END_DATE, 121)) '	
				SET @ORDERBY = ' B.START_DATE '				
			END
		END

		IF LEN(@AGT_CODE) > 0
		BEGIN
			SET @WHERE = @WHERE + ' AND E.AGT_CODE = @AGT_CODE'
		END

		IF @EMP_SEQ > 0
		BEGIN
			SET @WHERE = @WHERE + ' AND F.NEW_SEQ = @EMP_SEQ'
		END
		ELSE IF @TEAM_SEQ > 0
		BEGIN
			SET @WHERE = @WHERE + ' AND I.TEAM_SEQ = @TEAM_SEQ'
		END

		IF @ROUTE_TYPE = 'I'
		BEGIN 
			SET @WHERE = @WHERE + ' AND B.CITY_CODE NOT IN (SELECT CITY_CODE FROM PUB_CITY WHERE NATION_CODE = ''KR'') '
		END
		ELSE IF @ROUTE_TYPE = 'D'
		BEGIN 
			SET @WHERE = @WHERE + ' AND B.CITY_CODE IN (SELECT CITY_CODE FROM PUB_CITY WHERE NATION_CODE = ''KR'') '
		END

	END

	IF LEN(@WHERE) > 10
	BEGIN
		SELECT @WHERE = (N'WHERE ' + SUBSTRING(@WHERE, 5, 1000))
	END

    SET @SQLSTRING = @SQLSTRING + CONVERT(NVARCHAR(MAX), N'
		SELECT
			A.CUS_DATE, B.ISSUE_DATE, H.KOR_NAME AS [AGT_NAME], J.TEAM_NAME, I.KOR_NAME AS [AGT_EMP_NAME], K.POS_NAME, D.RES_CODE, B.PAX_NAME, B.ROUTING,
			B.START_DATE, B.END_DATE, L.KOR_NAME AS [CITY_NAME], B.AIRLINE_CODE, B.AIRLINE_NUM, B.AIR_CLASS, B.TICKET,
			A.CASH_PRICE AS [REFUND_CASH_PRICE], A.CARD_PRICE AS [REFUND_CARD_PRICE], A.CANCEL_CHARGE,
			--G.TOTAL_PRICE AS [REFUND_TASF_PRICE],
			(SELECT SUM(G.TOTAL_PRICE) FROM DSR_TASF G WHERE A.TICKET = G.PARENT_TICKET) AS [REFUND_TASF_PRICE], B.CARD_NUM
		FROM DSR_REFUND A WITH(NOLOCK)
		INNER JOIN DSR_TICKET B WITH(NOLOCK) ON A.TICKET = B.TICKET
		INNER JOIN RES_CUSTOMER_damo C WITH(NOLOCK) ON B.RES_CODE = C.RES_CODE AND B.RES_SEQ_NO = C.SEQ_NO
		INNER JOIN RES_MASTER_damo D WITH(NOLOCK) ON C.RES_CODE = D.RES_CODE
		INNER JOIN COM_BIZTRIP_DETAIL E WITH(NOLOCK) ON D.RES_CODE = E.RES_CODE
		INNER JOIN COM_BIZTRIP_MASTER F WITH(NOLOCK) ON E.AGT_CODE = F.AGT_CODE AND E.BT_CODE = F.BT_CODE
		--LEFT JOIN DSR_TASF G WITH(NOLOCK) ON A.TICKET = G.PARENT_TICKET
		LEFT JOIN AGT_MASTER H WITH(NOLOCK) ON F.AGT_CODE = H.AGT_CODE
		LEFT JOIN COM_EMPLOYEE I WITH(NOLOCK) ON F.AGT_CODE = I.AGT_CODE AND F.NEW_SEQ = I.EMP_SEQ
		LEFT JOIN COM_TEAM J WITH(NOLOCK) ON I.AGT_CODE = J.AGT_CODE AND I.TEAM_SEQ = J.TEAM_SEQ
		LEFT JOIN COM_POSITION K WITH(NOLOCK) ON I.AGT_CODE = K.AGT_CODE AND I.POS_SEQ = K.POS_SEQ
		LEFT JOIN PUB_CITY L WITH(NOLOCK) ON B.CITY_CODE = L.CITY_CODE
		' + @WHERE + N'
		ORDER BY ' + @ORDERBY + N';')

	SET @PARMDEFINITION = N'
		@AGT_CODE			VARCHAR(10),
		@TICKET				VARCHAR(10),
		@RES_CODE			VARCHAR(12),
		@START_DATE			DATE,
		@END_DATE			DATE,
		@TEAM_SEQ			INT,
		@EMP_SEQ			INT,
		@ROUTE_TYPE			VARCHAR(1)';
	  
	--PRINT @SQLSTRING
      
   EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@AGT_CODE,
		@TICKET,
		@RES_CODE,
		@START_DATE,
		@END_DATE,
		@TEAM_SEQ,
		@EMP_SEQ,
		@ROUTE_TYPE;

END 
GO
