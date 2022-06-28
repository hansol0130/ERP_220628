USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_PKG_MASTER_KEYWORD_LIST_SELECT
■ DESCRIPTION				: 마스터 상품 키워드 검색
■ INPUT PARAMETER			: 
	@KEY	NVARCHAR(100)	: 검색 키
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_WEB_PKG_MASTER_KEYWORD_LIST_SELECT ''	

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-11-21		이동호			신규 추가
   2013-11-21		김성호			부분 수정
   2014-08-05		정지용			대량 구분자 자르기 속도 저하로 인해 FN_XML_SPLIT 함수생성 및 변경
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_WEB_PKG_MASTER_KEYWORD_LIST_SELECT]
(
	@KEY		NVARCHAR(100)
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(1000), @PARMDEFINITION NVARCHAR(200), @WHERE NVARCHAR(100);
	/*
	IF ISNULL(@KEY, '') <> ''
	BEGIN
		SET @WHERE = N' CONTAINS(A.KEYWORD, @KEY) AND'
	END
	ELSE
	BEGIN
		SET @WHERE = ''
	END
	*/
	IF @KEY IS NULL
		BEGIN
			SET @KEY = ''
		END 

	IF @KEY <> ''
	BEGIN
		SET @WHERE = N' CONTAINS(A.KEYWORD, @KEY) AND'
	END
	ELSE
	BEGIN
		SET @WHERE = ''
	END

	SET @SQLSTRING = N'
	SELECT Data AS KEYWORD FROM DBO.FN_XML_SPLIT((
		SELECT ('','' + KEYWORD) AS [text()] FROM PKG_MASTER A WITH(NOLOCK) WHERE' + @WHERE + ' A.SHOW_YN = ''Y'' FOR XML PATH('''')
	), '','')
	WHERE Data LIKE ''%'' + @KEY + ''%''
	GROUP BY Data'

	SET @PARMDEFINITION = N'
		@KEY NVARCHAR(100)';

	--PRINT @SQLSTRING  

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@KEY;

END
GO
