USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_BBS_AGT_MASTER_SEQ_SELECT
■ DESCRIPTION				: 대외업무시스템 자유게시판 MASTER_SEQ 검색
■ INPUT PARAMETER			: 
	@EMP_CODE CHAR(7)		: 로그인한 사원의 사번
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_BBS_AGT_MASTER_SEQ_SELECT 'A130001'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-14		김성호			최초생성
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_BBS_AGT_MASTER_SEQ_SELECT]
(
	@EMP_CODE CHAR(7)
)
AS  
BEGIN

	SELECT MASTER_SEQ FROM BBS_MASTER_AGT_LINK WITH(NOLOCK) WHERE AGT_CODE IN (SELECT AGT_CODE FROM AGT_MEMBER WHERE MEM_CODE = @EMP_CODE AND USE_YN = 'Y')
	
END


GO
