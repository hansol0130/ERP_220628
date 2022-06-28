USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


create view [dbo].[damo_all_tab_privs] as
/********************************************************************************
*** v$version *****
[----]
  grants on objects for which the user is the grantor grantee owner or an enabled role or public is the grantee 

[data]
   grantor       						-	name of the user who performed the grant
   grantee      						-	name of the user to whom access was granted
   table_schema      					-	schema of the object
   table_schema+'.'+ table_name  as  table_name       	-	name of the object
   privilege_type as privilege    				-	table privilege
   is_grantable as  grantable  				-	privilege is grantable
   '' as hierarchy					-	privilege is with hierarchy option

[from]
  INFORMATION_SCHEMA.TABLE_PRIVILEGES

[result values]
dbo	guest	dbo	dbo.sales	references	NO	
dbo	guest	dbo	dbo.sales	select	NO	
dbo	guest	dbo	dbo.sales	insert	NO	
dbo	guest	dbo	dbo.sales	delete	NO	
dbo	guest	dbo	dbo.sales	update	NO	


[--------]

               
[--------]
	- ---- : 2006.11.22 ------
	- ---- : ------ ------ deny-- ------ ------ ------ -------- ------ ------.
	- ---- : -------- ---- ---- -------- -------- ---- ------ -------- ---- ---- ---------- grant, deny ---------- ---------- ---- --.
					(2000 -- ---- ---- ------, ---- user_name -- ---- schema_name -- ------)
			[data]
			   grantor       						-	name of the user who performed the grant
			   grantee      						-	name of the user to whom access was granted
			   table_schema      					-	schema of the object
			   table_schema+'.'+ table_name  as  table_name       	-	name of the object
				, case p.action  when 26 then  'references'     when 193 then 'SELECT'    when 195 then 'INSERT'    when 196 then 'DELETE'    when 197 then 'UPDATE'   end      as privilege  
				, case     when p.protecttype = 204 then 'YES'    else 'NO'  end  as grantable
				, case  p.protecttype   when  206 then 'NO'    else 'YES'  end  as privilege_status

			[from]
			 sysprotects
******************************************************************************** */
--select grantor
--	,grantee
--	, table_schema
--	,table_schema+'.'+ table_name  as  table_name 
--	,privilege_type as privilege
--	,is_grantable as grantable
--	, '' as hierarchy
--from INFORMATION_SCHEMA.TABLE_PRIVILEGES
--where table_name not like 'sys%' 

select   
	user_name(grantor) as grantor, 
	user_name(p.uid) as grantee, 
	db_name() table_schema, 
	schema_name(objectproperty(p.id,'schemaid'))+'.'+object_name(p.id) as table_name,
	case p.action  
		when 26 then  'REFERENCES'     
		when 193 then 'SELECT'
		when 195 then 'INSERT'
		when 196 then 'DELETE'
		when 197 then 'UPDATE'
	end as privilege,
	case p.protecttype 
		when 204 then 'YES'    
		else 'NO'  
	end as grantable,
	case  p.protecttype   
		when  206 then 'NO'    
		else 'YES'
	end as privilege_status
from sysprotects p 
where schema_name(objectproperty(p.id,'schemaid')) <> 'sys' 
	and ( objectproperty(p.id,'istable') = 1 or objectproperty(p.id,'isview') = 1 ) 
	and  object_name(id) not like 'damo_dba_%'  
	and action in (26,193,195,196,197) 

GO
