USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_EVT_RECOMMEND_CNT_SELECT
■ DESCRIPTION					: 친구추천 명수 검색
■ INPUT PARAMETER				: 
	@CUS_NO_RECOM		INT		: 추천고객코드
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : EXEC ZP_EVT_RECOMMEND_CNT_SELECT 11166539, '20210630'
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2021-07-14		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_EVT_RECOMMEND_ADSYNC_SELECT]
	@CUS_NO_RECOM			INT
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT SEQ, UID_NUM, AD_NO, REWARD_KEY
	FROM   (
	           SELECT ROW_NUMBER() OVER(ORDER BY seq DESC) RANKING
					 ,SEQ
	                 ,UID_NUM
	                 ,AD_NO
	                 ,REWARD_KEY
	           FROM   EVT_RECOMMEND_ADSYNC
	           WHERE  CUS_NO = @CUS_NO_RECOM
	       ) A
	WHERE RANKING = 1      
END
GO
