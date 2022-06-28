USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_INF_MASTER_LIST_SELECT
■ DESCRIPTION				: 컨텐츠 리스트 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			:   
■ EXEC						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2008-12-07		이규식			최초생성
   2009-05-08		김동수			페이징
   2012-03-02						WITH(NOLOCK) 추가
   2014-03-05						FN_ AIR_SPLIT_PARAMETER -> FN_SPLIT 으로 변경
   2016-08-03		김성호			CNT_TYPE 고정맵 타입 추가에 따른 수정 (APP 사용)
   2018-07-11		박형만			컨텐츠 검색 개선 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_INF_MASTER_LIST_SELECT]
	@FLAG			char(1),
	@PAGE_SIZE		int	= 10,
	@PAGE_INDEX		int = 0,	
	@REGION_CODE	char(3),
	@NATION_CODE	char(2),
	@STATE_CODE		varchar(4),
	@CITY_CODE		char(3),
	@ATTRIBUTE_CODE	varchar(100),
	@TITLE			varchar(100),
	@CNT_TYPE		INT , 

	--2018-07-11개선 추가
	@CNT_CODE	INT =0 , -- 컨텐츠 코드 입력시 나머지 조건 다 무시 
	@PRO_CODE	VARCHAR(20)=NULL , -- 마스터코드에 연관된 행사 
	@EDT_SDATE	VARCHAR(10)=NULL,
	@EDT_EDATE	VARCHAR(10)=NULL

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000),	@FROM INT,	@TO INT;
	SET @SQLSTRING = '';

	SET @FROM = @PAGE_INDEX * @PAGE_SIZE + 1;
	SET @TO = @PAGE_INDEX * @PAGE_SIZE + @PAGE_SIZE;

--	SET @FROM = ((@PAGE_INDEX - 1) * @PAGE_SIZE) + 1;
--	SET @TO = ((@PAGE_INDEX - 1) + 1) * @PAGE_SIZE

	-- 컨텐츠 코드 있으면  다른조건 무시 
	IF( @CNT_CODE > 0 )
	BEGIN
		SET @SQLSTRING = @SQLSTRING + ' AND CNT_CODE = @CNT_CODE '
	END 
	ELSE 
	BEGIN 
		-- 제목 있으면 지역무시 
		IF (@TITLE <> '')
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' AND KOR_TITLE LIKE ''%'' + @TITLE + ''%'''
		END
		-- 제목 없고 지역이 있으면 지역검색
		-- --> 2018-07-12 지역 추가 
		IF(ISNULL(@REGION_CODE,'000') <> '000')
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' AND REGION_CODE = @REGION_CODE';
		END 
		IF(ISNULL(@NATION_CODE,'000') <>  '000' AND @NATION_CODE <> '00')
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' AND NATION_CODE = @NATION_CODE';
		END 
		IF(ISNULL(@STATE_CODE,'000') <>  '000' AND @STATE_CODE <> '0000')
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' AND STATE_CODE = @STATE_CODE';
		END 
		IF(ISNULL(@CITY_CODE,'000') <>  '000' )
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' AND CITY_CODE = @CITY_CODE';
		END 

		
		--카테고리 구분 검색 	
		IF (@ATTRIBUTE_CODE <> '' AND @ATTRIBUTE_CODE IS NOT NULL )
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' AND A.CNT_CODE IN (SELECT CNT_CODE FROM INF_TYPE B WITH(NOLOCK) WHERE CNT_ATT_CODE IN 
	(SELECT Data FROM dbo.FN_SPLIT(@ATTRIBUTE_CODE,'','')))';	
		END 
		-- 컨텐츠 구분검색. 전체일때 고정맵항목은 제외
		IF (@CNT_TYPE = 0)
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' AND A.CNT_TYPE < 9';
		END
		ELSE
		BEGIN
			SET @SQLSTRING = @SQLSTRING + ' AND A.CNT_TYPE = @CNT_TYPE';
		END


		--행사,마스터 조건 
		IF(ISNULL(@PRO_CODE ,'') <> '')
		BEGIN
			-- 행사  LIKE 검색 
			-- EPP5442-180216 => ( EPP5442-180216EK , EPP5442-180216KE  전부 포함 ) 
			IF( CHARINDEX('-',@PRO_CODE) > 0 )
			BEGIN
				SET @SQLSTRING = @SQLSTRING + ' 
AND CNT_CODE IN ( 
 SELECT DISTINCT C.CNT_CODE  FROM PKG_DETAIL A 
 INNER JOIN PKG_DETAIL_SCH_MASTER B 
	ON A.PRO_CODE = B.PRO_CODE 
 INNER JOIN PKG_DETAIL_SCH_CONTENT C 
	ON A.PRO_CODE = C.PRO_CODE AND B.SCH_SEQ =  C.SCH_SEQ 
 WHERE A.PRO_CODE LIKE @PRO_CODE + ''%''
 AND A.DEP_dATE > DATEADD(YY,-1,GETDATe() ) 
 AND C.CNT_CODE > 0 ) '	
			END 
			ELSE  -- 마스터 
			BEGIN
				SET @SQLSTRING = @SQLSTRING + ' 
AND CNT_CODE IN ( 
 SELECT DISTINCT C.CNT_CODE  FROM PKG_DETAIL A 
 INNER JOIN PKG_DETAIL_SCH_MASTER B 
	ON A.PRO_CODE = B.PRO_CODE 
 INNER JOIN PKG_DETAIL_SCH_CONTENT C 
	ON A.PRO_CODE = C.PRO_CODE AND B.SCH_SEQ =  C.SCH_SEQ 
 WHERE A.MASTER_CODE = @PRO_CODE
 AND A.DEP_dATE > DATEADD(YY,-1,GETDATe() ) 
 AND C.CNT_CODE > 0 ) '	
			END 
		END 
		
		--수정일 검색 
		IF(ISNULL(@EDT_SDATE ,'') <> '' AND LEN(@EDT_SDATE) = 10  )
		BEGIN
			SET @SQLSTRING = @SQLSTRING + '
AND EDT_DATE >= CONVERT(DATETIME,@EDT_SDATE) '
		END 
		IF(ISNULL(@EDT_EDATE ,'') <> '' AND LEN(@EDT_EDATE) = 10  )
		BEGIN
			SET @SQLSTRING = @SQLSTRING + '
AND EDT_DATE < DATEADD(DD,1,CONVERT(DATETIME,@EDT_EDATE)) '
		END 

	END 
	
	

	-- 검색된 데이타의 카운트를 돌려준다.
	IF @FLAG = 'C'
	BEGIN
			SET @SQLSTRING = N'
			SELECT 
				COUNT(*) AS COUNT
			FROM 
				INF_MASTER A WITH(NOLOCK)
			WHERE 1 = 1
				 --KOR_TITLE LIKE ''%'' + ISNULL(@TITLE, '''') + ''%''
			' + @SQLSTRING;
	END
	-- 검색된 데이타의 리스트를 돌려준다.
	ELSE IF @FLAG = 'L'
	BEGIN
		SET @SQLSTRING = N'WITH TMP_INF_MASTER AS (
SELECT 
			ROW_NUMBER() OVER (ORDER BY CNT_CODE DESC) AS ROWNUMBER,
			CNT_CODE
		FROM 
			INF_MASTER A WITH(NOLOCK)
		WHERE 1 = 1
			--KOR_TITLE LIKE ''%'' + ISNULL(@TITLE, '''') + ''%''
		' + @SQLSTRING +
')
SELECT 
	*,
	(SELECT KOR_NAME FROM PUB_REGION B WITH(NOLOCK) WHERE B.REGION_CODE = A.REGION_CODE) AS REGION_NAME,
	(SELECT KOR_NAME FROM PUB_NATION B WITH(NOLOCK) WHERE B.NATION_CODE = A.NATION_CODE) AS NATION_NAME,
	(SELECT KOR_NAME FROM PUB_STATE B WITH(NOLOCK) WHERE B.STATE_CODE = A.STATE_CODE AND B.NATION_CODE = A.NATION_CODE) AS STATE_NAME,
	(SELECT KOR_NAME FROM PUB_CITY B WITH(NOLOCK) WHERE B.CITY_CODE = A.CITY_CODE) AS CITY_NAME,
	(SELECT KOR_NAME FROM EMP_MASTER B WITH(NOLOCK) WHERE B.EMP_CODE = A.NEW_CODE) AS NEW_NAME,
	(SELECT KOR_NAME FROM EMP_MASTER B WITH(NOLOCK) WHERE B.EMP_CODE = A.EDT_CODE) AS EDT_NAME,
	(SELECT TOP 1
		''/'' + B.REGION_CODE + ''/'' + B.NATION_CODE + ''/'' + 
		B.STATE_CODE + ''/'' + B.CITY_CODE + ''/IMAGE/'' + B.FILE_NAME_S
	FROM INF_FILE_MASTER B WITH(NOLOCK)
	INNER JOIN INF_FILE_MANAGER C WITH(NOLOCK) ON C.FILE_CODE = B.FILE_CODE
	WHERE C.CNT_CODE = A.CNT_CODE AND B.FILE_TYPE = 1
	ORDER BY SHOW_ORDER
	) AS IMAGE_NAME

FROM 
	INF_MASTER A WITH(NOLOCK)
WHERE
	A.CNT_CODE IN (
		SELECT 
			CNT_CODE
		FROM TMP_INF_MASTER
		WHERE ROWNUMBER BETWEEN @FROM AND @TO
		)
ORDER BY CNT_CODE DESC
		';
	END
	--SELECT @SQLSTRING
	SET @PARMDEFINITION=N'@FROM INT, @TO INT, @REGION_CODE CHAR(3), @NATION_CODE CHAR(2), @STATE_CODE VARCHAR(4), @CITY_CODE CHAR(3), @ATTRIBUTE_CODE VARCHAR(100), @TITLE VARCHAR(100), @CNT_TYPE INT,
@CNT_CODE INT, @PRO_CODE VARCHAR(20), @EDT_SDATE VARCHAR(10),@EDT_EDATE VARCHAR(10)';
	PRINT @SQLSTRING + ' ' + @PARMDEFINITION
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @FROM, @TO, @REGION_CODE, @NATION_CODE, @STATE_CODE, @CITY_CODE, @ATTRIBUTE_CODE, @TITLE, @CNT_TYPE
	,@CNT_CODE, @PRO_CODE , @EDT_SDATE ,@EDT_EDATE 
END

--EXEC SP_INF_MASTER_LIST_SELECT 'C', 10, 1, '340', 'AU','AUNW', 'SYD', '', '', 0
--EXEC SP_INF_MASTER_LIST_SELECT 'L', 10, 1, '340', 'AU','AUNW', 'SYD', '', '', 0

GO