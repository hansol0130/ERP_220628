USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ARS_CHART_SELECT
■ DESCRIPTION				: ARS통화 유입현황(팀별) @ 상담연결, 상담완료, 상담포기, 상담예약
■ INPUT PARAMETER			: 
	:SDATE				  : 시작일자
  :EDATE				  : 종료일자
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_ARS_CHART_SELECT '2015-01-01', '2015-01-20'

	GROUP_NAME   CON_CALL    FIN_CALL    AB_CALL     PMS_CNT     TOT_CON_CALL TOT_FIN_CALL TOT_AB_CALL TOT_PMS_CNT
---------------- ----------- ----------- ----------- ----------- ------------ ------------ ----------- -----------
    WEB          192         0           14          0           61279        0            4034        25470


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-26		홍영택			최초생성
   2015-01-28		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ARS_CHART_SELECT]
@SDATE varchar(10), 
@EDATE varchar(10)

WITH EXEC AS CALLER
AS
SET NOCOUNT ON

BEGIN

  SELECT 
    A.GROUP_NAME,
    SUM(A.CON_CALL) AS CON_CALL,
    SUM(A.FIN_CALL) AS FIN_CALL,
    SUM(A.AB_CALL) AS AB_CALL,
    SUM(A.PMS_CNT)AS PMS_CNT,
    SUM(B.TOT_CON_CALL) AS TOT_CON_CALL,
    SUM(B.TOT_FIN_CALL) AS TOT_FIN_CALL,
    SUM(B.TOT_AB_CALL)AS TOT_AB_CALL,
    SUM(B.TOT_PMS_CNT)AS TOT_PMS_CNT
  FROM 
  (
    SELECT 
      GROUP_NAME,
      ISNULL(SUM(CON_CALL),0) AS CON_CALL,  -- 상담연결
      ISNULL(SUM(FIN_CALL),0) AS FIN_CALL, -- 상담완료
      ISNULL(SUM(AB_CALL),0) AS AB_CALL,  -- 상담포기
      ISNULL(SUM(PMS_CNT),0) AS PMS_CNT  -- 상담예약
    FROM Sirens.cti.CTI_STAT_ARS
    WHERE  1=1
      AND S_DATE BETWEEN replace(@SDATE,'-','') AND replace(@EDATE,'-','')
      
    GROUP BY  GROUP_NAME
  ) A,
  (  
    SELECT 
      ISNULL(SUM(CON_CALL),0) AS TOT_CON_CALL,  -- 상담연결
      ISNULL(SUM(FIN_CALL),0) AS TOT_FIN_CALL, -- 상담완료
      ISNULL(SUM(AB_CALL),0) AS TOT_AB_CALL,  -- 상담포기
      ISNULL(SUM(PMS_CNT),0) AS TOT_PMS_CNT  -- 상담예약
    FROM Sirens.cti.CTI_STAT_ARS
    WHERE  1=1
    AND S_DATE BETWEEN replace(@SDATE,'-','') AND replace(@EDATE,'-','')
    
  ) B
  GROUP BY A.GROUP_NAME
  order by SUM(A.CON_CALL) desc
END


SET NOCOUNT OFF
GO
