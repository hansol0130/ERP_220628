USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_TEAM_SELECT
■ DESCRIPTION				: 팀목록 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
	BIZ_PUBLIC -> ERP_EMP_TEAM_SELECT_LIST, ERP_EMP_TEAM_SELECT_LIST2, 
	SP_CTI_AUTH_TEAM_SELECT 오픈후 삭제
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-03-19		정지용			최초생성 - 공통쿼리로 사용하기위해 생성(기존에 같은쿼리인데 나누어져 있음)
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_TEAM_SELECT]
	 @TEAM_CODE	VARCHAR(20)
	,@IS_TYPE CHAR(1) -- A : 공통 / B : 권한관리 / C : 통계
AS

BEGIN
	SELECT 
		TEAM.TEAM_CODE,
		TEAM.TEAM_NAME
	FROM Diablo.dbo.EMP_TEAM TEAM
	WHERE
		TEAM.USE_YN = 'Y'
		AND TEAM.VIEW_YN = 'Y'
		AND (
				(ISNULL(@IS_TYPE, '') = 'C')
				OR (ISNULL(@IS_TYPE, '') = 'B' AND TEAM.TEAM_CODE > 500) -- 권한관리쪽에서 사용
				OR (ISNULL(@IS_TYPE, '') = 'A' AND TEAM.TEAM_TYPE IN ('1', '2')) -- 일반적인 공통
			)
	ORDER BY 
		CASE 
			WHEN TEAM.TEAM_CODE = @TEAM_CODE THEN 1
		ELSE TEAM.ORDER_SEQ END
END
GO
