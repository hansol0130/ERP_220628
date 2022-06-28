USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 /*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_POLL_UP_CHECK_SELECT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 POLL 리스트 상태 검색
■ INPUT PARAMETER			: 
	@POL_TYPE CHAR(1)		:  전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6
	@PRO_CODE	VARCHAR(20)
■ OUTPUT PARAMETER			: 

■ EXEC						: 
	DECLARE @POL_TYPE CHAR(1),@PRO_CODE	VARCHAR(20)
	SELECT @POL_TYPE='2', @PRO_CODE='APP0504-130327TG5'
	--exec XP_ASG_EVT_REPORT_POLL_UP_SELECT @POL_TYPE ,@PRO_CODE
	exec XP_ASG_EVT_REPORT_POLL_UP_CHECK_SELECT @POL_TYPE ,@PRO_CODE
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-11		오인규			최초생성
   2014-01-15		김성호			쿼리수정
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_ASG_EVT_REPORT_POLL_UP_CHECK_SELECT]
(
	@POL_TYPE	CHAR(1),
	@PRO_CODE	VARCHAR(20)
)

AS  
BEGIN

	SELECT	CASE WHEN COUNT(A.OTR_POL_MASTER_SEQ) > 0 THEN 'Y' ELSE 'N' END AS ANSWERSTATE
	FROM	dbo.OTR_POL_MASTER A WITH(NOLOCK)
	INNER JOIN dbo.OTR_POL_QUESTION B WITH(NOLOCK) ON A.OTR_POL_MASTER_SEQ = B.OTR_POL_MASTER_SEQ
	INNER JOIN dbo.OTR_POL_DETAIL C WITH(NOLOCK) ON B.OTR_POL_MASTER_SEQ = C.OTR_POL_MASTER_SEQ AND B.OTR_POL_QUESTION_SEQ = C.OTR_POL_QUESTION_SEQ
	LEFT OUTER JOIN dbo.OTR_POL_ANSWER  D WITH(NOLOCK) ON C.OTR_POL_MASTER_SEQ = D.OTR_POL_MASTER_SEQ  AND C.OTR_POL_QUESTION_SEQ =  D.OTR_POL_QUESTION_SEQ --AND C.OTR_POL_EXAMPLE_SEQ = D.OTR_POL_EXAMPLE_SEQ            
	WHERE	A.OTR_SEQ IN (SELECT OTR_SEQ FROM OTR_MASTER WHERE PRO_CODE = @PRO_CODE)
	AND		A.POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
	 

END

GO
