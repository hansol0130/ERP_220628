USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_JOB_SCHEDULE_LOG_MASTER_SELECT
■ DESCRIPTION				: 작업스케줄러 마스터 정보
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
	EXEC SP_JOB_SCHEDULE_LOG_MASTER_SELECT 1, '테스트'
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-09-30		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_JOB_SCHEDULE_LOG_MASTER_SELECT]
 	@SCH_TYPE INT,
	@SCH_NAME VARCHAR(100)
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SEL_SCH_SEQ INT;
	SELECT
		@SEL_SCH_SEQ = SCH_SEQ
	FROM VGLog..SYS_SCH_MASTER A WITH(NOLOCK)
	WHERE SCH_TYPE = @SCH_TYPE AND SCH_NAME = @SCH_NAME

	SELECT 
		SCH_SEQ, SCH_NAME, SCH_TYPE, [HOST_NAME], LAST_RUN_DATE, LAST_RUN_REMARK, NEW_DATE, EDT_DATE
	FROM VGLog..SYS_SCH_MASTER A WITH(NOLOCK)
	WHERE SCH_SEQ = @SEL_SCH_SEQ		
END
GO
