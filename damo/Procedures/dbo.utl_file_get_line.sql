USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- exception -------- ---- ----
create   procedure [dbo].[utl_file_get_line]
	@phandle char(100),
	@pline varchar(8000) output,
	@plinesize int = null--,
--	@plen int output
as
begin
  declare @fileid int,
  	  @pres int,
	  @eof int,
	  @eol int,
	  @lline varchar(8000)

  set @pline = ''
  set @pres = 1
  if @phandle = '' 
    begin  
    return 
    end

  set @fileid = convert(int, substring(@phandle,51,50))  

  set @pline = ''

  exec sp_OAGetProperty @fileid, 'atendofstream', @eof output    
  if @eof = 1
   begin
    return
   end

  if @plinesize is null 
   begin
    exec @pres = sp_OAMethod @fileid, 'readline', @pline output
    if @pres != 0 
     begin
        return
     end
   end
   else
   while @plinesize > 0
    begin
     exec sp_OAGetProperty @fileid, 'atendofline', @eol output    
     if @eol = 1 
      begin
        exec @pres = sp_OAMethod @fileid, 'readline', @lline output
        if @pres != 0 
         begin
          return
         end
        set @pline = @pline + @lline
	break
      end
     exec @pres = sp_OAMethod @fileid, 'read', @lline output, @characters = 1
     if @pres != 0 
      begin
         return
      end
     set @pline = @pline + @lline
     set @plinesize = @plinesize - 1
    end

--  set @plen = len(@pline)

end



GO
