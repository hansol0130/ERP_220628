USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  function [dbo].[fnReplaceDomain] 
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
	set @st = dbo.fnINSTR2(@i,@str,'www.')
	set @ed = dbo.fnINSTR2(@st+1,@str,' ')

	IF @st > 0 And @ed > 0
	BEGIN
		set @ds = substring(@str,@st,(@ed+1)-@st)
		set @sf = replace(@sf,@ds,'')
		set @i = @ed
	END

	--IF @st > 0 And @ed > 0
	--BEGIN
	--	-- set @ds = substring(@str,@st,(@ed+1)-@st)
	--	--대상 img 태그 전체 문자열 
	--	set @ds = substring(@str,@st,(@ed+1)-@st)

	--	set @img = @img +  @ds  + '|'   --줄바꿈
	--	--set @sf = replace(@sf,@ds,'')
	--	set @i = @ed
	--END
	--ELSE 
	--BEGIN
	--	BREAK
	--END 


	set @i = @i + 1
END
--return replace(@sf,' ','')
	return @sf
end


GO
