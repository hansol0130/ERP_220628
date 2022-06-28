USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_ROAD_ADDRESS_SELECT_LIST
■ DESCRIPTION				: 도로명 주소 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
	EXEC DBO.SP_ROAD_ADDRESS_SELECT_LIST 0, '서울특별시', '중구', '서소문로', '135', '' -- 지역선택 + 도로명 + 건물번호 검색
	EXEC DBO.SP_ROAD_ADDRESS_SELECT_LIST 1, '서울특별시', '강서구', '염창동', '292', '' -- 지역선택 + 동 + 지번 검색
	EXEC DBO.SP_ROAD_ADDRESS_SELECT_LIST 2, '경상북도', '구미시', '', '', '농협' -- 건물명 검색
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-11-11		정지용			최초생성
   2016-12-06		정지용			건물명 검색 수정
================================================================================================================*/ 
CREATE PROC [dbo].[SP_ROAD_ADDRESS_SELECT_LIST_TEST]
 	@SEARCH_TYPE INT,
	@SIDO VARCHAR(40),
	@SIGUNGU VARCHAR(40),
	@ROAD_NAME VARCHAR(80),
	@ROAD_NUM VARCHAR(10),
	@BUILD_NAME VARCHAR(200)
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @SORT_STRING VARCHAR(100);


	SET @WHERE  = 'C.대표여부 = 1 '
	
	IF @SIDO <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.시도명 = @SIDO ';
	END

	IF @SIGUNGU <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.시군구명 = @SIGUNGU ';
	END

	IF @SEARCH_TYPE = 0 -- 지역선택 + 도로명 + 건물번호 검색
	BEGIN
		SET @WHERE = @WHERE + ' AND CONVERT(VARCHAR, B.건물본번) + ''-'' + CONVERT(VARCHAR, B.건물부번) LIKE @ROAD_NUM + ''%'' AND A.도로명 LIKE @ROAD_NAME + ''%'' ';
	END
	ELSE IF @SEARCH_TYPE = 1 -- 지역선택 + 동 + 지번 검색
	BEGIN
		SET @WHERE = @WHERE + ' AND CONVERT(VARCHAR, C.지번본번) + ''-'' + CONVERT(VARCHAR, C.지번부번) LIKE @ROAD_NUM + ''%'' AND C.법정읍면동명 + C.법정리명 LIKE REPLACE(@ROAD_NAME, '' '', '''') + ''%'' ';
	END
	ELSE IF @SEARCH_TYPE = 2 -- 건물명 검색
	BEGIN
		SELECT @BUILD_NAME = STUFF((SELECT (' OR "' + Data + '"') AS [text()] FROM [dbo].[FN_SPLIT](@BUILD_NAME, ',') FOR XML PATH('')), 1, 5, '"')
		--SET @WHERE = @WHERE + ' AND CONTAINS ((D.건축물대장건물명, D.시군구건물명), @BUILD_NAME) ';		
		--SET @WHERE = @WHERE + ' AND D.시군구건물명 LIKE ''%'' + @BUILD_NAME + ''%'' ';		
		SET @WHERE = @WHERE + ' AND D.시군구건물명 LIKE @BUILD_NAME + ''%'' ';		
	END
	
	SET @SQLSTRING = N'
		WITH ROAD_ADDRESS AS(
			SELECT		
	 			A.도로명코드, A.도로명, A.시도명, A.시군구명,  A.읍면동구분, B.지하여부, 
				B.관리번호, B.건물본번, B.건물부번, 
				C.법정읍면동명, C.법정리명, C.산여부, C.지번본번, C.지번부번,
				D.우편번호, D.건축물대장건물명, D.시군구건물명, D.공동주택여부
			FROM ROAD_ADDR_CODE A WITH(NOLOCK)
			INNER JOIN ROAD_ADDR B WITH(NOLOCK) ON A.도로명코드 = B.도로명코드 AND A.읍면동일련번호 = B.읍면동일련번호
			INNER JOIN ROAD_ADDR_JIBUN C WITH(NOLOCK) ON C.관리번호 = B.관리번호
			INNER JOIN ROAD_ADDR_INFO D WITH(NOLOCK) ON D.관리번호 = B.관리번호
			WHERE ' + @WHERE + N'     
		)	
		SELECT 
			우편번호 AS POST_NUM,
			시도명 + '' ''
			+ 시군구명 + '' ''
			+ 도로명 + '' ''
			+ CASE 지하여부 
				WHEN ''0'' THEN ''''
				WHEN ''1'' THEN ''지하''
				WHEN ''2'' THEN ''공중'' END
			+ CONVERT(VARCHAR, 건물본번) + CASE WHEN 건물부번 = 0 THEN '''' ELSE ''-'' + CONVERT(VARCHAR, 건물부번) END 
			+ CASE 
				WHEN 읍면동구분 = ''0'' AND 공동주택여부 = ''0'' THEN ''''
				WHEN 읍면동구분 = ''0'' AND 공동주택여부 = ''1'' THEN '' ('' + 시군구건물명 + '')''
				WHEN 읍면동구분 = ''1'' AND 공동주택여부 = ''0'' THEN '' ('' + 법정읍면동명 + '')''
				WHEN 읍면동구분 = ''1'' AND 공동주택여부 = ''1'' THEN '' ('' + 법정읍면동명 + '','' + 시군구건물명 + '')'' END AS ROAD_ADDR,
			시도명 + '' ''
			+ 시군구명 + '' ''
			+ CASE 
				WHEN 읍면동구분 = ''0'' THEN 법정읍면동명 + '' '' + CASE WHEN RTRIM(LTRIM(법정리명)) <> '''' THEN 법정리명 ELSE '''' END
				ELSE 법정읍면동명 END + '' ''
			+ CONVERT(VARCHAR, 지번본번) + CASE WHEN 지번부번 = 0 THEN '''' ELSE ''-'' + CONVERT(VARCHAR, 지번부번) END AS ROAD_JIBUN_ADDR
			, 시군구건물명 AS BUILD_NAME
		FROM ROAD_ADDRESS';

	--SET @SQLSTRING = N'
	--	WITH ROAD_ADDRESS AS (
	--		SELECT DISTINCT  A. 법정동코드, A.시도명, A.시군구명, A.법정읍면동명, A.법정리명, A.도로명코드,
	--					A.도로명, A.지하여부, A.건물본번, A.건물부번, A.시군구용건물명, A.산여부, A.지번본번,
	--					A.지번부번, A.기초구역번호, A.공동주택여부, A.읍면동일련번호 , Y.읍면동구분
	--		FROM ROAD_BUILD A WITH(NOLOCK)
	--		INNER JOIN ROAD_CODE Y  ON A.도로명코드 = Y.도로명코드 AND A.읍면동일련번호 = Y.읍면동일련번호
	--		WHERE ' + @WHERE + N'    
	--		UNION
	--		SELECT DISTINCT X.법정동코드, X.시도명, X.시군구명, X.법정읍면동명, X.법정리명, X.도로명코드,
	--					A.도로명, A.지하여부, A.건물본번, A.건물부번, A.시군구용건물명, X.산여부,
	--					X.지번본번, X.지번부번, A.기초구역번호, A.공동주택여부, A.읍면동일련번호, Y.읍면동구분
	--		FROM ROAD_BUILD A WITH(NOLOCK)
	--		INNER JOIN ROAD_JIBUN X WITH(NOLOCK) ON A.도로명코드 = X.도로명코드 AND A.지하여부 = X.지하여부 AND A.건물본번 = X.건물본번 AND A.건물부번 = X.건물부번
	--		INNER JOIN ROAD_CODE Y WITH(NOLOCK) ON A.도로명코드 = Y.도로명코드 AND A.읍면동일련번호 = Y.읍면동일련번호
	--		WHERE ' + @WHERE + N'    
	--	)
	--	SELECT 
	--		기초구역번호 AS POST_NUM,
	--		시도명 + '' ''
	--		+ 시군구명 + '' ''
	--		+ 도로명 + '' ''
	--		+ CASE 지하여부 
	--			WHEN ''0'' THEN ''''
	--			WHEN ''1'' THEN ''지하''
	--			WHEN ''2'' THEN ''공중'' END
	--		+ CONVERT(VARCHAR, 건물본번) + CASE WHEN 건물부번 = 0 THEN '''' ELSE ''-'' + CONVERT(VARCHAR, 건물부번) END
	--		+ CASE 
	--			WHEN 읍면동구분 = ''0'' AND 공동주택여부 = ''0'' THEN ''''
	--			WHEN 읍면동구분 = ''0'' AND 공동주택여부 = ''1'' THEN '' ('' + 시군구용건물명 + '')''
	--			WHEN 읍면동구분 = ''1'' AND 공동주택여부 = ''0'' THEN '' ('' + 법정읍면동명 + '')''
	--			WHEN 읍면동구분 = ''1'' AND 공동주택여부 = ''1'' THEN '' ('' + 법정읍면동명 + '','' + 시군구용건물명 + '')'' END AS ROAD_ADDR
	--		, 시도명 + '' ''
	--		+ 시군구명 + '' ''
	--		+ CASE 
	--			WHEN 읍면동구분 = ''0'' THEN '''' 
	--			ELSE 법정읍면동명 END + '' ''
	--		+ CONVERT(VARCHAR, 지번본번) + CASE WHEN 지번부번 = 0 THEN '''' ELSE ''-'' + CONVERT(VARCHAR, 지번부번) END + '' '' + 시군구용건물명 AS ROAD_JIBUN_ADDR
	--		, 산여부
	--	FROM ROAD_ADDRESS ORDER BY 건물본번, 건물부번;';
--		WHERE ' + @WHERE + '; ';		
	 
	SET @PARMDEFINITION = N'
		@SEARCH_TYPE INT,
		@SIDO VARCHAR(40),
		@SIGUNGU VARCHAR(40),
		@ROAD_NAME VARCHAR(80),
		@ROAD_NUM VARCHAR(10),
		@BUILD_NAME VARCHAR(200)';

	PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@SEARCH_TYPE,
		@SIDO,
		@SIGUNGU,
		@ROAD_NAME,
		@ROAD_NUM,
		@BUILD_NAME
END
GO
