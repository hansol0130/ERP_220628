USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_SCHEDULE_MASTER_REGISTER
■ DESCRIPTION				: DB 작업 스케줄러 로그 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_SCHEDULE_MASTER_REGISTER 'TestOne', 0, 'P18047', 'TT';
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2019-03-04		이명훈			생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_SCHEDULE_MASTER_REGISTER]
	@SCH_NAME VARCHAR(100),
	@SCH_TYPE INT,
	@HOST_NAME VARCHAR(30),
	@LAST_RUN_REMARK VARCHAR(50),
	@AVG_RUN_TIME INT
AS 
BEGIN
	DECLARE @SCH_SEQ INT,
			@SUCCESS_RUN_COUNT INT,
			@TOTAL_SECONDS INT,
			@TIME TIME,
			@SCH_DATE INT,
			@WORK_COUNT INT,
			@ERROR_COUNT INT

	SELECT @TIME = AVG_RUN_TIME FROM VGLog..SCH_LOG WHERE SCH_NAME = @SCH_NAME AND SCH_DATE = CONVERT(VARCHAR(8), GETDATE(), 112)

	SELECT @SCH_DATE = CONVERT(VARCHAR(8), GETDATE(), 112);
	SELECT @WORK_COUNT = ISNULL(WORK_COUNT, 0) FROM VGLog..SCH_LOG WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE;
	SELECT @ERROR_COUNT = ISNULL(ERROR_COUNT, 0) FROM VGLog..SCH_LOG WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE;

	SELECT @SCH_SEQ = SCH_SEQ FROM VGLog..SCH_MASTER WHERE SCH_NAME = @SCH_NAME

	IF @SCH_SEQ IS NULL
	BEGIN
			INSERT INTO VGLog..SCH_MASTER ( SCH_NAME, SCH_TYPE, HOST_NAME, NEW_DATE )
			VALUES ( @SCH_NAME, @SCH_TYPE, @HOST_NAME, GETDATE() )

			SET @SCH_SEQ = @@IDENTITY;
	END

	-- 로그
	IF EXISTS ( SELECT 1 FROM VGLog..SCH_LOG WITH(NOLOCK) WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE )
		BEGIN
			IF @LAST_RUN_REMARK IS NOT NULL
				BEGIN
					-- 로그 업데이트
					SELECT @SUCCESS_RUN_COUNT = ISNULL(SUCCESS_RUN_COUNT, 0) FROM VGLog..SCH_LOG WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE;

					--시간계산
					IF @SUCCESS_RUN_COUNT = 0
						BEGIN
							SELECT @TOTAL_SECONDS =  @AVG_RUN_TIME * 0.001
						END
					ELSE
						BEGIN
							SELECT @TIME = (SELECT AVG_RUN_TIME FROM VGLog..SCH_LOG WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE)
							SELECT @TOTAL_SECONDS = ((DATEPART(HOUR , @TIME) * 3600 + DATEPART(MINUTE, @TIME) * 60 + DATEPART(SECOND, @TIME)) * @SUCCESS_RUN_COUNT + @AVG_RUN_TIME * 0.001) / (@SUCCESS_RUN_COUNT + 1)
						END
					SELECT @TIME = CONVERT(nvarchar, DATEADD(s, @TOTAL_SECONDS, 0), 114);

					UPDATE VGLog..SCH_LOG
					SET SUCCESS_RUN_COUNT = @SUCCESS_RUN_COUNT + 1, AVG_RUN_TIME = @TIME, LAST_RUN_DATE = GETDATE()
					WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE
				END
		END
	ELSE
		BEGIN
			-- 로그 인서트
			INSERT INTO VGLog..SCH_LOG ( SCH_SEQ, SCH_NAME, SCH_DATE, WORK_COUNT, ERROR_COUNT, NEW_DATE )
			VALUES ( @SCH_SEQ, @SCH_NAME, @SCH_DATE, @WORK_COUNT + 1, @ERROR_COUNT, GETDATE() )
		END


	-- 마스터
	IF EXISTS ( SELECT 1 FROM VGLog..SCH_MASTER WITH(NOLOCK) WHERE SCH_NAME = @SCH_NAME )
		BEGIN
			-- 마스터 업데이트
			UPDATE VGLog..SCH_MASTER 
			SET	HOST_NAME = @HOST_NAME, LAST_RUN_DATE = GETDATE(), LAST_RUN_REMARK = @LAST_RUN_REMARK, LAST_RUN_TIME = @TIME
			WHERE SCH_SEQ = @SCH_SEQ --AND SCH_NAME = @SCH_NAME AND SCH_TYPE = @SCH_TYPE;
		END

	SELECT @SCH_SEQ;
END



GO
