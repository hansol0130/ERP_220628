USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


create view [dbo].[damo_dba_jobs] as
/********************************************************************************
*** dba_jobs *****
[----]
  ------ ------ ---- -------- ( all jobs in the database )
[data]
	sj.job_id as job
	,user_name(sj.owner_sid) as schema_user
	,case sjh.run_status when 1 then 'Y' else 'N' end as broken
	,sjs.command as what

[from]
msdb.dbo.sysjobs sj 
left outer join msdb.dbo.sysjobhistory sjh
	on sj.job_id = sjh.job_id
left outer join msdb.dbo.sysjobsteps sjs
	on sj.job_id = sjs.job_id

[result values]       

[--------]
- sql 2000-- sql2005-- -------- ----
        
*** -------- ***
	- ----
	- ----
	- ----
******************************************************************************/
select distinct sj.job_id as job
		,user_name(sj.owner_sid) as schema_user
		,case sjh.run_status when 1 then 'Y' else 'N' end as broken
		,sjs.command as what
from msdb.dbo.sysjobs sj 
	left outer join msdb.dbo.sysjobhistory sjh
		on sj.job_id = sjh.job_id
	left outer join msdb.dbo.sysjobsteps sjs
		on sj.job_id = sjs.job_id

GO
