USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ARS_INIP_YASIX_SELECT
■ DESCRIPTION				: ARS 통화 유입현황 그래프 Y좌표값 조회
■ INPUT PARAMETER			: 
	@TEAM_CODE varchar(10)	: 팀코드
	@EMP_CODE varchar(10)	: 직원코드
	@SDATE varchar(10)		: 시작일자
	@EDATE varchar(10)		: 끝일자
	@GUBUN varchar(10)		: 미사용
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_ARS_INIP_YASIX_SELECT '','','2015-01-01','2015-01-20',''

	GROUP_NAME
--------------------------------------------------
경영지원팀
고객만족실
고객지원
골프

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-26		홍영택			최초생성
   2015-01-28		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ARS_INIP_YASIX_SELECT]
@TEAM_CODE varchar(10), 
@EMP_CODE varchar(10), 
@SDATE varchar(10), 
@EDATE varchar(10), 
@GUBUN varchar(10)

WITH EXEC AS CALLER
AS
SET NOCOUNT ON

BEGIN

  
    SELECT 
      DISTINCT GROUP_NAME AS GROUP_NAME
    FROM Sirens.cti.CTI_STAT_ARS
    WHERE 1=1
    AND S_DATE BETWEEN replace(@SDATE,'-','') AND replace(@EDATE,'-','')
    AND  (ISNULL( @TEAM_CODE,'') = '' OR  GROUP_NO = @TEAM_CODE)
	and GROUP_NO in ( select GROUP_NO from Sirens.cti.CTI_STAT_ARS 
							   where S_DATE BETWEEN replace(@SDATE,'-','') AND replace(@EDATE,'-','')
							   group by group_no
							   having sum(total_call) > 0)
    GROUP BY GROUP_NAME
  
END


SET NOCOUNT OFF
GO
