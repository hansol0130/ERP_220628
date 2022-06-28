USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


create view [dbo].[damo_dba_triggers] as
/********************************************************************************
*** dba_triggers *****
[----]
  all triggers in the database
[data]
		db_name() as owner -- 	db --
		,  schema_name(schema_id)+'.'+so.name as trigger_name
		, case when objectproperty(so.object_id, 'execisaftertrigger') = 1 then 'after' 
		when objectproperty(so.object_id, 'execisinsteadoftrigger') = 1 then 'before' end as trigger_type
		, substring(case when objectproperty(so.object_id, 'execisupdatetrigger') = 1 then 'update , ' else '' end 
		+ case when objectproperty(so.object_id, 'execisdeletetrigger') = 1 then 'delete , ' else '' end 
		+ case when objectproperty(so.object_id, 'execisinserttrigger') = 1 then 'insert , ' else '' end
		, 0
		, datalength(case when objectproperty(so.object_id, 'execisupdatetrigger') = 1 then 'update , ' else '' end 
		+ case when objectproperty(so.object_id, 'execisdeletetrigger')= 1 then 'delete , ' else '' end 
		+ case when objectproperty(so.object_id, 'execisinserttrigger') = 1 then 'insert , ' else '' end) - 1) as triggering_event
		, db_name() as table_owner
		, case when objectproperty(so.parent_object_id, 'istable')= 1 then 'table' when objectproperty(so.parent_object_id, 'isview') = 1 then 'view' end as base_object_type-- -------- ------ ------ ---- (table/view)
		, schema_name(schema_id)+'.' + object_name(so.parent_object_id) as table_name---------- ------ -------- --------.-------- ------ ---- --
		, '' as column_name
		, '' as referencing_names
		, '' as when_clause
		, case when objectproperty(so.object_id, 'execistriggerdisabled')= 1 then 'disabled' else 'enabled' end as status				-- -------- ------------ ----
		, sc.definition as trigger_body					-- -------- ---- ----
[from]
- sql server 2000
  sysobjects as so
  syscomments as sc

[results values]
     
[--------]
- sql 2000-- sql 2005-- ---- ------ ----

        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
-- dba_triggers : all triggers in the database
select     db_name() as owner
		,  schema_name(schema_id)+'.'+so.name as trigger_name
		, case when objectproperty(so.object_id, 'execisaftertrigger') = 1 then 'after' 
		when objectproperty(so.object_id, 'execisinsteadoftrigger') = 1 then 'before' end as trigger_type
		, substring(case when objectproperty(so.object_id, 'execisupdatetrigger') = 1 then 'update , ' else '' end 
		+ case when objectproperty(so.object_id, 'execisdeletetrigger') = 1 then 'delete , ' else '' end 
		+ case when objectproperty(so.object_id, 'execisinserttrigger') = 1 then 'insert , ' else '' end
		, 0
		, datalength(case when objectproperty(so.object_id, 'execisupdatetrigger') = 1 then 'update , ' else '' end 
		+ case when objectproperty(so.object_id, 'execisdeletetrigger')= 1 then 'delete , ' else '' end 
		+ case when objectproperty(so.object_id, 'execisinserttrigger') = 1 then 'insert , ' else '' end) - 1) as triggering_event
		, db_name() as table_owner
		, case when objectproperty(so.parent_object_id, 'istable')= 1 then 'table' when objectproperty(so.parent_object_id, 'isview') = 1 then 'view' end as base_object_type
		, schema_name(schema_id)+'.' + object_name(so.parent_object_id) as table_name
		, '' as column_name
		, '' as referencing_names
		, '' as when_clause
		, case when objectproperty(so.object_id, 'execistriggerdisabled')= 1 then 'disabled' else 'enabled' end as status
		, sc.definition as trigger_body
from         sys.objects as so inner join
                      sys.sql_modules as sc on so.object_id = sc.object_id
where     (so.type = 'TR')

GO
