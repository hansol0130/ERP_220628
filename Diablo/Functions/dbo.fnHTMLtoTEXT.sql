USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  function [dbo].[fnHTMLtoTEXT] 
(
	@str varchar(max)
)
returns varchar(max)
as
begin
declare  @nLen int,@st int,@ed int,@ds varchar(5000),@sf varchar(5000),@i int
set @nLen = Len(@str)
set @sf = @str
set @i = 0
WHILE @i <= @nLen
BEGIN
set @st = dbo.fnINSTR(@i,@str,'<')
set @ed = dbo.fnINSTR(@st+1,@str,'>')
IF @st > 0 And @ed > 0
BEGIN
set @ds = substring(@str,@st,(@ed+1)-@st)
set @sf = replace(@sf,@ds,'')
set @i = @ed
END

set @i = @i + 1
END
--return replace(@sf,' ','')
	return @sf
end
GO
