USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_TEAM_SUB_LIST_USEYN_UPDATE
■ DESCRIPTION				: BTMS 하위부서 리스트 사용유무 업데이트
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@TEAM_SEQ				: 부서코드
■ EXEC						: 
	EXEC DBO.XP_COM_TEAM_SUB_LIST_SELECT '92756', 2, 'Y'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-17		JUSTGO백경훈			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_TEAM_SUB_LIST_USEYN_UPDATE]
	@AGT_CODE		VARCHAR(10),
	@TEAM_SEQ		INT,
	@USE_YN			VARCHAR(1)
AS 

WITH LIST AS
(
	SELECT A.AGT_CODE, A.TEAM_SEQ, A.USE_YN
	FROM COM_TEAM A WITH(NOLOCK)
	WHERE A.AGT_CODE = @AGT_CODE AND A.TEAM_SEQ = @TEAM_SEQ
	UNION ALL
	SELECT A.AGT_CODE, A.TEAM_SEQ, A.USE_YN
	FROM COM_TEAM A WITH(NOLOCK)
	INNER JOIN LIST B ON A.PARENT_TEAM_SEQ = B.TEAM_SEQ
)
UPDATE C SET C.USE_YN =@USE_YN
FROM COM_TEAM C
INNER JOIN LIST A
on C.AGT_CODE = A.AGT_CODE
AND C.TEAM_SEQ = A.TEAM_SEQ
AND C.AGT_CODE = @AGT_CODE

GO
