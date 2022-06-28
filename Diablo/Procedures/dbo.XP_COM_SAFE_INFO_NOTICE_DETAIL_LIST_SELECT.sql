USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_SAFE_INFO_NOTICE_DETAIL_LIST_SELECT
■ DESCRIPTION				: BTMS 안전정보리스트
■ INPUT PARAMETER			: 
   @KEY		VARCHAR(400)    : 검색 키
■ OUTPUT PARAMETER			: 
■ EXEC						: 
  XP_COM_SAFE_INFO_NOTICE_DETAIL_LIST_SELECT 'RegionName=중동/아프리카'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-02		저스트고			최초생성
   2016-02-23		저스트고			여행금지 테이블 조인
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_SAFE_INFO_NOTICE_DETAIL_LIST_SELECT]
(
	@KEY		VARCHAR(400)
)
	
AS 
BEGIN

	-- 검색_안전정보_리스트 --
	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(1000);
	DECLARE @REGION_NAME VARCHAR(50), @COUNTRY_NAME VARCHAR(100);

	SELECT
		@REGION_NAME = DBO.FN_PARAM(@KEY, 'RegionName'),
		@COUNTRY_NAME = DBO.FN_PARAM(@KEY, 'CountryName')
	
	SELECT @WHERE = ' WHERE 1 = 1'

	IF LEN(@REGION_NAME) > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND A.CONTINENT = @REGION_NAME  '
	END

	IF LEN(@COUNTRY_NAME) > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND A.COUNTRY_NAME LIKE ''%' + @COUNTRY_NAME + '%'' '
	END

	SET @SQLSTRING = N'
	SELECT

	--기본정보
	A.ID,
	A.CONTINENT,
	A.COUNTRY_NAME,
	A.COUNTRY_EN_NAME,
	A.BASIC_INFO,
	A.IMG_URL,
	A.WRT_DT,
	A.NEW_DATE,

	--유의
	B.ATTENTION,
	B.ATTENTION_PARTIAL,
	B.ATTENTION_NOTE,
	B.[CONTROL],
	B.CONTROL_PARTIAL,
	B.CONTROL_NOTE,
	B.LIMITA,
	B.LIMITA_PARTIAL,
	B.LIMITA_NOTE,

	--금지
	C.BAN,
	C.BAN_PARTIAL,
	C.BAN_NOTE

	FROM SAFE_INFO_COUNTRY_BASIC A
	LEFT JOIN SAFE_INFO_TRAVEL_WARNING B ON A.ID = B.ID
	LEFT JOIN SAFE_INFO_TRAVEL_BAN C ON A.ID = C.ID'
		+ @WHERE + 
		N'ORDER BY A.COUNTRY_NAME'
	
	SET @PARMDEFINITION = N'
		@REGION_NAME VARCHAR(50),
		@COUNTRY_NAME VARCHAR(100)';

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @REGION_NAME, @COUNTRY_NAME;
END 

GO
