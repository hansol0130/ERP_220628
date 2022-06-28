USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[get_secure_kms_policy_iv](
								@i_pid_iv			varchar(64)
								,@o_iv_type		int output
								,@o_iv_value		varchar(64) output
								,@o_sqlcode		int output
								,@o_sqlerrm		varchar(8000) output
)
as
	declare @v_policy_count		int
begin
	select @v_policy_count =0
	
	---------------------------------------------------------------------------------------------------------------
        -- SECURE_KMS_POLICY_IV ---- GET
    ---------------------------------------------------------------------------------------------------------------
	select @v_policy_count=count(1)
	from damo.dbo.secure_kms_policy_iv
	where pid_iv = @i_pid_iv
	
	if(@v_policy_count != 1)
	begin
		select @o_sqlcode = -300058
		select @o_sqlerrm = 'Cannot find POLICY value'
		return @o_sqlcode
	end
	
	select @o_iv_type=iv_type,  @o_iv_value=iv_value
	from damo.dbo.secure_kms_policy_iv
	where pid_iv = @i_pid_iv
	
	select @o_sqlcode =0
	select @o_sqlerrm = 'SUCCESSFUL COMPLETION'
  
  return 0
end --get_secure_kms_policy_iv
GO
