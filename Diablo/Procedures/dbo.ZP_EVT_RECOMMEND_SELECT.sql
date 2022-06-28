USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_EVT_RECOMMEND_CNT_SELECT
■ DESCRIPTION					: 친구추천 명수 검색
■ INPUT PARAMETER				: 
	@DATE 		VARCHAR(8)		: 기준일자
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
			EXEC ZP_EVT_RECOMMEND_SELECT '20210630' 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2021-06-21		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_EVT_RECOMMEND_SELECT]
	@DATE			VARCHAR(8)
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT AAA.WEK
	      ,AAA.RANKING
	      ,SUBSTRING(AAA.CUS_NAME ,0 ,2) + CASE 
                                          WHEN LEN(AAA.CUS_NAME) = '2' THEN '*'
                                          ELSE REPLICATE('*' ,LEN(AAA.CUS_NAME) -2) + SUBSTRING(AAA.CUS_NAME ,LEN(AAA.CUS_NAME) ,LEN(AAA.CUS_NAME) + 1)
                                     END AS CUS_NAME
	      ,AAA.TEL
	      ,AAA.CNT
	FROM   (
	           SELECT ROW_NUMBER() OVER(PARTITION BY AA.wek ORDER BY AA.cnt DESC, AA.NEW_DATE ASC) RANKING
	                 ,AA.wek
	                 ,AA.CUS_NO_RECOM
	                 ,AA.CNT
	                 ,CM.CUS_NAME
	                 ,CM.NOR_TEL3 TEL
	           FROM   (
	                      SELECT WEK
	                            ,CUS_NO_RECOM
	                            ,COUNT(1) CNT
	                            ,MAX(NEW_DATE) NEW_DATE
	                      FROM   (
	                                 SELECT CASE 
	                                             WHEN DATEDIFF(DD ,@DATE ,ER.NEW_DATE) < 0 THEN '0'
	                                             WHEN DATEDIFF(DD ,@DATE ,ER.NEW_DATE) <= 10 THEN '1'
	                                             WHEN DATEDIFF(DD ,@DATE ,ER.NEW_DATE) <= 17 THEN '2'
	                                             WHEN DATEDIFF(DD ,@DATE ,ER.NEW_DATE) <= 24 THEN '3'
	                                             WHEN DATEDIFF(DD ,@DATE ,ER.NEW_DATE) <= 31 THEN '4'
	                                             ELSE '0'
	                                        END WEK
	                                       ,ER.CUS_NO_RECOM
										   ,ER.NEW_DATE
	                                 FROM   EVT_RECOMMEND ER
	                                        JOIN CUS_MEMBER CU
	                                             ON  ER.CUS_NO = CU.CUS_NO
	                             ) A
	                      WHERE  WEK <> 0
	                      GROUP BY
	                             WEK
	                            ,CUS_NO_RECOM
	                  ) AA
	                  JOIN CUS_MEMBER CM
	                       ON  AA.CUS_NO_RECOM = CM.CUS_NO
	       ) AAA
	WHERE  RANKING <= 5
END
GO
