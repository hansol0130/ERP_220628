USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


create view [dbo].[damo_dba_objects] as
/********************************************************************************
*** dba_objects *****
[----]
  database---- table/index/trigger/function/view/procedure ---- ---- (all objects in the database)
[data]
  - index-- ------ -------- ----
	db_name() as owner                        		-- db --
	user_name(uid)+'.'+name as object_name           -------- --------.------         
	cast(id as char) as object_id			------id                        
	case xtype 
		when 'U' then 'table'             
		when 'TR'then 'trigger'           
		when 'fn'then 'function'          
		when 'if'then 'function'          
		when 'tf'then 'function'          
		when 'V' then 'view'              
		when 'p' then 'procedure'         
	end as object_type 				-- --------
	
- index-- ---- ----
	db_name() as owner      						-- db --
	user_name(objectproperty( id, 'ownerid' ))+'.'+name as object_name	--index-- ------ -------- --------.index --   
	rtrim(cast(id as char))+'-'+ cast(indid as char) as object_id   		-- index id
	'index' as object_type  						-- --------
	
[from]
  - sql2000
    sysobjects
    sysindexes
  - sql2005
    sys.objects
    sys.indexes
    sys.stats
    
[result values]        
testfordamo	dbo.sales	5575058                       	table
testfordamo	dbo.titleauthor	21575115                      	table
testfordamo	dbo.rename_obj	242099903                     	procedure
testfordamo	dbo.grant_obj	258099960                     	procedure

[--------]
  - sql2000/sql2005-- ---- -------- ------
  - index-- ----, ---- database -------- ------ ------------ ------,
     ------ id---- index-- ------ table/view-- id-- --------------------
       
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
--============================sql2005
/* type-- type_desx-- value ----
AF = ---- ----(clr)	(	aggregate_function	)
C = check ---- ----	(	check_constraint	)
D = default(---- ---- ---- ---- ------)	(	default_constraint	)
F = foreign key ---- ----	(	foreign_key_constraint	)
PK = primary key ---- ----	(	primary_key_constraint	)
P = sql ---- --------	(	sql_stored_procedure	)
PC = --------(clr) ---- --------	(	clr_stored_procedure	)
FN = sql ------ ----	(	sql_scalar_function	)
FS = --------(clr) ------ ----	(	clr_scalar_function	)
FT = --------(clr) ------ -- ----	(	clr_table_valued_function	)
R = ----(---- ------, ---- ------)	(	rule	)
RF = ---- ---- --------	(	replication_filter_procedure	)
SN = ------	(	synonym	)
SQ = ------ --	(	service_queue	)
TA = --------(clr) dml ------	(	clr_trigger	)
TR = sql dml ------	(	sql_trigger	)
IF = sql ------ ------ -- ----	(	sql_inline_table_valued_function	)
TF = sql ------ -- ----	(	sql_table_valued_function	)
U = ------(------ ----)	(	user_table	)
UQ = unique ---- ----	(	unique_constraint	)
V = --	(	view	)
X = ---- ---- --------	(	extended_stored_procedure	)
IT = ---- ------	(	internal_table	)
*/
--================sql 2005
-- index-- ------ object ------ ------
select db_name() as owner
	 , schema_name(schema_id) +'.'+name as object_name                          
	,cast(object_id as char)as object_id
	,case type 
		when 'U' then 'table'             
		when 'TR'then 'trigger'           
		when 'FN'then 'function'          
		when 'IF'then 'function'          
		when 'TF'then 'function'          
		when 'V' then 'view'              
		when 'P' then 'procedure'         
	end as object_type 
from sys.objects
where type in ('U', 'TR', 'FN', 'IF', 'TF', 'V', 'P')
and name not like 'sys%' 
union all
select distinct db_name() as owner 
, user_name(objectproperty( si.object_id, 'ownerid' )) +'.'+ si.name as object_name
	,rtrim(cast(si.object_id as char))+'-'+ cast(si.index_id as char) as object_id  
	, 'index' as object_type
from sys.indexes si join sys.stats ss
		on si.index_id = ss.stats_id
where object_name(si.object_id) not like 'damo_dba_%'
	and si.index_id between 1 and 254 -- heap---- ------ text/image type-- ---- ---- ---- ----
GO
