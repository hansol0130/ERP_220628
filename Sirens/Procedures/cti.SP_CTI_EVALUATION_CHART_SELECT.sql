USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_EVALUATION_CHART_SELECT
■ DESCRIPTION				: 상담평가 점수 현황
■ INPUT PARAMETER			: 
	:@TEAM_CODE				:팀코드
	@TEAM_NAME				:팀명
	@SDATE					조회년도
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_EVALUATION_CHART_SELECT '','','2014'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-26		홍영택			최초생성
   2015-01-30		박노민			부서 선택 시 하위 부서 동시 조회 추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_EVALUATION_CHART_SELECT]
@TEAM_CODE varchar(10), 
@TEAM_NAME varchar(20),  
@SDATE varchar(4)

WITH EXEC AS CALLER
AS
SET NOCOUNT ON

BEGIN
	
	
	-- 하위 부서 체크
	DECLARE @TEAM_LIST VARCHAR(500);

	WITH TEAM_LIST AS
	(
		SELECT A.TEAM_CODE, A.PARENT_CODE, 0 AS [DEPTH]
		FROM Diablo.dbo.EMP_TEAM A WITH(NOLOCK)
		WHERE A.TEAM_CODE = @TEAM_CODE
		UNION ALL
		SELECT A.TEAM_CODE, A.PARENT_CODE, B.DEPTH + 1
		FROM Diablo.dbo.EMP_TEAM A WITH(NOLOCK)
		INNER JOIN TEAM_LIST B ON A.PARENT_CODE = B.TEAM_CODE
		WHERE A.USE_YN = 'Y' AND A.VIEW_YN = 'Y'
	)
	SELECT @TEAM_LIST= (STUFF ((SELECT (',' + TEAM_CODE) AS [text()] FROM TEAM_LIST FOR XML PATH('')), 1, 1, ''));


  IF @SDATE IS NULL OR @SDATE = ''
		SET @SDATE = '2014 ';

  SELECT 
    A.COLUMN_CODE AS COLUMN_CODE,
    A.COLUMN_NAME AS COLUMN_NAME,
    SUM(A.CUST_COUNT) AS CUST_COUNT,
    SUM(A.CUST_POINT) / SUM(A.CUST_COUNT) AS CUST_POINT,
    SUM(A.MON_POINT) / COUNT(*) AS  MON_POINT
  FROM
  (
    SELECT 
      SUBSTRING(S_DATE, 5, 2)  AS S_DATE,
      CASE WHEN ISNULL( @TEAM_CODE,'') = ''  THEN TEAM_CODE
                ELSE  EMP_CODE END AS COLUMN_CODE,
      CASE WHEN ISNULL( @TEAM_CODE,'') = ''  THEN TEAM_NAME
                ELSE  EMP_NAME END AS COLUMN_NAME,
      SUM(CUST_COUNT) AS CUST_COUNT,
      SUM(CUST_POINT) / SUM(CUST_COUNT) AS CUST_POINT,
      SUM(MON_POINT) / COUNT(*) AS  MON_POINT
    FROM Sirens.cti.CTI_STAT_EVALUATION
    WHERE 1=1
    AND LEFT(S_DATE, 4) = @SDATE
    -- AND  ISNULL( @TEAM_CODE,'') = '' OR  TEAM_CODE = @TEAM_CODE
	AND (@TEAM_LIST IS NULL OR TEAM_CODE IN (SELECT DATA FROM Diablo.dbo.FN_SPLIT(ISNULL(@TEAM_LIST, ''), ',')))
    GROUP BY S_DATE, TEAM_CODE, TEAM_NAME, EMP_CODE, EMP_NAME
  ) A
  GROUP BY A.COLUMN_CODE, A.COLUMN_NAME
  
END


SET NOCOUNT OFF
GO
