USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_MOB_LOGIN_INFO_INSERT
■ DESCRIPTION				: BTMS 모바일 자동로그인 회원정보 입력
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec  XP_MOB_CUS_LOGIN_INFO_INSERT  '234234234234', '15'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-06-30		정지용			최초생성
   2021-09-02		김성호			1년이전 기록은 삭제
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_MOB_LOGIN_INFO_INSERT]
	@TOKEN VARCHAR(20),
	@AGT_CODE VARCHAR(20),
	@EMP_SEQ INT
AS
BEGIN
	
	DELETE COM_MOB_LOGIN_INFO WHERE TOKEN = @TOKEN
	DELETE FROM COM_MOB_LOGIN_INFO WHERE EMP_SEQ = @EMP_SEQ AND EDT_DATE < DATEADD(YY, -1, GETDATE()) 

	-- 로그인 된 유저의 정보를 토큰을 받아서 자동로그인 테이블에 담는다. 
	INSERT INTO COM_MOB_LOGIN_INFO (TOKEN, AGT_CODE, EMP_SEQ) VALUES(@TOKEN, @AGT_CODE, @EMP_SEQ)
END




GO
