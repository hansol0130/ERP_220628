USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_NOTICE_FIRST_SELECT_LIST
■ DESCRIPTION				: 공지사항 첫 15개 게시물 리스트 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec ZP_NOTICE_FIRST_SELECT_LIST

	SELECT TOP 10 SUBJECT, BOARD_SEQ, CONTENTS, NOTICE_YN NEW_DATE
	FROM HBS_DETAIL
	WHERE MASTER_SEQ='3' AND DEL_YN='N' 
	ORDER BY NEW_DATE DESC

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-08-29		지니웍스		최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[ZP_NOTICE_FIRST_SELECT_LIST]


AS  
BEGIN
	SELECT TOP 10 SUBJECT, BOARD_SEQ, CONTENTS, NOTICE_YN NEW_DATE
	FROM HBS_DETAIL
	WHERE MASTER_SEQ='3' AND DEL_YN='N' 
	ORDER BY NEW_DATE DESC
	

END

GO
