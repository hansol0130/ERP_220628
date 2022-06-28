USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_NATION_FLAG_SELECT
■ DESCRIPTION				: 검색_국기정보
■ INPUT PARAMETER			: CITY_CODE
■ EXEC						: 
    -- SP_MOV2_NATION_FLAG_SELECT 'LAT'

■ MEMO						: 도시코드로 부터 국기정보를 가져온다
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-30		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_NATION_FLAG_SELECT]
	@CITY_CODE		VARCHAR(20)
AS
BEGIN
	SELECT TOP 1 B.NATION_CODE, B.KOR_NAME, D.IMG_URL1 NATION_FLAG, D.ID NATION_ID FROM PUB_CITY A WITH(NOLOCK)
		INNER JOIN PUB_NATION B WITH(NOLOCK)
			ON A.NATION_CODE = B.NATION_CODE
		LEFT JOIN SAFE_INFO_TRAVEL_WARNING D WITH(NOLOCK)
			ON D.COUNTRY_NAME = B.KOR_NAME
		WHERE A.CITY_CODE = @CITY_CODE
END           



GO
