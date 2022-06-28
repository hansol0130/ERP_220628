USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PRI_NOTE_SELECT
■ DESCRIPTION				: 대외업무시스템 사내메일 검색
■ INPUT PARAMETER			: 
	@NOTE_SEQ_NO	INT		: 사내메일 순번
	@RCV_SEQ_NO		INT		: 수신자 순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_PRI_NOTE_SELECT 591880, 0

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-02-20		김성호			최초생성
   2021-06-16		오준혁			튜닝
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_PRI_NOTE_SELECT]
(
	@NOTE_SEQ_NO	INT,
	@RCV_SEQ_NO		INT
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--SELECT A.*
	--	, DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS [NEW_NAME]
	--	, DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS [NEW_TEAM_NAME]
	--	, DBO.XN_COM_GET_COM_TYPE(A.NEW_CODE) AS [NEW_COM_TYPE]
	--FROM PRI_NOTE A
	--WHERE A.NOTE_SEQ_NO = @NOTE_SEQ_NO;

	---- 첨부 파일 목록
	--SELECT * FROM PRI_NOTE_ATTACH A
	--WHERE A.NOTE_SEQ_NO = @NOTE_SEQ_NO;

	---- 수신자, 참조자 목록
	--SELECT *
	--	, DBO.XN_COM_GET_EMP_NAME(A.EMP_CODE) AS [EMP_NAME]
	--	, DBO.XN_COM_GET_COM_TYPE(A.EMP_CODE) AS [EMP_COM_TYPE]
	--FROM PRI_NOTE_RECEIPT A
	--WHERE A.NOTE_SEQ_NO = @NOTE_SEQ_NO;

	---- 이전/다음 글
	--IF @RCV_SEQ_NO = 0
	--BEGIN
	--	WITH LIST AS
	--	(
	--		SELECT TOP 1 A.NOTE_SEQ_NO
	--		FROM PRI_NOTE A
	--		WHERE A.NOTE_SEQ_NO > @NOTE_SEQ_NO AND A.DEL_YN = 'N'
	--			AND NEW_CODE IN (SELECT NEW_CODE FROM PRI_NOTE AA WHERE AA.NOTE_SEQ_NO = @NOTE_SEQ_NO)
	--		ORDER BY A.NOTE_SEQ_NO ASC
	--	)
	--	SELECT A.NOTE_SEQ_NO, 0 AS [RCV_SEQ_NO], '' AS [RCV_TYPE], 'N' AS [CONFIRM_YN], A.SUBJECT, A.NEW_CODE
	--		, (CASE WHEN EXISTS(SELECT 1 FROM PRI_NOTE_ATTACH AA WHERE AA.NOTE_SEQ_NO = A.NOTE_SEQ_NO) THEN 'Y' ELSE 'N' END) AS [ATTACH_YN]
	--	FROM LIST Z
	--	INNER JOIN PRI_NOTE A ON A.NOTE_SEQ_NO = Z.NOTE_SEQ_NO;

	--	WITH LIST AS
	--	(
	--		SELECT TOP 1 A.NOTE_SEQ_NO
	--		FROM PRI_NOTE A
	--		WHERE A.NOTE_SEQ_NO < @NOTE_SEQ_NO AND A.DEL_YN = 'N'
	--			AND NEW_CODE IN (SELECT NEW_CODE FROM PRI_NOTE AA WHERE AA.NOTE_SEQ_NO = @NOTE_SEQ_NO)
	--		ORDER BY A.NOTE_SEQ_NO DESC
	--	)
	--	SELECT A.NOTE_SEQ_NO, 0 AS [RCV_SEQ_NO], '' AS [RCV_TYPE], 'N' AS [CONFIRM_YN], A.SUBJECT, A.NEW_CODE
	--		, (CASE WHEN EXISTS(SELECT 1 FROM PRI_NOTE_ATTACH AA WHERE AA.NOTE_SEQ_NO = A.NOTE_SEQ_NO) THEN 'Y' ELSE 'N' END) AS [ATTACH_YN]
	--	FROM LIST Z
	--	INNER JOIN PRI_NOTE A ON A.NOTE_SEQ_NO = Z.NOTE_SEQ_NO;
	--END
	--ELSE
	--BEGIN
	--	WITH LIST AS
	--	(
	--		SELECT TOP 1 NOTE_SEQ_NO, RCV_SEQ_NO FROM PRI_NOTE_RECEIPT A
	--		WHERE NOTE_SEQ_NO > @NOTE_SEQ_NO AND RCV_DEL_YN = 'N'
	--			AND EMP_CODE IN (
	--				SELECT EMP_CODE FROM PRI_NOTE_RECEIPT AA WHERE AA.NOTE_SEQ_NO = @NOTE_SEQ_NO AND AA.RCV_SEQ_NO = @RCV_SEQ_NO
	--			)
	--		ORDER BY A.NOTE_SEQ_NO ASC
	--	)
	--	SELECT A.NOTE_SEQ_NO, B.RCV_SEQ_NO, B.RCV_TYPE, B.CONFIRM_YN, A.SUBJECT, A.NEW_CODE
	--		, (CASE WHEN EXISTS(SELECT 1 FROM PRI_NOTE_ATTACH AA WHERE AA.NOTE_SEQ_NO = A.NOTE_SEQ_NO) THEN 'Y' ELSE 'N' END) AS [ATTACH_YN]
	--	FROM LIST Z
	--	INNER JOIN PRI_NOTE A ON A.NOTE_SEQ_NO = Z.NOTE_SEQ_NO
	--	INNER JOIN PRI_NOTE_RECEIPT B ON B.NOTE_SEQ_NO = Z.NOTE_SEQ_NO AND B.RCV_SEQ_NO = Z.RCV_SEQ_NO;

	--	WITH LIST AS
	--	(
	--		SELECT TOP 1 NOTE_SEQ_NO, RCV_SEQ_NO FROM PRI_NOTE_RECEIPT A
	--		WHERE NOTE_SEQ_NO < @NOTE_SEQ_NO AND RCV_DEL_YN = 'N'
	--			AND EMP_CODE IN (
	--				SELECT EMP_CODE FROM PRI_NOTE_RECEIPT AA WHERE AA.NOTE_SEQ_NO = @NOTE_SEQ_NO AND AA.RCV_SEQ_NO = @RCV_SEQ_NO
	--			)
	--		ORDER BY A.NOTE_SEQ_NO DESC
	--	)
	--	SELECT A.NOTE_SEQ_NO, B.RCV_SEQ_NO, B.RCV_TYPE, B.CONFIRM_YN, A.SUBJECT, A.NEW_CODE
	--		, (CASE WHEN EXISTS(SELECT 1 FROM PRI_NOTE_ATTACH AA WHERE AA.NOTE_SEQ_NO = A.NOTE_SEQ_NO) THEN 'Y' ELSE 'N' END) AS [ATTACH_YN]
	--	FROM LIST Z
	--	INNER JOIN PRI_NOTE A ON A.NOTE_SEQ_NO = Z.NOTE_SEQ_NO
	--	INNER JOIN PRI_NOTE_RECEIPT B ON B.NOTE_SEQ_NO = Z.NOTE_SEQ_NO AND B.RCV_SEQ_NO = Z.RCV_SEQ_NO;
	--END


	SELECT A.NOTE_SEQ_NO, A.RCV_SEQ_NO, A.RCV_TYPE, A.CONFIRM_YN, A.CONFIRM_DATE, B.SUBJECT, B.CONTENTS
		, B.NEW_DATE, B.NEW_CODE
		, DBO.XN_COM_GET_EMP_NAME(B.NEW_CODE) AS [NEW_NAME]
		, DBO.XN_COM_GET_TEAM_NAME(B.NEW_CODE) AS [NEW_TEAM_NAME]
		, DBO.XN_COM_GET_COM_TYPE(B.NEW_CODE) AS [NEW_COM_TYPE]
		, A.EMP_CODE
		, DBO.XN_COM_GET_EMP_NAME(A.EMP_CODE) AS [EMP_NAME]
		--, DBO.XN_COM_GET_TEAM_NAME(B.EMP_CODE) AS [EMP_TEAM_NAME]
		, A.TEAM_NAME AS [EMP_TEAM_NAME]
		, DBO.XN_COM_GET_COM_TYPE(A.EMP_CODE) AS [EMP_COM_TYPE]
		, (CASE WHEN EXISTS(SELECT 1 FROM PRI_NOTE_ATTACH AA WITH(NOLOCK) WHERE AA.NOTE_SEQ_NO = A.NOTE_SEQ_NO) THEN 'Y' ELSE 'N' END) AS [ATTACH_YN]
	FROM PRI_NOTE_RECEIPT A WITH(NOLOCK)
	INNER LOOP JOIN PRI_NOTE B WITH(NOLOCK) ON A.NOTE_SEQ_NO = B.NOTE_SEQ_NO
	WHERE A.NOTE_SEQ_NO = @NOTE_SEQ_NO AND A.RCV_SEQ_NO = @RCV_SEQ_NO

	-- 첨부 파일 목록
	SELECT * FROM PRI_NOTE_ATTACH A WITH(NOLOCK)
	WHERE A.NOTE_SEQ_NO = @NOTE_SEQ_NO

	-- 수신자, 참조자 목록
	SELECT *
		, DBO.XN_COM_GET_EMP_NAME(A.EMP_CODE) AS [EMP_NAME]
		, DBO.XN_COM_GET_COM_TYPE(A.EMP_CODE) AS [EMP_COM_TYPE]
	FROM PRI_NOTE_RECEIPT A WITH(NOLOCK)
	WHERE A.NOTE_SEQ_NO = @NOTE_SEQ_NO

	-- 이전 글
	SELECT TOP 1 A.NOTE_SEQ_NO, A.RCV_SEQ_NO, A.RCV_TYPE, A.CONFIRM_YN, B.SUBJECT, B.NEW_CODE
		, (CASE WHEN EXISTS(SELECT 1 FROM PRI_NOTE_ATTACH AA WITH(NOLOCK) WHERE AA.NOTE_SEQ_NO = A.NOTE_SEQ_NO) THEN 'Y' ELSE 'N' END) AS [ATTACH_YN]
	FROM PRI_NOTE_RECEIPT A WITH(NOLOCK)
	INNER LOOP JOIN PRI_NOTE B WITH(NOLOCK) ON A.NOTE_SEQ_NO = B.NOTE_SEQ_NO
	WHERE A.NOTE_SEQ_NO > @NOTE_SEQ_NO AND A.EMP_CODE IN (
		SELECT EMP_CODE FROM PRI_NOTE_RECEIPT AA WITH(NOLOCK) WHERE AA.NOTE_SEQ_NO = @NOTE_SEQ_NO AND AA.RCV_SEQ_NO = @RCV_SEQ_NO
	)
	ORDER BY A.NOTE_SEQ_NO ASC
	
	-- 다음 글
	SELECT TOP 1 A.NOTE_SEQ_NO, A.RCV_SEQ_NO, A.RCV_TYPE, A.CONFIRM_YN, B.SUBJECT, B.NEW_CODE
		, (CASE WHEN EXISTS(SELECT 1 FROM PRI_NOTE_ATTACH AA WITH(NOLOCK) WHERE AA.NOTE_SEQ_NO = A.NOTE_SEQ_NO) THEN 'Y' ELSE 'N' END) AS [ATTACH_YN]
	FROM PRI_NOTE_RECEIPT A WITH(NOLOCK)
	INNER LOOP JOIN PRI_NOTE B WITH(NOLOCK) ON A.NOTE_SEQ_NO = B.NOTE_SEQ_NO
	WHERE A.NOTE_SEQ_NO < @NOTE_SEQ_NO AND EMP_CODE IN (
		SELECT EMP_CODE FROM PRI_NOTE_RECEIPT AA WITH(NOLOCK) WHERE AA.NOTE_SEQ_NO = @NOTE_SEQ_NO AND AA.RCV_SEQ_NO = @RCV_SEQ_NO
	)
	ORDER BY A.NOTE_SEQ_NO DESC

END


GO
