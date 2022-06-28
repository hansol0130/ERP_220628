USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_SHORTURL_SELECT
■ DESCRIPTION				: 단축 주소 검색
■ INPUT PARAMETER			: 
	@URL					: 주소
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_PUB_SHORTURL_SELECT '/Mov2/Product/PackageMaster?MasterCode=MPP947&MenuCode=101130101&atype=MB'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-07		김성호			최초생성
   2017-11-30		정지용			쿼리부하로 인해 인덱스 생성 및 쿼리 변경
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_PUB_SHORTURL_SELECT]
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
	SET @URL = LOWER(@URL);
	SET @URL_LEN = LEN(@URL);

	SELECT TOP 1 A.SHORTURL FROM VGLOG.DBO.PUB_SHORTURL A WITH(NOLOCK, INDEX = IDX_PUB_SHORTURL_1) WHERE URL = @URL
	--WHERE URL LIKE @URL + '%' AND LEN(URL) = @URL_LEN;

END



/*


declare @url varchar(1000) = '/product/package/packagedetail?procode=app2510-161214lj&priceseq=1&menucode=';


with list as (
	select @url as url
		, substring(@url, 1, charindex('?', @url, 1)) as front_url
		, charindex('procode=', @url) as [index]
		, substring(@url, charindex('procode=', @url), 100) as [procode_url]
)
select *, (case when charindex('&', a.procode_url) > 0 then substring(a.procode_url, 1, (charindex('&', a.procode_url) - 1)) else a.procode_url end) as [procode]
from list a


with list as (
	select @url as url
		, substring(@url, 1, charindex('?', @url, 1)) as front_url
		, charindex('procode=', @url) as [index]
		, substring(@url, charindex('procode=', @url), 100) as [procode_url]
), list2 as (
select *, (case when charindex('&', a.procode_url) > 0 then substring(a.procode_url, 1, (charindex('&', a.procode_url) - 1)) else a.procode_url end) as [procode]
from list a
)
select top 1 a.*
from VGLOG.DBO.PUB_SHORTURL A WITH(NOLOCK)
cross join list2 b
where a.url like (b.front_url + '%') and charindex(b.procode, a.url) > 0


*/
GO
