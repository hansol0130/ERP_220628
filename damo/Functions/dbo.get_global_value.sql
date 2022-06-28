USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create  function [dbo].[get_global_value]
(
	@name varchar(128)
)
 returns varchar(1024)
as
begin
  declare @value varchar(1024)

	select @value = value
	from damo.dbo.secure_package_variable
	where var_name = @name
	   and session_id = @@spid
	
	select @value = isnull(@value, 'FALSE')

  return @value
end




GO
