USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_JOB_SCHEDULE_LIST
■ DESCRIPTION				: DB 작업 스케줄러 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-09-28		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_JOB_SCHEDULE_LIST]
AS 
BEGIN
	SELECT
		SJ.Name AS JOB_NAME,
		[JOB_STATUS] = 
				CASE 
					WHEN SJ.Enabled = 1 THEN '사용' 
					ELSE '사용안함' 
				END,
		JOB_LAST_RESULT = 
				CASE 
					WHEN SJS.Last_Run_OutCome = 0 THEN '실패' 
					WHEN SJS.Last_Run_OutCome = 1 THEN '성공' 
					WHEN SJS.Last_Run_OutCome = 2 THEN '다시시도중' 
					WHEN SJS.Last_Run_OutCome = 3 THEN '취소' 
					WHEN SJS.Last_Run_OutCome = 4 THEN '실행중' 
					ELSE '알수없음' 
				END,
		JOB_LAST_RUNDATE =  
				CASE 
					WHEN SJS.Last_Run_Date = 0 OR SJS.Last_Run_Date IS NULL THEN NULL 
					ELSE SJS.Last_Run_Date 
				END,
		JOB_LAST_RUNTIME = 
				CASE 
					WHEN SJS.Last_Run_Time = 0 OR SJS.Last_Run_Time IS NULL THEN NULL 
					ELSE CONVERT(VARCHAR(10),(SJS.Last_Run_Time / 10000))+'시'+CONVERT(VARCHAR(10),(SJS.Last_Run_Time % 10000) / 100)+'분' 
				END,
		JOB_NEXT_RUNDATE = 
				CASE 
					WHEN SJSCH.Next_Run_Date = 0 OR SJSCH.Next_Run_Date IS NULL THEN NULL 
					ELSE SJSCH.Next_Run_Date 
				END,
		JOB_NEXT_RUNTIME = 
				CASE 
					WHEN SJSCH.Next_Run_Time = 0 OR SJSCH.Next_Run_Time IS NULL THEN NULL 
					ELSE CONVERT(VARCHAR(10),(SJSCH.Next_Run_Time / 10000))+'시'+CONVERT(VARCHAR(10),(SJSCH.Next_Run_Time % 10000) / 100)+'분' 
				END,
		JOB_DURATION_SEC = 
				CASE 
					WHEN SJS.Last_Run_Duration = 0 OR SJS.Last_Run_Duration IS NULL THEN NULL 
					ELSE CONVERT(INT, (SJS.Last_Run_Duration/10000 * 3600 ) + ((SJS.Last_Run_Duration / 100 % 100) * 60) + (SJS.Last_Run_Duration % 100 )) 
				END
    FROM
            msdb.dbo.SysJobs AS SJ WITH(READUNCOMMITTED)
            LEFT JOIN MSDB.dbo.SysJobServers AS SJS WITH(READUNCOMMITTED) ON SJ.Job_Id = SJS.Job_Id
            LEFT JOIN MSDB.dbo.SysJobSchedules AS SJSCH WITH(READUNCOMMITTED) ON SJ.Job_Id = SJSCH.Job_Id
    ORDER BY
            SJS.Last_Run_Date, SJS.Last_Run_Time
END
	
GO
