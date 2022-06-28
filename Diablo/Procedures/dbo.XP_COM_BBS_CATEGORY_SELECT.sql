USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BBS_CATEGORY_SELECT
■ DESCRIPTION				: BTMS 게시판 카테고리 구분 가져오기
■ INPUT PARAMETER			: 
	@MASTER_SEQ  INT		: 게시판 마스터코드
	@CATEGORY_CODE  INT			: 카테고리 구분 코드
■ EXEC						: 
	EXEC XP_COM_CATEGORY_SELECT 4, 1
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-02-24		저스트고-백경훈		최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BBS_CATEGORY_SELECT]
	@MASTER_SEQ	INT,
	@CATEGORY_CODE	INT
AS 
BEGIN		
	SELECT * FROM COM_BBS_CATEGORY WITH(NOLOCK) WHERE MASTER_SEQ = @MASTER_SEQ AND CATEGORY_CODE= @CATEGORY_CODE AND USE_YN = 'Y';
END 





GO
