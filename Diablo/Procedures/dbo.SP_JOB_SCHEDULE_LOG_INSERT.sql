USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_JOB_SCHEDULE_LOG_INSERT
■ DESCRIPTION				: DB 작업 스케줄러 로그 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_JOB_SCHEDULE_LOG_INSERT 3, '완료', NULL;
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-10-06		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_JOB_SCHEDULE_LOG_INSERT]
	@SCH_SEQ INT,
	@MESSAGE VARCHAR(100),
	@ERROR_LOG VARCHAR(MAX)	
AS 
BEGIN
	DECLARE @DATE_SEQ INT;
	SELECT @DATE_SEQ = ISNULL(MAX(DATE_SEQ), 0) + 1 FROM VGLog..SYS_SCH_LOG WITH(NOLOCK) WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = CONVERT(VARCHAR(8), GETDATE(), 112);

	INSERT INTO VGLog..SYS_SCH_LOG 
	VALUES ( @SCH_SEQ, CONVERT(VARCHAR(8), GETDATE(), 112), @DATE_SEQ, @MESSAGE, @ERROR_LOG, GETDATE() );
END
	
GO
