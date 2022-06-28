USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_WEB_PKG_MASTER_RECOMMEND_LIST_SELECT
■ DESCRIPTION				: 기준 마스터 코드를 통해 추천 마스터를 제공한다
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
	@MASTER_CODE_LIST		: 마스터코드 리스트
■ EXEC						: 

	exec SP_MOV2_WEB_PKG_MASTER_RECOMMEND_LIST_SELECT 'EPP2209'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-10-13		김성호			최초생성
   2017-10-31		정지용			이미지 공백이 들어가 있을 경우 NULL
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[SP_SLIME_WEB_PKG_MASTER_RECOMMEND_LIST_SELECT]
(
	@MASTER_CODE_LIST VARCHAR(100)
)
AS  
BEGIN

	SELECT A.MASTER_CODE, A.MASTER_NAME, A.LOW_PRICE, A.EVENT_PRO_CODE
		, ('/content/' + B.REGION_CODE + '/' + B.NATION_CODE + '/' + B.STATE_CODE + '/' + B.CITY_CODE + '/image/' + ISNULL(CASE WHEN B.FILE_NAME_M = '' THEN NULL ELSE B.FILE_NAME_M END, B.FILE_NAME_S)) AS [IMAGE_URL]
		, (SELECT COUNT(*) FROM PUB_EVENT_DATA AA WITH(NOLOCK) INNER JOIN PUB_EVENT BB WITH(NOLOCK) ON AA.EVT_SEQ = BB.EVT_SEQ WHERE AA.MASTER_CODE = A.MASTER_CODE AND AA.SHOW_YN = 'Y' AND BB.SHOW_YN = 'Y' AND (BB.START_DATE IS NULL OR BB.START_DATE < GETDATE()) AND (BB.END_DATE IS NULL OR BB.END_DATE > GETDATE())) AS [EVENT_COUNT]
		, (SELECT COUNT(*) FROM VR_CONTENT V2 WITH(NOLOCK) INNER JOIN VR_MASTER VM WITH(NOLOCK) ON V2.VR_NO = VM.VR_NO WHERE A.MASTER_CODE = V2.MASTER_CODE AND VM.VR_TYPE = 1) AS [VR_COUNT]
	FROM PKG_MASTER A WITH(NOLOCK)
	INNER JOIN INF_FILE_MASTER B WITH(NOLOCK) ON A.MAIN_FILE_CODE = B.FILE_CODE
	WHERE A.MASTER_CODE IN (SELECT MASTER_CODE FROM [CUVE].[dbo].[XN_PKG_RECOMMEND_SELECT_LIST](@MASTER_CODE_LIST, NULL))

END
GO
