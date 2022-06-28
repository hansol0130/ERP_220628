USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[get_sqlerrm] (@o_sqlcode int)
returns varchar(8000)
as
-- ---- ------ ----.
begin
	declare @o_sqlerrm varchar(8000)

	if @o_sqlcode <= 0 
	-- d'amo---- -------- ---- ------ 
	begin 
		select @o_sqlerrm = description
			from damo.dbo.damo_sysmessage 
			where error = @o_sqlcode
	end 
	else
		-- ms sql -- ---- ------
	begin 
		select @o_sqlerrm = description
			from master.dbo.sysmessages
			where error = @o_sqlcode
	end 

	return isnull(@o_sqlerrm, '')
end




GO
