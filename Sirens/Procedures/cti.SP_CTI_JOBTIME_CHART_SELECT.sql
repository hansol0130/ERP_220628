USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_JOBTIME_CHART_SELECT
■ DESCRIPTION				: 상담업무시간
■ INPUT PARAMETER			: 
	:SDATE				  : 시작일자
  :EDATE				  : 종료일자
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_JOBTIME_CHART_SELECT

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-26		홍영택			최초생성
   2014-12-29		박노민			1일평균값으로 수정
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_JOBTIME_CHART_SELECT]
--@TEAM_CODE varchar(10), 
--@EMP_CODE varchar(10), 
@SDATE varchar(10), 
@EDATE varchar(10)

WITH EXEC AS CALLER
AS
SET NOCOUNT ON

BEGIN

--IF @GUBUN IS NULL OR @GUBUN = ''
--		SET @GUBUN = 'M ';
declare @DayD int;

set @DayD = (datediff(D,@SDATE , @EDATE) + 1);

SELECT 
    ISNULL(SUM(JOBTIME_1) / @DayD , 0) AS JOBTIME_1,
    ISNULL(SUM(JOBTIME_2) / @DayD , 0) AS JOBTIME_2,
    ISNULL(SUM(JOBTIME_3) / @DayD , 0) AS JOBTIME_3,
    ISNULL(SUM(JOBTIME_4) / @DayD , 0) AS JOBTIME_4,
    ISNULL(SUM(JOBTIME_5) / @DayD , 0) AS JOBTIME_5,
    ISNULL(SUM(JOBTIME_6) / @DayD , 0) AS JOBTIME_6,
    (ISNULL(SUM(JOBTIME_1), 0) + ISNULL(SUM(JOBTIME_2), 0) + ISNULL(SUM(JOBTIME_3), 0) +
      ISNULL(SUM(JOBTIME_4), 0) + ISNULL(SUM(JOBTIME_5), 0) + ISNULL(SUM(JOBTIME_6), 0))  / @DayD  AS JOBTIME_TOT,
    ISNULL(SUM(INTIME_1) / @DayD , 0) AS INTIME_1,
    ISNULL(SUM(INTIME_2) / @DayD , 0) AS INTIME_2,
    ISNULL(SUM(INTIME_3) / @DayD , 0) AS INTIME_3,
    ISNULL(SUM(INTIME_4) / @DayD , 0) AS INTIME_4,
    ISNULL(SUM(INTIME_5) / @DayD , 0) AS INTIME_5,
    ISNULL(SUM(INTIME_6) / @DayD , 0) AS INTIME_6,
    (ISNULL(SUM(INTIME_1), 0) + ISNULL(SUM(INTIME_2), 0) + ISNULL(SUM(INTIME_3), 0) +
      ISNULL(SUM(INTIME_4), 0) + ISNULL(SUM(INTIME_5), 0) + ISNULL(SUM(INTIME_6), 0))  / @DayD  AS INTIME_TOT,
    ISNULL(SUM(OUTTIME_1) / @DayD ,0) AS OUTTIME_1,
    ISNULL(SUM(OUTTIME_2) / @DayD , 0) AS OUTTIME_2,
    ISNULL(SUM(OUTTIME_3) / @DayD , 0) AS OUTTIME_3,
    ISNULL(SUM(OUTTIME_4) / @DayD , 0) AS OUTTIME_4,
    ISNULL(SUM(OUTTIME_5) / @DayD , 0) AS OUTTIME_5,
    ISNULL(SUM(OUTTIME_6) / @DayD , 0) AS OUTTIME_6,
    (ISNULL(SUM(OUTTIME_1), 0) + ISNULL(SUM(OUTTIME_2), 0) + ISNULL(SUM(OUTTIME_3), 0) +
      ISNULL(SUM(OUTTIME_4), 0) + ISNULL(SUM(OUTTIME_5), 0) + ISNULL(SUM(OUTTIME_6), 0))  / @DayD  AS OUTTIME_TOT
  FROM Sirens.cti.CTI_STAT_REPORT_JOBTIME
  WHERE  1=1
  AND S_DATE BETWEEN replace(@SDATE,'-','') AND replace(@EDATE,'-','')
  -- AND  (ISNULL( @TEAM_CODE,'') = '' OR  TEAM_CODE = @TEAM_CODE)
  
END


SET NOCOUNT OFF
GO
