USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[del_secure_kms_service_column](
								@i_service_id		varchar(64)
								,@o_sqlcode			int output
								,@o_sqlerrm 		varchar(8000) output
)
as
	declare 
		@v_use_vti_count		int,
		@v_use_api_count		int,
    @tmp_sp_alias        varchar(64)
begin
begin try
begin tran
	select @v_use_vti_count =0
	select @v_use_api_count=0
	
	---------------------------------------------------------------------------------------------------------------
        -- SERVICE-- ------ ---------- ---- ------ ----
  ---------------------------------------------------------------------------------------------------------------
	select @v_use_vti_count = count(1)
	from damo.dbo.secure_column_info
	where service_id=@i_service_id
	
	if(@v_use_vti_count !=0)
	begin
    rollback tran
		select @o_sqlcode = -300063
		select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
		return @o_sqlcode
	end
  
  select @tmp_sp_alias = sp_alias
    from damo.dbo.secure_policy_master
    where service_id = @i_service_id
  
  select @v_use_api_count = count(1)
    from damo.dbo.secure_column_info
    where sp_alias = @tmp_sp_alias
    
  if(@v_use_api_count !=0)
  begin
    rollback tran
    select @o_sqlcode = -300055
    select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
    return @o_sqlcode
  end
  
	---------------------------------------------------------------------------------------------------------------
        -- ---- ------ ---- ---- KEY ----
    ---------------------------------------------------------------------------------------------------------------
	delete from damo.dbo.secure_kms_service_column
	where service_id=@i_service_id
	
	delete from damo.dbo.secure_policy_master
	where service_id=@i_service_id
	
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
end --del_secure_kms_service_column
GO
