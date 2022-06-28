USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_EMPLOYEE_AUTH_INSERT
■ DESCRIPTION				: BTMS 직원 권한 등록
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@EMP_SEQ_LIST			: 사원 번호 (1,2,3)
	@MENU_SEQ_LIST			: 메뉴 코드 (1,2,3)
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	DECLARE @TOTAL INT
	EXEC DBO.XP_COM_EMPLOYEE_AUTH_INSERT 1, '1,2,3', '2,3,6,8,9'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-26		김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_EMPLOYEE_AUTH_INSERT]
	@AGT_CODE		VARCHAR(10),
	@EMP_SEQ_LIST	VARCHAR(1000),
	@MENU_SEQ_LIST	VARCHAR(1000),
	@NEW_SEQ		INT
AS 
BEGIN

	-- 기존권한 삭제
	DELETE FROM COM_AUTH_MENU WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ IN (SELECT DATA FROM FN_SPLIT(@EMP_SEQ_LIST, ','))

	-- 신규권한 등록
	INSERT INTO COM_AUTH_MENU (AGT_CODE, EMP_SEQ, MENU_SEQ)
	SELECT @AGT_CODE, A.Data, B.Data
	FROM FN_SPLIT(@EMP_SEQ_LIST, ',') A
	CROSS JOIN FN_SPLIT(@MENU_SEQ_LIST, ',') B

	-- 로그 저장
	INSERT INTO COM_AUTH_MENU_HISTORY (AGT_CODE, EMP_SEQ_LIST, MENU_SEQ_LIST, NEW_DATE, NEW_SEQ)
	VALUES (@AGT_CODE, @EMP_SEQ_LIST, @MENU_SEQ_LIST, GETDATE(), @NEW_SEQ)

END 


--DROP TABLE COM_AUTH_MENU_HISTORY

--CREATE TABLE COM_AUTH_MENU_HISTORY (
--	AGT_CODE		VARCHAR(10) NOT NULL,
--	EMP_SEQ_LIST	VARCHAR(1000),
--	MENU_SEQ_LIST	VARCHAR(1000),
--	NEW_DATE		DATETIME,
--	NEW_SEQ			INT
--)
GO
