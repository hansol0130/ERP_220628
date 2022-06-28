USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_RES_AIR_ETICKET_INFO
■ DESCRIPTION				: 항공 출발자 E-TICKET 정보
■ INPUT PARAMETER			: 예약코드, 예약자 번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_WEB_RES_AIR_ETICKET_INFO 'RT1703175172',0
	XP_WEB_RES_AIR_ETICKET_INFO '',0,'1009953522'
■ MEMO						: 

BTMS 의 XP_COM_BIZTRIP_EMPLOYEE_ETICKET_INFO SP 참고 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR					DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-03-17		박형만				최초생성 
  
   
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_RES_AIR_ETICKET_INFO]
	@RES_CODE VARCHAR(15),
	@SEQ_NO INT,
	@TICKET VARCHAR(10) = NULL 

AS

BEGIN

	DECLARE @QUERY NVARCHAR(4000)
	SET @QUERY = N'
SELECT
	A.RES_CODE,
	A.RES_SEQ_NO,
	A.PNR,
	A.ROUTING,
	A.AIRLINE_NUM,
	A.TICKET,
	A.TICKET_STATUS,
	A.PAX_NAME,
	C.AIR_GDS,
	A.AIRLINE_CODE,
	A.START_DATE ,
	A.ISSUE_DATE , 
	A.NEW_DATE 
FROM DSR_TICKET A 
INNER JOIN RES_CUSTOMER_damo B ON A.RES_CODE = B.RES_CODE AND A.RES_SEQ_NO = B.
SEQ_NO
LEFT JOIN
 RES_AIR_DETAIL C ON C.RES_CODE = A.RES_CODE 
WHERE A.TICKET_STATUS = 1 AND C.AIR_GDS in (2, 5 ) /* abacus , amadeus  */' 
	IF ISNULL(@TICKET, '') <> ''
	BEGIN
		SET @QUERY = @QUERY + ' AND A.TICKET = @TICKET ' 
	END 
	ELSE
	BEGIN
		SET @QUERY = @QUERY + ' AND A.RES_CODE = @RES_CODE ' 
		IF( @SEQ_NO > 0 )
		BEGIN
			SET @QUERY = @QUERY + ' AND A.RES_SEQ_NO = @SEQ_NO  '
		END 
	END 
	SET @QUERY = @QUERY + ' ORDER BY A.[START_DATE] asc -- 여러건일경우 가장먼저 출발 하는 항공권  ' 
	--PRINT @QUERY 
	EXEC SP_EXECUTESQL @QUERY, N'@TICKET VARCHAR(10),@RES_CODE VARCHAR(12),@SEQ_NO INT', @TICKET,@RES_CODE ,@SEQ_NO

	
END 



GO
