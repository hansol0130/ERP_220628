USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_NOTICE_DETAIL_SELECT
■ DESCRIPTION				: 공지사항 디테일 정보 검색
■ INPUT PARAMETER			: 
	@BOARD_SEQ 				: 해당 공지사항 번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec ZP_NOTICE_DETAIL_SELECT 277

	SELECT SUBJECT, CONTENTS, NEW_DATE 
	FROM HBS_DETAIL 
	WHERE MASTER_SEQ='3' AND BOARD_SEQ =277 AND DEL_YN='N' 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-08-29		지니웍스		최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[ZP_NOTICE_DETAIL_SELECT]
(
	@BOARD_SEQ 		INT
)

AS  
BEGIN
	SELECT SUBJECT, CONTENTS, NEW_DATE 
	FROM HBS_DETAIL 
	WHERE MASTER_SEQ='3' AND BOARD_SEQ =@BOARD_SEQ AND DEL_YN='N' 
	

END

GO
