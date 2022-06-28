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
   2022-03-02		김성호			프로세스 시작, 종료 시 실행, LAST_RUN_REMARK 항상 등록, 시작 시 LAST_RUN_TIME = 0 으로 세팅 시작 시만 실행 카운트를 1 증가 시킨다 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_SCHEDULE_REGISTER]
	@SCH_NAME VARCHAR(100),
	@SCH_TYPE INT,
	@HOST_NAME VARCHAR(30),
	@LAST_RUN_REMARK VARCHAR(50),
	@LAST_RUN_TIME INT
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @SCH_SEQ      INT
	       ,@TIME         TIME = CONVERT(NVARCHAR ,DATEADD(s ,ISNULL(@LAST_RUN_TIME * 0.001 ,0) ,0) ,114)
	       ,@SCH_DATE     INT = CONVERT(VARCHAR(8) ,GETDATE() ,112)
	
	-- 스케줄 코드 조회
	SELECT @SCH_SEQ = SCH_SEQ
	FROM   VGLog..APP_SCH_MASTER WITH(NOLOCK)
	WHERE  SCH_NAME = @SCH_NAME;
	
	
	-- 마스터 최초 등록시
	IF @SCH_SEQ IS NULL
	BEGIN
	    INSERT INTO VGLog..APP_SCH_MASTER
	      (
	        SCH_NAME
	       ,SCH_TYPE
	       ,[HOST_NAME]
	       ,NEW_DATE
	      )
	    VALUES
	      (
	        @SCH_NAME
	       ,@SCH_TYPE
	       ,@HOST_NAME
	       ,GETDATE()
	      )
	    
	    SELECT @SCH_SEQ = @@IDENTITY;
	END
	
	-- 실행 로그 기록
	IF EXISTS (
	       SELECT 1
	       FROM   VGLog..APP_SCH_LOG WITH(NOLOCK)
	       WHERE  SCH_SEQ = @SCH_SEQ
	              AND SCH_DATE = @SCH_DATE
	   )
	BEGIN
	    IF @LAST_RUN_TIME = 0
	    BEGIN
	        -- 로그 업데이트
	        UPDATE ASL
	        SET    ASL.EXEC_COUNT = (ISNULL(ASL.EXEC_COUNT ,0) + 1)
	        FROM   VGLog.dbo.APP_SCH_LOG ASL
	        WHERE  ASL.SCH_SEQ = @SCH_SEQ
	               AND ASL.SCH_DATE = @SCH_DATE;
	    END
	END
	ELSE
	BEGIN
	    -- 로그 등록
	    INSERT INTO VGLog..APP_SCH_LOG
	      (
	        SCH_SEQ
	       ,SCH_DATE
	       ,EXEC_COUNT
	       ,ERROR
	       ,NEW_DATE
	      )
	    VALUES
	      (
	        @SCH_SEQ
	       ,@SCH_DATE
	       ,1
	       ,0
	       ,GETDATE()
	      )
	END
	
	-- 마스터 업데이트
	UPDATE VGLog..APP_SCH_MASTER
	SET    LAST_RUN_DATE = GETDATE()
	      ,LAST_RUN_REMARK = @LAST_RUN_REMARK
	      ,LAST_RUN_TIME = @TIME
	      ,HOST_NAME = @HOST_NAME
	WHERE  SCH_SEQ = @SCH_SEQ
	
	SELECT @SCH_SEQ;
END


GO
