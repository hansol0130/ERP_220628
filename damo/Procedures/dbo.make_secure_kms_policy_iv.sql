USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[make_secure_kms_policy_iv](
								@i_pid_iv			varchar(64)
								,@i_policy_info	varchar(64)
								,@i_desc			varchar(8000)
								,@o_sqlcode		int output
								,@o_sqlerrm		varchar(8000) output
)
as 
	declare
		@v_iv_type		int,
		@v_iv_value		varchar(64),
    @id_chk        int
begin
begin try
begin tran
	select @v_iv_type = 0
	select @v_iv_value = NULL
	
  select @id_chk = count(1)
    from damo.dbo.secure_kms_policy_iv
    where pid_iv = @i_pid_iv
    
  if(@id_chk != 0)
  begin
    rollback tran
    select @o_sqlcode = -300059
    select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
    return @o_sqlcode
  end
  
	---------------------------------------------------------------------------------------------------------------
        -- I_POLICY_INFO SPLIT : IV_TYPEIV_VALUE
    ---------------------------------------------------------------------------------------------------------------
	declare @flag	varchar(1)
	select @flag =char(24)
	
	select @v_iv_type = convert (int, damo.dbo.get_value_from_array(@i_policy_info, 1, @flag))
	select @v_iv_value = damo.dbo.get_value_from_array(@i_policy_info, 2, @flag)
	
	---------------------------------------------------------------------------------------------------------------
        -- SECURE_KMS_POLICY_IV  TABLE-- ---- INSERT
    ---------------------------------------------------------------------------------------------------------------
	
	insert into damo.dbo.secure_kms_policy_iv ( pid_iv, iv_type, iv_value, descript, time)
		values( @i_pid_iv, @v_iv_type, @v_iv_value, @i_desc, getdate())
	
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
end --make_secure_kms_policy_iv
GO
