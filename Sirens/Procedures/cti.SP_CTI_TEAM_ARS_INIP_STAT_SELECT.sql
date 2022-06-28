USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_TEAM_ARS_INIP_STAT_SELECT
■ DESCRIPTION				: ARS 통화 유입현황
■ INPUT PARAMETER			: 
	@TEAM_CODE				: 부서코드
	@EMP_CODE				: 사용안함 ???
	@SDATE					: 조회시작일자
	@EDATE					: 조회종료일자
	@GUBUN					: 검색 구분 코드 (M: 월, D: 일, H: 시간)
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec cti.SP_CTI_TEAM_ARS_INIP_STAT_SELECT '408', '', '2015-01-01', '2015-01-15', 'D'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-26		홍영택			최초생성
   2015-01-30		김성호			부서 선택 시 하위 부서 동시 조회 추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_TEAM_ARS_INIP_STAT_SELECT]
	@TEAM_CODE varchar(10), 
	@EMP_CODE varchar(10), 
	@SDATE varchar(10), 
	@EDATE varchar(10), 
	@GUBUN varchar(1)
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

	-- CASE문 ELSE 구문으로 DEFAULT 처리
	  --IF @GUBUN IS NULL OR @GUBUN = ''
		--SET @GUBUN = 'M ';

	SELECT 
		(CASE WHEN GROUPING(GROUP_NAME)  = '1' THEN ' 전체' ELSE GROUP_NAME END) AS TITLE,
		--COUNT(*) AS CNT,
		SUM(PMS_CNT) AS SUM_PMS_CNT, 
		AVG(PMS_CNT) AS AVG_REG_CNT, 
		SUM(REG_CNT) AS SUM_REG_CNT, 
		AVG(REG_CNT) AS AVG_REG_CNT, 
		SUM(TOTAL_CALL) AS SUM_TOTAL_CALL, 
		AVG(TOTAL_CALL) AS AVG_TOTAL_CALL, 
		SUM(DAN_CALL) AS SUM_DAN_CALL, 
		AVG(DAN_CALL) AS AVG_DAN_CALL, 
		SUM(REQ_CALL) AS SUM_REQ_CALL, 
		AVG(REQ_CALL) AS AVG_REQ_CALL, 
		SUM(FIN_CALL) AS SUM_FIN_CALL, 
		AVG(FIN_CALL) AS AVG_FIN_CALL, 
		SUM(CON_CALL) AS SUM_CON_CALL, 
		AVG(CON_CALL) AS AVG_CON_CALL, 
		SUM(AB_CALL) AS SUM_AB_CALL, 
		AVG(AB_CALL) AS AVG_AB_CALL, 
		SUM(CB_CALL) AS SUM_CB_CALL, 
		AVG(CB_CALL) AS AVG_CB_CALL, 
		SUM(SMS_CALL) AS SUM_SMS_CALL,
		AVG(SMS_CALL) AS AVG_SMS_CALL
	FROM (
		SELECT 
			GUBUN AS TITLE,
			GROUP_NAME,
			COUNT(*) AS CNT,
			SUM(PMS_CNT) AS PMS_CNT, 
			SUM(REG_CNT) AS REG_CNT, 
			SUM(TOTAL_CALL) AS TOTAL_CALL, 
			SUM(DAN_CALL) AS DAN_CALL, 
			SUM(REQ_CALL) AS REQ_CALL, 
			SUM(FIN_CALL) AS FIN_CALL, 
			SUM(CON_CALL) AS CON_CALL, 
			SUM(AB_CALL) AS AB_CALL, 
			SUM(CB_CALL) CB_CALL, 
			SUM(SMS_CALL) SMS_CALL
		FROM (  
			SELECT 
				GROUP_NO,
				GROUP_NAME ,
				COUNT(*) AS CNT,
				(	-- DEFAULT : M
					CASE @GUBUN
						WHEN 'M' THEN ISNULL(CONVERT(VARCHAR(6), S_DATE,120), '')
						WHEN 'D' THEN ISNULL(CONVERT(VARCHAR(8), S_DATE,120), '')
						WHEN 'H' THEN ISNULL(CONVERT(VARCHAR(2), S_HOUR,108), '')
						ELSE ISNULL(CONVERT(VARCHAR(6), S_DATE,120), '')
					END
				) AS GUBUN,
				SUM(PMS_CNT) AS PMS_CNT, 
				SUM(REG_CNT) AS REG_CNT, 
				SUM(TOTAL_CALL) AS TOTAL_CALL, 
				SUM(DAN_CALL) AS DAN_CALL, 
				SUM(REQ_CALL) AS REQ_CALL, 
				SUM(FIN_CALL) AS FIN_CALL, 
				SUM(CON_CALL) AS CON_CALL, 
				SUM(AB_CALL) AS AB_CALL, 
				SUM(CB_CALL) CB_CALL, 
				SUM(SMS_CALL) SMS_CALL
			FROM Sirens.cti.CTI_STAT_ARS WITH(NOLOCK)
			WHERE S_DATE BETWEEN REPLACE(@SDATE,'-','') AND REPLACE(@EDATE,'-','')
				-- AND (@TEAM_LIST IS NULL OR GROUP_NO IN (SELECT DATA FROM Diablo.dbo.FN_SPLIT(ISNULL(@TEAM_LIST, ''), ',')))
				AND  (ISNULL( @TEAM_CODE,'') = '' OR  GROUP_NO = @TEAM_CODE)
			GROUP BY GROUP_NO, GROUP_NAME, S_DATE, S_HOUR
		) A
        GROUP BY A.GUBUN, A.GROUP_NAME
	) B
	-- WITH ROLLUP은 MSSQL 2014 이후버전에서는 제거될 기능 (MSDN 참조)
    --GROUP BY B.GROUP_NAME WITH ROLLUP 
	GROUP BY ROLLUP(B.GROUP_NAME)
	having SUM(TOTAL_CALL) > 0
    ORDER BY CASE WHEN GROUPING(GROUP_NAME)  = '1' THEN '0' ELSE '1' END,
	SUM(TOTAL_CALL) desc
      
END


SET NOCOUNT OFF
GO
