USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[lms_linkage_check] ()
returns int
begin
  declare @v_count int
  declare @v_flag_lms_linkage int
  
  set @v_count =0
  set @v_flag_lms_linkage = 0
  
  select @v_count = count(*)
    from damo.dbo.secure_cfg
    where section = 'SYSTEM' and parameter= 'LMS_LINKAGE'
  
  if ( @v_count =0 )
  begin
    select @v_flag_lms_linkage = 0
  end
  else
  begin
    select @v_flag_lms_linkage = case value when 'TRUE' then 1 else 0 end
      from damo.dbo.secure_cfg
      where section = 'SYSTEM' and parameter = 'LMS_LINKAGE'
  end
  
  return @v_flag_lms_linkage
end
GO
