USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



create  view [dbo].[damo_dml_priv]
as 
/*
*** damo_dml_priv *****
[----]
 table-- ---- dml(select, insert, update, delete) ---- ------ -------- ------
[data]
role_name : -------- ---- ---- -- 
user_name : ---- db ---- ------ id
login_name : login id
obj_name : ------ (------.------)
privilege_type : dml ---- (select , insert, delete, update)
permission : YES / NO ( YES : grant, NO : deny )

[from]
sysobjects
sysprotects
sysusers
sysmembers
master.dbo.sysxlogins
master.dbo.spt_values
        
[--------]
 1. user / user-defined database role / public database role / db_owner database role/ db_datareader database role
 / db_denydatareader database role / db_datawriter database role / db_denydatawriter database role / guest ---- -- ------ ---- ---- ----
--> --, sysdamin-- ---- ---------- ---- ------ ---- ------ --------
2.  sysadmin server role -- ------ ------ -------- ---- dml ------ grant ---------- ------ (sysadmin-- ---- ------ ------ ---- ----)

[result values]
db_datawriter	user2	user2	dbo.tbl_test	update	YES
        
[--------]
	- ----
	- ----
	- ----

*/
select role_name, user_name, login_name,obj_name,privilege_type,permission
		from (
-- -------- ---- dml --------
		-- ---------- ---- ------ ---- ----
		select  '' as role_name, user_name(u.uid) as user_name,suser_sname(u.sid) as login_name, user_name(objectproperty(p.id,'ownerid'))+'.'+object_name(p.id) as obj_name
		,case p.action      when 193 then 'SELECT'    when 195 then 'INSERT'    when 196 then 'DELETE'    when 197 then 'UPDATE'   end      as privilege_type  
		 ,case     when p.protecttype = 205 then 'YES'    else 'NO'  end  as permission
		from sysprotects p join sysusers u on p.uid = u.uid
		where  object_name(id) not like 'sys%' and object_name(id) not like 'damo_%' and action in (193,195,196,197) and islogin = 1 and user_name(u.uid) != 'guest' and ( objectproperty(p.id,'istable') = 1 or objectproperty(p.id,'isview') = 1 )
		union all
		--user defined db role (guest ----)-- member ---- ---- ---- ----
		select user_name(p.uid) as role_name , u.name  as user_name ,suser_sname(u.sid) as login_name, user_name(objectproperty(p.id,'ownerid'))+'.'+object_name(p.id) as obj_name
		,case p.action      when 193 then 'SELECT'    when 195 then 'INSERT'    when 196 then 'DELETE'    when 197 then 'UPDATE'   end      as privilege_type  
		 ,case     when p.protecttype = 205 then 'YES'    else 'NO'  end as permission
		from sysprotects p join  sysmembers m on p.uid = m.groupuid join sysusers u on u.uid = m.memberuid
		where object_name(p.id) not like 'sys%' and object_name(id) not like 'damo_%' and p.action in (193,195,196,197)  and u.name != 'guest' and objectproperty(p.id,'isview') = 1 
		union all
		--public role -- member ---- ---- ---- ----
		select user_name(p.uid), u.name,suser_sname(u.sid), user_name(objectproperty(p.id,'ownerid'))+'.'+object_name(p.id)
		,case p.action      when 193 then 'SELECT'    when 195 then 'INSERT'    when 196 then 'DELETE'    when 197 then 'UPDATE'   end      as privilege_type  
		 ,case     when p.protecttype = 205 then 'YES'    else 'NO'  end
		from sysprotects p cross join sysusers u 
		where user_name(objectproperty(p.id,'ownerid')) <> 'sys' and user_name(p.uid)= 'public' and u.islogin=1 and object_name(p.id) not like 'sys%' and object_name(id) not like 'damo_%' and p.action in (193,195,196,197) and ( objectproperty(p.id,'istable') = 1 or objectproperty(p.id,'isview') = 1 )
		union all
		-- 'db_owner'-- member---- ---- ---- ----
		select  user_name(groupuid), user_name(memberuid),suser_sname(u.sid),user_name(o.uid)+'.'+o.name, upper(sv.name), 'YES' 
		 from sysmembers  m join sysusers u on m.memberuid = u.uid cross join sysobjects o cross join  master.dbo.spt_values sv
		where user_name(groupuid) in ( 'db_owner')
		and o.xtype = 'V' and o.name not like 'sys%' and o.name not like 'damo_%' and sv.name in ('Select', 'Insert', 'Update', 'Delete' ) and user_name(memberuid) != 'guest'
		union all
		--  'db_datareader',  'db_denydatareader'-- member---- ---- ---- ----
		select  user_name(groupuid), user_name(memberuid),suser_sname(u.sid),user_name(o.uid)+'.'+o.name, upper(sv.name), case user_name(groupuid) when   'db_datareader' then 'YES' else 'NO' end
		 from sysmembers  m join sysusers u on m.memberuid = u.uid cross join sysobjects o cross join  master.dbo.spt_values sv
		where user_name(groupuid) in ( 'db_datareader',  'db_denydatareader')
		and o.xtype = 'V' and o.name not like 'sys%' and o.name not like 'damo_%' and sv.name in ('Select') and user_name(memberuid) != 'guest'
		union all
		--  'db_datawriter', 'db_denydatawriter'-- member---- ---- ---- ----
		select  user_name(groupuid), user_name(memberuid),suser_sname(u.sid),user_name(o.uid)+'.'+o.name, upper(sv.name), case user_name(groupuid) when   'db_datawriter' then 'YES' else 'NO' end
		 from sysmembers  m join sysusers u on m.memberuid = u.uid cross join sysobjects o cross join  master.dbo.spt_values sv
		where user_name(groupuid) in (  'db_datawriter', 'db_denydatawriter')
		and o.xtype = 'V' and o.name not like 'sys%' and o.name not like 'damo_%' and sv.name in ( 'Insert', 'Update', 'Delete') and user_name(memberuid) != 'guest'
		union all
		-- guest ------ ------ ---- ----
		select user_name(p.uid), 'guest',s.name, user_name(objectproperty(p.id,'ownerid'))+'.'+object_name(p.id)
		,case p.action      when 193 then 'SELECT'    when 195 then 'INSERT'    when 196 then 'DELETE'    when 197 then 'UPDATE'   end      as privilege_type  
		 ,case     when p.protecttype = 205 then 'YES'    else 'NO'  end
		from sysprotects p cross join master..syslogins s
		where  user_name(objectproperty(p.id,'ownerid')) <> 'sys' and object_name(id) not like 'sys%' and object_name(id) not like 'damo_%' and action in (193,195,196,197)  and user_name(uid) in ('public','guest') and s.name is not null and objectproperty(p.id,'isview') = 1
		union all
		-- quest ------ ---- ------ ---- db role-- ------ ------ ------ --------
		select user_name(p.uid), u.name,s.name, user_name(objectproperty(p.id,'ownerid'))+'.'+object_name(p.id)
		,case p.action      when 193 then 'SELECT'    when 195 then 'INSERT'    when 196 then 'DELETE'    when 197 then 'UPDATE'   end      as privilege_type  
		 ,case     when p.protecttype = 205 then 'YES'    else 'NO'  end
		from sysprotects p join  sysmembers m on p.uid = m.groupuid join sysusers u on u.uid = m.memberuid cross join master..syslogins s
		where object_name(p.id) not like 'sys%' and object_name(id) not like 'damo_%' and p.action in (193,195,196,197)  and u.name = 'guest' and s.name is not null and objectproperty(p.id,'isview') = 1 
		union all
		-- guest ------ system db role -- 'db_datareader',  'db_denydatareader'-- ------ ------ ------ ---- ----
		select  user_name(groupuid), user_name(memberuid),s.name,user_name(o.uid)+'.'+o.name, upper(sv.name), case user_name(groupuid) when   'db_datareader' then 'YES' else 'NO' end
		 from sysmembers  m join sysusers u on m.memberuid = u.uid cross join sysobjects o cross join  master.dbo.spt_values sv cross join master..syslogins s
		where user_name(groupuid) in ( 'db_datareader',  'db_denydatareader')
		and o.xtype = 'V' and o.name not like 'sys%' and o.name not like 'damo_%' and sv.name in ('Select') and user_name(memberuid) = 'guest'
		union all
		-- guest ------ system db role --  'db_datawriter', 'db_denydatawriter'-- ------ ------ ------ ---- ----
		select  user_name(groupuid), user_name(memberuid),s.name,user_name(o.uid)+'.'+o.name, upper(sv.name), case user_name(groupuid) when   'db_datawriter' then 'YES' else 'NO' end
		 from sysmembers  m join sysusers u on m.memberuid = u.uid cross join sysobjects o cross join  master.dbo.spt_values sv cross join master..syslogins s
		where user_name(groupuid) in (  'db_datawriter', 'db_denydatawriter')
		and o.xtype = 'V'  and o.name not like 'sys%' and o.name not like 'damo_%' and sv.name in ( 'Insert', 'Update', 'Delete') and user_name(memberuid) = 'guest'
		)  a
where  login_name not in 
			( select distinct lgn.name
			from master.dbo.spt_values spv, master.dbo.syslogins lgn  
			where spv.low = 0 and  
			spv.type = 'SRV' and  
			lgn.sysadmin = 1  and lgn.name not like cast(serverproperty('machinename') as varchar(256)) + '%')
union all
-- server role-- member(login-id)
  select 'serverrole' = spv.name,'', 'membername' = lgn.name, user_name(o.uid)+'.'+o.name, upper(sv.name), 'YES' 
   from master.dbo.spt_values spv, master.dbo.syslogins lgn   cross join sysobjects o cross join  master.dbo.spt_values sv 
   where spv.low = 0 and  
      spv.type = 'SRV' and  
      spv.name = 'sysadmin' and lgn.sysadmin = 1
	and o.xtype = 'V' and o.name not like 'sys%' and o.name not like 'damo_%' and sv.name in ( 'Select', 'Insert', 'Update', 'Delete')
  and lgn.name not like cast(serverproperty('machinename') as varchar(256)) + '%'

GO
