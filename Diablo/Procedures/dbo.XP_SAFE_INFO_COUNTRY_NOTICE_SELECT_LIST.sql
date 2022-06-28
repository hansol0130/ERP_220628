USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_SAFE_INFO_COUNTRY_NOTICE_SELECT_LIST
■ DESCRIPTION				: 안전정보 여행경보제도 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
	declare @p4 int
	set @p4=417
	exec XP_SAFE_INFO_COUNTRY_NOTICE_SELECT_LIST @PAGE_INDEX=1,@PAGE_SIZE=5,@KEY=N'CityCodeString=C23,ICN,KWL&Title=',@TOTAL_COUNT=@p4 output
	select @p4

	declare @p4 int
	set @p4=417
	exec XP_SAFE_INFO_COUNTRY_NOTICE_SELECT_LIST @PAGE_INDEX=1,@PAGE_SIZE=5,@KEY=N'CityCodeString=&Title=',@TOTAL_COUNT=@p4 output
	select @p4
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-06		정지용			최초생성
   2016-01-14		정지용			텍스트 내용 / HTML 내용
================================================================================================================*/ 
CREATE PROC [dbo].[XP_SAFE_INFO_COUNTRY_NOTICE_SELECT_LIST]
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@TOTAL_COUNT	INT OUTPUT,
	@KEY			VARCHAR(100)
AS 
BEGIN

	DECLARE @TITLE VARCHAR(100)
	DECLARE @CITYCODE_STRING VARCHAR(100)
	SELECT @TITLE = Diablo.DBO.FN_PARAM(@KEY, 'Title'),
		   @CITYCODE_STRING = Diablo.DBO.FN_PARAM(@KEY, 'CityCodeString');

	DECLARE @NATION_CODE_STRING VARCHAR(100);

	IF @CITYCODE_STRING <> ''
	BEGIN
		SELECT 
			@NATION_CODE_STRING = STUFF((      
				SELECT DISTINCT
					',' + NATION_CODE 
				FROM PUB_CITY A WITH(NOLOCK) WHERE CITY_CODE IN ( SELECT Data FROM DBO.FN_XML_SPLIT(@CITYCODE_STRING, ',') )             
				FOR XML PATH('')
			), 1, 1, '');
	END

	/* 총 카운트 */
	SELECT
		@TOTAL_COUNT = COUNT(1)
	FROM 
	SAFE_INFO_COUNTRY_NOTICE WITH(NOLOCK)
	WHERE ((@TITLE = '') OR (@TITLE != '' AND TITLE LIKE '%' + @TITLE + '%'))
		AND NATION_CODE IN (
			SELECT 
				SAFE_NATION_CODE
			FROM SAFE_INFO_NATION_CATEGORY_MAP A WITH(NOLOCK) 
				WHERE NATION_CODE IN (SELECT Data FROM dbo.FN_XML_SPLIT(@NATION_CODE_STRING, ','))
		) AND WRT_DT > DATEADD(D,-120,GETDATE());

	/* 리스트 */			
	SELECT
		ID, TITLE, CONTENTS_HTML, CONTENTS, FILE_URL, CAST(WRT_DT AS DATETIME) AS WRT_DT
	FROM SAFE_INFO_COUNTRY_NOTICE WITH(NOLOCK)
	WHERE ((@TITLE = '') OR (@TITLE != '' AND TITLE LIKE '%' + @TITLE + '%'))
		AND NATION_CODE IN (
			SELECT 
				SAFE_NATION_CODE
			FROM SAFE_INFO_NATION_CATEGORY_MAP A WITH(NOLOCK) 
				WHERE NATION_CODE IN (SELECT Data FROM dbo.FN_XML_SPLIT(@NATION_CODE_STRING, ','))
		) AND WRT_DT > DATEADD(D,-120,GETDATE())
	ORDER BY WRT_DT DESC
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY;

END



GO
