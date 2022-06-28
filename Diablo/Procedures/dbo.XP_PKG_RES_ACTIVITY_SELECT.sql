USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PKG_RES_ACTIVITY_SELECT
■ DESCRIPTION				: 예약 액티비티 리스트 조회  
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: EXEC DBO.XP_PKG_RES_ACTIVITY_SELECT 'RP2001225683'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2020-02-03		오준혁			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_PKG_RES_ACTIVITY_SELECT]
	 @RES_CODE     CHAR(12) = ''
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	--set @RES_CODE = 'RP2001225683'; -- 예약불가
	--set @RES_CODE = 'RP2001105652'; -- 신규예약


	;WITH LIST AS (
	         SELECT A.MASTER_CODE
	               ,MAX(A.DEP_DATE) AS [DEP_DATE]
	               ,MAX(A.PRO_CODE) AS [PRO_CODE]
	               ,MAX(A.RES_CODE) AS [RES_CODE]
	         FROM   (
	                    SELECT B.MASTER_CODE
	                          ,B.DEP_DATE
	                          ,B.PRO_CODE
	                          ,B.RES_CODE
	                    FROM   RES_MASTER_CONNECT A WITH(NOLOCK)
	                           INNER JOIN RES_MASTER_damo B WITH(NOLOCK)
	                                ON  A.CON_RES_CODE = B.RES_CODE
	                                    AND B.RES_STATE < 7
	                    WHERE  A.RES_CODE = @RES_CODE
	                           AND A.CON_TYPE = 'CN'
	                    
	                    UNION
	                    SELECT B.CON_MASTER_CODE
	                          ,A.DEP_DATE
	                          ,'' AS [PRO_CODE]
	                          ,'' AS [RES_CODE]
	                    FROM   RES_MASTER_damo A WITH(NOLOCK)
	                           INNER JOIN PKG_MASTER_CONNECT B WITH(NOLOCK)
	                                ON  A.MASTER_CODE = B.MASTER_CODE
	                                    AND B.CON_TYPE = 'CN'
	                    WHERE  A.RES_CODE = @RES_CODE
	                ) A
	         GROUP BY
	                A.MASTER_CODE
	     )
	
	SELECT ROW_NUMBER() OVER(ORDER BY A.MASTER_CODE) AS [SEQ]
	      ,A.MASTER_CODE
	      ,A.PRO_CODE AS [CON_PRO_CODE]
	      ,(
	           CASE 
	                WHEN (
	                         SELECT MAX(RES_CODE)
	                         FROM   LIST
	                     ) = '' THEN '신규예약'
	                WHEN LEN(A.RES_CODE) > 0 THEN A.RES_CODE
	                ELSE '예약불가'
	           END
	       ) AS [CON_RES_CODE]
	      ,B.MASTER_NAME
	      ,C.ADT_PRICE
	      ,C.CHD_PRICE
	      ,C.INF_PRICE
	      ,D.KOR_NAME
	      ,(
	           SELECT TOP 1 BB.KOR_NAME
	           FROM   PKG_MASTER_SCH_CITY AA WITH(NOLOCK)
	                  INNER JOIN PUB_CITY BB WITH(NOLOCK)
	                       ON  AA.CITY_CODE = BB.CITY_CODE
	           WHERE  AA.MASTER_CODE = B.MASTER_CODE
	                  AND AA.SCH_SEQ = C.SCH_SEQ
	       ) AS [CITY_NAME]
	FROM   LIST A
	       LEFT JOIN PKG_MASTER B WITH(NOLOCK)
	            ON  A.MASTER_CODE = B.MASTER_CODE
	       LEFT JOIN PKG_MASTER_PRICE C WITH(NOLOCK)
	            ON  B.MASTER_CODE = C.MASTER_CODE
	                AND C.PRICE_SEQ = MONTH(A.DEP_DATE)
	       LEFT JOIN EMP_MASTER_damo D WITH(NOLOCK)
	            ON  B.NEW_CODE = D.EMP_CODE
	ORDER BY
	       A.MASTER_CODE
	 
END
GO
