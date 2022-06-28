USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_JOB_SCHEDULE_MASTER_REGISTER
■ DESCRIPTION				: DB 작업 스케줄러 마스터 입력 / 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	SELECT * FROM VGLog..SYS_SCH_MASTER WITH(NOLOCK);
	EXEC SP_JOB_SCHEDULE_MASTER_REGISTER '테스트1', 0, '정군님' ,'등록완료'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-10-06		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_JOB_SCHEDULE_MASTER_REGISTER]
	@SCH_NAME VARCHAR(100),
	@SCH_TYPE INT,
	@HOST_NAME VARCHAR(30),
	@LAST_RUN_REMARK VARCHAR(50)
AS 
BEGIN
	DECLARE @SCH_SEQ INT;
	IF EXISTS ( SELECT 1 FROM VGLog..SYS_SCH_MASTER WITH(NOLOCK) WHERE SCH_NAME = @SCH_NAME AND SCH_TYPE = @SCH_TYPE )
		BEGIN
			UPDATE VGLog..SYS_SCH_MASTER SET
				@SCH_SEQ = SCH_SEQ, HOST_NAME = @HOST_NAME, LAST_RUN_DATE = GETDATE(), LAST_RUN_REMARK = @LAST_RUN_REMARK, EDT_DATE = GETDATE()
			WHERE SCH_NAME = @SCH_NAME AND SCH_TYPE = @SCH_TYPE;
		END
	ELSE
		BEGIN
			INSERT INTO VGLog..SYS_SCH_MASTER ( SCH_NAME, SCH_TYPE, HOST_NAME, NEW_DATE )
			VALUES ( @SCH_NAME, @SCH_TYPE, @HOST_NAME, GETDATE() )
			
			SET @SCH_SEQ = @@IDENTITY;
		END

	SELECT @SCH_SEQ;
END
	
GO
