USE [Cuve]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create view [dbo].[damo_dba_cons_columns] as
/********************************************************************************
*** dba_cons_columns *****
[----]
	---------- ------ ---- ---- ---- (information about accessible columns in constraint definitions)
[data]
	db_name() as owner  							-	db --
	constraint_schema+'.'+constraint_name as constraint_name		-	------(------).----------
	table_schema+'.'+table_name as table_name				-	------(------).--------
	column_name     							-	------
[from]
	INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
[result values]   
testfordamo	dbo.ck__authors__au_id__0daf0cb0	dbo.authors	au_id
testfordamo	dbo.upkcl_auidind	dbo.authors	au_id
testfordamo	dbo.ck__authors__zip__0ea330e9	dbo.authors	zip
testfordamo	dbo.fk__discounts__stor___1bfd2c07	dbo.discounts	stor_id

     
[--------]
	-sql 2000-- sql2005-- -------- ----
        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
select	 db_name()  as owner
	,CONSTRAINT_SCHEMA+'.'+CONSTRAINT_NAME as constraint_name
	,TABLE_SCHEMA+'.'+TABLE_NAME as table_name
	,COLUMN_NAME as column_name
from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
where TABLE_NAME not like 'damo_dba_%' 
GO
