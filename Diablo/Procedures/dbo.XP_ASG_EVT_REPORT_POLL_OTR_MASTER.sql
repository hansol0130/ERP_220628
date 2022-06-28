USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_POLL_OTR_MASTER
■ DESCRIPTION				: 출장보고서 폴마스터 조회
■ INPUT PARAMETER			:
	@POL_TYPE				: 폴타입
	@PRO_CODE				: 여행코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_ASG_EVT_REPORT_POLL_OTR_MASTER '5', 'CPP456-130402'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-18		이상일			최초생성
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_ASG_EVT_REPORT_POLL_OTR_MASTER]
	@POL_TYPE		CHAR(1),
	@PRO_CODE		VARCHAR(20)
AS
BEGIN
	DECLARE @MASTER_SEQ INT


	SELECT TOP 1 @MASTER_SEQ = MASTER_SEQ
	FROM	dbo.POL_MASTER A
	WHERE	A.TARGET = 3
	AND		A.POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
	AND		A.POL_STATE = '1'  --진행중 = 1, 종료 = 2
	--AND     GETDATE() BETWEEN A.START_DATE AND A.END_DATE
	AND		A.DEL_FLAG ='N'
	ORDER BY NEW_DATE DESC

			SELECT 
				MASTER_SEQ                     --  
				, TARGET                         --  
				, POL_TYPE                       --  
				, POL_STATE                      --  
				, SUBJECT                        --  
				, POL_DESC                       --  
				, START_DATE                     --  
				, END_DATE                       --  
				, OPEN_DATE 
		FROM	dbo.POL_MASTER A
		WHERE	A.TARGET = 3
		AND		A.POL_TYPE = @POL_TYPE  --PollTypeEnum { 전체평가 = 1, 가이드평가 = 2, 호텔평가 = 3, 식사평가 = 4, 고객평가 = 5, 이벤트 = 6 };
		AND		A.POL_STATE = '1'  --진행중 = 1, 종료 = 2
		--AND     GETDATE() BETWEEN A.START_DATE AND A.END_DATE
		AND		A.MASTER_SEQ = @MASTER_SEQ

	SELECT OTR_SEQ, PRO_CODE, OTR_STATE, EDI_CODE, TOTAL_VALUATION, NEW_DATE, NEW_CODE, EDT_DATE, EDT_CODE  FROM OTR_MASTER
	WHERE PRO_CODE = @PRO_CODE
END


GO
