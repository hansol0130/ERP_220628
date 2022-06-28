USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



create view [dbo].[damo_v$session] as
/********************************************************************************
*** !!!!!!!!v$session *****
[----]
  ------ session ---- ---- ----
[data]
	  spid as sid           
	  ,spid as serial#             
	  ,spid as audsid              
	  ,user_name(uid) as username  
	  ,cmd as command              
	  ,loginame as osuser          
	  ,hostprocess as process      
	  ,hostname as machine         
	  ,hostname as terminal        
	  ,program_name as program     
	  ,login_time as logon_time    

[from]
  master.dbo.sysprocesses
        
[--------]

        
[--------]
	- ----
	- ----
	- ----
*/
-- =============== sql2005
select 	 spid as sid
	,spid as serial#
	,spid as audsid
	,user_name(uid) as username
	,cmd as command
	,loginame as osuser
	,hostprocess as process
	,hostname as machine
	,hostname as terminal
	,program_name as program
	,login_time as logon_time
from master.dbo.sysprocesses
where spid > 50
GO
