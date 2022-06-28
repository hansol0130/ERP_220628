USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_MASTER_SELECT
■ DESCRIPTION				: BTMS 거래처 기본정보 검색
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
■ OUTPUT PARAMETER			: 
■ EXEC						: XP_COM_MASTER_SELECT '92756'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-18		김성호			최초생성
   2016-04-07		박형만			컬럼추가,회사별담당자정보추가
   2016-07-27		박형만			SALE_RATE 추가 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_MASTER_SELECT]
	@AGT_CODE		VARCHAR(10)
AS 
BEGIN

	-- 회사기본정보
	SELECT A.KOR_NAME AS [AGT_NAME], A.CEO_NAME, A.AGT_REGISTER, B.COMPANY_NUMBER, A.ZIP_CODE, A.ADDRESS1, A.ADDRESS2
		, A.AGT_CONDITION, A.AGT_ITEM
		, A.NOR_TEL1, A.NOR_TEL2, A.NOR_TEL3, A.FAX_TEL1, A.FAX_TEL2, A.FAX_TEL3, A.AGT_MGR_NAME, A.AGT_MGR_EMAIL
		, A.AGT_MGR_TEL1, A.AGT_MGR_TEL2, A.AGT_MGR_TEL3, A.AGT_MGR_HAND1, A.AGT_MGR_HAND2, A.AGT_MGR_HAND3, A.URL
		, A.PAY_LATER_YN
		, B.CON_START_DATE, B.CON_END_DATE, B.EDT_SEQ, B.EDT_DATE , B.SALE_RATE 
		, C.KOR_NAME AS [EDT_NAME], D.TEAM_NAME, E.POS_NAME  
	FROM AGT_MASTER A WITH(NOLOCK)
	LEFT JOIN COM_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
	LEFT JOIN COM_EMPLOYEE C WITH(NOLOCK) ON B.AGT_CODE = C.AGT_CODE AND B.EDT_SEQ = C.EMP_SEQ
	LEFT JOIN COM_TEAM D WITH(NOLOCK) ON C.AGT_CODE = D.AGT_CODE AND C.TEAM_SEQ = D.TEAM_SEQ
	LEFT JOIN COM_POSITION E WITH(NOLOCK) ON C.AGT_CODE = E.AGT_CODE AND C.POS_SEQ = E.POS_SEQ
	WHERE A.AGT_CODE = @AGT_CODE

	-- 회사파일정보
	SELECT A.AGT_CODE, A.FILE_SEQ, A.FILE_NAME
	FROM COM_FILE A WITH(NOLOCK)
	WHERE A.AGT_CODE = @AGT_CODE

	-- 회사담당자 정보
	SELECT A.AGT_CODE, A.MANAGER_TYPE ,A.EMP_CODE  , ( SELECT KOR_NAME FROM EMP_MASTER WHERE EMP_CODE = A.EMP_CODE )  AS EMP_NAME
	FROM COM_MANAGER A WITH(NOLOCK)
	WHERE A.AGT_CODE = @AGT_CODE


END 

GO
