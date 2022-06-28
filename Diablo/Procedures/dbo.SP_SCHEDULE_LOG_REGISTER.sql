USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_SCHEDULE_LOG_REGISTER
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
   2019-03-04		이명훈			생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_SCHEDULE_LOG_REGISTER]
	@SCH_SEQ INT,
	@SCH_NAME VARCHAR(100),
	@MESSAGE VARCHAR(500),
	@ERROR_MESSAGE VARCHAR(500),
	@STATUS INT		-- 0 : 정상, 1 : 에러
AS 
BEGIN
	DECLARE @SCH_DATE INT,
			@ERROR_DATA_SEQ INT,
			@WORK_COUNT INT,
			@ERROR_COUNT INT,
			@EXIST_YN CHAR
	
	SELECT @SCH_DATE = CONVERT(VARCHAR(8), GETDATE(), 112);

	SELECT @WORK_COUNT = ISNULL(WORK_COUNT, 0) FROM VGLog..SCH_LOG WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE;
	SELECT @ERROR_COUNT = ISNULL(ERROR_COUNT, 0) FROM VGLog..SCH_LOG WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE;
	SELECT @ERROR_DATA_SEQ = ISNULL(MAX(DATA_SEQ), 0) + 1 FROM VGLog..SCH_ERROR_LOG WITH(NOLOCK) WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = CONVERT(VARCHAR(8), GETDATE(), 112);

	SELECT @EXIST_YN = 'Y' FROM VGLog..SCH_LOG WITH(NOLOCK) WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE;

	-- 에러
	IF @STATUS = 1
		BEGIN
			-- 업데이트
			IF @EXIST_YN = 'Y'
				BEGIN
					UPDATE VGLog..SCH_LOG
					SET	ERROR_COUNT = @ERROR_COUNT + 1, LAST_RUN_DATE = GETDATE()
					WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE 

					INSERT INTO VGLog..SCH_ERROR_LOG ( SCH_SEQ, SCH_NAME, SCH_DATE, DATA_SEQ, MESSAGE, ERROR_MESSAGE, NEW_DATE )
					VALUES ( @SCH_SEQ, @SCH_NAME, @SCH_DATE, @ERROR_DATA_SEQ, @MESSAGE, @ERROR_MESSAGE, GETDATE() )
				END
			-- 첫 동작
			ELSE
				BEGIN
					-- DATA_SEQ = 1
					INSERT INTO VGLog..SCH_LOG ( SCH_SEQ, SCH_NAME, SCH_DATE, MESSAGE, WORK_COUNT, ERROR_COUNT, NEW_DATE )
					VALUES ( @SCH_SEQ, @SCH_NAME, @SCH_DATE, @MESSAGE, @WORK_COUNT, @ERROR_COUNT + 1, GETDATE() )
					-- ERROR INSERT
					INSERT INTO VGLog..SCH_ERROR_LOG ( SCH_SEQ, SCH_NAME, SCH_DATE, DATA_SEQ, MESSAGE, ERROR_MESSAGE, NEW_DATE )
					VALUES ( @SCH_SEQ, @SCH_NAME, @SCH_DATE, @ERROR_DATA_SEQ, @MESSAGE, @ERROR_MESSAGE, GETDATE() )
				END
		END
	-- 정상동작
	ELSE
		BEGIN
			-- 업데이트
			IF @EXIST_YN = 'Y'
				BEGIN
					UPDATE VGLog..SCH_LOG
					SET	WORK_COUNT = @WORK_COUNT + 1, MESSAGE = @MESSAGE
					WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE
				END
			-- 첫 동작
			ELSE
				BEGIN
					INSERT INTO VGLog..SCH_LOG ( SCH_SEQ, SCH_NAME, SCH_DATE, MESSAGE, WORK_COUNT, ERROR_COUNT, NEW_DATE )
					VALUES ( @SCH_SEQ, @SCH_NAME, @SCH_DATE, @MESSAGE, @WORK_COUNT + 1, @ERROR_COUNT, GETDATE() )
				END
		END
END
GO
