USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

		
 /*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_AGENT_SELECT_LAND
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 인솔자 리스트 검색
■ INPUT PARAMETER			: 
	@AGT_TYPE_CODE  VARCHAR(2)	--랜드사 타입
■ OUTPUT PARAMETER			: 

■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-23		이상일			최초생성   
================================================================================================================*/ 		
		
CREATE  PROCEDURE [dbo].[XP_ASG_EVT_REPORT_AGENT_SELECT_LAND]
(
	@AGT_TYPE_CODE VARCHAR(2)	--랜드사 타입
)
AS  
BEGIN
	SELECT A.AGT_CODE, A.KOR_NAME FROM AGT_MASTER A WITH(NOLOCK)
	INNER JOIN AGT_MEMBER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
	WHERE A.AGT_TYPE_CODE = @AGT_TYPE_CODE and B.WORK_TYPE = 1 AND B.MEM_TYPE = 1
END


GO
