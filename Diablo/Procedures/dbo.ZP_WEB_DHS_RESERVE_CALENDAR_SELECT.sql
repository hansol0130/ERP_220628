USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************************
 * Code formatted by SoftTree SQL Assistant ?v11.3.277
 * Time: 2022-01-21 오후 4:51:52
 ************************************************************/

/*================================================================================================================
■ USP_NAME						: [ZP_WEB_DHS_RESERVE_CALENDAR_SELECT]
■ DESCRIPTION					: 홈쇼핑 호텔 달력 view 정보 조회
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    : ZP_WEB_DHS_RESERVE_CALENDAR_SELECT 'XPP1112', '3', '2022-02-26' 
■ MEMO						    :
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-20		김홍우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_WEB_DHS_RESERVE_CALENDAR_SELECT]
	@MASTER_CODE VARCHAR(10)
	,@BIT_CODE VARCHAR(4)
	,@SEARCH_DATE_E DATE
AS 
BEGIN
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
    DECLARE @SEARCH_DATE_S     DATE=GETDATE()
           ,@SEARCH_WORD       VARCHAR(20)
    
    PRINT CONVERT(CHAR(6) ,@SEARCH_DATE_S ,112)
    
    SELECT @SEARCH_WORD = (@MASTER_CODE+'-______'+@BIT_CODE)
    
SELECT B.*
      ,CONVERT(CHAR(10), PTD.[DATE], 23) AS ALL_DATE
      ,phd.IS_HOLIDAY
FROM   dbo.PUB_TMP_DATE PTD
       LEFT OUTER JOIN (
                SELECT A.PRO_CODE
                      ,A.DEP_DATE
                      ,PDP.PRICE_SEQ
                      ,PDP.SGL_PRICE
                      ,A.RES_ADD_YN
                      ,A.MAX_COUNT
                      ,A.RES_COUNT
                      ,(
                           CASE 
                                WHEN A.RES_ADD_YN='Y'
                                     AND A.MAX_COUNT>A.RES_COUNT THEN 'Y'
                                    ELSE 'N'
                               END
                       ) AS RES_ADD_YN2
                      ,(A.MAX_COUNT- A.RES_COUNT) AS REST_RES_COUNT
                FROM   (
                           SELECT PD.PRO_CODE
                                 ,PD.DEP_DATE
                                 ,ISNULL(MAX(PD.MAX_COUNT) ,0) AS MAX_COUNT
                                 ,MAX(PD.RES_ADD_YN) AS RES_ADD_YN
                                 ,ISNULL(COUNT(*) ,0) AS RES_COUNT
                           FROM   dbo.PKG_MASTER PM
                                  INNER JOIN dbo.PKG_DETAIL PD
                                       ON  PM.MASTER_CODE = PD.MASTER_CODE
                                  LEFT OUTER JOIN dbo.RES_MASTER_damo RM
                                       ON  PD.PRO_CODE = RM.PRO_CODE
                                           AND RM.RES_STATE<7
                           WHERE  PM.MASTER_CODE = @MASTER_CODE
                                  --AND PD.DEP_DATE >= @SEARCH_DATE	//CONVERT(CHAR(6), @SEARCH_DATE, 112)
                                  --AND PD.DEP_DATE < DATEADD(MM ,1 ,@SEARCH_DATE_S)
                                  AND CONVERT(CHAR(6) ,PD.DEP_DATE ,112)>=CONVERT(CHAR(6) ,@SEARCH_DATE_S ,112)
                                  --AND CONVERT(CHAR(6) ,PD.DEP_DATE ,112)<=CONVERT(CHAR(6) ,@SEARCH_DATE_E ,112)
                                  AND PD.PRO_CODE LIKE @SEARCH_WORD
                           GROUP BY
                                  PD.PRO_CODE
                                 ,PD.DEP_DATE
                       ) A
                       INNER JOIN PKG_DETAIL_PRICE PDP
                            ON  A.PRO_CODE = PDP.PRO_CODE
            ) B
            ON  PTD.[DATE] = B.DEP_DATE
            LEFT OUTER JOIN dbo.PUB_HOLIDAY PHD
            ON PTD.[DATE] = PHD.HOLIDAY
WHERE  1 = 1
       AND CONVERT(CHAR(6) ,PTD.[DATE] ,112)>=CONVERT(CHAR(6) ,@SEARCH_DATE_S ,112)
       AND CONVERT(CHAR(6) ,PTD.[DATE] ,112)<=CONVERT(CHAR(6) ,@SEARCH_DATE_E ,112)
ORDER BY PTD.[DATE] ASC       
END


GO
