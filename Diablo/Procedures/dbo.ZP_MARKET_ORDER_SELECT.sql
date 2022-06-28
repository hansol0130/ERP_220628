USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_MARKET_ORDER_SELECT
■ DESCRIPTION					: 참좋은마켓 주문정보화면 데이터
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2021-07-30		홍종우			최초생성
   2021-04-14		오준혁			마감된 상품은 주문되자 않도록 수정
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_MARKET_ORDER_SELECT]
	@CUS_NO				INT,
	@CNT				INT,
	@PRO_CODE			VARCHAR(20),
	@PRICE_SEQ			INT
	
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT PD.PRO_CODE
	      ,PD.PRO_NAME
	      ,@CNT CNT
	      ,CASE @CUS_NO
	            WHEN 0 THEN PP.CHD_PRICE * @CNT
	            ELSE PP.ADT_PRICE * @CNT
	       END PRICE
	      ,BA.TEAM_NAME
	      ,BA.KEY_NUMBER
	      ,B.KOR_NAME
	      ,B.FAX_NUMBER1
	      ,B.FAX_NUMBER2
	      ,B.FAX_NUMBER3
	      ,B.EMAIL
		  ,CASE
		       WHEN PM.SHOW_YN = 'N' THEN 'N'
		       ELSE PD.RES_ADD_YN
		   END AS 'RES_ADD_YN'  
	FROM   PKG_DETAIL PD
	       INNER JOIN PKG_DETAIL_PRICE PP
	            ON  PD.PRO_CODE = PP.PRO_CODE
	                AND PRICE_SEQ = @PRICE_SEQ
	       INNER JOIN EMP_MASTER B
	            ON  PD.NEW_CODE = B.EMP_CODE
	       INNER JOIN EMP_TEAM BA
	            ON  B.TEAM_CODE = BA.TEAM_CODE
	       INNER JOIN dbo.PKG_MASTER PM
	            ON PM.MASTER_CODE = PD.MASTER_CODE
	WHERE  PD.PRO_CODE = @PRO_CODE
	
END
GO
