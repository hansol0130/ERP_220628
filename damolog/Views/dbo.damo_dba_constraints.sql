USE [damolog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


create view [dbo].[damo_dba_constraints] as
/********************************************************************************
*** dba_constraints *****
[----]
	---- -------- ---------- ---- ---------- ---- ---- ---- (constraint definitions on all tables )
	pk/fk/check/unique -- ---- ------ ----
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
select 	 db_name()  as owner 
	,tc.TABLE_SCHEMA+'.'+tc.CONSTRAINT_NAME as constraint_name
	,tc.CONSTRAINT_TYPE as constraint_type
	,tc.TABLE_SCHEMA+'.'+tc.TABLE_NAME as table_name
	,cc.CHECK_CLAUSE as search_condition
	,rc.UNIQUE_CONSTRAINT_SCHEMA as r_owner
	,rc.UNIQUE_CONSTRAINT_NAME as r_constraint_name
	,case objectproperty(object_id(tc.CONSTRAINT_NAME), 'CnstIsDisabled')
		when 1 then 'DISABLED'
	else 'ENABLED' end as status
from  INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
	left outer join INFORMATION_SCHEMA.CHECK_CONSTRAINTS cc
		on tc.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
	left outer join INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
		on tc.CONSTRAINT_NAME = rc.CONSTRAINT_NAME
where TABLE_NAME not like 'damo_dba_%' 
GO
