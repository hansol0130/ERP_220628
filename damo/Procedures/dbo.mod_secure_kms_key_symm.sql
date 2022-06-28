USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[mod_secure_kms_key_symm](
									@i_key_id 		varchar(64)
									,@i_mod_key_id varchar(64)
									,@o_sqlcode		int output
									,@o_sqlerrm		varchar(8000) output
)
as
declare @v_use_count int
begin
begin try
begin tran
	---------------------------------------------------------------------------------------------------------------
        -- ---- ------ KEY_ID-- ------ ---- ---- ------ ---- ------ ---- ----
    ---------------------------------------------------------------------------------------------------------------
	select @v_use_count = count(1)
	 from damo.dbo.secure_kms_key_symm
 	 where key_id=@i_mod_key_id
	
	if(@v_use_count!=0)
	begin
    rollback tran
		select @o_sqlcode = -300060
		select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
		return @o_sqlcode
	end
	
	insert into damo.dbo.secure_kms_key_symm(key_id, key_data, key_len, key_type, descript, time)
		select @i_mod_key_id, key_data, key_len, key_type, descript, time
		from damo.dbo.secure_kms_key_symm
		where key_id=@i_key_id
	
	update damo.dbo.secure_kms_service_column
	 set key_id=@i_mod_key_id
 	 where key_id=@i_key_id
	
	---------------------------------------------------------------------------------------------------------------
        -- ---- ------ ---- ---- KEY ----
  ---------------------------------------------------------------------------------------------------------------
	delete 
	 from damo.dbo.secure_kms_key_symm
	 where key_id=@i_key_id

	select @o_sqlcode=0
	select @o_sqlerrm ='SUCCESSFUL COMPLETION'
	
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
end --mod_secure_kms_key_symm
GO
