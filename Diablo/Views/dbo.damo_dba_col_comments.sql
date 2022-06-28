USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create view [dbo].[damo_dba_col_comments] as
/********************************************************************************
*** !!!!!!!!! dba_col_comments *****
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
select db_name() as owner 
	, TABLE_SCHEMA+'.'+TABLE_NAME  as table_name
	,COLUMN_NAME as column_name
	,''	as comments
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME not like 'damo_dba_%'  
  
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
