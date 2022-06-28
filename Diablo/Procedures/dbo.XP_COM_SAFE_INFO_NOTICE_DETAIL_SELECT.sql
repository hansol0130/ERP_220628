USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_SAFE_INFO_NOTICE_DETAIL_SELECT
■ DESCRIPTION				: BTMS 안전정보 상세
■ INPUT PARAMETER			: 
	@ID  VARCHAR(50)		: ID 값
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-26		저스트고이유라		최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_SAFE_INFO_NOTICE_DETAIL_SELECT]
(
	@ID		VARCHAR(50)
)
	
AS 
BEGIN
	-- 안전소식상세 --
	/* 조회시 조회수 1 증가 */
	UPDATE SAFE_INFO_COUNTRY_NOTICE SET SHOW_COUNT = ISNULL(SHOW_COUNT, 0) + 1
	WHERE ID = @ID

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	/* 조회 */
	SELECT	
	A.ID,
	A.NATION_CODE,
	B.SAFE_KOR_NAME AS NATION_NAME,
	(SELECT D.KOR_NAME FROM PUB_REGION D WHERE C.REGION_CODE = D.REGION_CODE) AS REGION_NAME,
	A.TITLE,
	A.CONTENTS_HTML,
	A.CONTENTS,
	A.FILE_URL,
	A.WRT_DT,
	A.NEW_DATE,
	A.SHOW_COUNT
	FROM SAFE_INFO_COUNTRY_NOTICE A
	LEFT JOIN SAFE_INFO_NATION_CATEGORY_MAP B ON A.NATION_CODE = B.SAFE_NATION_CODE
	LEFT JOIN PUB_NATION C ON B.NATION_CODE = C.NATION_CODE
	WHERE A.ID = @ID
	ORDER BY A.WRT_DT DESC

	/* 이전글 */
	SELECT TOP 1 ID, TITLE, WRT_DT
	FROM SAFE_INFO_COUNTRY_NOTICE
	WHERE ID < @ID
	ORDER BY WRT_DT DESC;

	/* 다음글 */
	SELECT TOP 1 ID, TITLE, WRT_DT
	FROM SAFE_INFO_COUNTRY_NOTICE A 
	WHERE ID > @ID
	ORDER BY WRT_DT ASC;

END 
GO
