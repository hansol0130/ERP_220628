USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_MOV2_MEMBER_SEARCH_KEYWORD_UPDATE_SELECT
■ DESCRIPTION				: 검색 키워드 수정후 정보 조회.
■ INPUT PARAMETER			: 
	@CUSTOMER_NO			: 고객 번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------

	2017-10-17		김성호			현재 VS 사용 정보 없음으로 사용 체크를 위한 주석 처리
================================================================================================================*/ 
CREATE PROC [dbo].[SP_MOV2_MEMBER_SEARCH_KEYWORD_UPDATE_SELECT]
	@COOKIE_KEYWORD VARCHAR(50),
	@CUSTOMER_NO INT
AS 
BEGIN

	--UPDATE LATEST_KEYWORD
	--SET KEYWORD = @COOKIE_KEYWORD
	--	,NEW_DATE = getDate()
	--WHERE CUS_NO = @CUSTOMER_NO

	--SELECT KEYWORD,NEW_DATE  
	--FROM LATEST_KEYWORD WITH (NOLOCK) 
	--WHERE CUS_NO = @CUSTOMER_NO

	SELECT 1

END 


GO
