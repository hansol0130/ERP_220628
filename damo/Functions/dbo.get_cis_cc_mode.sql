USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[get_cis_cc_mode]()
returns varchar(16)
as
begin
	declare @state int, @ret int
	exec @ret = master..xp_P5_PCIS_CC_GetState @state output
	if @ret = 0
		return convert(varchar(16), @state)
	
	return '5' -- CIS2-4
end
GO
