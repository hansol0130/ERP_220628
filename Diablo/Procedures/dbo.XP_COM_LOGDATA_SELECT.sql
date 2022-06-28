USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_LOGDATA_SELECT
■ DESCRIPTION				: BTMS 거래처 직원 로그인
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@EMP_ID					: 아이디
	@PASS_WORD				: 비밀번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-14		김성호			최초생성
   2016-02-17		김성호			최초생성
   2016-04-20		박형만			패스워드 조건 해제, BIZ 에서 비교 처리 
   2016-05-30		박형만			AGT_ID 추가 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_LOGDATA_SELECT]
	@AGT_CODE		VARCHAR(10),
	@EMP_ID			VARCHAR(20),
	@PASSWORD		VARCHAR(100)
AS 
BEGIN

	-- 로그인기록
	SELECT A.*, B.TEAM_NAME, C.POS_NAME , D.KOR_NAME AS AGT_NAME  , E.AGT_ID 
	FROM COM_EMPLOYEE A WITH(NOLOCK)
	LEFT JOIN COM_TEAM B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.TEAM_SEQ = B.TEAM_SEQ
	LEFT JOIN COM_POSITION C WITH(NOLOCK) ON A.AGT_CODE = C.AGT_CODE AND A.POS_SEQ = C.POS_SEQ
	LEFT JOIN AGT_MASTER D WITH(NOLOCK) ON A.AGT_CODE = D.AGT_CODE
	LEFT JOIN COM_MASTER E WITH(NOLOCK) ON A.AGT_CODE = E.AGT_CODE 
	WHERE A.AGT_CODE = @AGT_CODE AND A.EMP_ID = @EMP_ID AND (A.PASS_WORD = @PASSWORD OR ISNULL(@PASSWORD,'') = '')

	SELECT C.*
	FROM COM_EMPLOYEE A WITH(NOLOCK)
	INNER JOIN COM_AUTH_MENU B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.EMP_SEQ = B.EMP_SEQ
	INNER JOIN COM_MENU C WITH(NOLOCK) ON B.MENU_SEQ = C.MENU_SEQ
	WHERE A.AGT_CODE = @AGT_CODE AND A.EMP_ID = @EMP_ID  

END 
GO
