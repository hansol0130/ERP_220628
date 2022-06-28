USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_EMPLOYEE_ETICKET_INFO
■ DESCRIPTION				: BTMS 출장자 E-TICKET 정보
■ INPUT PARAMETER			: 예약코드, 예약자 번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_COM_BIZTRIP_EMPLOYEE_ETICKET_INFO 'RT1609203853', '1'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR					DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-05-16		저스트고(강태영)		최초생성
   2016-09-21		저스트고(이유라)		TICKET -> 항공사 3코드 + 티켓번호로 수정
   2016-09-28		저스트고(이유라)		START_DATE -> 02MAR16 을 YYYYMMDD 형식으로 수정
   2016-12-29		박형만				abacus 나오도록 수정 
   2016-01-06		박형만				여러건일경우 가장먼저 출발 하는 항공권 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_EMPLOYEE_ETICKET_INFO]
	@RES_CODE VARCHAR(15),
	@SEQ_NO INT

AS

BEGIN
	SELECT
		A.RES_CODE,
		A.RES_SEQ_NO,
		A.PNR,
		--A.TICKET,
		A.ROUTING,
		A.AIRLINE_NUM + A.TICKET AS TICKET,
		A.TICKET_STATUS,
		A.PAX_NAME,
		--(CASE WHEN LEN(CONVERT(CHAR(2), DAY(A.[START_DATE]))) < 2 THEN '0' + CONVERT(VARCHAR(2), DAY(A.[START_DATE])) ELSE CONVERT(CHAR(2), DAY(A.[START_DATE])) END) +  SUBSTRING('JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC ', (MONTH(A.[START_DATE]) * 4) - 3, 3) + RIGHT(CONVERT(VARCHAR(4), YEAR(A.[START_DATE])), 2) AS [START_DATE],
		CONVERT(VARCHAR,A.[START_DATE],112) AS [START_DATE],
		C.AIR_GDS,
		A.AIRLINE_CODE
	FROM DSR_TICKET A 
	INNER JOIN RES_CUSTOMER_damo B ON A.RES_CODE = B.RES_CODE AND A.RES_SEQ_NO = B.SEQ_NO
	LEFT JOIN RES_AIR_DETAIL C ON C.RES_CODE = A.RES_CODE
	WHERE A.RES_CODE = @RES_CODE AND A.RES_SEQ_NO = @SEQ_NO AND A.TICKET_STATUS = 1 AND C.AIR_GDS in (2, 5 ) -- abacus , amadeus 
	ORDER BY A.[START_DATE] asc -- 여러건일경우 가장먼저 출발 하는 항공권 
END

GO
