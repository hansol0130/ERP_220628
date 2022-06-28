USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_MARKET_RESERVE_SUCCESS_SELECT
■ DESCRIPTION					: 참좋은마켓 예약완료 데이터
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    :
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2021-08-12		홍종우			최초생성
   2021-09-09		오준혁			쿼리 튜닝
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_MARKET_RESERVE_SUCCESS_SELECT]
	@RES_CODE			CHAR(12)
	
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT A.RES_CODE
	      ,CASE A.RES_STATE
	            WHEN 3 THEN '결제대기'
	            WHEN 4 THEN '결제완료'
	            ELSE ''
	       END RES_STATE
	      ,A.PRO_CODE
	      ,A.PRO_NAME
	      ,PT.NAME
	      ,PT.TEL
	      ,PT.EMAIL ORDER_EMAIL
	      ,PT.DELIVERY_NAME
	      ,PT.DELIVERY_TEL
	      ,PT.COUNT
	      ,PT.ADDR1
	      ,PT.ADDR2
	      ,PT.PAY_PRICE
	      ,BA.TEAM_NAME
	      ,BA.KEY_NUMBER
	      ,B.KOR_NAME
	      ,B.FAX_NUMBER1
	      ,B.FAX_NUMBER2
	      ,B.FAX_NUMBER3
	      ,B.EMAIL
	      ,PR.BANK_CODE
	      ,PR.ACCT_NUM
	      ,ISNULL(CR.CANCEL_STATE ,'Y') CANCEL_STATE
	FROM   RES_MASTER_DAMO A
	       INNER JOIN PKG_DETAIL PD
	            ON  PD.PRO_CODE = A.PRO_CODE
	       INNER JOIN EMP_MASTER B WITH(NOLOCK)
	            ON  PD.NEW_CODE = B.EMP_CODE
	       INNER JOIN EMP_TEAM BA WITH(NOLOCK)
	            ON  B.TEAM_CODE = BA.TEAM_CODE
	       INNER JOIN MARKET_PRODUCT_TEMP PT
	            ON  A.RES_CODE = PT.RES_CODE
	                AND SEQ = (
	                        SELECT MAX(SEQ)
	                        FROM   MARKET_PRODUCT_TEMP
	                        WHERE  RES_CODE = @RES_CODE
	                    )
	       LEFT OUTER JOIN KICC_PAY_REQUEST PR
	            ON  A.RES_CODE = PR.RES_CODE
	                AND PAY_REQ_TYPE = 'VACCT'
	                AND (ISNULL('' ,'') = '' OR COMP_YN = '')
	                --AND DEL_YN IS NULL OR DEL_YN = 'N'
	                AND ISNULL(DEL_YN,'') <> 'Y'
	       LEFT OUTER JOIN MARKET_CANCEL_REQUEST CR
	            ON  CR.RES_CODE = A.RES_CODE
	                AND CANCEL_STATE <> 'Y'
	WHERE  A.RES_CODE = @RES_CODE
END
GO
