USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_PKG_DETAIL_ONLY_SELECT
■ DESCRIPTION				: PKG_DETAIL 테이블만 검색
■ INPUT PARAMETER			: 
	@PRO_CODE VARCHAR(20)	: 행사코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_WEB_PKG_DETAIL_ONLY_SELECT 'EPF002-130406AF'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-04		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_WEB_PKG_DETAIL_ONLY_SELECT]
(
	@PRO_CODE	VARCHAR(20)
)
AS  
BEGIN

	SELECT * FROM PKG_DETAIL A WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE

END




GO
