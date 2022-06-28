USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


create view [dbo].[damo_role_tab_privs] as
/********************************************************************************
*** !!!!!!! role_tab_privs *****
[----]
'references'------ ------ dml ------------

[data]
	grantee as role
	, db_name() as owner
	,table_schema+'.'+table_name  as table_name 
	,privilege_type as privilege

[from]
INFORMATION_SCHEMA.COLUMN_PRIVILEGES
        
[--------]

[result values]
guest	testfordamo	dbo.sales	select
guest	testfordamo	dbo.sales	select
guest	testfordamo	dbo.sales	select
guest	testfordamo	dbo.sales	select
guest	testfordamo	dbo.sales	select

        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
select 	GRANTEE as role
	, db_name() as owner
	,TABLE_SCHEMA+'.'+TABLE_NAME  as table_name 
	,PRIVILEGE_TYPE as privilege
from INFORMATION_SCHEMA.COLUMN_PRIVILEGES
where PRIVILEGE_TYPE != 'REFERENCES'
and TABLE_NAME not like 'damo_dba_%' 
GO
