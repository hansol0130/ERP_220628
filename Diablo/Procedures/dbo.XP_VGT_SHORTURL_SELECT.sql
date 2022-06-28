USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_VGT_SHORTURL_SELECT
■ DESCRIPTION				: 단축 주소 검색 NEW http://vgt.kr/1
■ INPUT PARAMETER			: 
	@URL					: 주소
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_VGT_SHORTURL_SELECT 1 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
      2018-04-17		박형만			최초생성
	  2019-03-07		박형만			인덱스 SCAN 타는 현상 제거 URL_KEY 컬럼  COLLATE Korean_Wansung_CS_AS 로 수정 
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_VGT_SHORTURL_SELECT]
(
	@URL_KEY	VARCHAR(20)
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
	--SELECT TOP 1 A.URL FROM VGLOG.DBO.VGT_SHORTURL A WITH(NOLOCK) WHERE URL_KEY COLLATE Korean_Wansung_CS_AS = @URL_KEY
	SELECT TOP 1 A.URL FROM VGLOG.DBO.VGT_SHORTURL A WITH(NOLOCK) WHERE URL_KEY = @URL_KEY
	ORDER BY SEq_NO DESC -- 최신 
	--WHERE URL LIKE @URL + '%' AND LEN(URL) = @URL_LEN;

END
GO
