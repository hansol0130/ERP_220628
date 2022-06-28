USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_MARKET_NOTICE_SELECT
■ DESCRIPTION					: 참좋은마켓 메인 공지사항
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2021-07-20		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_MARKET_NOTICE_SELECT]
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT BOARD_SEQ, SUBJECT
FROM (SELECT BOARD_SEQ, SUBJECT, ROW_NUMBER() OVER(ORDER BY BOARD_SEQ DESC) RANKING 
FROM HBS_DETAIL
WHERE MASTER_SEQ = 3
AND CATEGORY_SEQ = 11) A
WHERE RANKING <= 1
END
GO
