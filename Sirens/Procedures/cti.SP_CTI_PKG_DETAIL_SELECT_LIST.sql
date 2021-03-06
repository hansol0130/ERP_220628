USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_PKG_DETAIL_SELECT_LIST
■ DESCRIPTION				: 행사정보 리스트
■ INPUT PARAMETER			: 	
■ OUTPUT PARAMETER			: 
	@MASTER_CODE	: 마스터 코드
	@PRO_CODE		: 행사코드
	@START_DATE		: 출발일
	@END_DATE		: 도착일
	@ATT_CODE		: 속성코드
	@SIGN_CODE		: 지역코드
	@CITY_CODE		: 도시코드
	@RES_YN			: 모객단체
	@KEYWORD		: 키워드
	@GROUP_CODE		: 그룹코드
	@PRICE			: 가격
	@PERIOD			: 기간
	@DEP_CFM_YN		: 출발확정여부
■ EXEC						: 	
	EXEC CTI.SP_CTI_PKG_DETAIL_SELECT_LIST 
	@MASTER_CODE=NULL,@PRO_CODE=NULL,@SIGN_CODE='J',@START_DATE='2013-01-01 00:00:00',@END_DATE='2013-01-08 00:00:00'
	,@ATT_CODE='F',@RES_YN=1,@CITY_CODE=NULL,@KEYWORD=NULL,@GROUP_CODE=NULL,@PRICE=0,@PERIOD='', @DEP_CFM_YN = ''

	exec cti.SP_CTI_PKG_DETAIL_SELECT_LIST 
	@MASTER_CODE=NULL,@PRO_CODE=NULL,@SIGN_CODE='J',@START_DATE=N'2013-01-01',@END_DATE=N'2013-01-08',
	@ATT_CODE='F',@RES_YN=1,@CITY_CODE=NULL,@KEYWORD=NULL,@GROUP_CODE=NULL,@PRICE=0,@PERIOD=NULL,@DEP_CFM_YN=NULL

	EXEC CTI.SP_CTI_PKG_DETAIL_SELECT_LIST 
	@MASTER_CODE=NULL,@PRO_CODE='XXX201-141109',@SIGN_CODE=NULL,@START_DATE=NULL,@END_DATE=NULL
	,@ATT_CODE=NULL,@RES_YN=NULL,@CITY_CODE=NULL,@KEYWORD=NULL,@GROUP_CODE=NULL,@PRICE=NULL,@PERIOD=NULL, @DEP_CFM_YN = NULL
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-22		정지용			최초생성
   2014-11-21		김성호			GROUP_CODE 검색 조건 추가, KEYWORD FULL TEXT INDEX 사용하도록 수정
   2015-01-22		김성호			키워드 검색 컬럼 추가 (MASTER_NAME, PKG_COMMENT)
   2015-08-05		정지용			SHOW_YN = 'Y' 추가
   2019-11-27		박형만			DEP_CFM_YN =F 출발확정(가) 도 검색되도록 수정 
================================================================================================================*/ 

CREATE PROCEDURE [cti].[SP_CTI_PKG_DETAIL_SELECT_LIST]
(
	@MASTER_CODE	VARCHAR(10),  
	@PRO_CODE		VARCHAR(20),  
	@START_DATE		DATETIME,  
	@END_DATE		DATETIME,  
	@ATT_CODE		VARCHAR(1),  
	@SIGN_CODE		VARCHAR(1),
	@CITY_CODE		VARCHAR(10) = '',
	@RES_YN			INT,
	@KEYWORD		VARCHAR(100),
	@GROUP_CODE		VARCHAR(10),
	@PRICE			INT,
	@PERIOD			VARCHAR(5),
	@DEP_CFM_YN		CHAR(1)
	
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @TEMP NVARCHAR(1000), @START VARCHAR(10), @END VARCHAR(10); 

	-- WHERE 조건 만들기  
	SET @SQLSTRING = '';  
	SET @START = ISNULL(CONVERT(VARCHAR(10), @START_DATE, 120), '')  
	SET @END = ISNULL(CONVERT(VARCHAR(10), DATEADD(DAY, 1, @END_DATE), 120), '')  

	SET @SQLSTRING = @SQLSTRING + ' A.SHOW_YN = ''Y'' AND'

	-- 마스터코드  
	IF ISNULL(@MASTER_CODE, '') <> '' 
	BEGIN  
		SET @SQLSTRING = @SQLSTRING + ' A.MASTER_CODE = @MASTER_CODE AND'  
	END 

	-- 행사코드  
	IF ISNULL(@PRO_CODE, '') <> ''  
	BEGIN  
		SET @SQLSTRING = @SQLSTRING + ' A.PRO_CODE LIKE @PRO_CODE + ''%'' AND'  
	END 

	-- 출발일  
	IF ISNULL(@START, '') <> '' AND ISNULL(@END, '') <> ''  
	BEGIN  
		SET @SQLSTRING = @SQLSTRING + ' A.DEP_DATE >= CAST(@START AS DATETIME) AND A.DEP_DATE < CAST(@END AS DATETIME) AND'  
	END  
	ELSE IF ISNULL(@START_DATE, '') <> '' AND ISNULL(@END_DATE, '') = ''  
	BEGIN  
		SET @SQLSTRING = @SQLSTRING + ' A.DEP_DATE >= CAST(@START_DATE AS DATETIME) AND'  
	END  
	ELSE IF ISNULL(@START_DATE, '') = '' AND ISNULL(@END_DATE, '') <> ''  
	BEGIN  
		SET @SQLSTRING = @SQLSTRING + ' A.DEP_DATE < CAST(@END_DATE AS DATETIME) + 1 AND'  
	END 
	
	-- 키워드입력  
	IF ISNULL(@KEYWORD, '') <> ''  
	BEGIN  
		SET @SQLSTRING = @SQLSTRING + ' (CONTAINS(C.MASTER_NAME, @KEYWORD) OR CONTAINS(C.KEYWORD, @KEYWORD) OR CONTAINS(C.PKG_COMMENT, @KEYWORD)) AND'
	END
	
	-- 그룹코드
	IF ISNULL(@GROUP_CODE, '') <> ''
	BEGIN
		SET @SQLSTRING = @SQLSTRING + ' A.MASTER_CODE IN (SELECT MASTER_CODE FROM Diablo.dbo.PKG_GROUP A WITH(NOLOCK) WHERE A.GROUP_CODE = @GROUP_CODE) AND'
	END
		
	--가격검색
	IF @PRICE > 0  
	BEGIN  
		SET @SQLSTRING = @SQLSTRING + ' C.LOW_PRICE >= @PRICE AND'  
	END
		
	--검색조건 추가 
	  	  
	-- 지역
	--IF ISNULL(@SIGN_CODE, '') <> ''  
	--BEGIN  
	--	SET @SQLSTRING = @SQLSTRING + ' C.SIGN_CODE = @SIGN_CODE AND';  
	--END  

	-- 속성  
	IF ISNULL(@ATT_CODE, '') <> ''  
	BEGIN  
		SET @SQLSTRING = @SQLSTRING + ' @ATT_CODE IN (SELECT ATT_CODE FROM DIABLO.DBO.PKG_ATTRIBUTE WHERE MASTER_CODE = C.MASTER_CODE)  AND';  
	END  
	  
	-- @예약자 유무  
	IF @RES_YN > 0  
	BEGIN  
		SET @SQLSTRING = @SQLSTRING + ' (DIABLO.DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) > 0 OR A.SALE_TYPE IN (2, 3) ) AND'  
	END    
		
	-- @도시코드
	IF ISNULL(@CITY_CODE, '') <> '' 
	BEGIN
		SET @SQLSTRING = @SQLSTRING + ' C.MASTER_CODE IN (SELECT MASTER_CODE FROM PKG_MASTER_SCH_CITY WHERE CITY_CODE= @CITY_CODE AND MAINCITY_YN =''Y'' ) AND'
	END  

	-- @기간
	IF ISNULL(@PERIOD, '') <> ''
	BEGIN
		IF @PERIOD = '10'
			SET @TEMP = ' AND TOUR_DAY >= @PERIOD'
		ELSE
			SET @TEMP = ' AND TOUR_DAY = @PERIOD'

		SET @SQLSTRING = @SQLSTRING + ' C.MASTER_CODE IN (SELECT MASTER_CODE FROM DIABLO.DBO.PKG_DETAIL WITH(NOLOCK) WHERE C.MASTER_CODE = MASTER_CODE' + @TEMP + ') AND'
	END

	IF ISNULL(@DEP_CFM_YN, '') <> '' AND ISNULL(@DEP_CFM_YN, '') IN( 'Y','F')
	BEGIN
		SET @SQLSTRING = @SQLSTRING + ' A.DEP_CFM_YN IN(''Y'',''F'') AND';
	END

	SET @SQLSTRING = 
	N'SELECT 
		A.DEP_CFM_YN, A.CONFIRM_YN, A.RES_ADD_YN, DIABLO.DBO.FN_PRO_GET_ACCOUNT_STATE(A.PRO_CODE) AS [ACCOUNT_TYPE],  
		A.PRO_CODE, A.DEP_DATE, B.DEP_DEP_DATE, B.DEP_DEP_TIME AS [DEP_TIME], A.ARR_DATE, B.ARR_ARR_DATE, B.ARR_ARR_TIME AS [ARR_TIME],
		(SELECT TOP 1 ADT_PRICE FROM DIABLO.DBO.PKG_DETAIL_PRICE WHERE PRO_CODE = A.PRO_CODE ORDER BY ADT_PRICE) AS [PRO_PRICE],  
		ISNULL(DIABLO.DBO.XN_PRO_DETAIL_SALE_PRICE_CUTTING(A.PRO_CODE,0) , 0) AS [PRO_SALE_PRICE], 
		B.DEP_TRANS_CODE, B.DEP_TRANS_NUMBER, A.PRO_NAME,
		DIABLO.DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS [RES_COUNT],  
		FAKE_COUNT, MAX_COUNT, MIN_COUNT, B.SEAT_COUNT, C.SIGN_CODE, A.SALE_TYPE, A.PRICE_TYPE, A.PKG_INSIDE_REMARK,
		A.TOUR_NIGHT, A.TOUR_DAY,
		D.KOR_NAME AS [NEW_NAME], A.NEW_CODE,  
		(SELECT TEAM_NAME FROM DIABLO.DBO.EMP_TEAM WITH(NOLOCK) WHERE TEAM_CODE = D.TEAM_CODE) AS [TEAM_NAME]
	FROM DIABLO.DBO.PKG_DETAIL A WITH(NOLOCK)   
	INNER JOIN DIABLO.DBO.PKG_MASTER C WITH(NOLOCK) ON C.MASTER_CODE = A.MASTER_CODE   
	LEFT OUTER JOIN DIABLO.DBO.PRO_TRANS_SEAT B  WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE 
	LEFT JOIN DIABLO.DBO.EMP_MASTER(NOLOCK) D ON A.NEW_CODE = D.EMP_CODE 
	WHERE' + SUBSTRING(@SQLSTRING, 0, LEN(@SQLSTRING) - 3) + '  
	ORDER BY A.DEP_DATE'  
	  
	SET @PARMDEFINITION = 
			N'@MASTER_CODE VARCHAR(10), 
			@PRO_CODE VARCHAR(20), 
			@START VARCHAR(10), 
			@END VARCHAR(10), 
			@ATT_CODE VARCHAR(1), 
			@RES_YN INT, 
			@SIGN_CODE VARCHAR(1), 
			@CITY_CODE VARCHAR(10), 
			@KEYWORD VARCHAR(100),
			@GROUP_CODE VARCHAR(10),
			@PRICE INT, 
			@PERIOD VARCHAR(5),
			@DEP_CFM_YN CHAR(1)';  

	--PRINT @SQLSTRING  

	EXEC SP_EXECUTESQL 
			@SQLSTRING, 
			@PARMDEFINITION, 
			@MASTER_CODE, 
			@PRO_CODE, 
			@START, 
			@END, 
			@ATT_CODE, 
			@RES_YN, 
			@SIGN_CODE, 
			@CITY_CODE, 
			@KEYWORD,
			@GROUP_CODE,
			@PRICE, 
			@PERIOD,
			@DEP_CFM_YN
END  
GO
