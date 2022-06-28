USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*================================================================================================================
■ USP_NAME					: SP_MOV2_BEST_KEYWORD_LIST_SELECT
■ DESCRIPTION				: 1주일간 베스트 키워드 정보 조회.
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017.11.02		ibsolution		변경된 키워드 테이블 사용
================================================================================================================*/ 
CREATE PROC [dbo].[SP_MOV2_BEST_KEYWORD_LIST_SELECT]
	@TOP_COUNT INT = 1
AS 

BEGIN

	DECLARE @SQLSTRING NVARCHAR(1000), @PARMDEFINITION NVARCHAR(100);

	SELECT
		@SQLSTRING = N'
		SELECT TOP (@TOP_COUNT) A.KEYWORD, COUNT(*) AS CNT
		FROM VGLOG.DBO.KEYWORD_LOG A WITH(NOLOCK)
		WHERE DATEDIFF ( DAY , A.NEW_DATE , GETDATE() ) <= 7 
		GROUP BY A.KEYWORD
		ORDER BY CNT DESC, A.KEYWORD',
		@PARMDEFINITION = N'@TOP_COUNT INT';

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @TOP_COUNT;

END 
GO
