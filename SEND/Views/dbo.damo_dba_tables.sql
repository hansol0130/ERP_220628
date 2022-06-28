USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


create view [dbo].[damo_dba_tables] as
/********************************************************************************
*** dba_tables *****
[----]
  description of all relational tables in the database
[data]
	db_name() as owner
	table_schema +'.'+table_name as table_name
	'N' as temporary -- ------------ ------ ----
	,table_type  -- ---------- -------- ---- ------
	
[from]
  INFORMATION_SCHEMA.TABLES
        
[--------]
- sql 2000-- sql2005-- -------- ----


[result values]
testfordamo	dbo.auditemployeedata	n
testfordamo	dbo.authors	n
testfordamo	dbo.discounts	n
testfordamo	dbo.employee	n

        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
select 	db_name() as owner
	,TABLE_SCHEMA +'.'+TABLE_NAME as table_name
	,'N' as temporary -- ------------ ------ ----
	,TABLE_TYPE as table_type 
from INFORMATION_SCHEMA.TABLES
where TABLE_NAME not like 'damo_dba_%' 
GO
