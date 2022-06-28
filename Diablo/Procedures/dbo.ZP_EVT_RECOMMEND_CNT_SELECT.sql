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
	@@CUS_NO		INT			: 고객코드
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : EXEC ZP_EVT_RECOMMEND_CNT_SELECT 11166539, '20210630'
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2021-06-21		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_EVT_RECOMMEND_CNT_SELECT]
	@CUS_NO			INT,
	@DATE			VARCHAR(8)
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	--SELECT COUNT(1)
	--FROM EVT_RECOMMEND
	--WHERE CUS_NO_RECOM = @CUS_NO
	
	DECLARE @TODAY_WEK INT
	
	SELECT @TODAY_WEK = CASE 
	                         WHEN DATEDIFF(DD ,@DATE ,GETDATE()) < 0 THEN '0'
	                         WHEN DATEDIFF(DD ,@DATE ,GETDATE()) <= 10 THEN '1'
	                         WHEN DATEDIFF(DD ,@DATE ,GETDATE()) <= 17 THEN '2'
	                         WHEN DATEDIFF(DD ,@DATE ,GETDATE()) <= 24 THEN '3'
	                         WHEN DATEDIFF(DD ,@DATE ,GETDATE()) <= 31 THEN '4'
	                         ELSE '0'
	                    END
	
	SELECT COUNT(1) TOT_CNT
	      ,ISNULL(SUM(WEK_CNT),0) WEK_CNT
	FROM   (
	           SELECT CASE WEK
	                       WHEN @TODAY_WEK THEN 1
	                       ELSE 0
	                  END WEK_CNT
	           FROM   (
	                      SELECT CASE 
	                                  WHEN DATEDIFF(DD ,@DATE ,ER.NEW_DATE) < 0 THEN '0'
	                                  WHEN DATEDIFF(DD ,@DATE ,ER.NEW_DATE) <= 10 THEN '1'
	                                  WHEN DATEDIFF(DD ,@DATE ,ER.NEW_DATE) <= 17 THEN '2'
	                                  WHEN DATEDIFF(DD ,@DATE ,ER.NEW_DATE) <= 24 THEN '3'
	                                  WHEN DATEDIFF(DD ,@DATE ,ER.NEW_DATE) <= 31 THEN '4'
	                                  ELSE '0'
	                             END WEK
	                      FROM   EVT_RECOMMEND ER
	                             JOIN CUS_MEMBER CU
	                                  ON  ER.CUS_NO = CU.CUS_NO
	                      WHERE  ER.CUS_NO_RECOM = @CUS_NO
	                  ) A
	                  --WHERE A.WEK <> 0
	       ) AA
END
GO
