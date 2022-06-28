USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[secure_update_cfg]()
returns int
as
begin
  declare @ret int
  exec @ret = master.dbo.xp_P5_UpdateSecureCfg
  
  if(@ret != 0)
    return -1

  return 0
end
GO
