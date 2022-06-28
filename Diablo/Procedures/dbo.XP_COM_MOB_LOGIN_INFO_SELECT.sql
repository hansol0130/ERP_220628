USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_MOB_LOGIN_INFO_SELECT
■ DESCRIPTION				: BTMS 모바일 자동로그인 회원정보 조회
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-06-30		정지용			최초생성
   2021-09-08		김성호			미사용 토큰 삭제 제거 (등록 시 체크)			
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_MOB_LOGIN_INFO_SELECT]
	@TOKEN VARCHAR(20)
AS
BEGIN
	DECLARE @AGT_CODE VARCHAR(20);
	DECLARE @EMP_SEQ INT;
	
	-- 토큰 값을 비교후 CUS_NO 값을 가지고 온다.
	SELECT TOP 1 @AGT_CODE = AGT_CODE, @EMP_SEQ = EMP_SEQ  FROM COM_MOB_LOGIN_INFO WITH(NOLOCK) WHERE TOKEN = @TOKEN AND ISVALID = 'N'
	
	-- 회원 정보 테이블에서 정보를 가지고 온다.
	SELECT A.*, B.TEAM_NAME, C.POS_NAME , D.KOR_NAME AS AGT_NAME  , E.AGT_ID 
	FROM COM_EMPLOYEE A WITH(NOLOCK)
	LEFT JOIN COM_TEAM B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.TEAM_SEQ = B.TEAM_SEQ
	LEFT JOIN COM_POSITION C WITH(NOLOCK) ON A.AGT_CODE = C.AGT_CODE AND A.POS_SEQ = C.POS_SEQ
	LEFT JOIN AGT_MASTER D WITH(NOLOCK) ON A.AGT_CODE = D.AGT_CODE
	LEFT JOIN COM_MASTER E WITH(NOLOCK) ON A.AGT_CODE = E.AGT_CODE 
	WHERE A.AGT_CODE = @AGT_CODE AND A.EMP_SEQ = @EMP_SEQ

	-- 한번 사용한 토큰값은 Y 로 업데이트 한다.
	UPDATE COM_MOB_LOGIN_INFO SET ISVALID = 'Y' , EDT_DATE = GETDATE()  WHERE TOKEN = @TOKEN;

	-- 한달정도 지난 사용 안하는 토큰값은 삭제 합니다.
	--DELETE COM_MOB_LOGIN_INFO WHERE EDT_DATE < CONVERT(varchar(10),getdate()-31,120) AND ISVALID = 'Y' AND AGT_CODE = @AGT_CODE AND EMP_SEQ = @EMP_SEQ;

END

GO
