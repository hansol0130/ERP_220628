USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--HTML 제거 함수2
/*
2017-01-19 
박형만 : html 내용 필드에서 img 태그만 골라낸다 
*/
CREATE  function [dbo].[fnHTMLtoExtractImgTag] 
(
	@str varchar(max)
)
returns varchar(max)
begin

	--declare @str varchar(max)
	--set  @str  = ( SELECT TOP 100 PKG_REVIEW FROM PKG_DETAIL WHERE PRO_CODE ='EPP4392-150918OK'  ) 
	--WHERE MASTER_CODE ='EPP4392' 
	declare  @nLen int,@st int,@ed int,@ds varchar(max),@sf varchar(max),@i int
	,@img varchar(max)
	set @nLen = Len(@str)
	set @sf = @str
	set @i = 0
	set @img = ''
	WHILE @i <= @nLen
	BEGIN
		set @st = dbo.fnINSTR2(@i,@str,'<img ')
		set @ed = dbo.fnINSTR2(@st+1,@str,'>')
		IF @st > 0 And @ed > 0
		BEGIN
			-- set @ds = substring(@str,@st,(@ed+1)-@st)
			--대상 img 태그 전체 문자열 
			set @ds = substring(@str,@st,(@ed+1)-@st)
			set @img = @img +  @ds  + '|'   --줄바꿈
			--set @sf = replace(@sf,@ds,'')
			set @i = @ed
		END
		ELSE 
		BEGIN
			BREAK
		END 

		set @i = @i + 1
	END
--select @sf 
	return @img 
end 
GO
