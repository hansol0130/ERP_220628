USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HTL_AUTOCANCEL_TYPE2]

/*
USP_HTL_AUTOCANCEL_TYPE2
*/

AS

SELECT RESV_NO, SUPP_NO, SUPP_CFM_NO, SUPP_CODE, SUPP_STATUS, MCPN_CODE, RESV_ID, RESV_NAME, 
RESV_PASSWORD, RESV_PHONE_MOBILE, RESV_PHONE_HOME, RESV_EMAIL, CREATE_DATE, HOTEL_CODE, 
HOTEL_NAME, S_HOTEL_CODE, S_HOTEL_NAME, CHECK_IN_DATE, CHECK_OUT_DATE, ROOM_CNT, ADULT_CNT, CHILD_CNT, 
MEAL_YN, MEAL_DESC, DEAD_LINE, SUPP_DEAD_LINE, NON_REFUND_YN, REQ_TEXT, LAST_STATUS, LAST_UPDATE_USER, 
LAST_UPDATE_DATE, PAY_REQ_DATE, CANCEL_DATE, CANCEL_TEXT, CANCEL_USER, 
B.CODE_NAME AS SUPP_STATUS_NAME, B.CODE_NAME2 AS SUPP_STATUS_NAME2, C.CODE_NAME AS LAST_STATUS_NAME,
A.VGT_CODE, A.VGT_NO, A.VGT_USER, A.VGT_REMARKS, AUTO_CANCEL
FROM HTL_RESV_MAST A
JOIN HTL_CODE_MAST B ON A.SUPP_STATUS=B.S_CODE AND B.M_CODE='SUST'
JOIN HTL_CODE_MAST C ON A.LAST_STATUS=C.S_CODE AND C.M_CODE='RSST'
WHERE LAST_STATUS IN ('RMQQ', 'RMPQ')
AND DEAD_LINE = CONVERT(VARCHAR(10), GETDATE(), 112)
AND MCPN_CODE='VG0000'
AND AUTO_CANCEL='Y'



GO