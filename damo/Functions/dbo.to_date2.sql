USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





create  function [dbo].[to_date2] (@date_str as nvarchar(4000), @format as nvarchar(4000))
returns  datetime
as
begin


 declare
        @date_str1   nvarchar(4000),
        @time_str    nvarchar(4000),
        @watch_d     int,
        @id          int, 
        @fpart       nvarchar(4000),
        @value       nvarchar(4000),
        @nlen        int,
        @maxlen      int,
        @vbegin      int,
        @vbend       int,
        @tot_count   int,
        @tmp_str     nvarchar(4000),
        @comp_str1   nvarchar(4000),
        @comp_str2   nvarchar(4000),
        @sep         char(1),
        @type        char(1)
declare
        @prev_type char(1),
        @prev_vbegin int,
        @prev_vbend  int,
        @dt_str  nvarchar(4000),
        @tm_str  nvarchar(4000),
        @rez datetime ,
        @main_count int,
        @timelingth int,
        @temp_d datetime,
        @time_str_pos int,
        @pm_am_is tinyint,
        @nchar nchar(1),
        @tmp_dt datetime 

 ---------------------------
 declare  @tformat table(
                         [id] int primary key, 
                         [fpart]  nvarchar(20) not null,    -- mask
                         [value]  nvarchar(20) default N'', -- parsval
                         [nlen]   int ,                     -- length of parsval
                         [maxlen] int ,                     -- 
                         [vbegin] int default 0,            -- start position parsedval in parsing string
                         [vbend]  int default 0,            -- end position parsedval in parsing string 
                         [sep]    char(1),                  -- separator
                         [type]   char(1),                  -- type of  
                         [maxval] int ,
                         [prior]  int                     
                       )
 ---------------------------
 declare @punctuation table(
                            [id] int primary key, 
                            [pv] nvarchar(20)
                           )
         ----------------------------------------------------------------------------------
         insert into @punctuation ([id],[pv]) values(1,N' ')
         insert into @punctuation ([id],[pv]) values(2,N'-')
         insert into @punctuation ([id],[pv]) values(3,N'/')
         insert into @punctuation ([id],[pv]) values(4,N',')
         insert into @punctuation ([id],[pv]) values(5,N'.')
         insert into @punctuation ([id],[pv]) values(6,N';')
         insert into @punctuation ([id],[pv]) values(7,N':')
         insert into @punctuation ([id],[pv]) values(8,N'?')
  
         ----------------------------------------------------------------------------------
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(3, N'am',0,N'u',0,100)
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(4, N'a.m.',0,N'u',0,100)
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(5, N'bc',0,N'u',0,100)
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(6, N'b.c.',0,N'u',0,100)
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(10,N'dd',2,N'd',31,3)   -- 31 val
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(11,N'ddd',3,N'd',366,2) -- 366 
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(13,N'hh',2,N't',12,4)   -- 12 val
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(14,N'hh12',2,N't',12,4) -- 12 val
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(15,N'hh24',2,N't',24,4) -- 24 val
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(16,N'j',7,N'd',7,1)     -- 7 chars (converted to int)
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(17,N'mi',2,N't',60,5)   -- 60 val
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(18,N'mm',2,N'd',12,2)   -- 12 val
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(19,N'mon',9,N'd',0,2)   -- 
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(20,N'month',9,N'd',0,2) -- 
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(21,N'rm',4,N'd',0,2)    --
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(22,N'rr',2,N'd',0,1)    -- 
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(23,N'rrrr',4,N'd',0,1)  --
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(24,N'ss',2,N't',0,6)    --
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(25,N'y,yyy',5,N'd',0,1) --
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(28,N'yyyy',4,N'd',0,1)   -- 
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(30,N'yyy',3,N'd',0,1)    --
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(31,N'yy',2,N'd',0,1)     -- 
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(32,N'y',1,N'd',0,1)      --
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(33,N'pm',2,N'u',0,100)   --
         insert into @tformat ([id],[fpart],[nlen],[type],[maxval],[prior]) values(34,N'p.m.',4,N'u',0,100) --

 --normalization -------------------------------------------------------------------
  set @format = @format
  set @date_str   = @date_str
  if  patindex(N'%[0-9]'+','+N'[0-9][0-9][0-9]%',@date_str)>0
            set @date_str = replace(@date_str,N',',N'')
  if  patindex(N'%[a-z]'+','+N'[a-z][a-z][a-z]%',@format)>0 -----!!!!!!!!!!!!!!
            set @format = replace(@format,N',',N'')
 set @format = replace(@format,N' ',N'')
 if (patindex('%syyyy%',@format)>0)
    set @format = replace(@format,'syyyy','yyyy')
 update @tformat
    set [vbegin] =  patindex(N'%'+[fpart]+N'%',@format),
        [vbend]  =  patindex(N'%'+[fpart]+N'%',@format)+len([fpart]),
        [sep] = case 
                    when isnull(substring(@format,patindex(N'%'+[fpart]+N'%',@format)+len([fpart]),1),N'') in 
                     (select [pv] from @punctuation) then  substring(@format,patindex(N'%'+[fpart]+N'%',@format)+len([fpart]),1)
                     else N''
                end  
  where isnull(patindex(N'%'+[fpart]+N'%',@format),0) <>0
  set @pm_am_is = 0
  if patindex('%'+(select top 1 [fpart] from @tformat where [type]='u' and [vbegin]>0)+'%',@date_str)>0
     set @pm_am_is = 1
  if exists (select top 1 [fpart] from @tformat where [type]='u' and [vbegin]>0) 
     set @date_str = replace(@date_str,(select top 1 [fpart] from @tformat where [type]='u' and [vbegin]>0),'')
  ---------------------
 --select * from tformat
 -----------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------
 declare main_cur 
        cursor fast_forward for
         select  [vbegin],min([id]) [id],max([fpart]) [fpart],
                 max([value])  [value], max([nlen]) [nlen],
                 max([maxlen]) [maxlen],max([vbend])[vbend],max([sep]) [sep],
                 max([type]) [type] 
            from @tformat
          group by [vbegin] having [vbegin]>0
          order by [vbegin]
 -----------------------------------------------------------------------------------
 -----------------------------------------------------------------------
  set @time_str = N''
  set @date_str1 = N''
  set @timelingth = (select sum([nlen]) from 
                      (select  [vbegin],  max([nlen]) [nlen],max([type]) [type] 
                      from @tformat
                        group by [vbegin] having [vbegin]>0) t 
                        where [type] =N't'
                      )
  set @date_str1 = @date_str -- !!!
 -----------------------------------------------------------------------
 open main_cur 
 fetch next from main_cur into @vbegin,@id,@fpart,@value,@nlen,@maxlen,@vbend,@sep,@type
 set @tot_count=1
 -----------------------------------------------------------------------
 set @tot_count=1
 --wd----------------------------
 set @watch_d = 0
 ------------------------------
 while @@fetch_status=0 -- main
  begin
       -- data without chars
     set @main_count=@tot_count
     set @tmp_str=N''
     while @main_count<@tot_count+@nlen
         begin
              --------------------------
              set @watch_d =@watch_d+1
              if @watch_d >100 break
              --------------------------
              set @nchar =  substring(@date_str,@main_count,1)
              if @nchar in (N'-',N'/',N',',N'.',N';',N':',N'?',N' ') begin 
                 set @tot_count = @tot_count+1
                 if len(@tmp_str)>0 break
              end
              else 
                 set @tmp_str=@tmp_str+@nchar
             set @main_count = @main_count+1
         end -- while @main_count<@tot_count+@nlen

      set @tot_count=@tot_count+len(@tmp_str) 
      set @tmp_str = replace(@tmp_str,N' ',N'')               
      
      --------------------------------------------------------------
      set @tmp_str = @tmp_str
      ------------------------------ 
      if @fpart =N'rm' 
         begin
               set @tmp_str = case @tmp_str 
                                    when N'i'    then N'01'  when N'ii'   then N'02'  when N'iii'  then N'03'
                                    when N'iv'   then N'04'  when N'v'    then N'05'  when N'vi'   then N'06'
                                    when N'vii'  then N'07'  when N'viii' then N'08'  when N'ix'   then N'09'
                                    when N'x'    then N'10'  when N'xi'   then N'11'  when N'xii'  then N'12'
                                 end
         end
      ------------------------------ 
      if @fpart =N'j'
        begin
             if(len(@tmp_str)<>7) set @tmp_str=N'17530101'
             else 
                if isnumeric(@tmp_str)=1
                begin
                     set @temp_d  = dateadd(day,((cast(@tmp_str as int)-2361331)),N'17530101')
                     set @tmp_str = cast(year(@temp_d) as nvarchar(4))+
                                         replicate(N'0', 2-len(month(@temp_d)))+cast(month(@temp_d) as nvarchar(2)) +
                                         replicate(N'0', 2-len(day(@temp_d)))+cast(day(@temp_d) as nvarchar(2)) 
                end
        end 
      --------------------------------------------------------------
      if @fpart =N'hh' or @fpart =N'hh12'
        begin
             if cast(@tmp_str as int)>12 set @tmp_str =N'24'
             if exists(select  [vbegin],min([id]) [id],max([fpart]) [fpart],
                         max([value])  [value], max([nlen]) [nlen],
                         max([maxlen]) [maxlen],max([vbend])[vbend],max([sep]) [sep],max([type]) [type]
                    from @tformat
                  group by [vbegin] having [vbegin]>0 and (max([fpart])=N'pm' or max([fpart])=N'p.m.')                 
                  ) and @pm_am_is=1
              set @tmp_str =   cast(@tmp_str as int)+12
        end
      -----------------------------------------
      if @fpart =N'rr'
        begin
                if isnumeric(@tmp_str)=1
                begin
                      if patindex('%2000 - 8%', @@version) >0 
                        select top 1 @tmp_dt=localtime from damo.dbo.[v_builtinfunctions]
                      else 
                       set @tmp_dt=cast('20000101' as datetime)
                     set @tmp_str = case 
                                         when cast(@tmp_str as int) < 50 then cast(year(@tmp_dt)/100 as nvarchar(2)) + @tmp_str
                                         else cast((year(@tmp_dt))/100-1 as nvarchar(2)) + @tmp_str
                                    end 
                end
        end 
      --------------------------------------------------------------
      if @fpart =N'yyy' or @fpart =N'yy' or @fpart =N'y' 
        begin
                      if patindex('%2000 - 8%', @@version) >0 
                        select top 1 @tmp_dt=localtime from damo.dbo.[v_builtinfunctions]
                      else 
                       set @tmp_dt=cast('20000101' as datetime)
                     set @tmp_str = cast((('2005')/(power(10,len(@fpart)))) as nvarchar(4)) + @tmp_str
        end 
      --------------------------------------------------------------
      if @fpart =N'dd'
        begin
                if isnumeric(@tmp_str)=1 begin
                     set @tmp_str =  replicate(N'0', 2-len(@tmp_str))+@tmp_str
                end
        end 
      --------------------------------------------------------------
      if @fpart =N'mm'
        begin
                if isnumeric(@tmp_str)=1 begin
                     set @tmp_str =  replicate(N'0', 2-len(@tmp_str))+@tmp_str
                end
        end 
      --------------------------------------------------------------
      update @tformat
         set [value] = @tmp_str
       where [vbegin]=@vbegin and [vbend]=@vbend
      --------------------------------------------------------------
       fetch next from main_cur into @vbegin,@id,@fpart,@value,@nlen,@maxlen,@vbend,@sep,@type
      -----------------------
      if @watch_d >1000 break
      -----------------------
  end -- main
  -----------------------------------------------------------------------
  --checking-------------------------------------------------------------
   if exists (select null from @tformat where fpart= N'ddd' and len(value) >0)
        begin
             declare @td nvarchar(4)
             set @td = (select top 1 value from @tformat where fpart like N'y%' and len(value)>0)
             set @tmp_str = (select top 1 value from @tformat where fpart = N'ddd' and len(value)>0)
             set @temp_d  = cast(dateadd(day,(case(cast(@tmp_str as int)) when 0 then 0 else cast(@tmp_str as int) end  -1 ),(@td+ N'0101')) as nvarchar(30))
             
             set @tmp_str = replicate(N'0', 2-len(month(@temp_d)))+cast(month(@temp_d) as nvarchar(2)) +
                            replicate(N'0', 2-len(day(@temp_d)))+cast(day(@temp_d) as nvarchar(2)) 
             update @tformat set value = @tmp_str  where fpart= N'ddd' and len(value) >0
        end 
  -----------------------------------------------------------------------
  close main_cur
  deallocate main_cur
  set @comp_str1=N''
  set @comp_str2=N''
  --------------------------
  set @dt_str = N''
  set @tm_str = N''
  select @dt_str= @dt_str +case 
                       when [type]=N'd' then  [value] 
                       else N'' end,
          @tm_str= @tm_str+case 
                       when [type]=N't' then  [value] +N':'
                       else N'' end,
        @comp_str2=@comp_str2+[value]
  from 
         (
          select  [vbegin],min([id]) [id],max([fpart])       [fpart],
                         max([value])  [value], max([nlen])  [nlen],
                         max([maxlen]) [maxlen],max([vbend]) [vbend]
                         ,max([type]) [type]
                         ,max([prior]) [prior]
                    from @tformat
                  
                  group by [vbegin] having [vbegin]>0
          )t
          order by [prior],[vbegin]

  if substring(@tm_str,len(@tm_str),1)=N':'
    set @tm_str = substring(@tm_str,1,len(@tm_str)-1)

  if isdate(@dt_str+N' '+@tm_str)=1
     set @rez = cast((@dt_str+N' '+@tm_str) as datetime)
  else set @rez =null
  return @rez
end




GO
