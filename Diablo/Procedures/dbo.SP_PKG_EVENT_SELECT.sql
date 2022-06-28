USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_PKG_EVENT_SELECT
- 기 능 : 할인예약상품한건조회
====================================================================================
	참고내용
====================================================================================
- 예제
 EXEC SP_PKG_EVENT_SELECT 'CPP107-110211',0,0
====================================================================================
	변경내역
====================================================================================
- 2011-02-01 박형만 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_PKG_EVENT_SELECT]
	@PRO_CODE PRO_CODE , --상품코드
	@PRICE_SEQ INT , --  가격코드 
	@EVT_SEQ INT -- 0 = 현재기간에해당되는상품 , -1 = 기간에상관없이 , 0이상=이벤트번호있을경우 해당이벤트
AS 
SET NOCOUNT ON 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--DECLARE @PRO_CODE PRO_CODE,
--	@EVT_SEQ INT 
--SET @PRO_CODE = 'CPP107-110204'
----SET @PRO_CODE = 'CPP107-110211'
--SET @EVT_SEQ = 1 -- 1

	SELECT TOP 1 
		PE.EVT_SEQ, PE.PRO_CODE, PE.PRICE_SEQ, PE.START_DATE, PE.END_DATE,  PDP.ADT_PRICE, PE.ORDER_SEQ, PE.REMARK, PE.NEW_CODE, PE.NEW_DATE, PE.EDT_CODE, PE.EDT_DATE 
	FROM PKG_EVENT AS PE WITH(NOLOCK)
		INNER JOIN PKG_DETAIL AS PD WITH(NOLOCK)
			ON PE.PRO_CODE = PD.PRO_CODE 
		INNER JOIN PKG_DETAIL_PRICE AS PDP WITH(NOLOCK)
			ON PE.PRO_CODE = PDP.PRO_CODE 
			AND PE.PRICE_SEQ = PDP.PRICE_SEQ 
	WHERE PE.PRO_CODE = @PRO_CODE
	AND ( @PRICE_SEQ = 0 OR PDP.PRICE_SEQ = @PRICE_SEQ ) 
	AND (@EVT_SEQ = -1
		OR (@EVT_SEQ = 0 AND GETDATE() BETWEEN PE.START_DATE AND PE.END_DATE )
		OR (@EVT_SEQ > 0 AND EVT_SEQ = @EVT_SEQ))
	ORDER BY PDP.PRICE_SEQ ASC 

END 
GO
