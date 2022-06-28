USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



create view [dbo].[damo_dba_roles] as
/********************************************************************************
*** dba_roles *****
[----] 	
  all roles which exist in the database 
[data]
	 name	-	role --
[from]
- sql 2000
  sysusers
- sql2005
  sys.database_principals
[result values]        

[--------]
- sql2000/sql2005-- ---- -------- ------
- ---- database role-- ---- ------ -------- ----
        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
--==================sql 2005
select name as role
from sys.database_principals
where type = 'R'
GO
