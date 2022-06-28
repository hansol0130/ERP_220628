USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_AGT_MASTER_LIST_SELECT
■ DESCRIPTION				: 대외업무시스템 이용 거래처 리스트 검색
■ INPUT PARAMETER			: 
	@@COM_TYPE	INT			: 거래처 타입
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_AGT_MASTER_LIST_SELECT 0, ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-02-26		김성호			최초생성
   2014-01-14		김성호			SYS_YN 삭제
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_AGT_MASTER_LIST_SELECT]
(
	@AGT_TYPE	INT,
	@AGT_NAME	VARCHAR(100)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @SQLSTRING NVARCHAR(1000), @WHERE NVARCHAR(100), @PARMDEFINITION NVARCHAR(1000);

	IF @AGT_TYPE = 0
		SET @WHERE = ''
	ELSE
		SET @WHERE = ' AND AGT_TYPE_CODE = @AGT_TYPE'

	IF ISNULL(@AGT_NAME, '') <> ''
		SET @WHERE = + @WHERE + ' AND KOR_NAME LIKE ''%'' + @AGT_NAME + ''%'''

	IF LEN(@AGT_NAME) > 5
		SELECT @WHERE = ('WHERE ' + SUBSTRING(@WHERE, 5, 100))

	SET @SQLSTRING = '
	SELECT A.AGT_CODE, A.KOR_NAME, A.AGT_NAME, A.AGT_TYPE_CODE 
	FROM AGT_MASTER A WITH(NOLOCK) ' + @WHERE + ' 
	WHERE AGT_CODE IN (SELECT AGT_CODE FROM AGT_MEMBER WITH(NOLOCK) WHERE WORK_TYPE = 1 GROUP BY AGT_CODE)
	ORDER BY A.KOR_NAME'

	SET @PARMDEFINITION = N'@AGT_TYPE  INT, @AGT_NAME VARCHAR(100)';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @AGT_TYPE, @AGT_NAME;

END


GO
