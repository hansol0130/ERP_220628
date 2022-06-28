USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************
내용: sp를이용한 trace 파일관리
Parameters :
	@Options : 2 - Roll over. MaxFileSize에 도달하면 새파일 생성후 계속해서 자료수집.
	@MaxFileSize : 한개의 추적 파일에 대한 최대 크기 지정. MB 단위.
	@StopTime : 추적 파일 수집을 자동으로 중지하려는 시각 설정(NULL:수동으로중지)
	@OutputFolder : .trc 파일이 생성될 폴더
사용예: 
	--sp수행(return value 가 1이면 정상적으로 시작됨.)
	exec uspTrace
	--현재 수행 중인 모든 trace 확인
	SELECT * FROM :: fn_trace_getinfo(default) 
	--특정 trace id 중지
	exec sp_trace_setstatus @traceid = 2, @status = 0
	--특정 trace id 삭제
	exec sp_trace_setstatus @traceid = 2, @status = 2
*********************************************************/

--use diablo

--drop proc uspTrace

CREATE PROC [dbo].[USP_TRACE]
(
	@maxfilesize bigint = 300,
	@Options int = 2,
	@stopTime datetime = '2014-12-12 18:00:00.000',
	@OutputFolder varchar(100) = 'D:\Trace\TraceData'
)
as

-- Create a Queue
declare @rc int
declare @TraceID int
declare @FileName sysname
-- Filename은 MyTrace+수집시작시각.trc 형태로 수집됨. (예: MyTrace200911101545.trc)
set @FileName = @OutputFolder+'TRC'+ REPLACE(REPLACE(REPLACE(CONVERT(varchar(16),getdate(),120),':',''),'-',''),' ','') 

exec @rc = sp_trace_create @TraceID output, @options=@Options, @tracefile=@FileName, @maxfilesize=@MaxFileSize, @stoptime=@StopTime

if (@rc != 0) goto error

-- Client side File and Table cannot be scripted

-- Set the events
declare @on bit
set @on = 1
exec sp_trace_setevent @TraceID, 16, 15, @on
exec sp_trace_setevent @TraceID, 16, 12, @on
exec sp_trace_setevent @TraceID, 16, 9, @on
exec sp_trace_setevent @TraceID, 16, 13, @on
exec sp_trace_setevent @TraceID, 16, 6, @on
exec sp_trace_setevent @TraceID, 16, 10, @on
exec sp_trace_setevent @TraceID, 16, 14, @on
exec sp_trace_setevent @TraceID, 16, 11, @on
exec sp_trace_setevent @TraceID, 33, 1, @on
exec sp_trace_setevent @TraceID, 33, 9, @on
exec sp_trace_setevent @TraceID, 33, 6, @on
exec sp_trace_setevent @TraceID, 33, 10, @on
exec sp_trace_setevent @TraceID, 33, 14, @on
exec sp_trace_setevent @TraceID, 33, 11, @on
exec sp_trace_setevent @TraceID, 33, 12, @on
exec sp_trace_setevent @TraceID, 67, 1, @on
exec sp_trace_setevent @TraceID, 67, 9, @on
exec sp_trace_setevent @TraceID, 67, 13, @on
exec sp_trace_setevent @TraceID, 67, 6, @on
exec sp_trace_setevent @TraceID, 67, 10, @on
exec sp_trace_setevent @TraceID, 67, 14, @on
exec sp_trace_setevent @TraceID, 67, 11, @on
exec sp_trace_setevent @TraceID, 67, 12, @on
exec sp_trace_setevent @TraceID, 79, 1, @on
exec sp_trace_setevent @TraceID, 79, 9, @on
exec sp_trace_setevent @TraceID, 79, 6, @on
exec sp_trace_setevent @TraceID, 79, 10, @on
exec sp_trace_setevent @TraceID, 79, 14, @on
exec sp_trace_setevent @TraceID, 79, 11, @on
exec sp_trace_setevent @TraceID, 79, 12, @on
exec sp_trace_setevent @TraceID, 80, 12, @on
exec sp_trace_setevent @TraceID, 80, 9, @on
exec sp_trace_setevent @TraceID, 80, 6, @on
exec sp_trace_setevent @TraceID, 80, 10, @on
exec sp_trace_setevent @TraceID, 80, 14, @on
exec sp_trace_setevent @TraceID, 80, 11, @on
exec sp_trace_setevent @TraceID, 69, 9, @on
exec sp_trace_setevent @TraceID, 69, 6, @on
exec sp_trace_setevent @TraceID, 69, 10, @on
exec sp_trace_setevent @TraceID, 69, 14, @on
exec sp_trace_setevent @TraceID, 69, 11, @on
exec sp_trace_setevent @TraceID, 69, 12, @on
exec sp_trace_setevent @TraceID, 162, 1, @on
exec sp_trace_setevent @TraceID, 162, 9, @on
exec sp_trace_setevent @TraceID, 162, 6, @on
exec sp_trace_setevent @TraceID, 162, 10, @on
exec sp_trace_setevent @TraceID, 162, 14, @on
exec sp_trace_setevent @TraceID, 162, 11, @on
exec sp_trace_setevent @TraceID, 162, 12, @on
exec sp_trace_setevent @TraceID, 148, 11, @on
exec sp_trace_setevent @TraceID, 148, 12, @on
exec sp_trace_setevent @TraceID, 148, 14, @on
exec sp_trace_setevent @TraceID, 148, 1, @on
exec sp_trace_setevent @TraceID, 25, 15, @on
exec sp_trace_setevent @TraceID, 25, 1, @on
exec sp_trace_setevent @TraceID, 25, 9, @on
exec sp_trace_setevent @TraceID, 25, 2, @on
exec sp_trace_setevent @TraceID, 25, 10, @on
exec sp_trace_setevent @TraceID, 25, 11, @on
exec sp_trace_setevent @TraceID, 25, 12, @on
exec sp_trace_setevent @TraceID, 25, 13, @on
exec sp_trace_setevent @TraceID, 25, 6, @on
exec sp_trace_setevent @TraceID, 25, 14, @on
exec sp_trace_setevent @TraceID, 59, 1, @on
exec sp_trace_setevent @TraceID, 59, 2, @on
exec sp_trace_setevent @TraceID, 59, 14, @on
exec sp_trace_setevent @TraceID, 59, 12, @on
exec sp_trace_setevent @TraceID, 23, 1, @on
exec sp_trace_setevent @TraceID, 23, 9, @on
exec sp_trace_setevent @TraceID, 23, 2, @on
exec sp_trace_setevent @TraceID, 23, 6, @on
exec sp_trace_setevent @TraceID, 23, 10, @on
exec sp_trace_setevent @TraceID, 23, 14, @on
exec sp_trace_setevent @TraceID, 23, 11, @on
exec sp_trace_setevent @TraceID, 23, 12, @on
exec sp_trace_setevent @TraceID, 27, 15, @on
exec sp_trace_setevent @TraceID, 27, 1, @on
exec sp_trace_setevent @TraceID, 27, 9, @on
exec sp_trace_setevent @TraceID, 27, 2, @on
exec sp_trace_setevent @TraceID, 27, 10, @on
exec sp_trace_setevent @TraceID, 27, 11, @on
exec sp_trace_setevent @TraceID, 27, 12, @on
exec sp_trace_setevent @TraceID, 27, 13, @on
exec sp_trace_setevent @TraceID, 27, 6, @on
exec sp_trace_setevent @TraceID, 27, 14, @on
exec sp_trace_setevent @TraceID, 10, 15, @on
exec sp_trace_setevent @TraceID, 10, 16, @on
exec sp_trace_setevent @TraceID, 10, 9, @on
exec sp_trace_setevent @TraceID, 10, 17, @on
exec sp_trace_setevent @TraceID, 10, 2, @on
exec sp_trace_setevent @TraceID, 10, 10, @on
exec sp_trace_setevent @TraceID, 10, 18, @on
exec sp_trace_setevent @TraceID, 10, 11, @on
exec sp_trace_setevent @TraceID, 10, 12, @on
exec sp_trace_setevent @TraceID, 10, 13, @on
exec sp_trace_setevent @TraceID, 10, 6, @on
exec sp_trace_setevent @TraceID, 10, 14, @on
exec sp_trace_setevent @TraceID, 12, 15, @on
exec sp_trace_setevent @TraceID, 12, 16, @on
exec sp_trace_setevent @TraceID, 12, 1, @on
exec sp_trace_setevent @TraceID, 12, 9, @on
exec sp_trace_setevent @TraceID, 12, 17, @on
exec sp_trace_setevent @TraceID, 12, 6, @on
exec sp_trace_setevent @TraceID, 12, 10, @on
exec sp_trace_setevent @TraceID, 12, 14, @on
exec sp_trace_setevent @TraceID, 12, 18, @on
exec sp_trace_setevent @TraceID, 12, 11, @on
exec sp_trace_setevent @TraceID, 12, 12, @on
exec sp_trace_setevent @TraceID, 12, 13, @on
exec sp_trace_setevent @TraceID, 13, 1, @on
exec sp_trace_setevent @TraceID, 13, 9, @on
exec sp_trace_setevent @TraceID, 13, 6, @on
exec sp_trace_setevent @TraceID, 13, 10, @on
exec sp_trace_setevent @TraceID, 13, 14, @on
exec sp_trace_setevent @TraceID, 13, 11, @on
exec sp_trace_setevent @TraceID, 13, 12, @on
exec sp_trace_setevent @TraceID, 50, 15, @on
exec sp_trace_setevent @TraceID, 50, 1, @on
exec sp_trace_setevent @TraceID, 50, 9, @on
exec sp_trace_setevent @TraceID, 50, 6, @on
exec sp_trace_setevent @TraceID, 50, 10, @on
exec sp_trace_setevent @TraceID, 50, 14, @on
exec sp_trace_setevent @TraceID, 50, 11, @on
exec sp_trace_setevent @TraceID, 50, 12, @on
exec sp_trace_setevent @TraceID, 50, 13, @on


-- Set the Filters
declare @intfilter int
declare @bigintfilter bigint

exec sp_trace_setfilter @TraceID, 10, 0, 7, N'SQL Server 프로파일러 - dec47bc4-b052-4a71-a018-d4068abf06a5'
-- Set the trace status to start
exec sp_trace_setstatus @TraceID, 1

-- display trace id for future references
select TraceID=@TraceID
goto finish

error: 
select ErrorCode=@rc

finish: 
GO
