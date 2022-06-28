USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_FAQ_COUNT
■ DESCRIPTION				:  FAQ 총 개수 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec ZP_FAQ_COUNT 

	SELECT ROW_NUMBER() OVER (ORDER BY NEW_DATE )
	FROM HBS_DETAIL
	WHERE MASTER_SEQ='6' AND DEL_YN='N'
	ORDER BY NEW_DATE DESC

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-08-29		지니웍스		최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[ZP_FAQ_COUNT]

AS  
BEGIN
	SELECT ROW_NUMBER() OVER (ORDER BY NEW_DATE )
	FROM HBS_DETAIL
	WHERE MASTER_SEQ='6' AND DEL_YN='N'
	ORDER BY NEW_DATE DESC

END

GO
