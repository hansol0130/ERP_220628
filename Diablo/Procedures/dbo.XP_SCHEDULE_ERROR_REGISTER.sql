USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_SCHEDULE_ERROR_REGISTER
■ DESCRIPTION				: DB 작업 스케줄러 로그 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_SCHEDULE_LOG_TEST 1, 'DEBUG';
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2019-03-12		이명훈			생성
   2022-03-03		김성호			불필요 부분 삭제
================================================================================================================*/ 
CREATE PROC [dbo].[XP_SCHEDULE_ERROR_REGISTER]
	@SCH_SEQ INT,
	@MESSAGE VARCHAR(500),
	@ERROR_MESSAGE VARCHAR(max)
AS 
BEGIN
	DECLARE @SCH_DATE INT = CONVERT(VARCHAR(8), GETDATE(), 112),
			@ERROR_SEQ INT
	
	SELECT @ERROR_SEQ = ISNULL(MAX(ERROR_SEQ), 0) + 1 FROM VGLog..APP_SCH_ERROR_LOG WITH(NOLOCK) WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = CONVERT(VARCHAR(8), GETDATE(), 112);

	-- 로그 업데이트
	UPDATE ASL
	SET    ASL.ERROR = (ISNULL(ASL.ERROR ,0) + 1)
	FROM   VGLog.dbo.APP_SCH_LOG ASL
	WHERE  ASL.SCH_SEQ = @SCH_SEQ
	        AND ASL.SCH_DATE = @SCH_DATE; 

	INSERT INTO VGLog..APP_SCH_ERROR_LOG ( SCH_SEQ, SCH_DATE, ERROR_SEQ, METHOD, [ERROR_MESSAGE], NEW_DATE )
	VALUES ( @SCH_SEQ, @SCH_DATE, @ERROR_SEQ, @MESSAGE, @ERROR_MESSAGE, GETDATE() );

END

GO
