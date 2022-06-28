USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_TC_TOP_SUMMARY
■ DESCRIPTION				: 인솔자 메인 상단 요약
■ INPUT PARAMETER			: 
	@EMP_CODE	CHAR(7)		: 사원코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_TC_TOP_SUMMARY 'T130001'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-30		오인규			최초생성
   2014-01-13		이동호			인솔자 출장보고서 재검토 카운트 추가 
   2014-01-16		이동호			배정행사 예정 카운트 수정 줄:64   
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_TC_TOP_SUMMARY]
(
	@EMP_CODE	CHAR(7)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	DECLARE @MAIL_COUNT INT,  @NotYetAssignEventCount INT ,@FinishAssignEventCount INT ,@NotYetReportCount INT ,@FinishReportCount INT ,@ReturnReportCount INT 

	DECLARE @NotYetAssignEventMinDepDate VARCHAR(10), @NotYetAssignEventMaxDepDate VARCHAR(10)
	DECLARE @FinishAssignEventMinDepDate VARCHAR(10), @FinishAssignEventMaxDepDate VARCHAR(10)
	DECLARE @NotYetReportMinDepDate VARCHAR(10), @NotYetReportMaxDepDate VARCHAR(10)
	DECLARE @FinishReportMinDepDate VARCHAR(10), @FinishReportMaxDepDate VARCHAR(10)
	DECLARE @ReturnReportMinDepDate VARCHAR(10), @ReturnReportMaxDepDate VARCHAR(10)

	SELECT @MAIL_COUNT = COUNT(*) FROM PRI_NOTE_RECEIPT WHERE EMP_CODE = @EMP_CODE AND RCV_DEL_YN = 'N' AND CONFIRM_YN = 'N';
				


	CREATE TABLE #LOCAL_TEMP
	(
		PRO_CODE VARCHAR(20),
		DEP_DATE datetime
	)
	INSERT INTO #LOCAL_TEMP (PRO_CODE, DEP_DATE)
	(
		SELECT 
				A.PRO_CODE --행사코드
				,A.DEP_DATE
		FROM PKG_DETAIL A
		LEFT OUTER JOIN dbo.TRAVEL_REPORT_MASTER V ON A.PRO_CODE = V.PRO_CODE
		WHERE A.TC_CODE = @EMP_CODE AND A.TC_ASSIGN_YN ='Y'
		AND A.DEP_DATE >= '2019-01-01 00:00:00.000'
	)

----------------------------------------------------------------------------------------------------------

	SELECT  @NotYetAssignEventCount = COUNT(*) 
			,@NotYetAssignEventMinDepDate = CONVERT(VARCHAR(20), MIN(Z.DEP_DATE), 120)
			,@NotYetAssignEventMaxDepDate = CONVERT(VARCHAR(20), MAX(Z.DEP_DATE), 120)
	FROM #LOCAL_TEMP Z
	INNER JOIN PKG_DETAIL A ON A.PRO_CODE = Z.PRO_CODE
	WHERE A.TC_CODE = @EMP_CODE AND A.TC_ASSIGN_YN ='Y' AND GETDATE() <  A.DEP_DATE;  --  배정행사 예정 카운트 완료
----------------------------------------------------------------------------------------------------------	

	SELECT @FinishAssignEventCount = COUNT(*) 
		,@FinishAssignEventMinDepDate = CONVERT(VARCHAR(20), MIN(Z.DEP_DATE), 120)
		,@FinishAssignEventMaxDepDate = CONVERT(VARCHAR(20), MAX(Z.DEP_DATE), 120)
	FROM #LOCAL_TEMP Z
	INNER JOIN PKG_DETAIL A ON A.PRO_CODE = Z.PRO_CODE
	WHERE A.TC_CODE = @EMP_CODE AND A.TC_ASSIGN_YN ='Y'  AND DATEDIFF(DAY,GETDATE(),A.ARR_DATE) < 0 ; -- 예정 -> 배정행사 완료(수정함)
			
----------------------------------------------------------------------------------------------------------
	SELECT @NotYetReportCount = COUNT(*) 
			,@NotYetReportMinDepDate = CONVERT(VARCHAR(20), MIN(Z.DEP_DATE), 120)
			,@NotYetReportMaxDepDate = CONVERT(VARCHAR(20), MAX(Z.DEP_DATE), 120)
	FROM #LOCAL_TEMP Z
	INNER JOIN dbo.PKG_DETAIL A ON A.PRO_CODE = Z.PRO_CODE
	INNER JOIN dbo.PKG_MASTER Y ON A.MASTER_CODE = Y.MASTER_CODE
	LEFT OUTER JOIN dbo.PUB_REGION X ON Y.SIGN_CODE = X.SIGN
	LEFT OUTER JOIN dbo.TRAVEL_REPORT_MASTER V ON A.PRO_CODE = V.PRO_CODE
	WHERE A.TC_CODE = @EMP_CODE AND A.TC_ASSIGN_YN ='Y' AND ISNULL(V.OTR_STATE , '0') IN ('0', '1');
----------------------------------------------------------------------------------------------------------
	SELECT @FinishReportCount = COUNT(*)
		,@FinishReportMinDepDate = CONVERT(VARCHAR(20), MIN(Z.DEP_DATE), 120)
		,@FinishReportMaxDepDate = CONVERT(VARCHAR(20), MAX(Z.DEP_DATE), 120)
	FROM #LOCAL_TEMP Z
	INNER JOIN dbo.PKG_DETAIL A ON A.PRO_CODE = Z.PRO_CODE
	INNER JOIN dbo.PKG_MASTER Y ON A.MASTER_CODE = Y.MASTER_CODE
	LEFT OUTER JOIN dbo.PUB_REGION X ON Y.SIGN_CODE = X.SIGN
	LEFT OUTER JOIN dbo.TRAVEL_REPORT_MASTER V ON A.PRO_CODE = V.PRO_CODE
	WHERE A.TC_CODE = @EMP_CODE AND A.TC_ASSIGN_YN ='Y' 
		AND ISNULL(V.OTR_STATE , '0') IN ('2', '3');
----------------------------------------------------------------------------------------------------------
	SELECT @ReturnReportCount = COUNT(*)		
		,@ReturnReportMinDepDate = CONVERT(VARCHAR(20), MIN(Z.DEP_DATE), 120)
		,@ReturnReportMaxDepDate = CONVERT(VARCHAR(20), MAX(Z.DEP_DATE), 120)						
	FROM #LOCAL_TEMP Z
	INNER JOIN dbo.PKG_DETAIL A ON A.PRO_CODE = Z.PRO_CODE
	INNER JOIN dbo.PKG_MASTER Y ON A.MASTER_CODE = Y.MASTER_CODE
	LEFT OUTER JOIN dbo.PUB_REGION X ON Y.SIGN_CODE = X.SIGN
	LEFT OUTER JOIN dbo.TRAVEL_REPORT_MASTER V ON A.PRO_CODE = V.PRO_CODE
	WHERE A.TC_CODE = @EMP_CODE AND A.TC_ASSIGN_YN ='Y' 			
		AND ISNULL(V.OTR_STATE , '0') = '4'


	SELECT @MAIL_COUNT AS MAIL_COUNT
			,@NotYetAssignEventCount AS NOT_YET_ASG_COUNT
			,@NotYetAssignEventMinDepDate AS NOT_YET_ASG_MinDepDate
			,@NotYetAssignEventMaxDepDate AS NOT_YET_ASG_MaxDepDate
			,@FinishAssignEventCount AS FINISH_ASG_COUNT
			,@FinishAssignEventMinDepDate AS FINISH_ASG_MinDepDate
			,@FinishAssignEventMaxDepDate AS FINISH_ASG_MaxDepDate
			,@NotYetReportCount AS NOT_YET_RPT_COUNT
			,@NotYetReportMinDepDate AS NOT_YET_RPT_MinDepDate
			,@NotYetReportMaxDepDate AS NOT_YET_RPT_MaxDepDate
			,@FinishReportCount AS FINISH_RPT_COUNT
			,@FinishReportMinDepDate AS FINISH_RPT_MinDepDate
			,@FinishReportMaxDepDate AS FINISH_RPT_MaxDepDate
			,@ReturnReportCount AS RETURN_REPORT_COUNT
			,@ReturnReportMinDepDate AS RETURN_RPT_MinDepDate
			,@ReturnReportMaxDepDate AS RETURN_RPT_MaxDepDate
			
	DROP TABLE #LOCAL_TEMP							
END


GO
