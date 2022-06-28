USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_EMPLOYEE_SELECT
■ DESCRIPTION				: BTMS 출장자 그룹 적용 직원 검색
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@BT_SEQ					: 출장그룹 순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_COM_BIZTRIP_EMPLOYEE_SELECT 92756, 1

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-30		김성호			최초생성
   2016-02-19		정지용			수정자 정보 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_EMPLOYEE_SELECT]
	@AGT_CODE		VARCHAR(10),
	@BT_SEQ			INT
AS 
BEGIN

	WITH AGT_EMP_LIST AS
	(
		SELECT 
			A.AGT_CODE, A.EMP_SEQ, A.KOR_NAME, B.TEAM_NAME, C.POS_NAME
		FROM COM_EMPLOYEE A WITH(NOLOCK)
		LEFT JOIN COM_TEAM B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.TEAM_SEQ = B.TEAM_SEQ
		LEFT JOIN COM_POSITION C WITH(NOLOCK) ON A.AGT_CODE = C.AGT_CODE AND A.POS_SEQ = C.POS_SEQ
		WHERE A.AGT_CODE = @AGT_CODE
	)
	SELECT 
		A.AGT_CODE, A.BT_SEQ, A.ALL_YN, A.USE_YN, 
		B.TEAM_NAME, B.POS_NAME, ISNULL(A.EDT_DATE, A.NEW_DATE) AS [EDT_DATE], ISNULL(A.EDT_SEQ, A.NEW_SEQ) AS [EDT_SEQ], B.KOR_NAME AS [EDT_NAME]
	FROM COM_BIZTRIP_GROUP A WITH(NOLOCK)
	LEFT JOIN AGT_EMP_LIST B ON A.AGT_CODE = B.AGT_CODE AND ISNULL(A.EDT_SEQ, A.NEW_SEQ) = B.EMP_SEQ	
	WHERE A.AGT_CODE = @AGT_CODE AND A.BT_SEQ = @BT_SEQ;

	WITH LIST AS
	(
		SELECT A.*
		FROM COM_BIZTRIP_EMPLOYEE A WITH(NOLOCK)
		WHERE A.AGT_CODE = @AGT_CODE AND A.BT_SEQ = @BT_SEQ
	)
	SELECT A.AGT_CODE, A.BT_SEQ, A.BTE_SEQ, A.BT_EMP_TYPE, A.BT_EMP_SEQ, B.KOR_NAME
	FROM LIST A
	INNER JOIN COM_EMPLOYEE B ON A.AGT_CODE = B.AGT_CODE AND A.BT_EMP_SEQ = B.EMP_SEQ
	WHERE A.BT_EMP_TYPE = 'E'
	UNION ALL
	SELECT A.AGT_CODE, A.BT_SEQ, A.BTE_SEQ, A.BT_EMP_TYPE, A.BT_EMP_SEQ, B.TEAM_NAME
	FROM LIST A
	INNER JOIN COM_TEAM B ON A.AGT_CODE = B.AGT_CODE AND A.BT_EMP_SEQ = B.TEAM_SEQ
	WHERE A.BT_EMP_TYPE = 'T'
	UNION ALL
	SELECT A.AGT_CODE, A.BT_SEQ, A.BTE_SEQ, A.BT_EMP_TYPE, A.BT_EMP_SEQ, B.POS_NAME
	FROM LIST A
	INNER JOIN COM_POSITION B ON A.AGT_CODE = B.AGT_CODE AND A.BT_EMP_SEQ = B.POS_SEQ
	WHERE A.BT_EMP_TYPE = 'P'

END

GO
