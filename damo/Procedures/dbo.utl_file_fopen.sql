USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create procedure [dbo].[utl_file_fopen]
	@pdir  varchar(255),
	@pfilename varchar(255),
	@pmode varchar(255),
	@psize int,
        @return_value_argument char(100) output 
    as
begin
  declare @fullname varchar(255),
	  @fso int,
	  @fileid int,
	  @pres int
	  
  set @return_value_argument = ''

  set @fullname = @pdir + '/' + @pfilename	

  if (@pmode = 'w')
    exec @pres = sp_OAMethod @fso, 'opentextfile', @fileid output, @fullname, 2, 1 
   else
    if (@pmode = 'a')
      exec @pres = sp_OAMethod @fso, 'opentextfile', @fileid output, @fullname, 8, 1 
     else
      if (@pmode = 'r')
       exec @pres = sp_OAMethod @fso, 'opentextfile', @fileid output, @fullname, 1, 0

end


GO
