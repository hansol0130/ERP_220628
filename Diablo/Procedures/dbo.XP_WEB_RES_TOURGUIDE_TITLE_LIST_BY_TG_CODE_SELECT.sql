USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_RES_TOURGUIDE_TITLE_LIST_BY_TG_CODE_SELECT
■ DESCRIPTION				: 여가코드별 여행가이드 메뉴 리스트 검색
■ INPUT PARAMETER			: 
	@TG_CODE_STRING VARCHAR(1000)	: 예약코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_WEB_RES_TOURGUIDE_TITLE_LIST_BY_TG_CODE_SELECT '100,101,10202,10401,'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-07-04		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_WEB_RES_TOURGUIDE_TITLE_LIST_BY_TG_CODE_SELECT]
(
	@TG_CODE_STRING	VARCHAR(1000)
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @SQLSTRING NVARCHAR(MAX), @TEMP_PARENT_CODE VARCHAR(1000), @TEMP_TG_CODE VARCHAR(4000);

	-- 부모 코드 체크
	SELECT @TEMP_PARENT_CODE = '''' + REPLACE((
		SELECT (SUBSTRING(DATA, 1, 3) + ',') AS [text()]
		FROM DBO.FN_SPLIT(@TG_CODE_STRING, ',')
		WHERE Data <> ''
		GROUP BY SUBSTRING(DATA, 1, 3) FOR XML PATH('')), ',', ''',''') + '''';

	-- 목차 코드 체크
	SELECT @TEMP_TG_CODE = '''' + REPLACE(@TG_CODE_STRING, ',', ''',''') + ''''

	SET @SQLSTRING = N'
	WITH LIST AS
	(
		SELECT A.TG_CODE, A.TG_NAME, A.PARENT_TG_CODE, CONVERT(VARCHAR(50), '''') AS [PARENT_TG_NAME], A.FILE_NUM, A.ORDER_NUM, 0 AS [LEVEL]
		FROM CUS_TOURGUIDE A WITH(NOLOCK)
		WHERE A.PARENT_TG_CODE IS NULL AND A.TG_CODE IN (' + @TEMP_PARENT_CODE + N')
		UNION ALL
		SELECT A.TG_CODE, A.TG_NAME, A.PARENT_TG_CODE, B.TG_NAME, A.FILE_NUM, A.ORDER_NUM, [LEVEL] + 1
		FROM CUS_TOURGUIDE A WITH(NOLOCK)
		INNER JOIN LIST B ON A.PARENT_TG_CODE = B.TG_CODE
		WHERE A.TG_CODE IN (' + @TEMP_TG_CODE + N')
	)
	SELECT A.TG_CODE, A.TG_NAME, A.PARENT_TG_CODE, A.PARENT_TG_NAME, A.FILE_NUM, ROW_NUMBER() OVER(ORDER BY ORDER_NUM) AS [PAGING_NUM]
	FROM LIST A
	ORDER BY A.ORDER_NUM;'

	--PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING


END
GO
