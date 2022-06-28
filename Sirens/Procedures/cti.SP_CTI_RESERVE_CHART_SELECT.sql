USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_RESERVE_CHART_SELECT
■ DESCRIPTION				: 예약건수 대비 고객콜수, 통화시간
■ INPUT PARAMETER			: 
	:BDATE				  : 기준일자
  :GUBUN         :상담기간구분
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_RESERVE_CHART_SELECT

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-26		홍영택			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_RESERVE_CHART_SELECT]
--@TEAM_CODE varchar(10), 
--@EMP_CODE varchar(10), 
@BDATE varchar(10), 
@GUBUN varchar(10)

WITH EXEC AS CALLER
AS
SET NOCOUNT ON

BEGIN

--IF @GUBUN IS NULL OR @GUBUN = ''
--		SET @GUBUN = 'M ';

SELECT 
-- 1 건
  ISNULL(SUM(IN_CALL_1) / count(*),0) AS IN_CALL_1 ,
  ISNULL(SUM(IN_TIME_1)/ count(*),0) AS IN_TIME_1,
  ISNULL(SUM(OUT_CALL_1)/ count(*),0) AS OUT_CALL_1,
  ISNULL(SUM(OUT_TIME_1)/ count(*),0) AS OUT_TIME_1,
  -- 2건
  ISNULL(SUM(IN_CALL_2)/ count(*),0) AS IN_CALL_2,
  ISNULL(SUM(IN_TIME_2)/ count(*),0) AS IN_TIME_2,
  ISNULL(SUM(OUT_CALL_2)/ count(*),0) AS OUT_CALL_2,
  ISNULL(SUM(OUT_TIME_2)/ count(*),0) AS OUT_TIME_2,
  -- 3건
  ISNULL(SUM(IN_CALL_3)/ count(*),0) AS IN_CALL_3,
  ISNULL(SUM(IN_TIME_3)/ count(*),0) AS IN_TIME_3,
  ISNULL(SUM(OUT_CALL_3)/ count(*),0) AS OUT_CALL_3, 
  ISNULL(SUM(OUT_TIME_3)/ count(*),0) AS OUT_TIME_3,
  --4건이상
  ISNULL(SUM(IN_CALL_4)/ count(*),0) AS IN_CALL_4,
  ISNULL(SUM(IN_TIME_4)/ count(*),0) AS IN_TIME_4,
  ISNULL(SUM(OUT_CALL_4)/ count(*),0) AS OUT_CALL_4, 
  ISNULL(SUM(OUT_TIME_4)/ count(*),0) AS OUT_TIME_4
FROM Sirens.cti.CTI_STAT_REPORT_RESERVE
WHERE  1=1
AND CONVERT(CHAR(10), CONVERT(DATETIME, S_DATE), 120)  =  @BDATE
AND PERIOD = @GUBUN
--AND  (ISNULL( @TEAM_CODE,'') = '' OR  TEAM_CODE = @TEAM_CODE)
  
END


SET NOCOUNT OFF
GO
