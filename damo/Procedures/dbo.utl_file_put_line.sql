USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create  procedure [dbo].[utl_file_put_line]
	@phandle char(100),
	@pline varchar(8000)
as
begin
  declare @fileid int, @pres int 

  set @pres = 1
  if @phandle = '' 
    begin  
		return 
    end
  set @fileid = convert(int, substring(@phandle,51,50))  
  exec @pres = sp_OAMethod @fileid, 'writeline', null, @pline
  if @pres != 0
      begin
         return
      end
end


GO
