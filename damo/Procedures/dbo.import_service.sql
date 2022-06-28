USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[import_service]
  @i_key_info varchar(8000),
  @i_policy_info varchar(8000),
  @i_ape_info varchar(8000),
  @i_out_info varchar(8000),
  @i_iv_info  varchar(8000),
  @i_service_info varchar(8000),
  @i_sp_alias varchar(8000),
  @o_sqlcode int output,
  @o_sqlerrm varchar(8000) output
as
begin
begin try
  begin tran
  
  declare @flag varchar(2)
  select @flag = char(24)
  declare @cnt int
  declare @i_desc varchar(64)
  declare @i_algorithm int
  declare @i_op int
  declare @i_enc_range varchar(12)
  declare @i_iv int

  set @cnt = 0
  
   -- start insert into secure_kms_key_symm
  declare @i_key_id varchar(64),
           @i_key_len int,
           @i_key_type int,
           @i_key_data varchar(8000),
           @i_key_data_binary varbinary(8000)
    
  select @i_key_id = damo.dbo.get_value_from_array(@i_key_info, 1, @flag)
  select @i_key_len = convert(int,damo.dbo.get_value_from_array(@i_key_info, 2, @flag)) 
  select @i_key_type = convert(int, damo.dbo.get_value_from_array(@i_key_info, 3, @flag))
  select @i_key_data = damo.dbo.get_value_from_array(@i_key_info, 4, @flag)
  
  if(@i_key_type != 1 and @i_key_type != 12)
  begin
    rollback tran
    select @o_sqlcode = -300103
    select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
    return @o_sqlcode
  end
  
  select @i_key_data_binary = damo.dbo.secure_access$b64_decode(@i_key_data)
  
  if(@i_key_data_binary is null or datalength(@i_key_data_binary) is null)
  begin
    rollback tran
    select @o_sqlcode = -300100
    select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
    return @o_sqlcode
  end
  
  select @i_key_data = damo.dbo.secure_access$encrypt_key(@i_key_data_binary)
  
  if(@i_key_data is null or datalength(@i_key_data) is null)
  begin
    rollback tran
    select @o_sqlcode = -300100
    select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
    return @o_sqlcode
  end

  select @cnt = count(*)
    from damo.dbo.secure_kms_key_symm
    where key_id = @i_key_id
  
  if ( @cnt = 0 )
  begin
    select @i_desc = convert(varchar(64),getdate())
    insert into damo.dbo.secure_kms_key_symm( key_id, key_data, key_len, key_type, descript, time)
      values(@i_key_id, @i_key_data, @i_key_len, @i_key_type, @i_desc, getdate())
  end
  else
  begin
    rollback tran
    select @o_sqlcode = -300059
    select @o_sqlerrm =  damo.dbo.get_sqlerrm(@o_sqlcode)
    return @o_sqlcode
  end
  -- insert into secure_kms_key_symm end
  
  if ( len(@i_policy_info) !=0 and len(@i_ape_info) != 0 )
  begin
    rollback tran
    select @o_sqlcode = -300102
    select @o_sqlerrm =damo.dbo.get_sqlerrm(@o_sqlcode)
    return @o_sqlcode
  end
  
  if ( len(@i_policy_info) =0 and len(@i_ape_info) = 0 )
  begin
    rollback tran
    select @o_sqlcode = -300101
    select @o_sqlerrm =damo.dbo.get_sqlerrm(@o_sqlcode)
    return @o_sqlcode
  end
  
  if( len(@i_policy_info) !=0 )
  begin
    -- start insert into secure_kms_policy_symm
    declare @i_pid_symm           varchar(64),
             @i_symm_algo_type    int,
             @i_op_mode_type      int,
             @i_iv_type               int,
             @i_auth_data           varchar(64),
             @i_out_type             int,
             @i_dupl_enc_data      varchar(12),
             @i_padding             int,
             @i_null_enc             varchar(1)
             
    select @i_pid_symm = damo.dbo.get_value_from_array(@i_policy_info, 1, @flag)
    select @i_symm_algo_type = damo.dbo.get_value_from_array(@i_policy_info, 2, @flag)
    select @i_key_len = damo.dbo.get_value_from_array(@i_policy_info, 3, @flag)
    select @i_op_mode_type = damo.dbo.get_value_from_array(@i_policy_info, 4, @flag)
    select @i_iv_type = isnull(damo.dbo.get_value_from_array(@i_policy_info, 5, @flag),'')
    select @i_auth_data = damo.dbo.get_value_from_array(@i_policy_info, 6, @flag)
    select @i_out_type = damo.dbo.get_value_from_array(@i_policy_info, 7, @flag)
    select @i_dupl_enc_data = damo.dbo.get_value_from_array(@i_policy_info, 8, @flag)
    select @i_padding = damo.dbo.get_value_from_array(@i_policy_info, 9, @flag)
    select @i_null_enc = damo.dbo.get_value_from_array(@i_policy_info, 10, @flag)
   
    if (@i_symm_algo_type = 18 or @i_symm_algo_type = 19 or @i_symm_algo_type = 20 or @i_null_enc = 1)
    begin
      rollback tran
      select @o_sqlcode = -300104
      select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
      return @o_sqlcode 
    end
   
    select @cnt = count(*)
      from damo.dbo.secure_kms_policy_symm
      where pid_symm = @i_pid_symm
    
    if( @cnt = 0 )
    begin
      select @i_desc = convert(varchar(64), getdate())
      insert into damo.dbo.secure_kms_policy_symm(pid_symm, symm_algo_type, key_len, op_mode_type, iv_type, auth_data, descript, time, out_type, dupl_enc_data, padding, null_enc)
        values(@i_pid_symm, @i_symm_algo_type, @i_key_len, @i_op_mode_type, @i_iv_type, @i_auth_data, @i_desc, getdate(), @i_out_type, @i_dupl_enc_data, @i_padding, @i_null_enc)
    end
    else 
    begin
      rollback tran
      select @o_sqlcode = -300059
      select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
      return @o_sqlcode
    end
   -- insert into secure_kms_policy_symm end
   
   select @i_algorithm = @i_symm_algo_type
   select @i_op  = @i_op_mode_type
  end
  
  if( len(@i_ape_info) != 0)
  begin
      -- start insert into secure_kms_policy_ape
    declare @i_pid_ape             varchar(64),
             @i_ape_algo_type      int,
             @i_ape_mode           int,
             @i_ape_type             int,
             @i_ignore_symbols     varchar(256),
             @i_in_symbols           varchar(256),
             @i_out_symbols         varchar(256),
             @i_ope_max_byte       int,
             @i_replace_in            varchar(256),
             @i_replace_out          varchar(256),
             @i_in_multiset           int,
             @i_out_multiset         int
             
    select @i_pid_ape = damo.dbo.get_value_from_array(@i_ape_info, 1, @flag)
    select @i_ape_algo_type = damo.dbo.get_value_from_array(@i_ape_info, 2, @flag)
    select @i_ape_mode = damo.dbo.get_value_from_array(@i_ape_info, 3, @flag)
    select @i_ape_type = damo.dbo.get_value_from_array(@i_ape_info, 4, @flag)
    select @i_ignore_symbols = damo.dbo.get_value_from_array(@i_ape_info, 5, @flag)
    select @i_in_symbols = damo.dbo.get_value_from_array(@i_ape_info, 6, @flag)
    select @i_out_symbols = damo.dbo.get_value_from_array(@i_ape_info, 7, @flag)
    select @i_ope_max_byte = damo.dbo.get_value_from_array(@i_ape_info, 8, @flag)
    select @i_iv_type = isnull(damo.dbo.get_value_from_array(@i_ape_info, 9, @flag),'')
    select @i_replace_in = damo.dbo.get_value_from_array(@i_ape_info, 10, @flag)
    select @i_replace_out = damo.dbo.get_value_from_array(@i_ape_info, 11, @flag)
    select @i_in_multiset = damo.dbo.get_value_from_array(@i_ape_info, 12, @flag)
    select @i_out_multiset = damo.dbo.get_value_from_array(@i_ape_info, 13, @flag)
    
    declare @key_server_version varchar(10)
    declare @key_server_level varchar(10)
    
    select @key_server_version= value
      from damo.dbo.secure_cfg
      where parameter = 'KEYSERV_VER_INFO'
      
    select @key_server_level= value
    from damo.dbo.secure_cfg
    where parameter = 'KEY_SERVER_LEVEL'
      
    if(@key_server_version = '2.3' and @key_server_level != 0 and (@i_ape_mode > 100 and @i_ape_mode <200))
    begin
      rollback tran
      select @o_sqlcode = -20904
      select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
      return @o_sqlcode
    end
    
    if(@i_ape_type >=128 or @i_ape_mode = 105 or @i_ape_mode = 106 or @i_ape_algo_type = 41  or @i_ape_algo_type = 42 or @i_ape_algo_type = 43)
    begin
      rollback tran
      select @o_sqlcode = -300105
      select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
      return @o_sqlcode
    end
   
    select @cnt = count(*)
      from damo.dbo.secure_kms_policy_ape
      where pid_ape = @i_pid_ape
    
    if( @cnt = 0 )
    begin
      select @i_desc = convert(varchar(64), getdate())  	 
      insert into damo.dbo.secure_kms_policy_ape (pid_ape, ape_algo_type, ape_mode, ape_type, ignore_symbols, in_symbols, out_symbols,ope_max_byte, descript, time, iv_type, replace_in, replace_out, in_multiset, out_multiset, null_enc)
        values(@i_pid_ape, @i_ape_algo_type, @i_ape_mode, @i_ape_type, @i_ignore_symbols, @i_in_symbols, @i_out_symbols, @i_ope_max_byte, @i_desc, getdate(), @i_iv_type, @i_replace_in, @i_replace_out,@i_in_multiset, @i_out_multiset, 0)
    end
    else
    begin    
      rollback tran
      select @o_sqlcode = -300059
      select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
      return @o_sqlcode
    end
   -- insert into secure_kms_policy_ape end
   
   select @i_algorithm = @i_ape_algo_type
   select @i_op = @i_ape_mode
  end
 
 -- start insert into secure_kms_policy_output
 declare @i_pid_out           varchar(64),
          @i_range_start       int,
          @i_range_len       int,
          @i_enc_range_type  int

  select @i_pid_out = damo.dbo.get_value_from_array(@i_out_info, 1, @flag)
  select @i_range_start = damo.dbo.get_value_from_array(@i_out_info, 2, @flag)
  select @i_range_len = damo.dbo.get_value_from_array(@i_out_info, 3, @flag)
  select @i_enc_range_type = damo.dbo.get_value_from_array(@i_out_info, 4, @flag)
 
  if( len(@i_pid_out) !=0 or @i_pid_out is null)
  begin
    select @cnt = isnull(count(*),0)
      from damo.dbo.secure_kms_policy_output
      where pid_out = @i_pid_out
    
    if( @cnt = 0 )
    begin
      select @i_desc = convert(varchar(64), getdate())
      insert into damo.dbo.secure_kms_policy_output ( pid_out, range_start, range_len, enc_range_type, descript, time)
        values( @i_pid_out, @i_range_start, @i_range_len, @i_enc_range_type, @i_desc, getdate())

      select @i_enc_range = convert(varchar(5),@i_range_start)+','+convert(varchar(5),@i_range_len)
    end
    else
    begin    
      rollback tran
      select @o_sqlcode = -300059
      select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
      return @o_sqlcode
    end
   -- end insert into secure_kms_policy_output
  end
 
  -- start insert into secure_kms_policy_iv
  declare @i_pid_iv         varchar(64),
          @i_iv_value       varchar(64)

  select @i_iv_type = damo.dbo.get_value_from_array(@i_iv_info, 2, @flag)
  select @i_iv_value = damo.dbo.get_value_from_array(@i_iv_info, 3, @flag)

  if (@i_iv_type =0)
  begin
    --select @i_desc = convert(varchar(64), getdate())
    select @i_pid_iv = 'COLUMN IV'
    /*insert into damo.dbo.secure_kms_policy_iv ( pid_iv, iv_type, iv_value, descript, time)
      values( @i_pid_iv, @i_iv_type, @i_iv_value, @i_desc, getdate())*/
  end
  else if (@i_iv_type = 1)
  begin
    --select @i_desc = convert(varchar(64), getdate())
    select @i_pid_iv = 'RECORD IV'
    /*insert into damo.dbo.secure_kms_policy_iv ( pid_iv, iv_type, iv_value, descript, time)
      values( @i_pid_iv, @i_iv_type, @i_iv_value, @i_desc, getdate())*/
  end
  else if (@i_iv_type = -1)
  begin
    select @i_pid_iv = ''
  end
  else 
  begin
    select @o_sqlerrm = 'IV TYPE is invalid (only 0, 1, -1)'
  end
  -- end insert into secure_kms_policy_iv
  
  select @i_iv = @i_iv_type
 
  -- start insert into secure_kms_service_column
  declare @i_service_id         varchar(64) 
  select @i_service_id = @i_service_info

  select @cnt = count(*)
    from damo.dbo.secure_kms_service_column
    where service_id = @i_service_id
  
  if( @cnt = 0 )
  begin
    select @i_desc = convert(varchar(64), getdate())
    insert into damo.dbo.secure_kms_service_column (service_id,db_name, db_owner, db_table, db_column, key_id, pid_symm, pid_ape, pid_out, descript, time, pid_iv)
      values( @i_service_id, '','','','',@i_key_id, @i_pid_symm, @i_pid_ape, @i_pid_out, @i_desc, getdate(), @i_pid_iv )
  end
  else 
  begin
    rollback tran
    select @o_sqlcode = -300054
    select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
    return @o_sqlcode
  end
 -- end insert into secure_kms_service_column
 
   -- start insert into secure_policy_master
  select @cnt = count(*)
    from damo.dbo.secure_policy_master
    where sp_alias = @i_service_id
  
  if( @cnt = 0 )
  begin
    select @i_desc = convert(varchar(64), getdate())
    insert into damo.dbo.secure_policy_master (   sp_alias,   algorithm, op_mode, iv_type, select_type,  [key],   enc_range, enc_null,  enc_range_type ,reg_date, service_id)
      values ( @i_sp_alias, @i_algorithm,    @i_op,    @i_iv, 0, @i_key_data, @i_enc_range, 0, @i_enc_range_type, getdate(), @i_service_id)
  end
  else 
  begin
    rollback tran
    select @o_sqlcode = -300057
    select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
    return @o_sqlcode
  end
 -- end insert into secure_policy_master
 
  select @o_sqlcode = 0
  select @o_sqlerrm = 'SUCCESSFUL COMPELETION'
  
  commit tran
  return
end try
begin catch
  /*
    ---- ---- ----
  CATCH ------ -------- ---- ------ ------ -------- CATCH ------ ---------- ---- ------ ---- ------ ---- -- --------.
  ERROR_NUMBER()-- ---- ------ ----------.
  ERROR_SEVERITY()-- -------- ----------.
  ERROR_STATE()-- ---- ---- ------ ----------.
  ERROR_PROCEDURE()-- ------ ------ ---- -------- ---- -------- ------ ----------.
  ERROR_LINE()-- ------ ------ ---- ---- -- ------ ----------.
  ERROR_MESSAGE()-- ---- -------- ---- -------- ----------. -- -------- ----, ---- ---- ---- ------ ---- ---- ------ ---- ------ ------ ---- ----------.
  */
  select @o_sqlcode = ERROR_NUMBER()
  select @o_sqlerrm = substring('Msg ' + convert(varchar,ERROR_NUMBER()) +', Level '+ convert(varchar,ERROR_SEVERITY())+', State '+ convert(varchar,ERROR_STATE()) + ', Line ' + convert(varchar,ERROR_LINE()) +'  //  ' + ERROR_MESSAGE(), 1, 8000)
        
  if (xact_state()) = -1
  begin
    rollback tran
  end
  
  if (xact_state()) = 1
  begin
    commit tran
  end
  
  return @o_sqlcode
end catch
end
GO
