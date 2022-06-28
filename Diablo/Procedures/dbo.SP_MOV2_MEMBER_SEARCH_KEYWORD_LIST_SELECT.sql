USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_MEMBER_SEARCH_KEYWORD_LIST_SELECT
■ DESCRIPTION				: 고객 저장 키워드 조회.
■ INPUT PARAMETER			: 
	@CUSTOMER_NO			: 고객 번호
	@TOP_COUNT				: 리턴 결과 갯수
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC SP_MOV2_MEMBER_SEARCH_KEYWORD_LIST_SELECT 15, 10

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2017.10.17		김성호			키워드테이블 변경
================================================================================================================*/ 
CREATE PROC [dbo].[SP_MOV2_MEMBER_SEARCH_KEYWORD_LIST_SELECT]
	@CUSTOMER_NO INT,
	@TOP_COUNT INT = 5
AS 
BEGIN

	DECLARE @SQLSTRING NVARCHAR(1000), @PARMDEFINITION NVARCHAR(100);

	SELECT
		@SQLSTRING = N'
		SELECT TOP (@TOP_COUNT) A.SEQ_NO AS KEYWORD_NO, A.KEYWORD, A.NEW_DATE
		FROM VGLOG.DBO.KEYWORD_LOG A WITH(NOLOCK)
		WHERE A.CUS_NO = @CUSTOMER_NO
		ORDER BY A.NEW_DATE DESC',
		@PARMDEFINITION = N'@TOP_COUNT INT, @CUSTOMER_NO INT';

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @TOP_COUNT, @CUSTOMER_NO;

	--SELECT TOP 5 KEYWORD_NO,KEYWORD,NEW_DATE 
	--FROM LATEST_KEYWORD WITH (NOLOCK) 
	--WHERE CUS_NO = @CUSTOMER_NO
	--  AND NEW_DATE <> '1900-01-01'	
	--ORDER BY NEW_DATE DESC

END


GO
