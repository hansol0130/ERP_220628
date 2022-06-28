USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_DETAIL_SELECT_LIST
■ DESCRIPTION				: 행사 리스트 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC SP_PKG_DETAIL_SELECT_LIST @PAGE_INDEX=0,@PAGE_SIZE=1000,@EMP_CODE=' ',@TEAM_CODE='512',@PRO_CODE=NULL,@PRO_NAME=NULL,@START_DATE=N'2016-11-01',@END_DATE=N'2016-11-09'
		,@WEEK_DAY_TYPE=N'1111111',@CITY_CODE='000',@RES_YN=0,@AIRLINE_CODE='KE',@AIRLINE_NUMBER=NULL,@FLAG=N'L'

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR		DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2013-03-20		김성호		최초생성
	2012-10-31					MAX_COUNT 가져오기
	2013-03-13		박형만		도시코드 검색시 PKG_MASTER_SCH_CITY -> PKG_DETAIL_SCH_CITY 로 변경 ()
	2014-06-25		박형만		상품가총액계산 으로 변경
	2015-09-24		정지용		도시코드 조건 조회시 조회지간이 오래걸러 타임아웃이 걸림 =>  TOP 1 추가
	2016-11-02		김성호		도시코드, 항공코드 조건 문 수정
	2018-06-14		박형만		상품코드 검색시 PK INDEX HINT 사용 
================================================================================================================*/
CREATE PROCEDURE [dbo].[SP_PKG_DETAIL_SELECT_LIST]        
	@FLAG   CHAR(1),        
	@PAGE_SIZE  INT,        
	@PAGE_INDEX  INT,        
    
	@EMP_CODE  VARCHAR(7),        
	@TEAM_CODE  VARCHAR(3),        
	@PRO_CODE  VARCHAR(20),        
	@PRO_NAME  NVARCHAR(100),        
	@START_DATE  VARCHAR(10),        
	@END_DATE  VARCHAR(10),        
	@WEEK_DAY_TYPE VARCHAR(7),        
	@CITY_CODE  CHAR(3),        
	@AIRLINE_CODE VARCHAR(2),
	@AIRLINE_NUMBER VARCHAR(4),
	@RES_YN   INT        
AS        
BEGIN        
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @FROM INT, @TO INT;      
    
	SET @FROM = @PAGE_INDEX * @PAGE_SIZE + 1;        
	SET @TO = @PAGE_INDEX * @PAGE_SIZE + @PAGE_SIZE;     
	
	DECLARE @SQLINDEXHINT NVARCHAR(200)
	SET @SQLINDEXHINT =''   
      
	-- WHERE 조건 만들기        
	SET @SQLSTRING = ' WHERE 1 = 1';    
      
	IF LEN(ISNULL(@PRO_CODE, '')) >= 10
	BEGIN
		SET @SQLSTRING = @SQLSTRING + ' AND A.PRO_CODE LIKE @PRO_CODE + ''%'''
		SET @SQLINDEXHINT = ',INDEX(PK_PKG_DETAIL) ' 
	END
	ELSE        
	BEGIN        
		-- 행사코드        
		IF LEN(ISNULL(@PRO_CODE, '')) >= 1
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' AND A.PRO_CODE LIKE @PRO_CODE + ''%'''        
		END
    
		-- 검색 시작일    
		IF ISNULL(@START_DATE, '') <> ''    
		BEGIN        
			SET @SQLSTRING = @SQLSTRING + ' AND A.DEP_DATE >= @START_DATE'    
		END    

		-- 검색 종료일    
		IF ISNULL(@END_DATE, '') <> ''    
		BEGIN        
			SET @SQLSTRING = @SQLSTRING + ' AND A.DEP_DATE <= @END_DATE'    
		END        
      
		-- 담당자코드( 없으면 팀 전체, 팀 코드가 없으면 전체)    
		IF LTRIM(ISNULL(@EMP_CODE, '')) <> ''
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' AND A.NEW_CODE = @EMP_CODE'    
		END
		ELSE IF LTRIM(ISNULL(@TEAM_CODE, '')) <> ''    
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' AND A.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE = @TEAM_CODE)'    
		END
      
		-- 행사명        
		IF ISNULL(@PRO_NAME, '') <> ''        
		BEGIN        
			SET @SQLSTRING = @SQLSTRING + ' AND A.PRO_NAME LIKE (''%'' + @PRO_NAME + ''%'')'        
		END
      
		-- 항공사별 검색        
		IF ISNULL(@AIRLINE_CODE, '') <> ''        
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' AND A.PRO_CODE IN (SELECT TOP 1 PRO_CODE FROM PRO_TRANS_SEAT AA WITH(NOLOCK) WHERE AA.SEAT_CODE = A.SEAT_CODE AND AA.DEP_TRANS_CODE = @AIRLINE_CODE'
			--SET @SQLSTRING = @SQLSTRING + ' AND EXISTS(SELECT 1 FROM PRO_TRANS_SEAT WHERE SEAT_CODE = A.SEAT_CODE AND DEP_TRANS_CODE = @AIRLINE_CODE'
   
			-- 항공사 편명 추가 검색
			IF ISNULL(@AIRLINE_NUMBER, '') <> ''
			BEGIN
				SET @SQLSTRING = @SQLSTRING + ' AND AA.DEP_TRANS_NUMBER = @AIRLINE_NUMBER'
			END
   
			SET @SQLSTRING = @SQLSTRING + ')'
		END    
      
		-- 도시코드        
		IF ISNULL(@CITY_CODE, '000') != '000'        
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' AND A.PRO_CODE IN (SELECT TOP 1 PRO_CODE FROM PKG_DETAIL_SCH_CITY AA WITH(NOLOCK) WHERE AA.PRO_CODE = A.PRO_CODE AND AA.CITY_CODE = @CITY_CODE)'    --AND MAINCITY_YN = ''Y''        

			--SET @SQLSTRING = @SQLSTRING + ' AND EXISTS (SELECT TOP 1 1 FROM PKG_DETAIL_SCH_CITY  WITH(NOLOCK) WHERE PRO_CODE = A.PRO_CODE AND CITY_CODE = @CITY_CODE AND MAINCITY_YN IN(''Y'',''N'') )'    --AND MAINCITY_YN = ''Y''        
		END

		-- @예약자 유무        
		IF @RES_YN > 0
		BEGIN        
			SET @SQLSTRING = @SQLSTRING + ' AND ' + CASE @RES_YN WHEN 2 THEN 'NOT ' ELSE '' END + 'EXISTS(SELECT 1 FROM RES_MASTER_damo WITH(NOLOCK) WHERE PRO_CODE = A.PRO_CODE AND RES_STATE <= 6)'        
		END
    
		-- @요일 체크        
		IF @WEEK_DAY_TYPE > '0000000' AND @WEEK_DAY_TYPE < '1111111'        
		BEGIN        
			SET @SQLSTRING = @SQLSTRING + ' AND SUBSTRING(@WEEK_DAY_TYPE, DATEPART(WEEKDAY, DEP_DATE), 1) = ''1'''        
		END        
	END    
      
	IF @FLAG = 'C'     -- 전체 글수        
	BEGIN        
		SET @SQLSTRING = N'SELECT COUNT(*) FROM PKG_DETAIL A  WITH(NOLOCK ' +@SQLINDEXHINT+') ' + @SQLSTRING;      
	END        
	ELSE IF @FLAG = 'L'    -- 검색        
	BEGIN        
		SET @SQLSTRING = N'    
		WITH LIST AS            
		(             
			SELECT   
				ROW_NUMBER() OVER (ORDER BY A.DEP_DATE) AS [ROWNUMBER]
				, A.PRO_CODE    
				, A.PRO_NAME    
				, A.DEP_DATE    
				, A.SALE_TYPE    
				, ISNULL(A.FAKE_COUNT, 0) AS [FAKE_COUNT]    
				, ISNULL(A.MIN_COUNT, 0) AS [MIN_COUNT]    
				, ISNULL(A.MAX_COUNT, 0) AS [MAX_COUNT]  
				, ISNULL((SELECT TOP 1 ADT_PRICE FROM PKG_DETAIL_PRICE WHERE PRO_CODE = A.PRO_CODE ORDER BY ADT_PRICE), 0) AS [PRO_PRICE]
				, ISNULL(dbo.XN_PRO_DETAIL_SALE_PRICE_CUTTING(A.PRO_CODE,0) , 0) AS [PRO_SALE_PRICE] --추가  
				, DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS [RES_COUNT]  
				, (SELECT KOR_NAME FROM EMP_MASTER WHERE EMP_CODE = A.NEW_CODE) AS [NEW_NAME]  
				, A.NEW_CODE  
				, A.DEP_CFM_YN    
				, A.CONFIRM_YN    
				, A.RES_ADD_YN    
				, DBO.FN_PRO_GET_ACCOUNT_STATE(A.PRO_CODE) AS [ACCOUNT_TYPE]     
				, A.PKG_INSIDE_REMARK     
				, A.SHOW_YN    
				, A.SEAT_CODE    
			FROM PKG_DETAIL A WITH(NOLOCK'+@SQLINDEXHINT+')
			' + @SQLSTRING + '
		)            
		SELECT
			A.ROWNUMBER    
			, A.PRO_CODE    
			, A.PRO_NAME    
			, A.DEP_DATE    
			, A.SALE_TYPE    
			, A.FAKE_COUNT    
			, A.MIN_COUNT  
			, A.MAX_COUNT    
			, A.PRO_SALE_PRICE
			, A.PRO_PRICE    
			, A.RES_COUNT    
			, A.NEW_CODE
			, A.NEW_NAME
			, A.DEP_CFM_YN    
			, A.CONFIRM_YN    
			, A.RES_ADD_YN    
			, A.ACCOUNT_TYPE     
			, A.PKG_INSIDE_REMARK     
			, A.SHOW_YN    
			, C.DEP_TRANS_CODE    
			, C.DEP_TRANS_NUMBER
			, D.TEAM_CODE
		FROM LIST A
			-- INNER JOIN PKG_DETAIL B  WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE               ------------------조인제거    
			LEFT JOIN PRO_TRANS_SEAT(NOLOCK) C ON A.SEAT_CODE = C.SEAT_CODE
			LEFT JOIN EMP_MASTER(NOLOCK) D ON A.NEW_CODE = D.EMP_CODE
		WHERE A.ROWNUMBER BETWEEN @FROM AND @TO
		ORDER BY A.DEP_DATE, A.PRO_CODE;';        
	END        
      
	SET @PARMDEFINITION = N'
		@FROM INT,
		@TO INT,
		@EMP_CODE VARCHAR(7),
		@TEAM_CODE VARCHAR(3),
		@PRO_CODE VARCHAR(20),
		@PRO_NAME NVARCHAR(100),
		@START_DATE VARCHAR(10),
		@END_DATE VARCHAR(10),
		@WEEK_DAY_TYPE VARCHAR(7),
		@CITY_CODE CHAR(3),
		@AIRLINE_CODE VARCHAR(2),
		@AIRLINE_NUMBER VARCHAR(4),
		@RES_YN INT';
      
	--PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@FROM,
		@TO,
		@EMP_CODE,
		@TEAM_CODE,
		@PRO_CODE,
		@PRO_NAME,
		@START_DATE,
		@END_DATE,
		@WEEK_DAY_TYPE,
		@CITY_CODE,
		@AIRLINE_CODE,
		@AIRLINE_NUMBER,
		@RES_YN;        

END        
        
GO
