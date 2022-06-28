USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BTMS_MANAGER_LIST_SELECT
■ DESCRIPTION				: BTMS 법인 담당자 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE					AUTHOR				DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-05-18		저스트고이유라			최초 생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BTMS_MANAGER_LIST_SELECT]
	@TEAM_CODE		VARCHAR(50)
AS 
BEGIN

	SELECT EMP_CODE, KOR_NAME
	FROM EMP_MASTER 
	WHERE TEAM_CODE = @TEAM_CODE AND WORK_TYPE = '1'
	ORDER BY KOR_NAME
END

GO
