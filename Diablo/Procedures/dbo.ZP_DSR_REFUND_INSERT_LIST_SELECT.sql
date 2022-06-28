USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME						: ZP_DSR_REFUND_INSERT_LIST_SELECT
■ DESCRIPTION					: DSR 환불 일괄 등록 조회
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :

EXEC [dbo].[ZP_DSR_REFUND_INSERT_LIST_SELECT] @TICKETS=',5883655571,5883655587', @START_DATE=NULL, @END_DATE=NULL

EXEC [dbo].[ZP_DSR_REFUND_INSERT_LIST_SELECT] @TICKETS=NULL, @START_DATE='2022-05-01', @END_DATE='2022-05-10'

■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-05-12		김성호			최초생성
   2022-05-19		김성호			기간조회 추가
   2022-05-23		김성호			기간조회 기준 변경 (NEW_DATE -> REQUEST_DATE)
   2022-05-25		김성호			환불리스트 항목 수정
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_DSR_REFUND_INSERT_LIST_SELECT]
	@TICKETS		VARCHAR(8000),	-- ex),5883655571,5883655587
	@START_DATE		DATE,
	@END_DATE		DATE
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	IF LEN(@TICKETS) > 0
	BEGIN
	    SELECT REQUEST_DATE -- AS [환불접수일]
	          ,RV100.PNR_SEQNO -- AS [일련번호]
	          ,RM.RES_CODE -- AS [예약코드]
	          ,RM.PRO_CODE -- AS [행사코드]
	          --,(CASE RM.PROVIDER WHEN '36' THEN '티몬' WHEN '45' THEN '네이버항공' WHEN '44' THEN '스카이스캐너' ELSE RM.PROVIDER END) AS [PROVIDER_NAME] -- AS [예약구분명]
	          ,CP.PUB_VALUE AS [PROVIDER_NAME]
	          ,AM.AGT_NAME -- AS [거래처]
	          ,DT.AIRLINE_CODE -- AS [항공사]
	          ,DT.AIRLINE_NUM -- AS [항공사번호]
	          ,DR.TICKET -- AS [티켓번호]
	          ,DT.PAX_NAME -- AS [탑승자명]
	          ,RM.RES_NAME -- AS [예약자명]
	          ,DR.FARE_USED_PRICE -- AS [FARE USED]
	          ,DR.FARE_REFUND_PRICE -- AS [FARE REFUND]
	          ,DR.CANCEL_CHARGE -- AS [CANCEL CHARGE]
	          ,DR.TAX_REFUND1 -- AS [TAX REFUND]
	          ,DR.COMM_REFUND -- AS [COMM REFUND]
	          ,DR.CASH_PRICE -- AS [CASH PRICE]
	          ,DR.CARD_PRICE -- AS [CARD PRICE]
	          ,DR.REFUND_PRICE -- AS [REFUND PRICE]
	          ,EM.KOR_NAME AS [EMP_NAME] -- AS [판매자]
	    FROM   dbo.DSR_REFUND DR
	           LEFT JOIN dbo.DSR_TICKET DT
	                ON  DR.TICKET = DT.TICKET
	           LEFT JOIN dbo.RES_MASTER_damo RM
	                ON  DT.RES_CODE = RM.RES_CODE
	           LEFT JOIN interface.TB_VGT_MA100 MA100
	                ON  RM.RES_CODE = MA100.IF_SYS_RSV_NO
	           LEFT JOIN interface.TB_VGT_RV100 RV100
	                ON  MA100.PNR_SEQNO = RV100.PNR_SEQNO
	           LEFT JOIN dbo.AGT_MASTER AM
	                ON  RM.SALE_COM_CODE = AM.AGT_CODE
	           LEFT JOIN dbo.EMP_MASTER_damo EM
	                ON  DT.ISSUE_CODE = EM.EMP_CODE
	           LEFT JOIN dbo.COD_PUBLIC CP
	                ON  CP.PUB_TYPE = 'RES.AGENT.TYPE' AND CP.PUB_CODE = RM.PROVIDER
	    WHERE  DR.TICKET IN (SELECT [Data]
	                         FROM   dbo.FN_XML_SPLIT(@TICKETS ,','))
	END
	ELSE
	BEGIN
	    SELECT @START_DATE = ISNULL(@START_DATE ,CONVERT(DATE ,DATEADD(DD ,-1 ,GETDATE())))
	          ,@END_DATE = DATEADD(DD ,1 ,ISNULL(@END_DATE ,CONVERT(DATE ,GETDATE())))
	    
	    SELECT REQUEST_DATE -- AS [환불접수일]
	          ,RV100.PNR_SEQNO -- AS [일련번호]
	          ,RM.RES_CODE -- AS [예약코드]
	          ,RM.PRO_CODE -- AS [행사코드]
	          --,(CASE RM.PROVIDER WHEN '36' THEN '티몬' WHEN '45' THEN '네이버항공' WHEN '44' THEN '스카이스캐너' ELSE RM.PROVIDER END) AS [PROVIDER_NAME] -- AS [예약구분명]
	          ,CP.PUB_VALUE AS [PROVIDER_NAME] -- AS [예약구분명]
	          ,AM.AGT_NAME -- AS [거래처]
	          ,DT.AIRLINE_CODE -- AS [항공사]
	          ,DT.AIRLINE_NUM -- AS [항공사번호]
	          ,DR.TICKET -- AS [티켓번호]
	          ,DT.PAX_NAME -- AS [탑승자명]
	          ,RM.RES_NAME -- AS [예약자명]
	          ,DR.FARE_USED_PRICE -- AS [FARE USED]
	          ,DR.FARE_REFUND_PRICE -- AS [FARE REFUND]
	          ,DR.CANCEL_CHARGE -- AS [CANCEL CHARGE]
	          ,DR.TAX_REFUND1 -- AS [TAX REFUND]
	          ,DR.COMM_REFUND -- AS [COMM REFUND]
	          ,DR.CASH_PRICE -- AS [CASH PRICE]
	          ,DR.CARD_PRICE -- AS [CARD PRICE]
	          ,DR.REFUND_PRICE -- AS [REFUND PRICE]
	          ,EM.KOR_NAME AS [EMP_NAME] -- AS [판매자]
	    FROM   dbo.DSR_REFUND DR
	           LEFT JOIN dbo.DSR_TICKET DT
	                ON  DR.TICKET = DT.TICKET
	           LEFT JOIN dbo.RES_MASTER_damo RM
	                ON  DT.RES_CODE = RM.RES_CODE
	           LEFT JOIN interface.TB_VGT_MA100 MA100
	                ON  RM.RES_CODE = MA100.IF_SYS_RSV_NO
	           LEFT JOIN interface.TB_VGT_RV100 RV100
	                ON  MA100.PNR_SEQNO = RV100.PNR_SEQNO
	           LEFT JOIN dbo.AGT_MASTER AM
	                ON  RM.SALE_COM_CODE = AM.AGT_CODE
	           LEFT JOIN dbo.EMP_MASTER_damo EM
	                ON  DT.ISSUE_CODE = EM.EMP_CODE
	           LEFT JOIN dbo.COD_PUBLIC CP
	                ON  CP.PUB_TYPE = 'RES.AGENT.TYPE' AND CP.PUB_CODE = RM.PROVIDER
	    WHERE  DR.REQUEST_DATE >= @START_DATE
	           AND DR.REQUEST_DATE < @END_DATE
	END
END

GO
