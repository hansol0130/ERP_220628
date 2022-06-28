USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ETC_CHART_SELECT
■ DESCRIPTION				: exr통계 상담유형별 기타 파이챠트
■ INPUT PARAMETER			: 
	@CHART_TYPE				: 차트 구분
	:SDATE				  : 시작일자
  :EDATE				  : 종료일자
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_ETC_CHART_SELECT '1','2015-01-01','2015-01-05'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-26		홍영택			최초생성
   2015-01-28		박노민			나이대 쿼리수정
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ETC_CHART_SELECT]
--@TEAM_CODE varchar(10), 
@CHART_TYPE char(1), 
@SDATE varchar(10), 
@EDATE varchar(10)

WITH EXEC AS CALLER
AS
SET NOCOUNT ON

BEGIN

IF @CHART_TYPE IS NULL OR @CHART_TYPE = ''
		SET @CHART_TYPE = '1';

	IF @CHART_TYPE = '3'
		BEGIN
						
		select '3' CHART_TYPE, main_name ITEM_NAME, isnull(ITEM_COUNT,0) ITEM_COUNT,0 tot_item_count from 
		Sirens.cti.CTI_CODE_MASTER  A left join 
		(SELECT 
			CHART_TYPE, 
			ITEM_NAME, 
			ISNULL(SUM(ITEM_COUNT),0) AS ITEM_COUNT
			FROM Sirens.cti.CTI_STAT_REPORT_ETC
			WHERE  1=1
			AND S_DATE BETWEEN replace(@SDATE,'-','') AND replace(@EDATE,'-','')
			AND CHART_TYPE =3
			GROUP BY CHART_TYPE, ITEM_NAME
			) B on (A.main_name = B.item_name)
			where CATEGORY = 'STA001'
			union all
			select '7' CHART_TYPE, main_name, isnull(ITEM_COUNT,0) ITEM_COUNT,0 tot_item_count from 
			Sirens.cti.CTI_CODE_MASTER  A left join 
			(SELECT 
				CHART_TYPE, 
				ITEM_NAME, 
				ISNULL(SUM(ITEM_COUNT),0) AS ITEM_COUNT
				FROM Sirens.cti.CTI_STAT_REPORT_ETC
				WHERE  1=1
				AND S_DATE BETWEEN replace(@SDATE,'-','') AND replace(@EDATE,'-','')
				AND CHART_TYPE =7
				GROUP BY CHART_TYPE, ITEM_NAME
			) B on (A.main_name = B.item_name)
			where CATEGORY = 'STA001'
								
				ORDER BY main_name, CHART_TYPE
		END
	ELSE
		BEGIN
			  SELECT
			  A.CHART_TYPE AS CHART_TYPE, 
			  A.ITEM_NAME AS ITEM_NAME, 
			  A.ITEM_COUNT AS ITEM_COUNT,
			  B.ITEM_COUNT AS TOT_ITEM_COUNT
			FROM
			(
			  SELECT 
				CHART_TYPE, 
				ITEM_NAME, 
			   ISNULL(SUM(ITEM_COUNT),0) AS ITEM_COUNT
			  FROM Sirens.cti.CTI_STAT_REPORT_ETC
			  WHERE  1=1
			  AND S_DATE BETWEEN replace(@SDATE,'-','') AND replace(@EDATE,'-','')
			  AND CHART_TYPE = @CHART_TYPE
			  --AND  (ISNULL( @TEAM_CODE,'') = '' OR  TEAM_CODE = @TEAM_CODE)
			  GROUP BY CHART_TYPE, ITEM_NAME
			) A,
			(
			  SELECT 
				CHART_TYPE, 
				ISNULL(SUM(ITEM_COUNT),0) AS ITEM_COUNT
			  FROM Sirens.cti.CTI_STAT_REPORT_ETC
			  WHERE  1=1
			  AND S_DATE BETWEEN replace(@SDATE,'-','') AND replace(@EDATE,'-','')
			  AND CHART_TYPE = @CHART_TYPE
			  -- AND  (ISNULL( @TEAM_CODE,'') = '' OR  TEAM_CODE = @TEAM_CODE)
			  GROUP BY CHART_TYPE
			) B
			WHERE A.CHART_TYPE = B.CHART_TYPE
			ORDER BY A.ITEM_COUNT desc, CHART_TYPE
		END
	
		
END


SET NOCOUNT OFF
GO
