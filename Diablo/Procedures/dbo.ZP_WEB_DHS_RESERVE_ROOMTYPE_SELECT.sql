USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME						: ZP_WEB_DHS_RESERVE_ROOMTYPE_SELECT
■ DESCRIPTION					: 홈쇼핑 호텔 룸타입 조회
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    : ZP_WEB_DHS_RESERVE_ROOMTYPE_SELECT 'RP2201177237'
■ MEMO						    :
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-14		김홍우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_WEB_DHS_RESERVE_ROOMTYPE_SELECT]
	@RES_CODE			CHAR(12)
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT RDD.MASTER_CODE
		  ,RDD.RES_NAME
		  ,PMP.PRICE_SEQ
		  ,PMP.PRICE_NAME
		  ,CASE 
				WHEN ISNULL(DM.ADT_MAX_COUNT ,'')='' THEN '0'
				ELSE DM.ADT_MAX_COUNT
		   END     ADT_MAX_COUNT
		  ,CASE 
				WHEN ISNULL(DM.CHD_MAX_COUNT ,'')='' THEN '0'
				ELSE DM.CHD_MAX_COUNT
		   END     CHD_MAX_COUNT 
		  ,(
			   SELECT CONVERT(CHAR(10), MAX(DEP_DATE), 23)  AS DEP_DATE
			   FROM   PKG_DETAIL        PD
			   WHERE  PD.MASTER_CODE = RDD.MASTER_CODE
					  AND PD.PRO_CODE LIKE RDD.MASTER_CODE+'-______'+CONVERT(VARCHAR(2) ,PMP.PRICE_SEQ)
		   )    AS CALENDAR_END_DATE
	FROM   dbo.RES_DHS_DETAIL RDD
		   INNER JOIN dbo.PKG_MASTER_PRICE_DHS_MASTER DM
				ON  RDD.MASTER_CODE = DM.MASTER_CODE
					AND RDD.DHS_ROOM_CODE = DM.DHS_ROOM_CODE
		   INNER JOIN dbo.PKG_MASTER_PRICE PMP
				ON  DM.MASTER_CODE = PMP.MASTER_CODE
					AND DM.PRICE_SEQ = PMP.PRICE_SEQ
	WHERE  RES_CODE = @RES_CODE;


END


GO
