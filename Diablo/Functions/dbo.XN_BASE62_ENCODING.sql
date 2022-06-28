USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
BASE62 ENCODING 
*/
create function [dbo].[XN_BASE62_ENCODING] (@UrlId int) 
	returns varchar(10)
as
begin

  declare
    @Chars varchar(62),
    @Code varchar(10),
    @Value int,
    @Adder int

  set @Chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
  if (@UrlId < 63) begin
    set @Code = substring(@Chars, @UrlId, 1)
  end else begin
    set @UrlId = @UrlId - 1
    set @Value = 62
    set @Adder = 0
    while (@UrlId >= @Value * 63 + @Adder) begin
      set @Adder = @Adder + @Value
      set @Value = @Value * 62
    end
    set @Code = substring(@Chars, (@UrlId - @Adder) / @Value, 1)
    set @UrlId = ((@UrlId - @Adder) % @Value)
    while (@Value > 1) begin
      set @Value = @Value / 62
      set @Code = @Code + substring(@Chars, @UrlId / @Value + 1, 1)
      set @UrlId = @UrlId % @Value
    end
  end
  return @Code

end
GO
