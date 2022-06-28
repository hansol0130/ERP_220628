USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[get_secure_kms_service_column](
									@i_service_id		varchar(64)
									,@o_key_id			varchar(64) output
									,@o_pid_symm		varchar(64) output
									,@o_pid_ape			varchar(64) output
									,@o_pid_out			varchar(64) output
									,@o_pid_iv			varchar(64) output
									,@o_sqlcode			int output
									,@o_sqlerrm			varchar(8000) output
)
as
begin
	declare @v_policy_count		int
	select @v_policy_count = 0
	
	select @v_policy_count=count(1)
	from damo.dbo.secure_kms_service_column
	where service_id = @i_service_id
	
	if(@v_policy_count != 1)
  begin
    select @o_sqlcode = -300058
    select @o_sqlerrm = damo.dbo.get_sqlerrm(@o_sqlcode)
    return @o_sqlcode
  end
	
	select @o_key_id=key_id,  @o_pid_symm=pid_symm, @o_pid_ape=pid_ape , @o_pid_out=pid_out , @o_pid_iv = pid_iv
	from damo.dbo.secure_kms_service_column
	where service_id = @i_service_id
	
	select @o_sqlcode =0
	select @o_sqlerrm = 'SUCCESSFUL COMPLETION'
  return 0
end --get_secure_kms_service_column
GO
