USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_EVALUATION_STAT_SELECT
■ DESCRIPTION				: 상담평가 점수 현황
■ INPUT PARAMETER			: 
	:@TEAM_CODE				:팀코드
	@TEAM_NAME				:팀명
	@SDATE					조회년도
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_EVALUATION_STAT_SELECT '','','2014'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-26		홍영택			최초생성
   2015-01-30		박노민			부서 선택 시 하위 부서 동시 조회 추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_EVALUATION_STAT_SELECT]
@TEAM_CODE varchar(10), 
@TEAM_NAME varchar(20), 
@SDATE varchar(4)

WITH EXEC AS CALLER
AS
SET NOCOUNT ON

/********************************************************************************
*  임시테이블삭제하기
********************************************************************************/
IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name like '#TblDynamicPivot%')
       DROP TABLE #TblDynamicPivot

/********************************************************************************
*  임시테이블만들기
********************************************************************************/
CREATE TABLE #TblDynamicPivot (
       GUBUN CHAR(1)
       , S_DATE NVARCHAR(10)
       , QUANTITY INT
)
 
/********************************************************************************
*  임시테이블에데이터넣기
********************************************************************************/
IF @SDATE IS NULL OR @SDATE = ''
SET @SDATE = '2014 ';

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



       INSERT INTO #TblDynamicPivot
       SELECT 
        '1' AS GUBUN,
        --SUBSTRING(S_DATE, 5, 2)   + '월' AS S_DATE,
        SUBSTRING(S_DATE, 5, 2)   + '월' AS S_DATE,
        SUM(CUST_COUNT) AS QUANTITY
      FROM Sirens.cti.CTI_STAT_EVALUATION
      WHERE 1=1
      AND LEFT(S_DATE, 4) = @SDATE
      -- AND  (ISNULL(@TEAM_CODE ,'') = '' OR  TEAM_CODE = @TEAM_CODE )
	  AND (@TEAM_LIST IS NULL OR TEAM_CODE IN (SELECT DATA FROM Diablo.dbo.FN_SPLIT(ISNULL(@TEAM_LIST, ''), ',')))
      GROUP BY S_DATE

        UNION ALL

      SELECT 
        '2' AS GUBUN,
        SUBSTRING(S_DATE, 5, 2)   + '월' AS S_DATE,
        SUM(CUST_POINT) AS QUANTITY
      FROM Sirens.cti.CTI_STAT_EVALUATION
      WHERE 1=1
      AND LEFT(S_DATE, 4) = @SDATE
      -- AND  (ISNULL(@TEAM_CODE ,'') = '' OR  TEAM_CODE = @TEAM_CODE )
	  AND (@TEAM_LIST IS NULL OR TEAM_CODE IN (SELECT DATA FROM Diablo.dbo.FN_SPLIT(ISNULL(@TEAM_LIST, ''), ',')))
      GROUP BY S_DATE

        UNION ALL

      SELECT 
        '3' AS GUBUN,
        SUBSTRING(S_DATE, 5, 2)   + '월' AS S_DATE,
        SUM(MON_POINT) AS QUANTITY
      FROM Sirens.cti.CTI_STAT_EVALUATION
      WHERE 1=1
      AND LEFT(S_DATE, 4) = @SDATE
      --AND  (ISNULL(@TEAM_CODE ,'') = '' OR  TEAM_CODE = @TEAM_CODE )
	  AND (@TEAM_LIST IS NULL OR TEAM_CODE IN (SELECT DATA FROM Diablo.dbo.FN_SPLIT(ISNULL(@TEAM_LIST, ''), ',')))
      GROUP BY S_DATE

END
 
/********************************************************************************
* 동적PIVOT 만들기
********************************************************************************/
-- 원본테이블
-- SELECT * FROM #TblDynamicPivot
 
-- PIVOT 하기
DECLARE @mSQL NVARCHAR(MAX)
DECLARE @SQL NVARCHAR(MAX)

SELECT @mSQL = 
  COALESCE(
    @mSQL + ',[' + cast(S_DATE as varchar) + ']',
    '[' + cast(S_DATE as varchar)+ ']'
  )
FROM #TblDynamicPivot
GROUP BY S_DATE

SET @SQL = '
  SELECT
    *
  FROM 
  (
      SELECT 
        S_DATE,
        GUBUN,
        QUANTITY
      FROM  #TblDynamicPivot
  )  S
  PIVOT
  (
  -- SUM(QUANTITY) FOR S_DATE IN ([01월],[02월],[03월])
  SUM(QUANTITY) FOR S_DATE IN ('+ @mSQL +')
  ) AS RESULTS
  -- ORDER BY S_DATE ASC, GUBUN ASC
'
EXECUTE(@SQL)

SET NOCOUNT OFF
GO
