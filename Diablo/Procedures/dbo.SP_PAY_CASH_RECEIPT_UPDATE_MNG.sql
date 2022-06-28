USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_PAY_CASH_RECEIPT_UPDATE_MNG
- 기 능 : 현금영수증 신청 관리자 상태변경
====================================================================================
	참고내용
====================================================================================
- 예제
EXEC SP_PAY_CASH_RECEIPT_UPDATE_MNG 
 @RECEIPT_NO = 6 ,@STATUS_TYPE = 2 , @MNG_CODE = '9999999',@MNG_COMMENT='1차반려입니다'
====================================================================================
	변경내역
====================================================================================
- 2010-05-17 박형만 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_PAY_CASH_RECEIPT_UPDATE_MNG]
	@RECEIPT_NO INT ,
	@STATUS_TYPE INT,
	@MNG_CODE NEW_CODE,
	@MNG_COMMENT VARCHAR(200)
AS
--SELECT @RECEIPT_NO = 6 ,@STATUS_TYPE = 2 , @MNG_CODE = '9999999',@MNG_COMMENT='1차반려입니다'
UPDATE PAY_CASH_RECEIPT
SET STATUS_TYPE = @STATUS_TYPE 
,MNG_CODE = @MNG_CODE
,MNG_COMMENT = @MNG_COMMENT
,EDT_DATE = GETDATE() 
WHERE RECEIPT_NO = @RECEIPT_NO 
GO
