USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_SEARCH_BTMS_AGENT
■ DESCRIPTION				: ERP BTMS 거래처 검색
■ INPUT PARAMETER			: 
	@KEY		VARCHAR(400): 검색 키
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_COM_SEARCH_BTMS_AGENT ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-06-24	 저스트고_강태영	  최초생성
   2016-08-09	 저스트고_이유라	 @KEYWORD 없을때 전체 거래처 나오도록 수정 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_SEARCH_BTMS_AGENT]

@KEYWORD VARCHAR(100)

AS

IF (LEN(@KEYWORD) > 0) 
	BEGIN
		SELECT TOP 20 AGT_CODE, KOR_NAME
			FROM (
				SELECT
					AGT_CODE,
					KOR_NAME,
					CHARINDEX(@KEYWORD, KOR_NAME) AS SORT1
				FROM AGT_MASTER
				WHERE BTMS_YN = 'Y' AND SHOW_YN = 'Y'
				AND (KOR_NAME LIKE '%' + @KEYWORD + '%' OR UPPER(KOR_NAME) LIKE '%' + UPPER(@KEYWORD) + '%')
			) A
		ORDER BY A.SORT1

	END
ELSE
	BEGIN 
		SELECT AGT_CODE, KOR_NAME
		FROM AGT_MASTER
		WHERE BTMS_YN = 'Y' AND SHOW_YN = 'Y'
		ORDER BY KOR_NAME
	END
GO
