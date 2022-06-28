USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_FAQ_SELECT_LIST
■ DESCRIPTION				: FAQ 게시물 리스트 검색
■ INPUT PARAMETER			: 
	@BOARD_SEQ 				: 게시물 번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec ZP_FAQ_SELECT_LIST ,277

	select top 15 master_seq, board_seq, category_seq, parent_seq, level step, subject, contents
	, show_count, notice_yn, del_yn, complete_yn, lock_yn, new_date, edt_date, search_pk
	from HBS_DETAIL 
	where MASTER_SEQ='6' and BOARD_SEQ < @BOARD_SEQ and DEL_YN='N'
	order by NEW_DATE desc

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-08-29		지니웍스		최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[ZP_FAQ_SELECT_LIST]
(
	@BOARD_SEQ 		INT
)

AS  
BEGIN
	select top 15 master_seq, board_seq, category_seq, parent_seq, level step, subject, contents
	, show_count, notice_yn, del_yn, complete_yn, lock_yn, new_date, edt_date, search_pk
	from HBS_DETAIL 
	where MASTER_SEQ='6' and BOARD_SEQ < @BOARD_SEQ and DEL_YN='N'
	order by NEW_DATE desc
	

END

GO
