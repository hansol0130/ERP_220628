USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HTL_RESV_MAST_11ST3]

/*
USP_HTL_RESV_MAST_11ST3 '90', 'HTD'
*/

@RSV_NO VARCHAR(100),
@TYPE VARCHAR(3)

AS

IF @TYPE = 'HTL'

BEGIN

SELECT 'HTL' AS AFF_TYPE, @RSV_NO AS RSV_NO, AFF_NO
FROM HOTEL.DBO.HTL_RESV_MAST
WHERE RESV_NO = @RSV_NO AND MCPN_CODE='EL0001'

END

ELSE

SELECT 'HTD' AS AFF_TYPE, @RSV_NO AS RSV_NO, AFF_NO
FROM AIR.DBO.HTL_DOM_RESV_MAST
WHERE RESV_NO = @RSV_NO AND MCPN_CODE='EL0001'


GO
