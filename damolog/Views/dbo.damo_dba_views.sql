USE [damolog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



create view [dbo].[damo_dba_views] as
/********************************************************************************
*** dba_views *****
[----]
db---- ---- view ---- ---- (description of all views in the database)

[data]
	db_name() as owner
	table_schema +'.'+table_name  as view_name

[from]
INFORMATION_SCHEMA.VIEWS
        
[--------]
 : sql 2000-- sql2005-- -------- ----

[result values]
testfordamo	dbo.titleview
testfordamo	dbo.syssegments
testfordamo	dbo.sysconstraints
        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
-- dba_views : description of all views in the database
select 	 db_name() as owner
	,table_schema +'.'+table_name as view_name
from INFORMATION_SCHEMA.VIEWS
where table_name not like 'damo_dba_%' 
GO
