USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_SAFE_INFO_SELECT
■ DESCRIPTION				: 안전정보 전체 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
	EXEC XP_COM_SAFE_INFO_SELECT '304'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-18		저스트고이유라			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_SAFE_INFO_SELECT]
	@ID VARCHAR(20)
AS 
BEGIN

	DECLARE @NATION_NAME VARCHAR(100), @NATION_CODE VARCHAR(3);
	SET @NATION_NAME = (SELECT COUNTRY_NAME FROM SAFE_INFO_COUNTRY_BASIC WHERE ID = @ID)
	SET @NATION_CODE = (SELECT G.SAFE_NATION_CODE FROM SAFE_INFO_NATION_CATEGORY_MAP G WHERE G.SAFE_KOR_NAME = @NATION_NAME )

	SELECT 	C.ID,	C.CONTINENT,	C.COUNTRY_NAME,	C.COUNTRY_EN_NAME,	C.BAN,
			C.BAN_PARTIAL,	C.BAN_NOTE,	C.IMG_URL1,	C.IMG_URL2,	C.WRT_DT,
			C.NEW_DATE 
	FROM SAFE_INFO_TRAVEL_BAN C
	WHERE C.ID = @ID

	SELECT 	B.ID,	B.CONTINENT,	B.COUNTRY_NAME,	B.COUNTRY_EN_NAME,	B.IMG_URL1,
			B.IMG_URL2,	B.ATTENTION,	B.ATTENTION_PARTIAL,	B.ATTENTION_NOTE,	B.[CONTROL],
			B.CONTROL_PARTIAL,	B.CONTROL_NOTE,	B.LIMITA,	B.LIMITA_PARTIAL,	B.LIMITA_NOTE,
			B.WRT_DT,	B.NEW_DATE 
	FROM SAFE_INFO_TRAVEL_WARNING B
	WHERE B.ID = @ID

	SELECT	A.ID,	A.CONTINENT,	A.COUNTRY_NAME,	A.COUNTRY_EN_NAME,	A.NEWS,
			A.IMG_URL1,	A.IMG_URL2,	A.WRT_DT,	A.NEW_DATE 
	FROM SAFE_INFO_ACCIDENT A 
	WHERE A.ID = @ID

	SELECT 	E.ID,	E.CONTINENT,	E.COUNTRY_NAME,	E.COUNTRY_EN_NAME,	E.CONTACT,
			E.IMG_URL1,	E.IMG_URL2,	E.WRT_DT,	E.NEW_DATE
	FROM SAFE_INFO_CONTACT E
	WHERE E.ID = @ID

	SELECT 	D.ID,	D.CONTINENT,	D.COUNTRY_NAME,	D.COUNTRY_EN_NAME,	D.BASIC_INFO,
			D.IMG_URL,	D.WRT_DT,	D.NEW_DATE , @NATION_CODE AS NATION_CODE
	FROM SAFE_INFO_COUNTRY_BASIC D
	WHERE D.ID = @ID

	SELECT TOP 3 *
	FROM SAFE_INFO_COUNTRY_NOTICE F
	WHERE (F.NATION_CODE IS NULL) OR
		 (F.NATION_CODE = ( SELECT G.SAFE_NATION_CODE FROM SAFE_INFO_NATION_CATEGORY_MAP G WHERE G.KOR_NAME = @NATION_NAME ))
	ORDER BY F.WRT_DT DESC

END

GO
