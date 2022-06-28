USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[get_column_mig_matching_info](
									@i_service_id		varchar(64)
									,@o_algo				int output
									,@o_op				int output
									,@o_iv				int output
									,@o_key_value		varchar(1024) output
									,@o_range			varchar(64) output
									,@o_range_type		varchar(64) output
									,@o_null_enc		varchar(1) output   
									,@o_sqlcode			int output
									,@o_sqlerrm 		varchar(8000) output
)
as
	declare
		@v_policy_count		int,
		@v_key_id				varchar(64),
		@v_pid_symm			varchar(64),
		@v_pid_ape				varchar(64),
		@v_pid_out				varchar(64),
		@v_pid_iv				varchar(64),
    @v_iv_value      varchar(64),
		
		@v_range_start			int,
		@v_range_len			int,
		@v_range_type			int,
		
		@v_code					int,
		@v_msg					varchar(1024)
begin
	select @v_policy_count = 0
	select @v_key_id = NULL
	select @v_pid_symm = NULL
	select @v_pid_ape = NULL
	select @v_pid_out = NULL
	select @v_pid_iv = NULL
	
	select @v_range_start = 0
	select @v_range_len = 0
	select @v_range_type = 0
	
	select @v_code =0
	
	select @o_null_enc = NULL
	
	---------------------------------------------------------------------------------------------------------------
        -- SECURE_KMS_SERVICE_COLUMN ---- GET
    ---------------------------------------------------------------------------------------------------------------
	select @v_policy_count = count(1)
	from damo.dbo.secure_kms_service_column
	where service_id=@i_service_id
	
	if(@v_policy_count != 1)
	begin
		select @o_sqlcode = -300058
		select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
		return @o_sqlcode
	end

	exec get_secure_kms_service_column @i_service_id, @v_key_id output, @v_pid_symm output, @v_pid_ape output, @v_pid_out output, @v_pid_iv output, @v_code output, @v_msg output
	
	if(@v_code !=0)
	begin
		select @o_sqlcode = @v_code
		select @o_sqlerrm = @v_msg
		return @o_sqlcode
	end
	
	exec get_secure_kms_key_symm @v_key_id, @o_key_value output, @v_code output, @v_msg output
	
	if(@v_code !=0)
	begin
		select @o_sqlcode =@v_code
		select @o_sqlerrm = @v_msg
		return @o_sqlcode
	end
	
	if( len(@v_pid_symm)!=0)
	begin
		exec get_secure_kms_policy_symm @v_pid_symm, @o_algo output, @o_op output, @o_iv output, @o_null_enc output, @v_code output, @v_msg output
		if( @v_code !=0 )
		begin
			select @o_sqlcode =@v_code
			select @o_sqlerrm = @v_msg
			return @o_sqlcode
		end
	end
	else -- ---- ------ ----
	begin
		exec get_secure_kms_policy_ape @v_pid_ape, @o_algo output, @o_op output, @o_iv output, @o_null_enc output, @v_code output, @v_msg output
		if(@v_code !=0)
		begin
			select @o_sqlcode =@v_code
			select @o_sqlerrm = @v_msg
			return @o_sqlcode
		end
	end
  
  if( len(@v_pid_iv)!=0)
  begin
    exec get_secure_kms_policy_iv @v_pid_iv,  @o_iv output, @v_iv_value output, @v_code output, @v_msg output
    
    if(@v_code !=0)
    begin
      select @o_sqlcode = @v_code
      select @o_sqlerrm = @v_msg
      return @o_sqlcode
    end
    
  end
	
	if(@v_pid_out ='')
	begin
		select @o_range = NULL
		select @o_range_type = NULL
	end
	else
	begin
		exec get_secure_kms_policy_output @v_pid_out, @v_range_start output, @v_range_len output, @v_range_type output, @v_code output, @v_msg output
		if(@v_code !=0)
		begin
			select @o_sqlcode =@v_code
			select @o_sqlerrm = @v_msg
			return @o_sqlcode
		end
		
		select @o_range = convert(varchar(64), @v_range_start)+',' + convert(varchar(64),@v_range_len)
		
		if(@v_range_type  =0)
		begin
			select @o_range_type= 'BYTE'
		end
		if(@v_range_type = 1)
		begin
			select @o_range_type = 'CHAR'
		end
	end
	
	select @o_sqlcode = 0
	select @o_sqlerrm = 'SUCCESSFUL COMPLETION'
  
  return 0
end
GO
