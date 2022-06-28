USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create view [dbo].[damo_dba_ind_columns] as
/********************************************************************************
*** dba_ind_columns *****
[----]
  -------- ---------- ---- ---- ---- ---- (columns comprising indexes on all tables and clusters)
[data]
 db_name()  as tabl_owner 								-- db--
 user_name(objectproperty(t.id, 'ownerid' ))+'.'+object_name(t.id) as table_name  	-- -------- ------ -------- --------.-------- ------ ------ --
  substring(
	  max(col1) +', '+ max(col2) +', '+max(col3) +', '+ max(col4) +', '             
	+ max(col5) +', '+ max(col6) +', '+max(col7) +', '+ max(col8) +', '             
	+ max(col9) +', '+ max(col10)+', '+max(col11)+', '+ max(col12)+', '             
	+ max(col13)+', '+ max(col14)+', '+max(col15)+', '+ max(col16) 
		,0,
	charindex (' , ' , max(col1) +', '+ max(col2) +', '+max(col3) +', '+ max(col4) +', '             
						+ max(col5) +', '+ max(col6) +', '+max(col7) +', '+ max(col8) +', '             
						+ max(col9) +', '+ max(col10)+', '+max(col11)+', '+ max(col12)+', '             
						+ max(col13)+', '+ max(col14)+', '+max(col15)+', '+ max(col16) )-2
	)as column_name								-- -------- ------ ---- ------

[from]
  - sql2000
    sysindexkeys 
    sysindexes
  - sql2005
    sys.index_columns
    sys.indexes si
    sys.stats ss
[result values]        
testfordamo	dbo.sales	stor_id, ord_num, title_id
testfordamo	dbo.sales	title_id
testfordamo	dbo.titleauthor	au_id, title_id
testfordamo	dbo.titleauthor	au_id

[--------]
  - sql2000/sql2005-- ---- -------- ------
  - ------------ ------ ---- ------ ---- subquery ------
  - sql2000/sql2005 -- ---- ------ ------,
     ---- ------ -- : 16--
     ---------- ---- ---- : 900bytes
     
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
--============sql 2005
select  db_name()  as table_owner ,t.index_id
	, schema_name(objectproperty(t.object_id, N'schemaid' ))+'.'+object_name(t.object_id) as table_name  
	, column_name
from (                                                                         
	select top 100percent                                                                    
		object_id, index_id, key_ordinal, col_name(object_id, column_id) as column_name
	from sys.index_columns                    
	where object_name(object_id) not like 'damo_dba_%' -- ------ ------ ---- ----
	order by object_id, index_id, key_ordinal                                         
)	t            join sys.indexes si
	on t.object_id = si.object_id and t.index_id = si.index_id                                                                
GO
