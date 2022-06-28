USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create view [dbo].[damo_dba_trigger_cols] as
/********************************************************************************
*** !!!! dba_trigger_cols *****
[----]
  column usage in all triggers
[data]
	db_name() as trigger_owner						- db --
	,schema_name(schema_id)+'.'+ name		- ------ ------.------ --
	,user_name(objectproperty(parent_object_id, 'ownerid' ))as table_owner -	-------- ------ ------ ------
	,schema_name(schema_id)+'.'+object_name(parent_object_id)			- 	-------- ------ ------ --
	, '' as column_name 							- 	-------- ------ ---- -- ( ms sql server------ ---- ---- )
	, '' as column_list							- 	-------- ------ ---- --( ms sql server------ ---- ---- )

[from] 
   sys.objects
        
[--------] 
  -- sql 2000-- sql 2005-- ---- ------ ----
  -- -------- ------ column-- ------ -------- ----

[result valeus]
testfordamo	dbo.trig2	dbo	dbo.authors		
testfordamo	dbo.updemployeedata	dbo	dbo.employeedata		
testfordamo	dbo.employee_insupd	dbo	dbo.employee		
        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
-- sql server 2005------------------------------
select	db_name() as trigger_owner
	, schema_name(schema_id)+'.'+ name as trigger_name
	,user_name(objectproperty(parent_object_id, 'ownerid' )) as table_owner
	,schema_name(schema_id)+'.'+object_name(parent_object_id) as table_name
	, '' as column_name
	, '' as column_list
from sys.objects
where 	type = 'TR'
GO
