USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



create view [dbo].[damo_dba_tab_privs] as
/********************************************************************************
*** dba_tab_privs *****
[----]
  all grants on objects in the database
[data]
	grantee
	,db_name() as owner
	,table_schema +'.'+table_name as table_name
	,privilege_type as privilege

[from]
  INFORMATION_SCHEMA.TABLE_PRIVILEGES
        
[--------]
 

[result values]
guest	testfordamo	dbo.sales	references
guest	testfordamo	dbo.sales	select
guest	testfordamo	dbo.sales	insert

        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */

select 	 GRANTEE
	,db_name() as owner
	,TABLE_SCHEMA +'.'+TABLE_NAME as table_name
	,PRIVILEGE_TYPE as privilege
from INFORMATION_SCHEMA.TABLE_PRIVILEGES
where TABLE_NAME not like 'damo_dba_%' 
GO
