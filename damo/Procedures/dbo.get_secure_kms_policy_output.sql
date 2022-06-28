USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[get_secure_kms_policy_output](
									@i_pid_out				varchar(64)
									,@o_range_start			int output
									,@o_range_len			int output
									,@o_enc_range_type	int output
									,@o_sqlcode				int output
									,@o_sqlerrm 			varchar(8000) output
)
as 
	declare @v_policy_count  int
begin
	select @v_policy_count =0
	
	---------------------------------------------------------------------------------------------------------------
        -- SECURE_KMS_POLICY_OUTPUT -- ---- GET
  ---------------------------------------------------------------------------------------------------------------
	select @v_policy_count=count(1)
	from damo.dbo.secure_kms_policy_output
	where pid_out = @i_pid_out
	
	if(@v_policy_count !=1)
	begin
		select @o_sqlcode = -300058
		select @o_sqlerrm =damo.dbo.get_sqlerrm(@o_sqlcode)
		return @o_sqlcode
	end
  
	select @o_range_start=range_start,  @o_range_len=range_len,  @o_enc_range_type= enc_range_type
	from damo.dbo.secure_kms_policy_output
	where pid_out = @i_pid_out
	
	select @o_sqlcode =0
	select @o_sqlerrm = 'SUCCESSFUL COMPLETION'

   return 0
end --get_secure_kms_policy_output
GO
