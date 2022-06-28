USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_AIR_AMADEUS_FARE_AIRLINE_JOIN_INFO
■ DESCRIPTION				: 아마데우스 XML 데이터 공항정보 조인항목 조회
■ INPUT PARAMETER			: NONE
■ OUTPUT PARAMETER			: NONE
■ EXEC						: 
	EXEC XP_AIR_AMADEUS_FARE_AIRLINE_JOIN_INFO
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-02-06		정지용			최초생성
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_AIR_AMADEUS_FARE_AIRLINE_JOIN_INFO]
AS  
BEGIN
	SELECT AIRLINE_CODE, KOR_NAME FROM PUB_AIRLINE WITH(NOLOCK);

	SELECT A.AIRPORT_CODE, A.KOR_NAME AS AIRPORT_NAME, B.CITY_CODE, B.KOR_NAME AS CITY_NAME FROM PUB_AIRPORT A WITH(NOLOCK)
	INNER JOIN PUB_CITY B WITH(NOLOCK) ON A.CITY_CODE = B.CITY_CODE;
END
GO
