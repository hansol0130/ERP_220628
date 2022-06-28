USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_JOB_SCHEDULE_LOG_DETAIL_LIST
■ DESCRIPTION				: 작업스케줄러 로그 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
	EXEC SP_JOB_SCHEDULE_LOG_DETAIL_LIST 1, '20170412'
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-09-30		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_JOB_SCHEDULE_LOG_DETAIL_LIST]
 	@SCH_SEQ INT,
	@SCH_DATE VARCHAR(8)
AS 
BEGIN
	SELECT 
		SCH_SEQ, SCH_DATE, DATE_SEQ, MESSAGE, ERROR_LOG, NEW_DATE
	FROM VGLog..SYS_SCH_LOG WITH(NOLOCK)
	WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE	
	ORDER BY DATE_SEQ ASC;
END
GO
