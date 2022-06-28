USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_AIR_SERVICE_CHARGE_BY_REGION
■ DESCRIPTION				: 서비스 차지 찾기 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_AIR_SERVICE_CHARGE_BY_REGION '001'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2018-01-29			박형만			최초생성

================================================================================================================*/ 
CREATE PROC [dbo].[XP_AIR_SERVICE_CHARGE_BY_REGION]	
	@REGION_CODE VARCHAR(3)
AS 
BEGIN

--DECLARE @REGION_CODE VARCHAR(100)
--SET @REGION_CODE = 'ICN,BKK' 

IF( ISNULL(@REGION_CODE,'') ='')
BEGIN
	SET @REGION_CODE = '001'
END 

SELECT TOP 1 PUB_VALUE FROM COD_PUBLIC WITH(NOLOCK)
WHERE PUB_TYPE = 'AIR.SERVICE.CHARGE'
AND PUB_CODE = @REGION_CODE
AND USE_YN ='Y'

END



GO
