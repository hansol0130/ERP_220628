USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* ------------------ IP --------- ------------ ------ */
create function [dbo].[secure_context$get_local_server_ip]()
returns varchar(255)
as
begin
	declare @strtemp varchar(256)
	declare @session_ipinfo varchar(256)
	exec master.dbo.xp_P5_GetLocalIP '<local machine>', @session_ipinfo output
	return @session_ipinfo
end
GO
