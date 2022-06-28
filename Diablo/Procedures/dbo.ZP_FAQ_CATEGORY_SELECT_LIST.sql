USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_FAQ_CATEGORY_SELECT_LIST
■ DESCRIPTION				: FAQ 카테고리 별 게시물 리스트
■ INPUT PARAMETER			: 
	@BOARD_SEQ 				: 해당 공지사항 번호
	@CATEGORY_SEQ			: 카테고리 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec ZP_FAQ_CATEGORY_SELECT_LIST ,277,2

	SELECT TOP 15 MASTER_SEQ, BOARD_SEQ, CATEGORY_SEQ, PARENT_SEQ, LEVEL STEP, SUBJECT, CONTENTS
	, SHOW_COUNT, NOTICE_YN, DEL_YN, COMPLETE_YN, LOCK_YN, NEW_DATE, EDT_DATE, SEARCH_PK
	FROM HBS_DETAIL
	WHERE MASTER_SEQ='6' AND CATEGORY_SEQ=@CATEGORY_SEQ=2 AND BOARD_SEQ < @BOARD_SEQ=277 AND DEL_YN='N'
	ORDER BY NEW_DATE DESC

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-08-29		지니웍스		최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[ZP_FAQ_CATEGORY_SELECT_LIST]
(
	@BOARD_SEQ 		INT,
	@CATEGORY_SEQ	INT
)

AS  
BEGIN
	SELECT TOP 15 MASTER_SEQ, BOARD_SEQ, CATEGORY_SEQ, PARENT_SEQ, LEVEL STEP, SUBJECT, CONTENTS
	, SHOW_COUNT, NOTICE_YN, DEL_YN, COMPLETE_YN, LOCK_YN, NEW_DATE, EDT_DATE, SEARCH_PK
	FROM HBS_DETAIL
	WHERE MASTER_SEQ='6' AND CATEGORY_SEQ=@CATEGORY_SEQ AND BOARD_SEQ < @BOARD_SEQ AND DEL_YN='N'
	ORDER BY NEW_DATE DESC
	

END

GO
