USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_GROUP_LIST_SELECT
■ DESCRIPTION				: BTMS 출장자 그룹 규정관리
■ INPUT PARAMETER			: 
	@AGT_CODE				: 거래처코드
	@USE_YN					: 사용유무 '' 전체
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_COM_BIZTRIP_GROUP_LIST_SELECT 92756, 'N'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-01-29		김성호			최초생성
   2016-02-04		정지용			수정자명 추가
   2016-02-16		정지용			AIR_USE_YN, HOTEL_USE_YN 가져올시 BT_SEQ 조건 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_GROUP_LIST_SELECT]
	@AGT_CODE		VARCHAR(10),
	@USE_YN			CHAR(1)
AS 
BEGIN

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(1000);

	SELECT @WHERE = 'WHERE A.AGT_CODE = @AGT_CODE'

	IF LEN(@USE_YN) > 0
	BEGIN
		SELECT @WHERE = @WHERE + ' AND A.USE_YN = @USE_YN'
	END

	-- 리스트 조회
	SET @SQLSTRING = N'
	SELECT A.*
		, ISNULL((SELECT MAX(USE_YN) FROM COM_AIR_RULE AA WITH(NOLOCK) WHERE AA.AGT_CODE = @AGT_CODE AND AA.BT_SEQ = A.BT_SEQ), ''N'') AS [AIR_USE_YN]
		, ISNULL((SELECT MAX(USE_YN) FROM COM_HOTEL_RULE AA WITH(NOLOCK) WHERE AA.AGT_CODE = @AGT_CODE AND AA.BT_SEQ = A.BT_SEQ), ''N'') AS [HOTEL_USE_YN]
		, ISNULL(A.EDT_SEQ, A.NEW_SEQ) AS [EDT_SEQ], B.KOR_NAME AS [EDT_NAME]
	FROM COM_BIZTRIP_GROUP A WITH(NOLOCK)
	LEFT JOIN COM_EMPLOYEE B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND ISNULL(A.EDT_SEQ, A.NEW_SEQ) = B.EMP_SEQ
	' + @WHERE + ' ORDER BY ORDER_NUM'

	SET @PARMDEFINITION = N'
		@AGT_CODE VARCHAR(10),
		@USE_YN CHAR(1)';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@AGT_CODE,
		@USE_YN;

END

GO
