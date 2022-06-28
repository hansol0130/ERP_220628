USE [damolog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



create view [dbo].[damo_dba_role_privs] as
/********************************************************************************
*** dba_role_privs *****
[----]
  - user-- role-- ------ role---- ---- (roles granted to users and roles)
  - role-- ---- member ----
[data]
	 user_name(memberuid) as grantee
	,user_name(groupuid) as granted_role
[from]
- sql 2000
   sysmembers
- sql 2005
  sys.database_role_members
[result values]        

[--------]
  - sql2000/sql2005-- ---- -------- ------
  - ---- database role-- ---- ------ -------- ----
        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
--====================sql 2005
select user_name(member_principal_id) as grantee
	,user_name(role_principal_id) as granted_role
from sys.database_role_members
GO
