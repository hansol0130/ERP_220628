USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[damosa_version]()
returns varchar(128)
as
begin
	return 'D''Amo Sqlserver SA v3.0.11.13 Release'
end
GO
