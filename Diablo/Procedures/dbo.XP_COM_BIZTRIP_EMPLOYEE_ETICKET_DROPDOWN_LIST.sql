USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_EMPLOYEE_ETICKET_DROPDOWN_LIST
■ DESCRIPTION				: BTMS 출장자 E-TICKET 탑승객 드롭다운
■ INPUT PARAMETER			: 출장코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_COM_BIZTRIP_EMPLOYEE_ETICKET_DROPDOWN_LIST 'BT1605160305'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR					DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-05-16		저스트고(강태영)		최초생성
================================================================================================================*/ 

CREATE PROC [dbo].[XP_COM_BIZTRIP_EMPLOYEE_ETICKET_DROPDOWN_LIST]
@BT_CODE VARCHAR(15)

AS

BEGIN
	SELECT DISTINCT
		A.RES_CODE,
		A.SEQ_NO,
		A.CUS_NO,
		A.CUS_NAME
	FROM RES_CUSTOMER_damo A
	INNER JOIN RES_MASTER_damo B ON B.RES_CODE = A.RES_CODE
	WHERE A.RES_CODE IN (SELECT RES_CODE FROM COM_BIZTRIP_DETAIL WHERE BT_CODE = @BT_CODE)
	AND B.PRO_TYPE = 2
	ORDER BY SEQ_NO ASC
END
GO
