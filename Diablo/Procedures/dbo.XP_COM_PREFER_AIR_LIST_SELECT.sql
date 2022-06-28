USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [XP_COM_PREFER_AIR_LIST_SELECT]
■ DESCRIPTION				: BTMS 항공사 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 

	EXEC XP_COM_PREFER_AIR_LIST_SELECT

■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-04		강태영			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_PREFER_AIR_LIST_SELECT]

AS
BEGIN
	
SELECT
	AIRLINE_CODE,
	KOR_NAME
FROM PUB_AIRLINE
WHERE DISPLAY_YN = 'Y'
ORDER BY KOR_NAME ASC

END
GO
