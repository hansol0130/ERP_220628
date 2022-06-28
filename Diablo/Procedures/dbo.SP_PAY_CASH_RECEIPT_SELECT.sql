USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_PAY_CASH_RECEIPT_SELECT_HISTORY
- 기 능 : 현금영수증 신청내역 한건 조회
====================================================================================
	참고내용
====================================================================================
- 예제
EXEC SP_PAY_CASH_RECEIPT_SELECT  @RECEIPT_NO = 27 
====================================================================================
	변경내역
====================================================================================
- 2010-05-17 박형만 신규 작성 
- 2010-06-03 박형만 SOC_NUM2 암호화 적용
- 2010-06-08 박형만 PAY_NUM 암호화 적용
===================================================================================*/
CREATE PROC [dbo].[SP_PAY_CASH_RECEIPT_SELECT]
	@RECEIPT_NO INT 
AS 
SET NOCOUNT ON 
SELECT 
	CRR.RECEIPT_NO ,
	CRR.GROUP_NO ,
	CRR.PAY_SEQ ,
	CRR.MCH_SEQ ,
	CRR.REQ_NO , 
	CRR.REQ_VER , 
	CRR.NEW_DATE ,
	PM1.PAY_NAME ,
	CRR.RES_CODE , 
	CRR.SOC_NUM1 , 
	--CRR.SOC_NUM2 , 
	damo.dbo.dec_varchar('DIABLO','dbo.PAY_CASH_RECEIPT','SOC_NUM2', CRR.SEC_SOC_NUM2) AS SOC_NUM2 ,
	CRR.NOR_TEL1 ,
	CRR.NOR_TEL2,
	CRR.NOR_TEL3,
	CRR.TARGET_PRICE , 
	CRR.NEW_CODE ,
	CRR.STATUS_TYPE ,
	CRR.REQ_COMMENT  ,
	CRR.MNG_COMMENT  ,
	CRR.EDT_DATE ,
	CRR.MNG_CODE ,
	EMP.KOR_NAME ,
	EMP.EMAIL
FROM PAY_CASH_RECEIPT_damo AS CRR WITH(NOLOCK)
	LEFT JOIN PAY_MASTER_damo AS PM1 WITH(NOLOCK)
		ON CRR.PAY_SEQ = PM1.PAY_SEQ 
	LEFT JOIN PAY_MATCHING AS PM2 WITH(NOLOCK)
		ON CRR.PAY_SEQ = PM2.PAY_SEQ 
		AND CRR.MCH_SEQ = PM2.MCH_SEQ 
	LEFT JOIN EMP_MASTER AS EMP WITH(NOLOCK)
		ON CRR.NEW_CODE = EMP.EMP_CODE 
WHERE RECEIPT_NO = @RECEIPT_NO
ORDER BY RECEIPT_NO ASC 


GO
