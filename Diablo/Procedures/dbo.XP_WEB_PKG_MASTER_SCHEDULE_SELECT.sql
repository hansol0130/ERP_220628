USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_PKG_MASTER_SCHEDULE_SELECT
■ DESCRIPTION				: 행사 마스터 일정표 검색
■ INPUT PARAMETER			: 
	@MASTER_CODE VARCHAR(10): 마스터코드
	@SCH_SEQ INT			: 일정순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_WEB_PKG_MASTER_SCHEDULE_SELECT 'EPF002', 1

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-09-05		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_WEB_PKG_MASTER_SCHEDULE_SELECT]
(
	@MASTER_CODE	VARCHAR(20),
	@SCH_SEQ		INT
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);
	
	SET @SQLSTRING = N'
	-- 일자정보
	SELECT A.*, STUFF((
			SELECT (''-'' + BB.KOR_NAME) AS [text()] FROM PKG_MASTER_SCH_CITY AA WITH(NOLOCK) LEFT JOIN PUB_CITY BB WITH(NOLOCK) ON AA.CITY_CODE = BB.CITY_CODE WHERE AA.MASTER_CODE = A.MASTER_CODE AND AA.SCH_SEQ = A.SCH_SEQ AND AA.DAY_SEQ = A.DAY_SEQ ORDER BY AA.CITY_SHOW_ORDER FOR XML PATH('''')
		), 1, 1, '''') AS [TOUR_JOURNEY]
	FROM PKG_MASTER_SCH_DAY A WITH(NOLOCK)
	WHERE A.MASTER_CODE = @MASTER_CODE AND A.SCH_SEQ = @SCH_SEQ
	ORDER BY A.DAY_NUMBER;
	-- 도시
	SELECT A.*, B.KOR_NAME AS [CITY_NAME]
	FROM PKG_MASTER_SCH_CITY A WITH(NOLOCK)
	LEFT JOIN PUB_CITY B WITH(NOLOCK) ON A.CITY_CODE = B.CITY_CODE
	WHERE A.MASTER_CODE = @MASTER_CODE AND A.SCH_SEQ = @SCH_SEQ
	ORDER BY A.CITY_SHOW_ORDER;
	-- 컨텐츠
	SELECT A.*, B.KOR_TITLE, B.GPS_X, B.GPS_Y, B.SHORT_DESCRIPTION, B.DESCRIPTION, B.DISPLAY_TYPE, B.CNT_TYPE, B.SHOW_YN AS CNTSHOW_YN
		, (CASE A.CNT_CODE WHEN 0 THEN NULL ELSE DBO.XN_CNT_GET_IMAGE_FILE_PATH_STRING(A.CNT_CODE, (CASE B.DISPLAY_TYPE WHEN 2 THEN 2 ELSE 1 END), ''|'') END) AS [FILE_PATH_STRING]
	FROM PKG_MASTER_SCH_CONTENT A WITH(NOLOCK)
	LEFT JOIN INF_MASTER B WITH(NOLOCK) ON A.CNT_CODE = B.CNT_CODE
	WHERE A.MASTER_CODE = @MASTER_CODE AND A.SCH_SEQ = @SCH_SEQ
	ORDER BY A.CNT_SHOW_ORDER;
	'

	SET @PARMDEFINITION = N'
		@MASTER_CODE VARCHAR(10),
		@SCH_SEQ INT';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@MASTER_CODE,
		@SCH_SEQ;

END
GO
