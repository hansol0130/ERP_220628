USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[encrypt_str_hmac] 
(
  @i_sp_alias varchar(64),
  @i_data varchar(8000)
)
returns varbinary(8000)
--with encryption
as
begin
  declare @ret int,  @out    varbinary(8000), @in varbinary(8000)
  
  select @in= cast(@i_data as varbinary(8000)) 
  
  -- C ---- ----
  exec @ret = master.dbo.xp_P5_ENC_STR_HMAC @in, @i_sp_alias, @out output
  
  if(@ret!=0)
    return -1
  
  return @out
end
GO
