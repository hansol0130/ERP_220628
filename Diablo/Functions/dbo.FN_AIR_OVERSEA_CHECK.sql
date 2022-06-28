USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: FN_AIR_DOMESTIC_CHECK
■ DESCRIPTION				: 해외항공 체크
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2015-10-12		김성호			최초생성
================================================================================================================*/ 
CREATE FUNCTION [dbo].[FN_AIR_OVERSEA_CHECK]
(
	@ROUTING	VARCHAR(1000)
)
RETURNS CHAR(1)
AS
BEGIN

	DECLARE @CHECK_YN CHAR(1)

	SELECT @CHECK_YN = MAX(CASE WHEN C.NATION_CODE <> 'KR' THEN 'Y' ELSE 'N' END)
	FROM DBO.FN_SPLIT_NUMBER(@ROUTING, 3) A
	INNER JOIN PUB_AIRPORT B ON A.DATA = B.AIRPORT_CODE
	INNER JOIN PUB_CITY C ON B.CITY_CODE = C.CITY_CODE

	RETURN ISNULL(@CHECK_YN, 'Y')
END
GO
