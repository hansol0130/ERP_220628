USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_RES_AIR_MASTER_LIST_SELECT
■ DESCRIPTION				: 항공예약검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	SP_RES_AIR_MASTER_LIST_SELECT '1','RT2103243984','','','','','',1,'2019-08-26 00:00:00','2019-08-26 12:00:00',9,0,9,10,'',''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-05-23		김성호			최초생성
   2018-07-12		박형만			PRO_CODE 
   2019-08-27       김남훈          예약검색 변경, DATE에서 DATETIME으로 변경
   2022-03-07       강동훈          CUS_NO
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_RES_AIR_MASTER_LIST_SELECT]
(@SEARCH_TYPE INT ,@SEARCH_VALUE VARCHAR(40) ,@AIRLINE_CODE CHAR(2) ,@CITY_CODE CHAR(3) ,@STATE_CODE VARCHAR(4) ,@NATION_CODE CHAR(2) ,@REGION_CODE CHAR(3) ,@SEARCH_DATE_TYPE INT ,@START_DATE DATETIME ,@END_DATE DATETIME ,@AIR_PRO_TYPE CHAR(1) ,@PROVIDER VARCHAR(10) ,@AIR_GDS INT ,@RES_STATE INT ,@NEW_CODE CHAR(7) ,@TEAM_CODE CHAR(3))
AS
BEGIN
	DECLARE @SQLSTRING          NVARCHAR(MAX)
	       ,@PARMDEFINITION     NVARCHAR(1000)
	       ,@WHERE              NVARCHAR(4000) = ''
	       ,@TEMP_STRING        VARCHAR(20);
	
	IF ISNULL(@SEARCH_VALUE ,'') <> ''
	BEGIN
	    IF @SEARCH_TYPE = 0 -- 고객명
	    BEGIN
	        SET @WHERE = ' AND A.RES_NAME LIKE ''%'' + @SEARCH_VALUE + ''%'''
	    END
	    ELSE 
	    IF @SEARCH_TYPE = 1 -- 예약코드
	    BEGIN
	        SET @WHERE = ' AND A.RES_CODE = CONVERT(CHAR(12), @SEARCH_VALUE)'
	    END
	    ELSE 
	    IF @SEARCH_TYPE = 2 -- PNR
	    BEGIN
	        SET @WHERE = ' AND B.PNR_CODE1 = CONVERT(VARCHAR(20), @SEARCH_VALUE)'
	    END
	END
	ELSE
	BEGIN
	    IF ISNULL(@AIRLINE_CODE ,'') <> ''
	    BEGIN
	        SET @WHERE = @WHERE + ' AND B.AIRLINE_CODE = @AIRLINE_CODE'
	    END
	    
	    IF ISNULL(@CITY_CODE ,'') <> ''
	    BEGIN
	        SET @WHERE = @WHERE + ' AND C.CITY_CODE = @CITY_CODE'
	    END
	    ELSE 
	    IF ISNULL(@NATION_CODE ,'') <> ''
	    BEGIN
	        SET @WHERE = @WHERE + ' AND D.NATION_CODE = @NATION_CODE'
	    END
	    ELSE 
	    IF ISNULL(@REGION_CODE ,'') <> ''
	    BEGIN
	        SET @WHERE = @WHERE + ' AND E.REGION_CODE = @REGION_CODE'
	    END
	    
	    IF @SEARCH_DATE_TYPE = 1 -- 예약일
	    BEGIN
	        SET @TEMP_STRING = 'A.NEW_DATE'
	    END
	    ELSE 
	    IF @SEARCH_DATE_TYPE = 2 -- 출발일
	    BEGIN
	        SET @TEMP_STRING = 'A.DEP_DATE'
	    END
	    ELSE 
	    IF @SEARCH_DATE_TYPE = 3 -- 발권시한
	    BEGIN
	        SET @TEMP_STRING = 'B.TTL_DATE'
	    END
	    ELSE 
	    IF @SEARCH_DATE_TYPE = 4 -- 결제시한
	    BEGIN
	        SET @TEMP_STRING = 'A.LAST_PAY_DATE'
	    END
	    
	    IF @START_DATE IS NOT NULL
	       AND @END_DATE IS NOT NULL
	    BEGIN
	        SET @WHERE = @WHERE + ' AND ' + @TEMP_STRING + ' >= @START_DATE AND ' + @TEMP_STRING + ' <= @END_DATE'
	    END
	    ELSE 
	    IF @START_DATE IS NOT NULL
	    BEGIN
	        SET @WHERE = @WHERE + ' AND ' + @TEMP_STRING + ' >= @START_DATE'
	    END
	    ELSE 
	    IF @END_DATE IS NOT NULL
	    BEGIN
	        SET @WHERE = @WHERE + ' AND ' + @TEMP_STRING + ' <= @END_DATE'
	    END
	    ELSE
	    BEGIN
	        SET @WHERE = @WHERE + ' AND ' + @TEMP_STRING + ' >= GETDATE()'
	    END
	    
	    IF ISNULL(@AIR_PRO_TYPE ,'9') <> '9'
	    BEGIN
	        SET @WHERE = @WHERE + ' AND B.AIR_PRO_TYPE = @AIR_PRO_TYPE'
	    END
	    
	    IF ISNULL(@PROVIDER ,'0') <> '0'
	    BEGIN
	        SET @WHERE = @WHERE + ' AND A.PROVIDER = @PROVIDER'
	    END
	    
	    IF @AIR_GDS <> 9
	    BEGIN
	        SET @WHERE = @WHERE + ' AND B.AIR_GDS = @AIR_GDS'
	    END
	    
	    IF @RES_STATE < 10
	    BEGIN
	        SET @WHERE = @WHERE + ' AND A.RES_STATE = @RES_STATE'
	    END
	    
	    IF ISNULL(@NEW_CODE ,'') <> ''
	    BEGIN
	        SET @WHERE = @WHERE + ' AND A.NEW_CODE = @NEW_CODE'
	    END
	    ELSE 
	    IF ISNULL(@TEAM_CODE ,'') <> ''
	    BEGIN
	        SET @WHERE = @WHERE + ' AND A.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER_DAMO WITH(NOLOCK) WHERE TEAM_CODE = @TEAM_CODE)'
	    END
	END
	
	SELECT @WHERE = 'WHERE' + SUBSTRING(@WHERE ,5 ,4000)
	
	SET @SQLSTRING = 
	    N'
WITH DOCUMENTLIST AS
(
	SELECT
		A.CUS_NO,
		A.RES_CODE,
		A.RES_STATE,
		A.RES_NAME,
		A.DEP_DATE,
		A.NEW_CODE,
		A.NEW_DATE,
		A.LAST_PAY_DATE,
		A.PROVIDER,
		B.ADT_PRICE,
		B.CHD_PRICE,
		B.PNR_CODE1 AS [PNR_CODE],
		B.AIRLINE_CODE,
		B.AIR_PRO_TYPE,
		C.CITY_CODE,
		E.KOR_NAME AS [NATION_NAME],
		F.KOR_NAME AS [NEW_NAME],
		DBO.FN_RES_GET_RES_COUNT(A.RES_CODE)  AS RES_COUNT,
		(SELECT SUM(CASE WHEN ISNULL(SEAT_STATUS,'''') NOT IN (''OS'',''HK'') THEN 1 ELSE 0 END) FROM RES_SEGMENT WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE) AS SEAT_NO_COUNT,
		(
			SELECT SUM(
				CASE
					WHEN SEAT_STATUS = ''HK'' THEN 1
					WHEN SEAT_STATUS = ''DS'' THEN 1
					WHEN SEAT_STATUS = ''QQ'' THEN 1
					ELSE 0
				END) - COUNT(*) 
			FROM RES_SEGMENT WITH(NOLOCK) 
			WHERE RES_CODE = A.RES_CODE
		) AS HK_COUNT,
		DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) AS TOTAL_PRICE,
		ISNULL((SELECT SUM(CONVERT(DECIMAL, PART_PRICE)) FROM PAY_MATCHING WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE),0) AS PAY_PRICE , 
		A.PRO_CODE 
	FROM RES_MASTER_DAMO A WITH(NOLOCK)
	INNER JOIN RES_AIR_DETAIL B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
	INNER JOIN PUB_AIRPORT C WITH(NOLOCK) ON B.DEP_ARR_AIRPORT_CODE = C.AIRPORT_CODE
	INNER JOIN PUB_CITY D WITH(NOLOCK) ON C.CITY_CODE = D.CITY_CODE
	INNER JOIN PUB_NATION E WITH(NOLOCK) ON D.NATION_CODE = E.NATION_CODE
	INNER JOIN EMP_MASTER F WITH(NOLOCK) ON A.NEW_CODE = F.EMP_CODE
	' + @WHERE + N'
)
SELECT
	A.*,
	(CASE WHEN A.SEAT_NO_COUNT > 0 THEN ''N'' ELSE ''Y'' END) AS SEAT_YN,
	(CASE WHEN A.PAY_PRICE = 0 THEN 0					--미납
		   WHEN A.TOTAL_PRICE > A.PAY_PRICE THEN 1		--부분납
		   WHEN A.TOTAL_PRICE = A.PAY_PRICE THEN 2		--완납
		   ELSE 3 END) AS PAY_STATE
FROM DOCUMENTLIST A
ORDER BY A.NEW_DATE DESC;'
	
	
	SET @PARMDEFINITION = N'
		@SEARCH_VALUE		VARCHAR(20),
		@AIRLINE_CODE		VARCHAR(2),
		@CITY_CODE			VARCHAR(3),
		@STATE_CODE			VARCHAR(4),
		@NATION_CODE		VARCHAR(2),
		@REGION_CODE		VARCHAR(3),
		@START_DATE			DATETIME,
		@END_DATE			DATETIME,
		@AIR_PRO_TYPE		INT,
		@PROVIDER			INT, 
		@AIR_GDS			INT,
		@RES_STATE			INT,
		@NEW_CODE			VARCHAR(7),
		@TEAM_CODE			VARCHAR(3)';
	
	--PRINT @SQLSTRING
	--PRINT @START_DATE
	--PRINT @END_DATE
	PRINT @SQLSTRING;
	EXEC SP_EXECUTESQL @SQLSTRING
	    ,@PARMDEFINITION
	    ,@SEARCH_VALUE
	    ,@AIRLINE_CODE
	    ,@CITY_CODE
	    ,@STATE_CODE
	    ,@NATION_CODE
	    ,@REGION_CODE
	    ,@START_DATE
	    ,@END_DATE
	    ,@AIR_PRO_TYPE
	    ,@PROVIDER
	    ,@AIR_GDS
	    ,@RES_STATE
	    ,@NEW_CODE
	    ,@TEAM_CODE;
END

GO
