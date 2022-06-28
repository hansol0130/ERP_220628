USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_AUTH_TEAM_EMP_SELECT
■ DESCRIPTION				: 해당 팀 사원목록 조회
■ INPUT PARAMETER			: 
	@TEAM_CODE				: 팀코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_AUTH_TEAM_EMP_SELECT '538'

	EMP_CODE EMP_NAME
-------- --------------------
2010001  최현아
2010003  권병철
2010006  홍경은
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-11		홍영택			최초생성
   2015-02-05		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_AUTH_TEAM_EMP_SELECT]
--DECLARE
	@TEAM_CODE	VARCHAR(20)

--SET @TEAM_CODE = '100'

AS

  IF @TEAM_CODE IS NULL OR @TEAM_CODE = ''
		SET @TEAM_CODE = ' ';
    
BEGIN
  SELECT
    EMP.EMP_CODE,
    EMP.KOR_NAME AS EMP_NAME
    FROM Diablo.dbo.EMP_MASTER EMP
  WHERE WORK_TYPE = '1'
  AND EMP.TEAM_CODE = @TEAM_CODE
  ORDER BY EMP_CODE
END
GO
