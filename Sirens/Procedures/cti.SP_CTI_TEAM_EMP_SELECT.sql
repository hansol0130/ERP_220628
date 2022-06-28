USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_TEAM_EMP_SELECT
■ DESCRIPTION				: 해당 팀 사원목록 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
	BIZ_PUBLIC -> ERP_EMP_MASTER_SELECT_LIST,
	SP_CTI_AUTH_TEAM_EMP_SELECT 오픈후 삭제
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-03-19		정지용			최초생성 - 공통쿼리로 사용하기위해 생성(기존에 같은쿼리인데 나누어져 있음)
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_TEAM_EMP_SELECT]
	 @TEAM_CODE	VARCHAR(20)
	,@WORK_TYPE INT		
AS

BEGIN

	SELECT
		EMP.EMP_CODE,
		EMP.KOR_NAME AS EMP_NAME
	FROM Diablo.dbo.EMP_MASTER EMP
	WHERE 
		EMP.TEAM_CODE = @TEAM_CODE 
		AND 
			(
				(ISNULL(@WORK_TYPE, 0) = 0) -- 권한관리에서사용
				OR (ISNULL(@WORK_TYPE, 0) <> 0 AND WORK_TYPE = @WORK_TYPE)  -- 일반적인 공통
			)
	ORDER BY 
		EMP.POS_TYPE DESC, CASE WHEN ISNULL(@WORK_TYPE, 0) <> 0 THEN EMP.INNER_NUMBER3 ELSE 1 END

END
GO
