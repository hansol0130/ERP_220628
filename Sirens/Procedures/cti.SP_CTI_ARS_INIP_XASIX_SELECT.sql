USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ARS_INIP_XASIX_SELECT
■ DESCRIPTION				: ARS 통화 유입현황 그래프 X 좌표값 가져오기
■ INPUT PARAMETER			: 
	@TEAM_CODE varchar(10)	: 팀코드
	@EMP_CODE varchar(10)	: 직원코드
	@SDATE varchar(10)		: 시작일자
	@EDATE varchar(10)		: 끝일자
	@GUBUN varchar(10)		: 조회구분 W : 요일, D : 일, T : 시간
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_ARS_INIP_XASIX_SELECT '','','2015-01-01','2015-01-20','D'

	TITLE    GUBUN
-------- ----------
20150101 D

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-26		홍영택			최초생성
   2015-01-28		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ARS_INIP_XASIX_SELECT]
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
		SET @GUBUN = 'T ';


          SELECT
            DISTINCT A.TITLE,
            A.GUBUN
          FROM  
          (  
            SELECT 
              @GUBUN AS GUBUN,
             CASE WHEN @GUBUN = 'T' THEN S_HOUR -- ISNULL(CONVERT(VARCHAR(2),S_HOUR,108),'')
              WHEN  @GUBUN = 'D' THEN S_DATE -- ISNULL(CONVERT(VARCHAR(8),S_DATE,120),'')
              ELSE S_WEEK END AS TITLE   
            FROM Sirens.cti.CTI_STAT_ARS
            WHERE 1=1
            AND S_DATE BETWEEN replace(@SDATE,'-','') AND replace(@EDATE,'-','')
			-- AND (@TEAM_LIST IS NULL OR GROUP_NO IN (SELECT DATA FROM Diablo.dbo.FN_SPLIT(ISNULL(@TEAM_LIST, ''), ',')))
             AND  (ISNULL( @TEAM_CODE,'') = '' OR  GROUP_NO = @TEAM_CODE)
		
			GROUP BY GROUP_NAME, S_DATE, S_WEEK, S_HOUR
        ) A
        GROUP BY A.GUBUN,  A.TITLE
        ORDER BY  A.TITLE
  
END


SET NOCOUNT OFF
GO
