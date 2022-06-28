USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create view [dbo].[damo_dba_table_comments] as
/********************************************************************************
*** !!!!!!!!! damo_dba_table_comments *****
[----]
	-------- ---- ---- ---- ---- (comments on columns of all tables and views)

[data]
	db_name() as owner  					-	db --
	 table_schema+'.'+table_name  as table_name		-	------(------).------
	column_name						-	------
	as comments						-	-------- :  null-- ------
[from]
	INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
[result values]
testfordamo	dbo.sales	ord_date	
testfordamo	dbo.sales	ord_num	
testfordamo	dbo.employee	minit	

[--------]
	- sql 2000-- sql2005-- -------- ----
  - column_id = 0 -- ------ ------ ------

[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
SELECT
top 100 percent db_name() as owner,
SCHEMA_NAME(tbl.schema_id)+'.'+tbl.name AS [table_name],
SCHEMA_NAME(tbl.schema_id) AS [schema_name],
tbl.name AS [table_name_only],
clmns.column_id AS [column_id],
clmns.name AS [column_name],
p.name AS [property_name],
CAST(p.value AS sql_variant) AS [comments]
FROM
sys.tables AS tbl
INNER JOIN sys.all_columns AS clmns ON clmns.object_id=tbl.object_id
INNER JOIN sys.extended_properties AS p ON p.major_id=clmns.object_id AND p.minor_id=clmns.column_id AND p.class=1
where tbl.name not like 'damo_dba_%'
UNION
SELECT
top 100 percent db_name() as owner,
SCHEMA_NAME(tbl.schema_id)+'.'+tbl.name AS [table_name],
SCHEMA_NAME(tbl.schema_id) AS [schema],
tbl.name AS [table_name_only],
p.minor_id AS [column_id],
'' AS [column_name],
p.name AS [property_name],
CAST(p.value AS sql_variant) AS [comments]
FROM
sys.tables AS tbl
INNER JOIN sys.extended_properties AS p ON p.major_id=tbl.object_id and p.minor_id=0 AND p.class=1
where tbl.name not like 'damo_dba_%'
ORDER BY
[table_name] ASC,[column_id] ASC,[property_name] ASC
  
/*
SELECT
	db_name() as owner,
	SCHEMA_NAME(tbl.schema_id)+'.'+tbl.name as table_name,
	clmns.name AS [column_name],
	SCHEMA_NAME(tbl.schema_id) AS [t_schema],
	tbl.name AS [t_name],
	clmns.column_id AS [column_id],
	CAST(p.value AS varchar(4096)) AS [comments]
FROM
	sys.tables AS tbl
	INNER JOIN sys.columns AS clmns ON clmns.object_id=tbl.object_id
	INNER JOIN sys.extended_properties AS p ON p.major_id=clmns.object_id AND p.minor_id=clmns.column_id AND p.class=1
WHERE p.name = 'MS_Description'
*/
GO
