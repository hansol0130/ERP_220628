USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[damosa_dll_version]()
returns varchar(8000)
as
begin
  declare @damosaVersion varchar(16)
  declare @version varchar(8000), @ret int, @message varchar(8000)

  select @damosaVersion = value
   from damo.dbo.secure_cfg
   where section   = 'SYSTEM'
     and parameter = 'SA_VERSION'	
  
  select @damosaVersion = isnull(@damosaVersion, '2.3')
		
	if ( @damosaVersion >= '3.1001105' )
  begin
    exec @ret = master..xp_P5_GetVersionInfo @version output
    if @ret = 0
      select @message = 'D''Amo Sqlserver SA: damosa.dll version is ' + @version
  end
  else
    select @message = @damosaVersion + ': Not Supported Version'
    
    return @message
  
end
GO
