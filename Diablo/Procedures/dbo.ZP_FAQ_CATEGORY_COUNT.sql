USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_FAQ_CATEGORY_COUNT
■ DESCRIPTION				: 카테고리 별 FAQ 개수
■ INPUT PARAMETER			: 
	@CATEGORY_SEQ			: 카테고리 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec ZP_FAQ_CATEGORY_COUNT , 2

	SELECT ROW_NUMBER() OVER(ORDER BY NEW_DATE ) AS NUM 
	FROM HBS_DETAIL 
	WHERE MASTER_SEQ ='6' AND CATEGORY_SEQ=@CATEGORY_SEQ=2 AND DEL_YN='N' 
	ORDER BY NEW_DATE DESC

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
--------------------------------------------------------------------+----------------------------------------------
   2019-08-29		지니웍스		최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[ZP_FAQ_CATEGORY_COUNT]
(
	@CATEGORY_SEQ	INT
)

AS  
BEGIN
	SELECT ROW_NUMBER() OVER(ORDER BY NEW_DATE ) AS NUM 
	FROM HBS_DETAIL
	WHERE MASTER_SEQ ='6' AND CATEGORY_SEQ=@CATEGORY_SEQ AND DEL_YN='N'
	ORDER BY NEW_DATE DESC
	

END

GO
