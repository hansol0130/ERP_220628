USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_MOB_CUS_LOGIN_INFO_SELECT
■ DESCRIPTION				: 모바일 자동로그인 회원정보 조회
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec  XP_MOB_CUS_LOGIN_INFO_SELECT  '234234234234'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-11-04		이동호			최초생성			
   2016-08-05		박형만			CUS_CUSTOMER -> DAMO 로 변경 
   2021-09-02		김성호			조회 테이블 변경 (CUS_CUSTOMER -> VIEW_MEMBER)
================================================================================================================*/ 
CREATE PROC [dbo].[XP_MOB_CUS_LOGIN_INFO_SELECT]
	@TOKEN VARCHAR(20)
AS
BEGIN
	DECLARE @CUS_NO INT
	
	-- 토큰 값을 비교후 CUS_NO 값을 가지고 온다.
	SELECT TOP 1 @CUS_NO = CUS_NO  FROM CUS_LOGIN_INFO WITH(NOLOCK) WHERE TOKEN = @TOKEN  
	
	-- 회원 정보 테이블에서 정보를 가지고 온다.
	SELECT TOP  1 
		CUS_NO, CUS_ID, CUS_NAME, NICKNAME, LAST_NAME, FIRST_NAME, EMAIL, GENDER,
		NOR_TEL1, NOR_TEL2, NOR_TEL3, ADDRESS1, ADDRESS2, ZIP_CODE, BIRTH_DATE
	FROM VIEW_MEMBER WHERE CUS_NO = @CUS_NO

	-- 한번 사용한 토큰값은 Y 로 업데이트 한다.
	UPDATE CUS_LOGIN_INFO SET ISVALID = 'Y' , EDT_DATE = GETDATE()  WHERE TOKEN = @TOKEN

END
GO
