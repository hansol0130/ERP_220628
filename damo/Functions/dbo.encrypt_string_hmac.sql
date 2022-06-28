USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[encrypt_string_hmac]
(
  @i_owner  varchar(64),
  @i_table  varchar(64),
  @i_column  varchar(64),
  @i_data varchar(8000)
)
returns varbinary(8000)
--with encryption
as
begin
  declare @ret int,   @out      varbinary(8000), @in varbinary(8000)
  
  select @in= cast(@i_data as varbinary(8000)) 
  select @ret = 0
  
  -- C ---- ----
  exec @ret = master.dbo.xp_P5_ENC_STRING_HMAC @in, @i_owner, @i_table, @i_column, @out output
  
  if(@ret!=0)
    return -1
  
  return @out
end
GO
