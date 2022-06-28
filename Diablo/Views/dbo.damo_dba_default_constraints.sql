USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create view [dbo].[damo_dba_default_constraints] as
/********************************************************************************
*** damo_dba_default_constraints *****
[----]
	---- -------- ---------- ---- default ---------- ---- ---- ---- (default constraint definitions on all tables )
	
[data]
	db_name() as owner  							-	db --
	,tc.table_schema+'.'+tc.constraint_name as constraint_name	-	------(------).----------	
	tc.constraint_type                            		    			-	-------- ---- (pk/fk/chekc/unique)
	tc.table_schema+'.'+tc.table_name as table_name			-	------(------).--------
	cc.check_clause as search_condition               			-	check-- ----
	rc.unique_constraint_schema as r_owner            			-	fk-- -------- ------ ------
	rc.unique_constraint_name as r_constraint_name    			-	fk-- -------- -------- ------
	case objectproperty(object_id(tc.constraint_name), 'cnstisdisabled')
		when 1 then 'disabled' 	else 'enabled' end as status		-	---------- --------(enabled/disabled-enabled-- ------)
[from]
	INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
	INFORMATION_SCHEMA.CHECK_CONSTRAINTS cc
	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
[result values]
testfordamo	dbo.ck__authors__au_id__0daf0cb0	check	dbo.authors	([au_id] like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]')	null	null	enabled
testfordamo	dbo.ck__authors__zip__0ea330e9	check	dbo.authors	([zip] like '[0-9][0-9][0-9][0-9][0-9]')	null	null	enabled
testfordamo	dbo.ck__jobs__max_lvl__108b795b	check	dbo.jobs	([max_lvl] <= 250)	null	null	enabled

[--------]
	- sql 2000-- sql2005-- -------- ----
	- system table-- ---- -------- ------ ------------
        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
select top 100 percent db_name() as owner
    ,SCHEMA_NAME(tbl.schema_id) + '.' + tbl.name AS [table_name]
    ,clmns.name AS [column_name]
    ,clmns.column_id AS [column_id]
    ,cstr.name AS [default_constraints_name]
    ,CAST(cstr.is_system_named AS bit) AS [is_system_named]
    ,cstr.definition AS [data_default]
from
  sys.tables AS tbl
  INNER JOIN sys.all_columns AS clmns ON clmns.object_id=tbl.object_id
  INNER JOIN sys.default_constraints AS cstr ON cstr.object_id=clmns.default_object_id
where tbl.name not like 'damo_dba_%' 
order by
[table_name] asc,[column_id] asc,[column_name] asc
/*
SELECT
SCHEMA_NAME(tbl.schema_id) AS [Table_Schema],
tbl.name AS [Table_Name],
clmns.column_id AS [Column_ID],
clmns.name AS [Column_Name],
cstr.name AS [Name],
CAST(cstr.is_system_named AS bit) AS [IsSystemNamed],
cstr.definition AS [Text]
FROM
sys.tables AS tbl
INNER JOIN sys.all_columns AS clmns ON clmns.object_id=tbl.object_id
INNER JOIN sys.default_constraints AS cstr ON cstr.object_id=clmns.default_object_id
ORDER BY
[Table_Schema] ASC,[Table_Name] ASC,[Column_ID] ASC,[Name] ASC 
*/
GO
