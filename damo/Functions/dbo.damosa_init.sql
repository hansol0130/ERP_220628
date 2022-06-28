USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[damosa_init]()
returns int
as
begin
  declare @ret int
  exec @ret = master..xp_P5_InitSecureInfos
  return @ret
end
GO
