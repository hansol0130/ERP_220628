USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: ZP_TC_HOTEL_LIST_SELECT
■ DESCRIPTION				: 호텔 리스트 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2021-10-20		오준혁			최초생성    
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[ZP_TC_HOTEL_LIST_SELECT]
(
	@MASTER_NAME		VARCHAR(200)
)

AS  
BEGIN

    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT MASTER_CODE
		  ,RTRIM(MASTER_NAME) AS MASTER_NAME
		  ,(
			   SELECT KOR_NAME
			   FROM   PUB_CITY
			   WHERE  CITY_CODE = HM.CITY_CODE
		   ) AS CITY_CODE
	FROM   HTL_MASTER HM
	WHERE  SHOW_YN = 'Y'
		   AND (REGION_CODE = '210' OR REGION_CODE = '340')
		   AND HM.MASTER_NAME LIKE '%' + @MASTER_NAME + '%'
	ORDER BY
		   REGION_CODE

END
GO
