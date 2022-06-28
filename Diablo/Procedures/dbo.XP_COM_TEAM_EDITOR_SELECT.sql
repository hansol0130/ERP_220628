USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_TEAM_EDITOR_SELECT
■ DESCRIPTION				: BTMS 조직 최종 수정자 검색
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_COM_TEAM_LIST_SELECT 92756

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-22		김성호			최초생성
   2016-04-15		이유라			ERP일괄업데이트 수정자 빈값처리 (INNER JOIN -> LEFT JOIN 으로 변경)
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_TEAM_EDITOR_SELECT]
	@AGT_CODE		VARCHAR(10)
AS 
BEGIN

	-- 수정자정보
	WITH LIST AS
	(
		SELECT TOP 1 AGT_CODE, ISNULL(EDT_SEQ, NEW_SEQ) AS [NEW_SEQ], ISNULL(EDT_DATE, NEW_DATE) AS [NEW_DATE]
		FROM COM_TEAM WITH(NOLOCK)
		WHERE AGT_CODE = @AGT_CODE
		ORDER BY ISNULL(EDT_DATE, NEW_DATE) DESC
	)
	SELECT A.EMP_SEQ, A.KOR_NAME, B.TEAM_NAME, C.POS_NAME, Z.NEW_DATE
	FROM LIST Z
	LEFT JOIN COM_EMPLOYEE A WITH(NOLOCK) ON Z.AGT_CODE = A.AGT_CODE AND Z.NEW_SEQ = A.EMP_SEQ
	LEFT JOIN COM_TEAM B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.TEAM_SEQ = B.TEAM_SEQ
	LEFT JOIN COM_POSITION C WITH(NOLOCK) ON A.AGT_CODE = C.AGT_CODE AND A.POS_SEQ = C.POS_SEQ;

END 

GO
