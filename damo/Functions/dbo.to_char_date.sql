USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[to_char_date](@date_t as datetime, @format as nvarchar(4000))
returns nvarchar(4000)
begin
  if @date_t is null or isnull(@format, '') is null
    return null

  declare @retval nvarchar(4000), @ind integer, @ind1 integer, @flag tinyint, @strlen integer, @strlen1 integer
  set @retval = @format

  declare @midnight datetime, @monthname nvarchar(100), @dayname nvarchar(100), @year varchar(4),
          @century varchar(2), @hour12 varchar(2), @hour24 varchar(2), 
          @seconddigits tinyint, @millisecond varchar(9), @firstyearday integer,
          @isoweek integer, @isoyear varchar(4), @isodeltaday integer, @yearsign varchar(1),
          @fmpos integer, @blanksymbol varchar(1), @rest integer, @thexp varchar(2),
          @tzh integer, @tzm integer, @nametemp nvarchar(4000)

  set @yearsign = ' '
  set @blanksymbol = '0'

  if right(year(@date_t), 2) = '00' 
    set @century = left(convert(nvarchar(4), year(@date_t)), 2)
  else
    set @century = convert(nvarchar(2), cast(left(convert(nvarchar(4), year(@date_t)), 2) as integer) + 1)

  set @midnight = convert(datetime, cast(day(@date_t) as nvarchar) + '/' + cast(month(@date_t) as nvarchar) + '/' + cast(year(@date_t) as nvarchar), 103)
  set @monthname = datename(month, @date_t) + space(9 - len(datename(month, @date_t)))
  set @dayname = datename(dw, @date_t) + space(9 - len(datename(dw, @date_t)))
  set @year = convert(nvarchar(4), year(@date_t))
  set @hour24 = convert(nvarchar(2), datepart(hour, @date_t))
  set @hour12 = convert(nvarchar(2), case when datepart(hour, @date_t) > 12 then datepart(hour, @date_t) - 12
                                          when datepart(hour, @date_t) = 0 then datepart(hour, @date_t) + 12
                                          else datepart(hour, @date_t) end )
  set @firstyearday = isnull(nullif((@@datefirst + datepart(dw, convert(datetime, '01/01/' + cast(year(@date_t) as nvarchar))) - 1) % 7, 0), 7)
  set @isodeltaday = isnull(nullif(8 - @firstyearday, 7), 0)
  set @isoweek = (datepart(dayofyear, @date_t) + @isodeltaday) / 7 + @isodeltaday / 4 + (1 - sign(@isodeltaday / datepart(dayofyear, @date_t)))
  set @isoyear = convert(nvarchar(4), year(@date_t))
  if @isoweek = 0
    begin
      set @firstyearday = isnull(nullif((@@datefirst + datepart(dw, convert(datetime, '01/01/' + cast(year(@date_t) - 1 as nvarchar))) - 1) % 7, 0), 7)
      set @isodeltaday = isnull(nullif(8 - @firstyearday, 7), 0)
      set @isoweek = datediff(day, convert(datetime, cast(@isodeltaday + 1 as nvarchar) + '/01/' + cast(year(@date_t) - 1 as nvarchar), 103), @date_t) / 7 + 1 + @isodeltaday / 4
      set @isoyear = convert(nvarchar(4), year(@date_t) - 1)
    end

  if @date_t >= convert(datetime, '29/12/' + cast(year(@date_t) as nvarchar), 103)
    begin
      set @isodeltaday = isnull(nullif((@@datefirst + datepart(dw, @date_t)) % 7 - 1, 0), 7)
      if 3 - (31 - day(@date_t)) >= @isodeltaday
        begin
          set @isoweek = 1    
          set @isoyear = convert(nvarchar(4), year(@date_t) + 1)
        end
    end

  
  if left(cast(serverproperty('productversion') as varchar), 1) = '8'
    select @tzh = timediff / 60, @tzm = timediff % 60 from damo.dbo.v_builtinfunctions
  else
    select @tzh = null, @tzm = null


  set @fmpos = charindex('fm', @retval)
-- check for "..."
  set @ind = charindex('"', @retval)
  if @fmpos > 0
    while @ind > 0
      if @fmpos > @ind
        begin
          set @ind = charindex('"', @retval, @ind + 1)
          if @fmpos < @ind
            begin
              set @fmpos = charindex('fm', @retval, @ind)
              set @ind = charindex('"', @retval, @ind + 1)
              continue
            end
        end
      else break

  set @retval = replace(@retval, 'fm', '')

  set @retval = replace(@retval, 'fx', '') -- doesn't affect this conversion
  set @ind = charindex('tzd', @retval)
  set @ind1 = charindex('"', @retval)
  if @ind > 0
    while @ind1 > 0
      if @ind > @ind1
        begin
          set @ind1 = charindex('"', @retval, @ind1 + 1)
          if @ind < @ind1
            begin
              set @ind = charindex('tzd', @retval, @ind1)
              set @ind1 = charindex('"', @retval, @ind1 + 1)
              continue
            end
        end

  if @ind > 0
    begin
--      date format not recognized
      return null
    end

  if @tzh is null
  begin
  set @ind = charindex('tzh', @retval)
  set @ind1 = charindex('"', @retval)
  if @ind > 0
    while @ind1 > 0
      if @ind > @ind1
        begin
          set @ind1 = charindex('"', @retval, @ind1 + 1)
          if @ind < @ind1
            begin
              set @ind = charindex('tzh', @retval, @ind1)
              set @ind1 = charindex('"', @retval, @ind1 + 1)
              continue
            end
        end

  if @ind > 0
    begin
--      date format not recognized
      return null
    end
  end

  if @tzh is null
  begin
  set @ind = charindex('tzm', @retval)
  set @ind1 = charindex('"', @retval)
  if @ind > 0
    while @ind1 > 0
      if @ind > @ind1
        begin
          set @ind1 = charindex('"', @retval, @ind1 + 1)
          if @ind < @ind1
            begin
              set @ind = charindex('tzm', @retval, @ind1)
              set @ind1 = charindex('"', @retval, @ind1 + 1)
              continue
            end
        end

  if @ind > 0
    begin
--      date format not recognized
      return null
    end
  end

  if (@tzh is null) or (@tzm is null)
  begin
  set @ind = charindex('tzr', @retval)
  set @ind1 = charindex('"', @retval)
  if @ind > 0
    while @ind1 > 0
      if @ind > @ind1
        begin
          set @ind1 = charindex('"', @retval, @ind1 + 1)
          if @ind < @ind1
            begin
              set @ind = charindex('tzr', @retval, @ind1)
              set @ind1 = charindex('"', @retval, @ind1 + 1)
              continue
            end
        end

  if @ind > 0
    begin
--      date format not recognized
      return null
    end
  end
  
  set @ind = charindex('dl', @retval)
  set @ind1 = charindex('"', @retval)
  if @ind > 0
    while @ind1 > 0
      if @ind > @ind1
        begin
          set @ind1 = charindex('"', @retval, @ind1 + 1)
          if @ind < @ind1
            begin
              set @ind = charindex('dl', @retval, @ind1)
              set @ind1 = charindex('"', @retval, @ind1 + 1)
              continue
            end
        end
      else break

  if @ind > 0
    begin
--      date format not recognized
      return null
    end

  set @ind = charindex('ds', @retval)
  set @ind1 = charindex('"', @retval)
  if @ind > 0
    while @ind1 > 0
      if @ind > @ind1
        begin
          set @ind1 = charindex('"', @retval, @ind1 + 1)
          if @ind < @ind1
            begin
              set @ind = charindex('ds', @retval, @ind1)
              set @ind1 = charindex('"', @retval, @ind1 + 1)
              continue
            end
        end
      else break

  if @ind > 0
    if (substring(@retval, @ind, 3) <> 'dsp') 
      begin
--        date format not recognized
        return null
      end

  set @ind = charindex('ts', @retval)
  set @ind1 = charindex('"', @retval)
  if @ind > 0
    while @ind1 > 0
      if @ind > @ind1
        begin
          set @ind1 = charindex('"', @retval, @ind1 + 1)
          if @ind < @ind1
            begin
              set @ind = charindex('ts', @retval, @ind1)
              set @ind1 = charindex('"', @retval, @ind1 + 1)
              continue
            end
        end
      else break

  if @ind > 0
    begin
--      date format not recognized
      return null
    end

  set @ind = charindex('ee', @retval)
  set @ind1 = charindex('"', @retval)
  if @ind > 0
    while @ind1 > 0
      if @ind > @ind1
        begin
          set @ind1 = charindex('"', @retval, @ind1 + 1)
          if @ind < @ind1
            begin
              set @ind = charindex('ee', @retval, @ind1)
              set @ind1 = charindex('"', @retval, @ind1 + 1)
              continue
            end
        end
      else break

  if @ind > 0
    begin
--      date format not recognized
      return null
    end

  set @ind = charindex('e', @retval)
  set @ind1 = charindex('"', @retval)
  if @ind > 0
    while @ind1 > 0
      if @ind > @ind1
        begin
          set @ind1 = charindex('"', @retval, @ind1 + 1)
          if @ind < @ind1
            begin
              set @ind = charindex('e', @retval, @ind1)
              set @ind1 = charindex('"', @retval, @ind1 + 1)
              continue
            end
        end
      else break

  if @ind > 0
    begin
      if (substring(@retval, @ind - 1, 4) <> 'year')
        begin
--          date format not recognized
          return null
        end
    end

  set @ind = charindex('tz', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 set @blanksymbol = ''
      if substring(@retval, @ind, 3) = 'tzh'
        if substring(@retval, @ind + 3, 4) in ('spth', 'thsp') or substring(@retval, @ind + 3, 2) = 'sp'
          set @retval = stuff(@retval, @ind, 3, char(124) + case sign(@tzh) when -1 then '-' when 1 then '+' else '' end + right(@blanksymbol + cast(@tzh as nvarchar), 2))
        else
          set @retval = stuff(@retval, @ind, 3, case sign(@tzh) when -1 then '-' when 1 then '+' else '' end + right(@blanksymbol + cast(@tzh as nvarchar), 2))
      else
      if substring(@retval, @ind, 3) = 'tzm'
        if substring(@retval, @ind + 3, 4) in ('spth', 'thsp') or substring(@retval, @ind + 3, 2) = 'sp'
          set @retval = stuff(@retval, @ind, 3, char(124) + right(@blanksymbol + cast(@tzm as nvarchar), 2))
        else
          set @retval = stuff(@retval, @ind, 3, right(@blanksymbol + cast(@tzm as nvarchar), 2))
      else
      if substring(@retval, @ind, 3) = 'tzr'
        set @retval = stuff(@retval, @ind, 3, case sign(@tzh) when -1 then '-' when 1 then '+' else '' end + right('0' + cast(@tzh as nvarchar), 2) + ':' + right('0' + cast(@tzm as nvarchar), 2))
      else
        set @retval = stuff(@retval, @ind, 2, '')

      set @ind = charindex('tz', @retval, @ind)
    end
  set @blanksymbol = '0'

  set @ind = charindex('cc', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 2, 4) in ('spth', 'thsp') or substring(@retval, @ind + 2, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 2, char(124) + @century)
      else
        set @retval = stuff(@retval, @ind, 2, @century)

      if substring(@retval, @ind - 1, 1) = 's'
        set @retval = stuff(@retval, @ind - 1, 1, @yearsign)

      set @ind = charindex('cc', @retval, @ind + 1)
    end

  set @ind = charindex('yyyy', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 4, 4) in ('spth', 'thsp') or substring(@retval, @ind + 4, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 4, char(124) + @year)
      else
        set @retval = stuff(@retval, @ind, 4, @year)

      if substring(@retval, @ind - 1, 1) = 's'
        set @retval = stuff(@retval, @ind - 1, 1, @yearsign)

      set @ind = charindex('yyyy', @retval, @ind + 1)
    end

  set @ind = charindex('rrrr', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 4, 4) in ('spth', 'thsp') or substring(@retval, @ind + 4, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 4, char(124) + @year)
      else
        set @retval = stuff(@retval, @ind, 4, @year)

      set @ind = charindex('rrrr', @retval, @ind + 1)
    end

  set @ind = charindex('y,yyy', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 5, 4) in ('spth', 'thsp') or substring(@retval, @ind + 5, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 5, char(124) + left(@year, 1) + ',' + right(@year, 3))
      else
        set @retval = stuff(@retval, @ind, 5, left(@year, 1) + ',' + right(@year, 3))

      set @ind = charindex('y,yyy', @retval, @ind + 1)
    end

  set @ind = charindex('iyyy', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 4, 4) in ('spth', 'thsp') or substring(@retval, @ind + 4, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 4, char(124) + @isoyear)
      else
        set @retval = stuff(@retval, @ind, 4, @isoyear)

      set @ind = charindex('iyyy', @retval, @ind + 1)
    end

  set @ind = charindex('yyy', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 3, 4) in ('spth', 'thsp') or substring(@retval, @ind + 3, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 3, char(124) + right(@year, 3))
      else
        set @retval = stuff(@retval, @ind, 3, right(@year, 3))

      set @ind = charindex('yyy', @retval, @ind + 1)
    end

  set @ind = charindex('iyy', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 3, 4) in ('spth', 'thsp') or substring(@retval, @ind + 3, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 3, char(124) + right(@isoyear, 3))
      else
        set @retval = stuff(@retval, @ind, 3, right(@isoyear, 3))

      set @ind = charindex('iyy', @retval, @ind + 1)
    end

  set @ind = charindex('yy', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 2, 4) in ('spth', 'thsp') or substring(@retval, @ind + 2, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 2, char(124) + right(@year, 2))
      else
        set @retval = stuff(@retval, @ind, 2, right(@year, 2))

      set @ind = charindex('yy', @retval, @ind + 1)
    end

  set @ind = charindex('rr', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 2, 4) in ('spth', 'thsp') or substring(@retval, @ind + 2, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 2, char(124) + right(@year, 2))
      else
        set @retval = stuff(@retval, @ind, 2, right(@year, 2))

      set @ind = charindex('rr', @retval, @ind + 1)
    end

  set @ind = charindex('iy', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 2, 4) in ('spth', 'thsp') or substring(@retval, @ind + 2, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 2, char(124) + right(@isoyear, 2))
      else
        set @retval = stuff(@retval, @ind, 2, right(@isoyear, 2))

      set @ind = charindex('iy', @retval, @ind + 1)
    end

  set @ind = charindex('y', @retval)
  while @ind > 0
    begin
      if (substring(@retval, @ind - 1, 2) <> 'dy') and (substring(@retval, @ind - 2, 3) <> 'day') and (substring(@retval, @ind, 4) <> 'year')
        if substring(@retval, @ind + 1, 4) in ('spth', 'thsp') or substring(@retval, @ind + 1, 2) = 'sp'
          set @retval = stuff(@retval, @ind, 1, char(124) + right(@year, 1))
        else
          set @retval = stuff(@retval, @ind, 1, right(@year, 1))

      set @ind = charindex('y', @retval, @ind + 1)
    end

  set @ind = charindex('q', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 1, 4) in ('spth', 'thsp') or substring(@retval, @ind + 1, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 1, char(124) + cast(datepart(q, @date_t) as nvarchar))
      else
        set @retval = stuff(@retval, @ind, 1, cast(datepart(q, @date_t) as nvarchar))

      set @ind = charindex('q', @retval, @ind + 1)
    end

  set @ind = charindex('mm', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 set @blanksymbol = ''
      if substring(@retval, @ind + 2, 4) in ('spth', 'thsp') or substring(@retval, @ind + 2, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 2, char(124) + right(@blanksymbol + cast(month(@date_t) as nvarchar), 2))
      else
        set @retval = stuff(@retval, @ind, 2, right(@blanksymbol + cast(month(@date_t) as nvarchar), 2))

      set @ind = charindex('mm', @retval, @ind)
    end
  set @blanksymbol = '0'


  set @ind = charindex('ddd', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 set @blanksymbol = ''
      if substring(@retval, @ind + 3, 4) in ('spth', 'thsp') or substring(@retval, @ind + 3, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 3, char(124) + right(replicate(@blanksymbol, 2) + cast(datepart(dy, @date_t) as nvarchar), 3))
      else
        set @retval = stuff(@retval, @ind, 3, right(replicate(@blanksymbol, 2) + cast(datepart(dy, @date_t) as nvarchar), 3))

      set @ind = charindex('ddd', @retval, @ind)
    end
  set @blanksymbol = '0'

  set @ind = charindex('dd', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 set @blanksymbol = ''
      if substring(@retval, @ind + 2, 4) in ('spth', 'thsp') or substring(@retval, @ind + 2, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 2, char(124) + right(@blanksymbol + cast(datepart(dd, @date_t) as nvarchar), 2))
      else
        set @retval = stuff(@retval, @ind, 2, right(@blanksymbol + cast(datepart(dd, @date_t) as nvarchar), 2))

      set @ind = charindex('dd', @retval, @ind)
    end
  set @blanksymbol = '0'

  set @ind = charindex('d', @retval)
  while @ind > 0
    begin
      if (substring(@retval, @ind, 2) <> 'dy') and (substring(@retval, @ind, 3) <> 'day')
        if substring(@retval, @ind + 1, 4) in ('spth', 'thsp') or substring(@retval, @ind + 1, 2) = 'sp'
          set @retval = stuff(@retval, @ind, 1, char(124) + cast(datepart(dw, @date_t) as nvarchar))
        else
          set @retval = stuff(@retval, @ind, 1, cast(datepart(dw, @date_t) as nvarchar))

      set @ind = charindex('d', @retval, @ind + 1)
    end

  set @ind = charindex('ww', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 set @blanksymbol = ''
      if substring(@retval, @ind + 2, 4) in ('spth', 'thsp') or substring(@retval, @ind + 2, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 2, char(124) + right(@blanksymbol + cast(datepart(dy, @date_t) / 7 + 1 as nvarchar), 2))
      else
        set @retval = stuff(@retval, @ind, 2, right(@blanksymbol + cast(datepart(dy, @date_t) / 7 + 1 as nvarchar), 2))

      set @ind = charindex('ww', @retval, @ind)
    end
  set @blanksymbol = '0'

  set @ind = charindex('iw', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 set @blanksymbol = ''
      if substring(@retval, @ind + 2, 4) in ('spth', 'thsp') or substring(@retval, @ind + 2, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 2, char(124) + right(@blanksymbol + cast(@isoweek as nvarchar), 2))
      else
        set @retval = stuff(@retval, @ind, 2, right(@blanksymbol + cast(@isoweek as nvarchar), 2))

      set @ind = charindex('iw', @retval, @ind)
    end
  set @blanksymbol = '0'

  set @ind = charindex('w', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 1, 4) in ('spth', 'thsp') or substring(@retval, @ind + 1, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 1, char(124) + cast(day(@date_t) / 7 + 1 as nvarchar))
      else
        set @retval = stuff(@retval, @ind, 1, cast(day(@date_t) / 7 + 1 as nvarchar))

      set @ind = charindex('w', @retval, @ind + 1)
    end

  set @ind = charindex('hh24', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 set @blanksymbol = ''
      if substring(@retval, @ind + 4, 4) in ('spth', 'thsp') or substring(@retval, @ind + 4, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 4, char(124) + right(@blanksymbol + @hour24, 2))
      else
        set @retval = stuff(@retval, @ind, 4, right(@blanksymbol + @hour24, 2))
      if @ind < @fmpos set @fmpos = @fmpos - 2

      set @ind = charindex('hh24', @retval, @ind)
    end
  set @blanksymbol = '0'

  set @ind = charindex('hh12', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 set @blanksymbol = ''
      if substring(@retval, @ind + 4, 4) in ('spth', 'thsp') or substring(@retval, @ind + 4, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 4, char(124) + right(@blanksymbol + @hour12, 2))
      else
        set @retval = stuff(@retval, @ind, 4, right(@blanksymbol + @hour12, 2))
      if @ind < @fmpos set @fmpos = @fmpos - 2

      set @ind = charindex('hh12', @retval, @ind)
    end
  set @blanksymbol = '0'

  set @ind = charindex('hh', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 set @blanksymbol = ''
      if substring(@retval, @ind + 2, 4) in ('spth', 'thsp') or substring(@retval, @ind + 2, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 2, char(124) + right(@blanksymbol + @hour12, 2))
      else
        set @retval = stuff(@retval, @ind, 2, right(@blanksymbol + @hour12, 2))

      set @ind = charindex('hh', @retval, @ind)
    end
  set @blanksymbol = '0'

  set @ind = charindex('mi', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 set @blanksymbol = ''
      if substring(@retval, @ind + 2, 4) in ('spth', 'thsp') or substring(@retval, @ind + 2, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 2, char(124) + right(@blanksymbol + cast(datepart(minute, @date_t) as nvarchar), 2))
      else
        set @retval = stuff(@retval, @ind, 2, right(@blanksymbol + cast(datepart(minute, @date_t) as nvarchar), 2))

      set @ind = charindex('mi', @retval, @ind)
    end
  set @blanksymbol = '0'

  set @ind = charindex('sssss', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 set @blanksymbol = ''
      if substring(@retval, @ind + 5, 4) in ('spth', 'thsp') or substring(@retval, @ind + 5, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 5, char(124) + right(replicate(@blanksymbol, 4) + cast(datediff(second, @date_t, @midnight) as nvarchar), 5))
      else
        set @retval = stuff(@retval, @ind, 5, right(replicate(@blanksymbol, 4) + cast(datediff(second, @date_t, @midnight) as nvarchar), 5))

      set @ind = charindex('sssss', @retval, @ind)
    end
  set @blanksymbol = '0'

  set @ind = charindex('ss', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 set @blanksymbol = ''
      if substring(@retval, @ind + 2, 4) in ('spth', 'thsp') or substring(@retval, @ind + 2, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 2, char(124) + right(@blanksymbol + cast(datepart(second, @date_t) as nvarchar), 2))
      else
        set @retval = stuff(@retval, @ind, 2, right(@blanksymbol + cast(datepart(second, @date_t) as nvarchar), 2))

      set @ind = charindex('ss', @retval, @ind)
    end
  set @blanksymbol = '0'

  set @ind = charindex('i', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 1, 4) in ('spth', 'thsp') or substring(@retval, @ind + 1, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 1, char(124) + right(@isoyear, 1))
      else
        set @retval = stuff(@retval, @ind, 1, right(@isoyear, 1))

      set @ind = charindex('i', @retval, @ind + 1)
    end

  set @ind = patindex('%ff[1-9]%', @retval)
  while @ind > 0
    begin
      set @seconddigits = cast(substring(@retval, @ind + 2, 1) as tinyint)
      set @millisecond = right('00' + cast(datepart(millisecond, @date_t) as nvarchar), 3)
      
      if substring(@retval, @ind + 2, 4) in ('spth', 'thsp') or substring(@retval, @ind + 2, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 3, char(124) + left(@millisecond + '00000', @seconddigits))
      else
        set @retval = stuff(@retval, @ind, 3, left(@millisecond + '00000', @seconddigits))
      set @ind = patindex('%ff[1-9]%', @retval)
    end

  set @retval = replace(@retval, 'x', '.')

  set @ind = charindex('ff', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 2, 4) in ('spth', 'thsp') or substring(@retval, @ind + 2, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 2, char(124) + right('00' + cast(datepart(millisecond, @date_t) as nvarchar), 3))
      else
        set @retval = stuff(@retval, @ind, 2, right('00' + cast(datepart(millisecond, @date_t) as nvarchar), 3))

      set @ind = charindex('ff', @retval, @ind)
    end
  
  set @retval = replace(@retval, 'am', case when datepart(hour, @date_t) > 11 then 'pm' else 'am' end)
  set @retval = replace(@retval, 'a.m.', case when datepart(hour, @date_t) > 11 then 'p.m.' else 'a.m.' end)
  set @retval = replace(@retval, 'pm', case when datepart(hour, @date_t) > 11 then 'pm' else 'am' end)
  set @retval = replace(@retval, 'p.m.', case when datepart(hour, @date_t) > 11 then 'p.m.' else 'a.m.' end)


  set @ind = charindex('j', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind + 1, 4) in ('spth', 'thsp') or substring(@retval, @ind + 1, 2) = 'sp'
        set @retval = stuff(@retval, @ind, 1, char(124) + cast(2361331 + datediff(day, convert(datetime, '01/01/1753', 103), @date_t) as nvarchar))
      else
        set @retval = stuff(@retval, @ind, 1, cast(2361331 + datediff(day, convert(datetime, '01/01/1753', 103), @date_t) as nvarchar))

      set @ind = charindex('j', @retval, @ind + 1)
    end

  set @ind = charindex('th', @retval)
  while @ind > 0
    begin
      if isnumeric(substring(@retval, @ind - 1, 1)) = 1 and substring(@retval, @ind, 4) <> 'thsp'
        begin
          set @thexp = case cast(substring(@retval, @ind - 1, 1) as integer)
                       when 1 then 'st'
                       when 2 then 'nd'
                       when 3 then 'rd'
                       else 'th'
                       end
          if ascii(substring(@retval, @ind, 1)) = ascii('t')
            set @thexp = lower(@thexp)

          set @retval = stuff(@retval, @ind, 2, @thexp)
        end
      else
        if substring(@retval, @ind - 3, 5) <> 'month' and 
           substring(@retval, @ind, 4) <> 'thsp' and
           substring(@retval, @ind - 2, 4) <> 'spth'
         begin
           set @ind1 = charindex('"', @retval)
           while @ind1 > 0
             if @ind > @ind1
               begin
                 set @ind1 = charindex('"', @retval, @ind1 + 1)
                 if @ind < @ind1 break
                 else set @ind1 = charindex('"', @retval, @ind1 + 1)
               end
             else
               begin
--           date format not recognized
                 return null
               end
             if @ind > 0
               begin
--                 date format not recognized
                 return null
               end
         end

      set @ind = charindex('th', @retval, @ind + 1)
    end

  set @ind = charindex('sp', @retval)
  while @ind > 0
    begin
      if substring(@retval, @ind - 2, 4) = 'thsp' and substring(@retval, @ind - 5, 7) <> 'monthsp'
        set @ind = @ind - 2

      set @ind1 = charindex(char(124), @retval, @ind - 8)
      set @nametemp = ''
      if @ind1 > 0 and @ind1 < @ind
        begin
          set @strlen = charindex(char(124), @retval, @ind1 + 1)
          if @strlen > 0 and @strlen < @ind
            set @ind1 = @strlen

          if isnumeric(replace(substring(@retval, @ind1 + 1, @ind - @ind1 - 1), ',', '')) = 1
            begin
              if substring(@retval, @ind, 4) in ('spth', 'thsp') set @flag = 1
              else set @flag = 0
              set @nametemp = rtrim(ssma.numberspelledoutenglish(cast(replace(substring(@retval, @ind1 + 1, @ind - @ind1 - 1), ',', '') as integer), @flag))

              if substring(@retval, @ind, 4) in ('spth', 'thsp') 
                set @retval = stuff(@retval, @ind1, @ind - @ind1 + 4, @nametemp)
              else
                set @retval = stuff(@retval, @ind1, @ind - @ind1 + 2, @nametemp)
            end 
          else
            begin
              set @ind1 = charindex('"', @retval)
              while @ind1 > 0
                if @ind > @ind1
                  begin
                    set @ind1 = charindex('"', @retval, @ind1 + 1)
                    if @ind < @ind1 break
                    else set @ind1 = charindex('"', @retval, @ind1 + 1)
                  end
                else
                  begin
--                    date format not recognized
                    return null
                  end
             if @ind > 0
               begin
--                 date format not recognized
                 return null
               end
            end
        end
      else
        begin
          set @ind1 = charindex('"', @retval)
            while @ind1 > 0
              if @ind > @ind1
                begin
                  set @ind1 = charindex('"', @retval, @ind1 + 1)
                  if @ind < @ind1 break
                  else set @ind1 = charindex('"', @retval, @ind1 + 1)
                end
              else
                begin
--                  date format not recognized
                  return null
                end
             if @ind > 0
               begin
--                 date format not recognized
                 return null
               end
        end

      set @ind = charindex('sp', @retval, @ind1 + len(@nametemp))
    end

  set @ind = charindex('month', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 
        begin
          set @nametemp = rtrim(@monthname)
        end
      else
        begin
          set @nametemp = @monthname
          if @fmpos > 0 set @fmpos = @fmpos + len(replace(@monthname, ' ', '.')) - 5
        end

      if substring(@retval collate latin1_general_bin, @ind, 2) = 'mo' collate latin1_general_bin
        set @retval = stuff(@retval, @ind, 5, @nametemp)
      else if substring(@retval collate latin1_general_bin, @ind, 2) = 'mo' collate latin1_general_bin
             set @retval = stuff(@retval, @ind, 5, @nametemp) 
           else
             set @retval = stuff(@retval, @ind, 5, lower(@nametemp))
      if @ind + len(@monthname) < len(@retval)
        set @ind = charindex('month', @retval, @ind + len(@monthname))
      else
        set @ind = 0
    end

  set @ind = charindex('mon', @retval)
  while @ind > 0
    begin
      if (substring(@retval collate latin1_general_bin, @ind, 2) = 'mo' collate latin1_general_bin)
        set @retval = stuff(@retval, @ind, 3, left(@monthname, 3))
      else if (substring(@retval collate latin1_general_bin, @ind, 2) = 'mo' collate latin1_general_bin)
             set @retval = stuff(@retval, @ind, 3, left(@monthname, 3))
           else
             set @retval = stuff(@retval, @ind, 3, lower(left(@monthname, 3)))
      set @ind = charindex('mon', @retval, @ind + 3)
    end

  set @ind = charindex('rm', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 set @blanksymbol = '' else set @blanksymbol = ' '
      set @retval = stuff(@retval, @ind, 2, left((case month(@date_t) when 1 then  'i'
                                                           when 2 then  'ii'
                                                           when 3 then  'iii'
                                                           when 4 then  'iv'
                                                           when 5 then  'v'
                                                           when 6 then  'vi'
                                                           when 7 then  'vii'
                                                           when 8 then  'viii'
                                                           when 9 then  'ix'
                                                           when 10 then 'x'
                                                           when 11 then 'xi'
                                                           when 12 then 'xii' end) + replicate(@blanksymbol, 3), 4))
      set @ind = charindex('rm', @retval, @ind)
    end

  set @ind = charindex('day', @retval)
  while @ind > 0
    begin
      if @ind >= @fmpos and @fmpos > 0 
        begin
          set @nametemp = rtrim(@dayname)
        end
      else
        begin
          set @nametemp = @dayname
          if @fmpos > 0 set @fmpos = @fmpos + len(replace(@dayname, ' ', '.')) - 5
        end

      if (substring(@retval collate latin1_general_bin, @ind, 2) = 'da' collate latin1_general_bin)
        set @retval = stuff(@retval, @ind, 3, @nametemp)
      else if (substring(@retval collate latin1_general_bin, @ind, 2) = 'da' collate latin1_general_bin)
             set @retval = stuff(@retval, @ind, 3, @nametemp) 
           else
             set @retval = stuff(@retval, @ind, 3, lower(@nametemp)) 

      if @ind + len(@dayname) < len(@retval)
        set @ind = charindex('day', @retval, @ind + len(@dayname))
      else
        set @ind = 0
    end

  set @ind = charindex('dy', @retval)
  while @ind > 0
    begin
      if @ind < @fmpos and @fmpos > 0 
        set @fmpos = @fmpos + 1

      if (substring(@retval collate latin1_general_bin, @ind, 2) = 'dy' collate latin1_general_bin)
        set @retval = stuff(@retval, @ind, 2, left(@dayname, 3))
      else if (substring(@retval collate latin1_general_bin, @ind, 2) = 'dy' collate latin1_general_bin)
             set @retval = stuff(@retval, @ind, 2, left(@dayname, 3)) 
           else
             set @retval = stuff(@retval, @ind, 2, lower(left(@dayname, 3)))
      set @ind = charindex('dy', @retval, @ind + 3)
    end

  set @ind = charindex('year', @retval)
  while @ind > 0
    begin
      set @retval = stuff(@retval, @ind, 4, ssma.numberspelledoutenglish(@year, 0))
      if substring(@retval, @ind - 1, 1) = 's'
        set @retval = stuff(@retval, @ind - 1, 1, @yearsign)
      set @ind = charindex('year', @retval)
    end

-- check for "..."
  set @ind = charindex('"', @retval)
  set @strlen1 = 0
  set @ind1 = 0
  while @ind > 0
    begin
      set @ind1 = charindex('"', @format, @ind1 + @strlen1)
      if @ind1 > 0
        begin
          set @strlen = charindex('"', @retval, @ind + 1) - @ind + 1
          set @strlen1 = charindex('"', @format, @ind1 + 1) - @ind1 + 1
          set @retval = stuff(@retval, @ind, @strlen, substring(@format, @ind1 + 1, @strlen1 - 2))
          set @ind = charindex('"', @retval, @ind + @strlen)
        end
      else break
    end
  return @retval
end




GO
