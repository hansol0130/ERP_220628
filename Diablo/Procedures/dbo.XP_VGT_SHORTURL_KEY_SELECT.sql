USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_VGT_SHORTURL_KEY_SELECT
■ DESCRIPTION				: 단축 주소 검색 NEW 
■ INPUT PARAMETER			: 
	@URL					: 주소
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_VGT_SHORTURL_KEY_SELECT '1A' 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
      2018-04-17		박형만			최초생성
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_VGT_SHORTURL_KEY_SELECT]
(
	@URL	VARCHAR(900)
)

AS  
BEGIN
	--WITH LIST AS (
	--	SELECT @URL AS URL
	--		, SUBSTRING(@URL, 1, CHARINDEX('?', @URL, 1)) AS FRONT_URL
	--		, CHARINDEX('PROCODE=', @URL) AS [INDEX]
	--		, SUBSTRING(@URL, CHARINDEX('PROCODE=', @URL), 100) AS [MAIN_PARAM]
	--), LIST2 AS (
	--SELECT *, (CASE WHEN CHARINDEX('&', A.MAIN_PARAM) > 0 THEN SUBSTRING(A.MAIN_PARAM, 1, (CHARINDEX('&', A.MAIN_PARAM) - 1)) ELSE A.MAIN_PARAM END) AS [MAIN_KEY]
	--FROM LIST A
	--)
	--SELECT TOP 1 A.*
	--FROM VGLOG.DBO.PUB_SHORTURL A WITH(NOLOCK)
	--CROSS JOIN LIST2 B
	--WHERE A.URL LIKE (B.FRONT_URL + '%') AND A.MainKey = B.MAIN_KEY

	--SELECT A.SHORTURL FROM VGLOG.DBO.PUB_SHORTURL A WITH(NOLOCK) WHERE PATINDEX((LOWER(@URL) + '%'), A.URL) > 0

	DECLARE @URL_LEN INT;
	--SET @URL = LOWER(@URL);
	--SET @URL_LEN = LEN(@URL);

	--SELECT '/';
	--RETURN;
	SELECT TOP 1 A.URL_KEY FROM VGLOG.DBO.VGT_SHORTURL A WITH(NOLOCK) WHERE URL = @URL
	ORDER BY SEq_NO DESC -- 최신 
	--WHERE URL LIKE @URL + '%' AND LEN(URL) = @URL_LEN;

END
GO
