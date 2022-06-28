USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[get_CertKey](
	@agent_key		varbinary(4000)	 output,
	@agent_cer		varbinary(4000)  output,
	@agent_site		varbinary(4000)  output,
	@o_sqlcode		int					output, 
	@o_sqlerrm		varchar(8000) 	output
)
as
begin
	declare @ret        int
 
	exec @ret= master..xp_P5_getCertKey @agent_cer output, @agent_key output, @agent_site output
	
	if @ret <> 0
	begin
		select @o_sqlcode = @ret
		select @o_sqlerrm = 'FAILED TO EXECUTE xp_P5_getCertKey'
		return @ret
	end
	
	select @o_sqlcode= 0
	select @o_sqlerrm = 'get_CertKey success'
	
	return
end -- end get_CertKey
GO
