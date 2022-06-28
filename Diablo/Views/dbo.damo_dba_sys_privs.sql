USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create view [dbo].[damo_dba_sys_privs] as
/********************************************************************************
*** dba_sys_privs *****
[----]
-------- role-- ------ dcl/ddl--------(grant ----------) (system privileges granted to users and roles)

[data]
	user_name(uid) as grantee	-	------ ---- role --
	,sv.name as privilege		-	------ ------

[from]
- sql2000
  sysprotects
- sql2005
  sys.server_permissions
  sys.database_permissions
        
[--------]
- sql2000/sql2005-- ---- -------- ------  

[result values]  
        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
/*
grant ------ ------ ---- --.
--> ---- test--, deny ------ ------ ------ ---------- ---------- ---- ----
*/
--====================sql2005
select distinct user_name(grantee_principal_id) as grantee
		,permission_name as privilege
from sys.server_permissions 
where state = 'G'
union all
select distinct user_name(grantee_principal_id)
		,permission_name
from sys.database_permissions 
where state = 'G'
GO
