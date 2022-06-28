USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_ETBS_PKG_MASTER_KEYWORD_LIST_SELECT
■ DESCRIPTION				: 마스터 상품 키워드 검색
■ INPUT PARAMETER			: 
	@KEY	NVARCHAR(100)	: 검색 키
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec ZP_ETBS_PKG_MASTER_KEYWORD_LIST_SELECT ''	

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2021-09-08		김영민			이제너두 제휴사 국내검색 제외(AND A.SIGN_CODE <> ''K'')
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[ZP_ETBS_PKG_MASTER_KEYWORD_LIST_SELECT]
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
		SELECT ('','' + KEYWORD) AS [text()] FROM PKG_MASTER A WITH(NOLOCK) WHERE' + @WHERE + ' A.SHOW_YN = ''Y'' AND A.SIGN_CODE <> ''K'' FOR XML PATH('''')
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
