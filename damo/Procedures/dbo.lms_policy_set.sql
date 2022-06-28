USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[lms_policy_set] @i_policy_info varchar(max), @o_sqlcode int output
as
begin
begin try
  declare
    @v_history_max_no     int,
    @v_policy_max_no   int,
    
    @v_policy_buffer     int,
    @v_policy_info       varchar(8000),
    @v_policy_cnt        int,
    
    @v_detail_info       varchar(8000),
    @v_detail_cnt        int,
    
    @v_dml              varchar(1),
    @v_policy_id         varchar(128),
    @v_policy_user              varchar(256),
    @v_owner           varchar(128),
    @v_table             varchar(128),
    @v_column         varchar(128),
    @v_ip                 varchar(4000),
    @v_app               varchar(4000),
    @v_start_time        varchar(4000),
    @v_end_time         varchar(4000),
    @v_service_flag      int,
    @v_check_amount   int,
    @v_check_unit        int

  select @v_policy_buffer = 200
  
  select @v_history_max_no = 0
  select @v_history_max_no = isnull(max(no),0)
    from damo.dbo.secure_policy_lms_history
    
  select @v_policy_max_no = count(*)
    from damo.dbo.secure_policy_lms
    
   ----------------------------------------------------------------------------------------------------------------
  -- dbo.secure_policy_lms -------- ---- ---- ---- -- HISTORY -------- ---- ----(---- ------ 3---- ------ ----)
  ----------------------------------------------------------------------------------------------------------------
  
  if(@v_policy_max_no != 0)
  begin
    insert into damo.dbo.secure_policy_lms_history(no, policy_id, policy_user, owner, table_name, column_name, ip ,  application, start_time, end_time, service_flag, check_amount, check_unit)
      select  @v_history_max_no+1, policy_id,  policy_user, owner, table_name, column_name, ip ,  application, start_time, end_time, service_flag, check_amount, check_unit
      from damo.dbo.secure_policy_lms
      
    if (@v_history_max_no > 3)
    begin
      delete from damo.dbo.secure_policy_lms_history
        where [no] = @v_history_max_no - 3;
    end  
  end
  
  declare @flag varchar(2)
  set @flag= char(124)  -- --
  declare @i int, @cnt int
  
  set @i = 1
  
  exec damo.dbo.secure_com_1$column_sp @i_policy_info, @v_policy_buffer, @v_policy_cnt output, @v_policy_info output, @flag
  
  while(@i <= @v_policy_cnt)
  begin
    set @v_policy_info = damo.dbo.get_value_from_array(@i_policy_info, @i, char(124))
    set @cnt = 0
    
    -- char(94) == '^'
    set @v_dml = damo.dbo.get_value_from_array(@v_policy_info, 1, char(94))
    set @v_policy_id = damo.dbo.get_value_from_array(@v_policy_info, 2, char(94))
    set @v_policy_user = damo.dbo.get_value_from_array(@v_policy_info, 3, char(94))
    set @v_owner = damo.dbo.get_value_from_array(@v_policy_info, 4, char(94))
    set @v_table = damo.dbo.get_value_from_array(@v_policy_info, 5, char(94))
    set @v_column = damo.dbo.get_value_from_array(@v_policy_info, 6, char(94))
    set @v_ip = damo.dbo.get_value_from_array(@v_policy_info, 7, char(94))
    set @v_app = damo.dbo.get_value_from_array(@v_policy_info, 8, char(94))
    set @v_start_time = replace(replace(replace(damo.dbo.get_value_from_array(@v_policy_info, 9, char(94)),'-',''),':',''),' ','')
    set @v_end_time = replace(replace(replace(damo.dbo.get_value_from_array(@v_policy_info, 10, char(94)),'-',''),':',''),' ','')
   set @v_service_flag = case damo.dbo.get_value_from_array(@v_policy_info, 11, char(94)) when 'A' then 1 when 'B' then 2 when 'AB' then 3 else 1 end  -- Alarm / Block / Alarm+Block
    set @v_check_amount = convert(int,damo.dbo.get_value_from_array(@v_policy_info, 12, char(94)))
    set @v_check_unit = convert(int,damo.dbo.get_value_from_array(@v_policy_info, 13, char(94)))
    
    if(@v_policy_id is NULL or len(@v_policy_id)=0)
    begin
      select @o_sqlcode = -1
      return 
    end
    
    if(@v_dml is NULL or len(@v_dml)=0)
    begin 
      select @o_sqlcode = -2
      return 
    end
    
    select @v_ip = damo.dbo.secure_agent_mgmt$encrypted_context_sql_lms (@v_policy_user, @v_policy_id, @v_ip)
    select @v_app = damo.dbo.secure_agent_mgmt$encrypted_context_sql_lms(@v_policy_user, @v_policy_id, @v_app)
    select @v_start_time = damo.dbo.secure_agent_mgmt$encrypted_context_sql_lms(@v_policy_user, @v_policy_id, @v_start_time)
    select @v_end_time = damo.dbo.secure_agent_mgmt$encrypted_context_sql_lms(@v_policy_user, @v_policy_id, @v_end_time)
    
    if (@v_dml = 'I' or @v_dml = 'i')
    begin
      select @cnt = count(1)
        from damo.dbo.secure_policy_lms
        where policy_id = @v_policy_id
        
      if(@cnt != 0)
      begin
        select @o_sqlcode = -10
        return
      end
      else
      begin
        insert into damo.dbo.secure_policy_lms(policy_id, policy_user, owner, table_name, column_name, ip ,  application, start_time, end_time, service_flag, check_amount, check_unit)
          values(@v_policy_id, @v_policy_user, @v_owner, @v_table, @v_column, @v_ip, @v_app, @v_start_time, @v_end_time, @v_service_flag, @v_check_amount, @v_check_unit)
      end
    end
    else if(@v_dml = 'U' or @v_dml = 'u')
    begin
      select @cnt = count(1)
        from damo.dbo.secure_policy_lms
        where policy_id = @v_policy_id
       
      if(@cnt =0)
      begin
        select @o_sqlcode = -11
        return
      end
      else
      begin
        update damo.dbo.secure_policy_lms
          set policy_user = @v_policy_user, owner= @v_owner, table_name = @v_table, column_name = @v_column, ip = @v_ip, application = @v_app, start_time = @v_start_time , end_time = @v_end_time, service_flag = @v_service_flag, check_amount = @v_check_amount, check_unit = @v_check_unit
          where policy_id =@v_policy_id
      end
    end
    else if(@v_dml = 'D' or @v_dml = 'd')
    begin
      select @cnt = count(1)
        from damo.dbo.secure_policy_lms
        where policy_id = @v_policy_id
       
      if(@cnt =0)
      begin
        select @o_sqlcode = -12
        return
      end
      else
      begin
        delete from damo.dbo.secure_policy_lms
          where policy_id = @v_policy_id
      end
    
    end
    
    
    set @i= @i+1
  end
  
  declare @ret int
  exec @ret =master.dbo.xp_P5_InitSecureInfos
  
  if(@ret !=0)
  begin
    select @o_sqlcode = -3
    return 
  end
  
  exec @ret = master.dbo.xp_P5_UpdateLMSPolicyInfo

  if(@ret !=0)
  begin
    select @o_sqlcode = -4
    return
  end
  
  select @o_sqlcode = 0
  return 
end try
begin catch
  select @o_sqlcode = -13
  return 
end catch
end
GO
