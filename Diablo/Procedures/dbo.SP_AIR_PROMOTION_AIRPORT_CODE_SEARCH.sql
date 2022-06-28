USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_AIR_PROMOTION_AIRPORT_CODE_SEARCH
■ DESCRIPTION				: 항공 프로모션 공항 코드 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	SP_AIR_PROMOTION_AIRPORT_CODE_SEARCH 'BKK', ''
	SP_AIR_PROMOTION_AIRPORT_CODE_SEARCH '', 'DMK, BKK'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2017-02-14			정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_AIR_PROMOTION_AIRPORT_CODE_SEARCH]	
	@CITY_CODE CHAR(3),
	@AIRPORT_CODE VARCHAR(200)
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	SELECT 
		A.AIRPORT_CODE, A.KOR_NAME AS AIRPORT_NAME, D.KOR_NAME AS NATION_NAME 
	FROM PUB_AIRPORT A WITH(NOLOCK)
		INNER JOIN PUB_CITY B WITH(NOLOCK) ON A.CITY_CODE = B.CITY_CODE
		INNER JOIN PUB_STATE C WITH(NOLOCK) ON B.STATE_CODE = C.STATE_CODE AND B.NATION_CODE = C.NATION_CODE
		INNER JOIN PUB_NATION D WITH(NOLOCK) ON C.NATION_CODE = D.NATION_CODE
		INNER JOIN PUB_REGION E WITH(NOLOCK) ON D.REGION_CODE = E.REGION_CODE	
	WHERE (@CITY_CODE != '' AND A.CITY_CODE = @CITY_CODE) OR (@AIRPORT_CODE != '' AND A.AIRPORT_CODE IN (SELECT Data FROM DBO.FN_XML_SPLIT(@AIRPORT_CODE, ',') ))
END
GO
