USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


create view [dbo].[damo_dba_constraints_include_default] as
/********************************************************************************
*** damo_dba_constraints_include_default *****
[----]
	---- -------- ---------- ---- ---------- ---- ---- ---- (constraint definitions on all tables )
	pk/fk/check/unique + default(system-- ------ ---- ----) -- ---- ------ ----

[--------]
	- create_secure_partition---- -------- ---- ----
        
[--------]
	- ----
	- ----
	- ----
******************************************************************************** */
SELECT top 100 percent db_name() as owner
     ,SCHEMA_NAME(st.schema_id)+'.'+i.name as constraint_name
     ,i.name as constraint_name_without_schema
     , case i.is_primary_key when 1 then 'PRIMARY KEY' else 'UNIQUE' end as constraint_type
     ,SCHEMA_NAME(st.schema_id)+'.'+st.name as table_name
  FROM sys.indexes AS i 
    INNER JOIN sys.key_constraints AS k ON k.parent_object_id = i.object_id AND k.unique_index_id = i.index_id
    INNER JOIN sys.tables AS st ON st.object_id = i.object_id
    LEFT OUTER JOIN sys.data_spaces AS dsi ON dsi.data_space_id = i.data_space_id
    LEFT OUTER JOIN sys.xml_indexes AS xi ON xi.object_id = i.object_id AND xi.index_id = i.index_id
    LEFT OUTER JOIN sys.stats AS s ON s.stats_id = i.index_id AND s.object_id = i.object_id
  WHERE i.is_hypothetical = 0 and st.name not like 'damo_dba_%' 
UNION
SELECT top 100 percent db_name() as owner
    ,SCHEMA_NAME(st.schema_id)+'.'+ckc.name as constraint_name
    , ckc.name as constraint_name_without_schema
    , 'CHECK' as constraint_type
    ,SCHEMA_NAME(st.schema_id)+'.'+st.name as table_name
  FROM sys.check_constraints AS ckc
    INNER JOIN sys.tables AS st ON st.object_id = ckc.parent_object_id
  WHERE st.name not like 'damo_dba_%'  
UNION
SELECT top 100 percent db_name() as owner
    ,SCHEMA_NAME(tbl.schema_id) + '.'+ cstr.name AS [constraints_name]
    ,cstr.name AS constraint_name_without_schema
	  ,'DEFAULT' as constraint_type
    ,SCHEMA_NAME(tbl.schema_id) + '.' + tbl.name AS [table_name]
  FROM
    sys.tables AS tbl
    INNER JOIN sys.all_columns AS clmns ON clmns.object_id=tbl.object_id
    INNER JOIN sys.default_constraints AS cstr ON cstr.object_id=clmns.default_object_id
  WHERE cstr.is_system_named = 0 and tbl.name not like 'damo_dba_%'
ORDER BY table_name 

GO
