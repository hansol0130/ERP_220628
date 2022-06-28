USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_ERP_BIZTRIP_CUSTOMER_LIST_UPDATE
■ DESCRIPTION				: BTMS ERP 출장 현황 출발자 비고 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-20		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_ERP_BIZTRIP_CUSTOMER_LIST_UPDATE]
	@ETC_REMARK		XML
AS 
BEGIN

	WITH LIST AS
	(
		SELECT
			ROW_NUMBER() OVER (ORDER BY t1.col.value('./ReserveCode[1]', 'varchar(10)'), t1.col.value('./SeqNo[1]', 'int')) AS [RowNumber]
			, t1.col.value('./ReserveCode[1]', 'varchar(20)') as [ReserveCode]
			, t1.col.value('./SeqNo[1]', 'int') as [SeqNo]
			, t1.col.value('./EtcRemark[1]', 'varchar(1000)') as [EtcRemark]
			, t1.col.value('./EdtCode[1]', 'char(7)') as [EdtCode]
		FROM @ETC_REMARK.nodes('/ArrayOfBtmsBizTripReserveCustomerEtcRemarkRQ/BtmsBizTripReserveCustomerEtcRemarkRQ') as t1(col)
	)
	UPDATE A SET A.ETC_REMARK = B.EtcRemark, A.EDT_CODE = B.EdtCode, A.EDT_DATE = GETDATE()
	FROM RES_CUSTOMER_damo A
	INNER JOIN LIST B ON A.RES_CODE = B.ReserveCode AND A.SEQ_NO = B.SeqNo;

END



GO
