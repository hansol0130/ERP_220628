USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME						: ZP_WEB_DHS_RESERVE_COMPLETE_SELECT
■ DESCRIPTION					: 홈쇼핑 호텔 예약 완료 조회
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    : EXEC ZP_WEB_DHS_RESERVE_COMPLETE_SELECT 'RP2202107309'
■ MEMO						    :
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-17		김홍우			최초생성
   2022-02-10		김성호			추가금액 조회 컬럼 변경 (PKG_MASTER_PRICE -> PKG_DETAIL_PRICE)
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_WEB_DHS_RESERVE_COMPLETE_SELECT]
	@RES_CODE			CHAR(12)
AS 
BEGIN
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
    SELECT RM.RES_CODE
          ,RM.RES_NAME
          ,RM.PRO_NAME		--왜 바꿈?
          ,PMP.PRICE_NAME
          ,CONVERT(CHAR(10) ,RM.DEP_DATE ,23) AS DEP_DATE
          ,CONVERT(CHAR(10) ,RM.ARR_DATE ,23) AS ARR_DATE
          ,ISNULL(PDP.SGL_PRICE ,0) AS SGL_PRICE
          ,RM.PNR_INFO
          ,RM.CUS_REQUEST
          ,ISNULL(PM.RES_REMARK ,'') AS RES_REMARK
    FROM   dbo.RES_MASTER_damo RM
           INNER JOIN dbo.PKG_DETAIL_PRICE PDP
                ON  RM.PRO_CODE = PDP.PRO_CODE
                    AND RM.PRICE_SEQ = PDP.PRICE_SEQ
           INNER JOIN dbo.PKG_MASTER PM
                ON  RM.MASTER_CODE = PM.MASTER_CODE
           LEFT OUTER JOIN PKG_MASTER_PRICE PMP ON RM.MASTER_CODE = PMP.MASTER_CODE AND CONVERT(INT, SUBSTRING(RM.PRO_CODE, (CHARINDEX('-', RM.PRO_CODE)+7), 4)) = PMP.PRICE_SEQ
    WHERE  RM.RES_CODE = @RES_CODE;

END


GO
