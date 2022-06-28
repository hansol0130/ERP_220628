USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





create view [dbo].[damo_dba_users] as
/********************************************************************************
*** !!!!!!! dba_users *****
[----]
ms sql server-- userid list---- ----(information about all users of the database)

[data]
 name as username
	,'' as password
	,'' as account_status -- -------- ----
	,create_date
	
[from]
- sql server 2005
  sys.database_principals
        
[--------]
 : sql 2000-- sql2005-- ------ ----

[result values]
dbo			2003-04-08 09:10:42.287
guest			2003-04-08 09:10:42.317
information_schema			2005-10-14 01:36:18.080
sys			2005-10-14 01:36:18.080
sql2			2006-06-29 16:26:54.123
        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
-- ================================sql 2005
select name as username
	,'' as password
	,'' as account_status -- -------- ----
	,create_date
from  sys.database_principals
where type in ('S', 'G', 'U')
GO
