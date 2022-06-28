USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[make_secure_kms_service_column](
										@i_service_id		varchar(64)
										,@i_service_info		varchar(8000)
										,@i_sp_alias			varchar(64)
										,@i_desc				varchar(8000)
										,@o_sqlcode			int output
										,@o_sqlerrm			varchar(8000) output
)
as
	declare 
		@v_db_name			varchar(64),
		@v_db_owner			varchar(128),
		@v_db_table				varchar(128),
		@v_db_column			varchar(128),
		@v_key_id				varchar(64),
		@v_pid_symm			varchar(64),
		@v_pid_ape				varchar(64),
		@v_pid_out				varchar(64),
		@v_pid_iv				varchar(64),
		@v_sp_alias				varchar(64),
		
		@v_mig_algo			int,
		@v_mig_op				int,
		@v_mig_iv				int,
		@v_mig_key_value		varchar(1024),
		@v_mig_range			varchar(1024),
		@v_mig_range_type	varchar(4),
		
		@v_enc_null				varchar(1),
		@v_operator_id			varchar(30),
		@v_derive_sp_alias		varchar(64),
		@v_select_type			int, 
    
    @id_chk            int,
		
		@v_code					int,
		@v_msg					varchar(1024)
begin
begin try
begin tran
	select @v_db_name=NULL
	select @v_db_owner=NULL
	select @v_db_table=NULL
	select @v_db_column=NULL
	select @v_key_id=NULL
	select @v_pid_symm=NULL
	select @v_pid_ape=NULL
	select @v_pid_out=NULL
	select @v_pid_iv=NULL
	select @v_sp_alias=NULL
	
	select @v_mig_algo=0
	select @v_mig_op =0 
	select @v_mig_iv = 0
	select @v_mig_key_value = NULL
	select @v_mig_range = NULL
	select @v_mig_range_type ='BYTE'
	
	select @v_enc_null ='N'
	select @v_operator_id = NULL
	select @v_derive_sp_alias = NULL

  ---------------------------------------------------------------------------------------------------------------
    -- I_SERVICE_INFO SPLIT : DB_NAMEDB_OWNERDB_TABLEDB_COLUMNKEY_IDPID_SYMMPID_APEPID_OUTPID_IV
  ---------------------------------------------------------------------------------------------------------------
  declare @flag	varchar(1)
  select @flag = char(24)
  
  select @v_db_name = damo.dbo.get_value_from_array(@i_service_info, 1, @flag)
  select @v_db_owner = damo.dbo.get_value_from_array(@i_service_info, 2, @flag)
  select @v_db_table = damo.dbo.get_value_from_array(@i_service_info, 3, @flag)
  select @v_db_column = damo.dbo.get_value_from_array(@i_service_info, 4, @flag)
  select @v_key_id = damo.dbo.get_value_from_array(@i_service_info, 5, @flag)
  select @v_pid_symm = damo.dbo.get_value_from_array(@i_service_info, 6, @flag)
  select @v_pid_ape = damo.dbo.get_value_from_array(@i_service_info, 7, @flag)
  select @v_pid_out = isnull(damo.dbo.get_value_from_array(@i_service_info, 8, @flag),'')
  select @v_pid_iv = isnull(damo.dbo.get_value_from_array(@i_service_info, 9, @flag),'')
  select @v_select_type = 0

  if(len(@i_sp_alias)=0)
  begin
    select @v_sp_alias = @i_service_id
  end
  else
  begin
    select @v_sp_alias = @i_sp_alias
  end
  
    select @id_chk = count(1)
    from damo.dbo.secure_kms_service_column
    where service_id = @i_service_id
  
  if(@id_chk != 0)
  begin
    rollback tran
    select @o_sqlcode = -300054
    select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
    return @o_sqlcode
  end
  
  select @id_chk = 0
  
  select @id_chk = count(1)
    from damo.dbo.secure_policy_master
    where sp_alias = @v_sp_alias
    
  if(@id_chk != 0)
  begin
    rollback tran
    select @o_sqlcode = -300057
    select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
    return @o_sqlcode
  end
  
  ---------------------------------------------------------------------------------------------------------------
    -- SECURE_KMS_SERVICE_COLUMN TABLE-- ---- INSERT
  ---------------------------------------------------------------------------------------------------------------
  insert into damo.dbo.secure_kms_service_column (service_id, db_name, db_owner, db_table, db_column, key_id, pid_symm, pid_ape, pid_out, descript, time, pid_iv)
    values( @i_service_id, @v_db_name, @v_db_owner, @v_db_table, @v_db_column, @v_key_id, @v_pid_symm, @v_pid_ape, @v_pid_out, @i_desc, getdate(), @v_pid_iv )

   ---------------------------------------------------------------------------------------------------------------
    -- SECURE_POLICY_MASTER TABLE-- ---- INSERT (SP_ALIAS ----)
   ---------------------------------------------------------------------------------------------------------------
  -- ------------ ---- -- -- ------ ID---- -------- mapping ---- --------
  exec get_column_mig_matching_info @i_service_id, @v_mig_algo output, @v_mig_op output, @v_mig_iv output, @v_mig_key_value output, @v_mig_range output, @v_mig_range_type output, @v_enc_null output, @v_code output, @v_msg output
  
  if( @v_code !=0)
  begin
    if (@@trancount > 0)
      rollback tran
    select @o_sqlcode = @v_code
    select @o_sqlerrm = @v_msg
    return @o_sqlcode
  end

  exec make_secure_policy_master @v_sp_alias, @v_mig_algo, @v_mig_iv, @v_select_type, @v_mig_op, @v_mig_range, @v_mig_range_type, @v_enc_null, @v_mig_key_value, @v_operator_id, @v_derive_sp_alias, @i_desc, @v_code output, @v_msg output
  
  if(@v_code != 0)
  begin
    if (@@trancount > 0)
    begin
      rollback tran
    end
    select @o_sqlcode = @v_code
    --select @o_sqlerrm = 'make_secure_policy_master fail'
    select @o_sqlerrm = @v_msg
    return @o_sqlcode
  end
  
  update secure_policy_master
  set service_id= @i_service_id
  where sp_alias=@v_sp_alias
  
  select @o_sqlcode = 0
  select @o_sqlerrm = 'SUCCESSFUL COMPLETION'
  
  if (@@trancount > 0)
    commit tran
  return 0 
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
    if (@@trancount > 0)
    begin
      rollback tran
    end
  end
  
  if (xact_state()) = 1
  begin
    if (@@trancount > 0)
    begin
      commit tran
    end
  end
  
  return @o_sqlcode
end catch
end --make_secure_kms_service_column
GO
