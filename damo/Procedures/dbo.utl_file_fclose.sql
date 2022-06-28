USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




create  procedure [dbo].[utl_file_fclose]
	@phandle char(100) output
as
begin
  declare @fso int,
	  @fileid int,
	  @pres int

  set @pres = 1 
  if @phandle = '' 
    begin
    return 
    end
  set @fso    = convert(int, substring(@phandle,1,50))
  set @fileid = convert(int, substring(@phandle,51,50))
  exec @pres = sp_OADestroy @fileid
  if @pres != 0 
    begin
    return 
    end
  exec @pres = sp_OADestroy @fso
  if @pres != 0 
    begin
    return 
    end
  set @phandle = '' 
end



GO
