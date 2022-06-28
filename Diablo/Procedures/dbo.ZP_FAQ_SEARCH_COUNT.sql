USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_FAQ_SEARCH_COUNT
■ DESCRIPTION				: 검색어를 포함한 FAQ 개수 검색
■ INPUT PARAMETER			: 
	@SUBJECT				: 검색어
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec ZP_FAQ_SEARCH_COUNT "호텔"

	SELECT ROW_NUMBER() OVER(ORDER BY NEW_DATE ) AS NUM FROM HBS_DETAIL
	WHERE MASTER_SEQ ='6' AND  SUBJECT LIKE @SUBJECT='호텔' AND DEL_YN='N' ORDER BY NEW_DATE DESC

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-08-29		지니웍스		최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[ZP_FAQ_SEARCH_COUNT]
(
	@SUBJECT	NVARCHAR(200)
)

AS  
BEGIN
	SELECT ROW_NUMBER() OVER(ORDER BY NEW_DATE ) AS NUM 
	FROM HBS_DETAIL
	WHERE MASTER_SEQ ='6' AND  SUBJECT LIKE @SUBJECT AND DEL_YN='N' 
	ORDER BY NEW_DATE DESC 
	

END

GO
