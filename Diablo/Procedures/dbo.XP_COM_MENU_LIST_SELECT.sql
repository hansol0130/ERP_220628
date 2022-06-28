USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_MENU_LIST_SELECT
■ DESCRIPTION				: BTMS 메뉴 리스트 검색
■ INPUT PARAMETER			: 
	@MENU_SEQ				: 메뉴코드
	@AGT_CODE				: 거래처코드
	@EMP_SEQ				: 사원 번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	DECLARE @TOTAL INT	
	EXEC DBO.XP_COM_MENU_LIST_SELECT 0, '', 0

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-23		김성호			최초생성
   2016-02-02		김성호			레벨별 정리를 위해 정렬값 생성및 정렬 조건 변경
   2016-02-17		박형만			parentMenuName 추가( Navigation 를 위해 )
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_MENU_LIST_SELECT]
	@MENU_SEQ		INT,
	@AGT_CODE		VARCHAR(10),
	@EMP_SEQ		INT
AS 
BEGIN

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000), @INNERJOIN NVARCHAR(1000), @WHERE NVARCHAR(4000);

	SELECT @INNERJOIN = '', @WHERE = ''

	IF @MENU_SEQ > 0
	BEGIN
		SELECT @WHERE = @WHERE + ' AND A.MENU_SEQ = @MENU_SEQ'
	END

	IF LEN(@AGT_CODE) > 0 AND @EMP_SEQ > 0
	BEGIN
		SELECT @INNERJOIN = 'INNER JOIN COM_AUTH_MENU B WITH(NOLOCK) ON A.MENU_SEQ = B.MENU_SEQ'
			, @WHERE = @WHERE + ' AND B.AGT_CODE = @AGT_CODE AND B.EMP_SEQ = @EMP_SEQ'
	END

	IF LEN(@WHERE) > 0
	BEGIN
		SELECT @WHERE = 'WHERE ' + SUBSTRING(@WHERE, 5, 1000)
	END

	-- 리스트 조회
	SET @SQLSTRING = N'
	-- 수정자정보
	WITH LIST AS
	(
		SELECT TOP 1 *
		FROM COM_AUTH_MENU_HISTORY WITH(NOLOCK)
		WHERE AGT_CODE = @AGT_CODE
		ORDER BY NEW_DATE DESC
	)
	SELECT A.EMP_SEQ, A.KOR_NAME, B.TEAM_NAME, C.POS_NAME, Z.NEW_DATE
	FROM LIST Z
	INNER JOIN COM_EMPLOYEE A WITH(NOLOCK) ON Z.AGT_CODE = A.AGT_CODE AND Z.NEW_SEQ = A.EMP_SEQ
	INNER JOIN COM_TEAM B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.TEAM_SEQ = B.TEAM_SEQ
	INNER JOIN COM_POSITION C WITH(NOLOCK) ON A.AGT_CODE = C.AGT_CODE AND A.POS_SEQ = C.POS_SEQ;

	-- 메뉴 리스트
	WITH LIST AS
	(
		SELECT A.MENU_SEQ, A.MENU_NAME, A.MENU_URL, A.PARENT_MENU_SEQ, A.USE_YN, 0 AS [LEVEL]
			, CASE WHEN A.PARENT_MENU_SEQ IS NULL THEN '''' ELSE A.MENU_NAME END  AS [PARENT_MENU_NAME]
			, CONVERT(VARCHAR(100), RIGHT((''000'' + CONVERT(VARCHAR(10), A.ORDER_NUM)), 3)) AS [ORDER_STRING]
		FROM COM_MENU A WITH(NOLOCK)
		WHERE ISNULL(A.PARENT_MENU_SEQ, 0) = 0 AND A.USE_YN = ''Y''
		UNION ALL
		SELECT A.MENU_SEQ, A.MENU_NAME, A.MENU_URL, A.PARENT_MENU_SEQ, A.USE_YN, B.LEVEL + 1
			, B.MENU_NAME  
			, CONVERT(VARCHAR(100), B.ORDER_STRING + RIGHT((''000'' + CONVERT(VARCHAR(10), A.ORDER_NUM)), 3))
		FROM COM_MENU A WITH(NOLOCK)\
		INNER JOIN LIST B ON A.PARENT_MENU_SEQ = B.MENU_SEQ
		WHERE A.USE_YN = ''Y''
	)
	SELECT *
	FROM LIST A
	' + @INNERJOIN + N'
	' + @WHERE + N'
	ORDER BY A.ORDER_STRING;'

	SET @PARMDEFINITION = N'
		@MENU_SEQ INT,
		@AGT_CODE VARCHAR(10),
		@EMP_SEQ INT';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@MENU_SEQ,
		@AGT_CODE,
		@EMP_SEQ;

END 

GO
