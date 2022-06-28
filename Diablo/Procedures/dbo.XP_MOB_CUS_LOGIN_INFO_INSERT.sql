USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_MOB_CUS_LOGIN_INFO_INSERT
■ DESCRIPTION				: 모바일 자동로그인 회원정보 입력
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
   2013-11-04		이동호			최초생성
   2021-09-02		김성호			1년이전 기록 삭제
================================================================================================================*/ 
CREATE PROC [dbo].[XP_MOB_CUS_LOGIN_INFO_INSERT]
	@TOKEN VARCHAR(20),
	@CUS_NO INT
AS
BEGIN
	-- 이전기록 삭제
	DELETE CUS_LOGIN_INFO WHERE TOKEN = @TOKEN
	DELETE FROM CUS_LOGIN_INFO WHERE CUS_NO = @CUS_NO AND EDT_DATE < DATEADD(YY, -1, GETDATE())

	-- 로그인 된 유저의 정보를 토큰을 받아서 자동로그인 테이블에 담는다. 
	INSERT INTO CUS_LOGIN_INFO (TOKEN, CUS_NO) VALUES(@TOKEN, @CUS_NO)
END



GO
