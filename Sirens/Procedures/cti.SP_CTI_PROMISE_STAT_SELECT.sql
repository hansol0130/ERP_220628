USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*================================================================================================================
■ USP_NAME					: SP_CTI_PROMISE_STAT_SELECT
■ DESCRIPTION				: 상담업무시간분석
■ INPUT PARAMETER			: 
	@TEAM_CODE varchar(10)	: 팀코드
@EMP_CODE varchar(10),		: 직원코드
@SDATE varchar(10),			:시작일자
@EDATE varchar(10),			:종료일자
@GUBUN varchar(10)			:조회구분
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_PROMISE_STAT_SELECT

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-26		홍영택			최초생성
   2015-01-30		박노민			부서 선택 시 하위 부서 동시 조회 추가
   2015-02-25		박노민			대기시간을 평균으로 변경
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_PROMISE_STAT_SELECT]
@TEAM_CODE varchar(10), 
@EMP_CODE varchar(10), 
@SDATE varchar(10), 
@EDATE varchar(10), 
@GUBUN varchar(10)

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


  IF @GUBUN IS NULL OR @GUBUN = ''
		SET @GUBUN = 'M ';


  -- 일자별 상담업무 현황
  -- SP_CTI_PROMISE_STAT_SELECT
  SELECT
    CASE WHEN GROUPING(GUBUN)  = '1' THEN ' 전체' ELSE GUBUN END AS TITLE,
    SUM(RESERVE_COUNT) AS RESERVE_COUNT, 
    SUM(IN_CUST_COUNT) + SUM(IN_CALL_COUNT) AS IN_CUST_CALL_COUNT ,
    SUM(OUT_CUST_COUNT) + SUM(OUT_CALL_COUNT) AS OUT_CUST_CALL_COUNT ,
    SUM(IN_CUST_COUNT)  AS IN_CUST_COUNT , 
    SUM(OUT_CUST_COUNT) AS  OUT_CUST_COUNT, 
    iif(SUM(OUT_CUST_COUNT) = 0, 0, SUM(ON_CALL_TIME)/ SUM(OUT_CUST_COUNT)) AS  ON_CALL_TIME ,
    SUM(IN_CALL_COUNT) AS  IN_CALL_COUNT, 
    SUM(OUT_CALL_COUNT) AS OUT_CALL_COUNT , 
    SUM(PRE_CUST_COUNT) AS  PRE_CUST_COUNT
  FROM
  (
    SELECT 
        CASE WHEN @GUBUN = 'M' THEN ISNULL(CONVERT(VARCHAR(6),S_DATE,120),'')
                  WHEN  @GUBUN = 'D' THEN ISNULL(CONVERT(VARCHAR(8),S_DATE,120),'')
                  ELSE ISNULL(CONVERT(VARCHAR(2), S_HOUR,108),'') END AS GUBUN,
        CASE WHEN ISNULL( @TEAM_CODE,'') = ''  THEN TEAM_CODE 
                  ELSE  EMP_CODE END AS TEAM_CODE,
        CASE WHEN ISNULL( @TEAM_CODE,'') = ''  THEN TEAM_NAME
                  ELSE  EMP_NAME END AS TEAM_NAME,  
        SUM(RESERVE_COUNT) AS RESERVE_COUNT, 
        SUM(IN_CUST_COUNT)  AS IN_CUST_COUNT , 
        SUM(OUT_CUST_COUNT) AS  OUT_CUST_COUNT, 
        SUM(ON_CALL_TIME) AS  ON_CALL_TIME ,
        SUM(IN_CALL_COUNT) AS  IN_CALL_COUNT, 
        SUM(OUT_CALL_COUNT) AS OUT_CALL_COUNT, 
        SUM(PRE_CUST_COUNT) AS  PRE_CUST_COUNT
    FROM Sirens.cti.CTI_STAT_PROMISE
    WHERE 1=1
    AND S_DATE BETWEEN replace(@SDATE,'-','') AND replace(@EDATE,'-','')
     AND  (ISNULL( @TEAM_CODE,'') = '' OR  TEAM_CODE = @TEAM_CODE)
	-- AND (@TEAM_LIST IS NULL OR TEAM_CODE IN (SELECT DATA FROM Diablo.dbo.FN_SPLIT(ISNULL(@TEAM_LIST, ''), ',')))
	GROUP BY S_DATE, S_HOUR, TEAM_CODE, TEAM_NAME, EMP_CODE, EMP_NAME
  )  A
  WHERE 1=1
  GROUP BY A.GUBUN WITH ROLLUP
  ORDER BY  A.GUBUN
  
END


SET NOCOUNT OFF


GO
