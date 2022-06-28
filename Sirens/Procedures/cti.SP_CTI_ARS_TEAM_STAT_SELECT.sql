USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ARS_TEAM_STAT_SELECT
■ DESCRIPTION				: ARS 통화 유입현황
■ INPUT PARAMETER			: 
	@TEAM_CODE varchar(10)	: 팀코드
	@EMP_CODE varchar(10)	: 직원코드
	@SDATE varchar(10)		: 시작일자
	@EDATE varchar(10)		: 끝일자
	@GUBUN varchar(10)		: 조회구분 W : 요일, D : 일, T : 시간
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_ARS_TEAM_STAT_SELECT '','','2015-01-01','2015-01-20','D'

	GUBUN      GROUP_NAME                                         TITLE    TOTAL_CALL
---------- -------------------------------------------------- -------- -----------
D          경영지원팀                                              20150101 0
D          고객만족실                                              20150101 0


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-26		홍영택			최초생성
   2015-01-28		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ARS_TEAM_STAT_SELECT]
@TEAM_CODE varchar(10), 
@EMP_CODE varchar(10), 
@SDATE varchar(10), 
@EDATE varchar(10), 
@GUBUN varchar(10)

WITH EXEC AS CALLER
AS
SET NOCOUNT ON

BEGIN

  IF @GUBUN IS NULL OR @GUBUN = ''
		SET @GUBUN = 'T ';


          SELECT
            GUBUN,
            GROUP_NAME,
            TITLE,
            SUM(TOTAL_CALL) AS TOTAL_CALL
          FROM  
          (  
            SELECT 
              @GUBUN AS GUBUN,
             GROUP_NAME AS GROUP_NAME ,
             CASE WHEN @GUBUN = 'T' THEN S_HOUR -- ISNULL(CONVERT(VARCHAR(2),S_HOUR,108),'')
              WHEN  @GUBUN = 'D' THEN S_DATE -- ISNULL(CONVERT(VARCHAR(8),S_DATE,120),'')
              ELSE S_WEEK END AS TITLE,             
              SUM(TOTAL_CALL) AS TOTAL_CALL
            FROM Sirens.cti.CTI_STAT_ARS
            WHERE 1=1
            AND S_DATE BETWEEN replace(@SDATE,'-','') AND replace(@EDATE,'-','')
            AND  (ISNULL( @TEAM_CODE,'') = '' OR  GROUP_NO = @TEAM_CODE)

            GROUP BY GROUP_NAME, S_DATE, S_WEEK, S_HOUR
			
        ) A
        GROUP BY A.GUBUN, A.GROUP_NAME, A.TITLE
        ORDER BY  TITLE
  
END


SET NOCOUNT OFF
GO
