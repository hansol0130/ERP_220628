USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[mod_secure_kms_service_column](
									@i_service_id			varchar(64)
									,@i_mod_service_id		varchar(64) 
									,@o_sqlcode				int output
									,@o_sqlerrm				varchar(8000) output
)
as
begin
begin try
begin tran
	declare @v_use_count  int
	select @v_use_count =0
	---------------------------------------------------------------------------------------------------------------
        -- ---- ------ SERVICE_ID-- ------ ---- ---- ------ ---- ------ ---- ----
  ---------------------------------------------------------------------------------------------------------------
	
	select @v_use_count=count(1)
	from damo.dbo.secure_kms_service_column
	where service_id= @i_mod_service_id
	
	if(@v_use_count!=0)
	begin
    rollback tran
		select @o_sqlcode = -300054
		select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
		return @o_sqlcode
	end
	
	insert into damo.dbo.secure_kms_service_column	(service_id, db_name, db_owner, db_table, db_column, key_id, pid_symm, pid_ape, pid_out, descript, time, pid_iv)
    select @i_mod_service_id,   db_name, db_owner, db_table, db_column, key_id, pid_symm, pid_ape, pid_out, descript, time, pid_iv
    from damo.dbo.secure_kms_service_column
    where service_id=@i_service_id
	
	update damo.dbo.secure_column_info
    set service_id = @i_mod_service_id
    where service_id=@i_service_id
	
	update damo.dbo.secure_policy_master
    set service_id=@i_mod_service_id
    where  service_id=@i_service_id
	 ---------------------------------------------------------------------------------------------------------------
        -- ---- ------ ---- ---- KEY ----
   ---------------------------------------------------------------------------------------------------------------
	
	delete 
	from damo.dbo.secure_kms_service_column
	where service_id=@i_service_id
  
  declare @ret int
  exec @ret = master.dbo.xp_P5_InitSecureInfos
  
  if(@ret != 0)
  begin
    rollback tran
    select @o_sqlcode = -1
    select @o_sqlerrm = 'FAILED TO EXECUTE xp_P5_InitSecureInfos'
    return -1
  end
	
	select @o_sqlcode = 0
	select @o_sqlerrm = 'SUCCESSFUL COMPLETION'

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
  select 'catch'
  select @o_sqlcode = ERROR_NUMBER()
  select convert(varchar,@o_sqlcode)
  select @o_sqlerrm = substring('Msg ' + convert(varchar,ERROR_NUMBER()) +', Level '+ convert(varchar,ERROR_SEVERITY())+', State '+ convert(varchar,ERROR_STATE()) + ', Line ' + convert(varchar,ERROR_LINE()) +'  //  ' + ERROR_MESSAGE(), 1, 8000)
  select @o_sqlerrm
        
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
end --mod_secure_kms_service_column
GO
