USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_RES_HOTEL_INVOICE_SELECT
■ DESCRIPTION				: BTMS 호텔 예약 인보이스 정보
■ INPUT PARAMETER			: 
	@RES_CODE  VARCHAR(20)  : 예약번호
■ EXEC						: 
	EXEC XP_COM_RES_HOTEL_INVOICE_SELECT 'RH1603232825'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-24		저스트고-강태영		최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_RES_HOTEL_INVOICE_SELECT]
	@RES_CODE VARCHAR(20)
AS 
BEGIN

	SELECT
		A.RES_CODE,
		A.RES_NAME,
		A.CUS_REQUEST,
		B.KOR_NAME,
		B.EMAIL,
		B.INNER_NUMBER1,
		B.INNER_NUMBER2,
		B.INNER_NUMBER3,
		B.FAX_NUMBER1,
		B.FAX_NUMBER2,
		B.FAX_NUMBER3
	FROM RES_MASTER_damo A
	LEFT JOIN EMP_MASTER B ON A.NEW_CODE = B.EMP_CODE
	WHERE A.RES_CODE = @RES_CODE

END
GO
