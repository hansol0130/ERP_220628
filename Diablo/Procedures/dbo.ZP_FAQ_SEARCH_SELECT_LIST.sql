USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_FAQ_SEARCH_SELECT_LIST
■ DESCRIPTION				: 검색어를 포함한 FAQ 게시물 리스트 검색
■ INPUT PARAMETER			: 
	@SUBJECT 				: 검색어
	@BOARD_SEQ 				: 게시물 번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec ZP_FAQ_SEARCH_SELECT_LIST , "호텔","277"

	SELECT TOP 15 MASTER_SEQ, BOARD_SEQ, CATEGORY_SEQ, PARENT_SEQ, LEVEL STEP, SUBJECT, CONTENTS
	,SHOW_COUNT, NOTICE_YN, DEL_YN, COMPLETE_YN, LOCK_YN, NEW_DATE, EDT_DATE, SEARCH_PK 
	FROM HBS_DETAIL 
	WHERE MASTER_SEQ='6' AND SUBJECT LIKE @SUBJECT="호텔" AND BOARD_SEQ < @BOARD_SEQ=277 AND DEL_YN='N' 
	ORDER BY NEW_DATE DESC

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-08-29		지니웍스  		최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[ZP_FAQ_SEARCH_SELECT_LIST]
(
	@SUBJECT 		NVARCHAR(200),
	@BOARD_SEQ 		INT
)
AS  
BEGIN
	SELECT TOP 15 MASTER_SEQ, BOARD_SEQ, CATEGORY_SEQ, PARENT_SEQ, LEVEL STEP, SUBJECT, CONTENTS
	,SHOW_COUNT, NOTICE_YN, DEL_YN, COMPLETE_YN, LOCK_YN, NEW_DATE, EDT_DATE, SEARCH_PK 
	FROM HBS_DETAIL 
	WHERE MASTER_SEQ='6' AND SUBJECT LIKE @SUBJECT AND BOARD_SEQ < @BOARD_SEQ AND DEL_YN='N' 
	ORDER BY NEW_DATE DESC

END

GO
