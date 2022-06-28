USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_SCHEDULE_REGISTER
■ DESCRIPTION				: DB 작업 스케줄러 로그 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC XP_SCHEDULE_MASTER_REGISTER 'TestOne', 0, 'P18047', 'TT';
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2019-03-12		이명훈			생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_SCHEDULE_REGISTER2]
	@SCH_NAME VARCHAR(100),
	@SCH_TYPE INT,
	@HOST_NAME VARCHAR(30),
	@LAST_RUN_REMARK VARCHAR(50),
	@LAST_RUN_TIME INT
AS 
BEGIN
	DECLARE @SCH_SEQ INT,
			@EXEC_COUNT INT,
			@TIME TIME,
			@SCH_DATE INT,
			@ERROR INT

	SELECT @SCH_DATE = CONVERT(VARCHAR(8), GETDATE(), 112);
	SELECT @SCH_SEQ = SCH_SEQ FROM VGLog..APP_SCH_MASTER WHERE SCH_NAME = @SCH_NAME
	SELECT @EXEC_COUNT = ISNULL(EXEC_COUNT, 0) FROM VGLog..APP_SCH_LOG WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE;
	SELECT @ERROR = ISNULL(ERROR, 0) FROM VGLog..APP_SCH_LOG WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE;

	-- 마스터 최초 등록시
	IF @SCH_SEQ IS NULL
	BEGIN
			INSERT INTO VGLog..APP_SCH_MASTER ( SCH_NAME, SCH_TYPE, HOST_NAME, NEW_DATE )
			VALUES ( @SCH_NAME, @SCH_TYPE, @HOST_NAME, GETDATE() )

			SELECT @SCH_SEQ = SCH_SEQ FROM VGLog..APP_SCH_MASTER WHERE SCH_NAME = @SCH_NAME;
	END

		
	-- 로그 업데이트
	IF EXISTS ( SELECT 1 FROM VGLog..APP_SCH_LOG WITH(NOLOCK) WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE )
		BEGIN
			IF @LAST_RUN_REMARK IS NOT NULL
				BEGIN
					-- 로그 업데이트
					UPDATE VGLog..APP_SCH_LOG
					SET EXEC_COUNT = @EXEC_COUNT + 1
					WHERE SCH_SEQ = @SCH_SEQ AND SCH_DATE = @SCH_DATE
				END
		END
	-- 로그 인서트
	ELSE
		BEGIN
			INSERT INTO VGLog..APP_SCH_LOG ( SCH_SEQ, SCH_DATE, EXEC_COUNT, ERROR, NEW_DATE )
			VALUES ( @SCH_SEQ, @SCH_DATE, 0, 0, GETDATE() )
		END

		/*

	-- 마스터 업데이트
	IF EXISTS ( SELECT 1 FROM VGLog..APP_SCH_MASTER WITH(NOLOCK) WHERE SCH_NAME = @SCH_NAME )
		BEGIN
			SELECT @TIME = CONVERT(nvarchar, DATEADD(s, ISNULL(@LAST_RUN_TIME*0.001, 0), 0), 114);
			-- 마스터 업데이트
			UPDATE VGLog..APP_SCH_MASTER 
			SET	LAST_RUN_DATE = GETDATE(), LAST_RUN_REMARK = @LAST_RUN_REMARK, LAST_RUN_TIME = @TIME, HOST_NAME = @HOST_NAME
			WHERE SCH_SEQ = @SCH_SEQ
		END

	SELECT @SCH_SEQ;
	*/
END



GO
