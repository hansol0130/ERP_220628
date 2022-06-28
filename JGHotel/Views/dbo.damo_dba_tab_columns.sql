USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
	

create view [dbo].[damo_dba_tab_columns] as
/********************************************************************************
*** dba_tab_columns *****
[----]
  columns of user's tables,views and clusters 
[data]
	db_name() as owner							- 	db --
	,table_schema +'.'+table_name as table_name				-	------ ------ --.------ --
	,column_name								-	---- --
	,data_type								-	------ ------ ----
	,col_length(table_schema + '.' + table_name, column_name)  as data_length		-	------ ------(bytes)
	,numeric_precision as data_precision					-	---- -------- ------
	,numeric_scale as data_scale						- 	---- -------- ----
	,case is_nullable when 'YES' then 'Y' else 'N' as nullable		-	null ---- ----(yes,no)
	,ordinal_position as column_id					-	---- id
	,isnull(len(column_default),0) as default_length			-	default ---- ------
	,substring(column_default,2,len(column_default)-2)as data_default -	default --
[from]
  INFORMATION_SCHEMA.COLUMNS
        
[--------] 
 - sql2000/sql2005-- ---- -------- ------

[result values]
testfordamo	dbo.auditemployeedata	audit_changed	datetime	8	23	3	yes	8	11	getdate()
testfordamo	dbo.auditemployeedata	audit_emp_bankaccountnumber	char	10	null	null	yes	4	0	null
testfordamo	dbo.auditemployeedata	audit_emp_id	int	4	10	0	no 	3	0	null


[--------]
	- ----
	- ----
	- ----

******************************************************************************** */	
--===================sql2005
select     top 100 percent db_name() as owner
	, table_schema + '.' + table_name as table_name
	, column_name
	, data_type
	, col_length(table_schema + '.' + table_name, column_name) as data_length
	, numeric_precision as data_precision
	, numeric_scale as data_scale
	, case is_nullable when 'YES' then 'Y' else 'N' end as nullable
	, ordinal_position as column_id
	, isnull(len(column_default), null) as default_length
	, case when charindex('CREATE', upper(column_default)) > 0 
	            and charindex('DEFAULT', upper(column_default)) > 0 
	            and charindex(' AS ', upper(column_default)) > 0 
					 then rtrim(ltrim(substring(column_default, charindex(' AS ', upper(column_default))+4, len(column_default))))
	       else substring(column_default, 2, len(column_default) - 2)
	  end as data_default
	, collation_name 
from         INFORMATION_SCHEMA.COLUMNS
order by table_name

GO
