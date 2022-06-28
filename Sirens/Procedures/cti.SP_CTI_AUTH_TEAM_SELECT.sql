USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_AUTH_TEAM_SELECT
■ DESCRIPTION				: 팀목록 조회
■ INPUT PARAMETER			: 
	@TEAM_CODE				: 소속 팀코드 처음row위치 하기위해 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_AUTH_TEAM_SELECT '538'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-11		홍영택			최초생성
   2015-02-05		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_AUTH_TEAM_SELECT]
--DECLARE
	@TEAM_CODE	VARCHAR(20)

--SET @TEAM_CODE = '100'

AS

BEGIN
  SELECT
  TEAM.TEAM_CODE,
  TEAM.TEAM_NAME
  FROM Diablo.dbo.EMP_TEAM TEAM
  WHERE TEAM.USE_YN = 'Y'
  AND TEAM.VIEW_YN = 'Y'
  -- AND TEAM.TEAM_TYPE IN ('1','2')
  -- AND TEAM.TEAM_CODE > 500
  ORDER BY CASE WHEN TEAM.TEAM_CODE = @TEAM_CODE THEN 1 ELSE TEAM.ORDER_SEQ END
END
GO
