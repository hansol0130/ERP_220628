USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_VGT_SHORTURL_SELECT
■ DESCRIPTION				: 단축 주소 검색 NEW http://vgt.kr/
■ INPUT PARAMETER			: 
	@URL					: 주소
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_VGT_SHORTURL_SELECT 1 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
      2018-04-17		박형만			최초생성
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_VGT_URL_KEY_SELECT]
(
	@URL	VARCHAR(900)
)

AS  
BEGIN

	SELECT TOP 1 A.URL_KEY FROM VGLOG.DBO.VGT_SHORTURL A WITH(NOLOCK, INDEX = IDX_PUB_SHORTURL_1) WHERE URL = @URL
	--SELECT TOP 1 A.URL FROM VGLOG.DBO.VGT_SHORTURL A WITH(NOLOCK) WHERE SEQ_NO = @SEQ_NO
	--ORDER BY SEq_NO DESC -- 최신 
END

GO
